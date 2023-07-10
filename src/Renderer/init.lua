local util = script.Parent.Util
local Colour = require(util.Colour)
local Threads = require(util.Thread)

local Class = {}

-- SRE
local sre = {}
sre.__index = sre
Class.Sre = sre

function sre.new(scene, materials, camera, thread)
    local self = {}
    
    self.scene = scene or Class.Scene.new()
    self.camera = camera or Class.Camera.new()
    self.thread = thread or Class.Thread.new()
    self.materials = materials or Class.Materials.new()

    self.screen = {}

    self.colourBuffer = {}

    self.finished = false

    setmetatable(self, sre)
    return self
end

local function PreAllocateBuffer(index, ...)
    for _, buffer in {...} do
        buffer[index] = {}
    end
end

function sre:Render()
    local camera = {}
    do  
        local cameraObj = self.camera
        camera.imageSize = cameraObj.imageSize
        local imageAspectRatio = camera.imageSize.X / camera.imageSize.Y
        camera.aspectRatio = imageAspectRatio
        camera.fov = math.rad(cameraObj.fov)
        camera.cframe = cameraObj.cframe
        camera.worldOrigin = Vector3.zero
    end

    local cameraProjectionBuffer = {}
    local reflectBuffer = {}
    local tempColourBuffer

    for x = 0, camera.imageSize.X - 1 do
        PreAllocateBuffer(x, cameraProjectionBuffer, self.colourBuffer, reflectBuffer, tempColourBuffer)
        for y = 0, camera.imageSize.Y - 1 do
            PreAllocateBuffer(y, cameraProjectionBuffer[x], self.colourBuffer[x], reflectBuffer[x], tempColourBuffer[x])
            
            local u = (2 * ((x + 0.5) / camera.imageSize.X) - 1) * math.tan(camera.fov / 2 * math.pi / 180) * camera.aspectRatio
            local v = (1 - 2 * ((y + 0.5) / camera.imageSize.Y)) * math.tan(camera.fov / 2 * math.pi / 180)
            local worldOrigin = camera.worldOrigin * camera.cframe
            local rayPosition = Vector3.new(u, v, -1) * camera.cframe
            
            local rayDirection = (rayPosition - worldOrigin).Unit

            cameraProjectionBuffer[x][y] = {rayPosition, rayDirection}
            self.colourBuffer[x][y] = Colour.new()
        end
    end

    -- Thread creation for reflections
    local threads = Threads(self.thread.threadCount, script)
    threads:SetupThreads(script.Parallel)

    local function ReflectionCallback(xCord, result)
        -- Callback
        reflectBuffer[xCord] = result
    end

    local function ColourCallback(xCord, result)
        table.insert(tempColourBuffer[xCord], result)
    end

    local currentRay = 0
    for count, self.camera.rays - 1 do
        currentRay += 1
        threads:OnThreadFinished(ReflectionCallback)

        -- Reflect
        --[[ 
            Weak material referencing to determine reflection direction and light sources.
        ]]--
        print(`Executing reflections`)
        for x = 0, camera.imageSize.X - 1 do
            --[[
                Perform raycast reflections via in parallel here for all lines on the Y axis.
            ]]
            threads:GiveTask("RayTrace", cameraProjectionBuffer[x], self.camera) 
        end
        threads:Finished()
        print(`Completed reflections`)

        -- Thread creation for colour
        threads:OnThreadFinished(ColourCallback)

        -- Colour Extract
        --[[
            Full material referencing to determine pixel overall colour.
        ]]--
        print(`Executing colour computation`)
        for x = 0, camera.imageSize.X - 1 do
            --[[
                Perform pixel colour determination via in parallel here for all lines on the Y axis.
            ]]
            threads:GiveTask("Shader", reflectBuffer[x])
        end
        threads:Finished()

        for x = 0, camera.imageSize.X - 1 do
            for y = 0, camera.imageSize.Y - 1 do
                PreAllocateBuffer(y, reflectBuffer[x])
            end
        end

        -- Push recent colour computation to colour buffer to view progress
        local recentColour = self.tem
        for x = 0, camera.imageSize.X - 1 do
            self.colourBuffer[x] = tempColourBuffer[x][currentRay]
        end

        print(`Rays Complete: {count}`)
    end

    print(`Averaging colours`)
    -- colour averaging
    for x = 0, camera.imageSize.X - 1 do
        for y = 0, camera.imageSize.Y - 1 do
            local colour = Vector3.zero
            for i = 0, self.camera.rays - 1 do
                colour += tempColourBuffer[x][i][y]
            end
            self.colourBuffer[x][y] = colour / self.camera.rays
        end
    end

    self.finished = true
end

function sre:GetColourBuffer()
    return self.colourBuffer
end

-- Scene
local scene = {}
scene.__index = scene
Class.Scene = scene

function scene.new(objects)
    local self = {}

    self.objects = objects or {}

    setmetatable(self, scene)
    return self
end

function scene:AddObject(instance)
    table.insert(self.objects, instance)
end

function scene:CreateOverlapParam()
    local overlapParam = OverlapParams.new()
    overlapParam.FilterDescendantsInstances = self.objects
    overlapParam.FilterType = Enum.RaycastFilterType.Include
    return overlapParam
end

-- Camera
local camera = {
    _cameraDefaultProperties = {
        cframe = CFrame.new(),
        fov = 70,
        imageSize = Vector2.new(100, 100),
        bounces = 2,
        rays = 3,
        length = 30
    }
}
camera.__index = camera
Class.Camera = camera

function camera.new(cameraProperties)
    local self = {}
    for property, value in camera._cameraDefaultProperties do
        if cameraProperties[property] == nil then
            self[property] = value
        else
            self[property] = cameraProperties[property]
        end
    end
    setmetatable(self, scene)
    return self
end

-- Materials
local materials = {
    _materialDefaultProperties = {
        Smoothness = 0.4
    }
}
materials.__index = materials
Class.Materials = materials

function materials.new()
    local self = {}
    self.materials = {}
    setmetatable(self, materials)

    -- Default materials
    self:AddMaterial("Plastic", {

    })
    self:AddMaterial("Metal", {
        
    })
    self:AddMaterial("None", {

    })

    return self
end

function materials:AddMaterial(name, materialProperties)
    local material = {}
    material.name = name
    for property, value in self._materialDefaultProperties do
        if materialProperties[property] == nil then
            material[property] = value
        else
            material[property] = materialProperties[property]
        end
    end
end

-- Thread
local thread = {
    _defaultThreadCount = 10
}
thread.__index = thread
Class.Thread = thread

function thread.new(threadCount)
    local self = {}
    self.threadCount = threadCount or thread._defaultThreadCount

    setmetatable(self, thread)
    return self
end

return Class