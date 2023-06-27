local Class = {}

-- SRE
local sre = {}
sre.__index = sre
Class.Sre = sre

function sre.new(scene, materials, camera, thread)
    local self = {}
    
    self.scene = scene or Class.Scene.new()
    self.camera = camera or Class.Camera.new()
    self.Thread = thread or Class.Thread.new()
    self.Materials = materials or Class.Materials.new()

    self.screen = {}

    setmetatable(self, sre)
    return self
end

function sre:Render()
    local camera = {}
    do  
        local cameraObj = self.camera
        local imageAspectRatio = camera.imageSize.X / camera.imageSize.Y
        camera.aspectRatio = imageAspectRatio
        camera.imageSize = cameraObj.imageSize
        camera.fov = math.rad(cameraObj.fov)
        camera.cframe = cameraObj.cframe
        camera.worldOrigin = Vector3.zero
    end

    for x = 0, camera.imageSize.X do
        for y = 0, camera.imageSize.Y do
            local u = (2 * ((x + 0.5) / camera.imageSize.X) - 1) * math.tan(camera.fov / 2 * math.pi / 180) * camera.aspectRatio
            local v = (1 - 2 * ((y + 0.5) / camera.imageSize.Y)) * math.tan(camera.fov / 2 * math.pi / 180)
            local worldOrigin = camera.worldOrigin * camera.cframe
            local rayPosition = Vector3.new(u, v, -1) * camera.cframe
            
            local rayDirection = (rayPosition - worldOrigin).Unit
        end
    end
end

-- Scene
local scene = {}
scene.__index = scene
Class.Scene = scene

function scene.new(objects: table?)
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
        imageSize = Vector2.new(100, 100)
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
Class.thread = thread

function thread.new(threadCount)
    local self = {}
    self.threadCount = threadCount or thread._defaultThreadCount

    setmetatable(self, thread)
    return self
end

return Class