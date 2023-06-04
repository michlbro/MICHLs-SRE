--[[
    SRE - Software Raytracing Engine
    Made by XxprofessgamerxX
    Created on 04/06/2023
]]

-- // Variables
local classes = script.classes

local SceneClass = require(classes.scene)
local ImageClass = require(classes.image)
local CameraClass = require(classes.camera)
local RaycastClass = require(classes.raycast)
local BufferClass = require(classes.buffer)
local MaterialsClass = require(classes.materials)

local RayTracingPipeline = require(script.RayTracingPipeline)

local SRE = {}

-- // Raytracing Pipeline
function SRE:Render()
    -- Scene Setup
    local sceneSetup = RayTracingPipeline.SceneSetup(self.scene)

    -- Camera Projection
    -- Determine if pixel intersects or not
    local raycastBuffer = BufferClass.new(self.camera.size, {result = nil, intersected = false})
    RayTracingPipeline.CameraProjection(sceneSetup,self.camera, self.raycast, raycastBuffer)

    -- Calculate direct lighting illumination
    -- Only for pixels that have an intersection.
    local directIlluminationBuffer = BufferClass.new(self.camera.size, {colour = Vector3.zero, directlyIlluminated = false})
    RayTracingPipeline.DirectIllumination(sceneSetup, raycastBuffer, directIlluminationBuffer, self.camera, self.scene, self.materials)
end

-- // Image Rendering

-- // functions

local function new(sceneObj, materialsObj, imageObj, cameraObj, raycastObj)
    local self = {}
    self.scene = sceneObj or SceneClass.new()
    self.image = imageObj or ImageClass.new()
    self.camera = cameraObj or CameraClass.new()
    self.raycast = raycastObj or RaycastClass.new()
    self.materials = materialsObj or MaterialsClass.new()


    setmetatable(self, {
        __index = SRE
    })
end

return setmetatable({
    new = new,
    SceneClass = SceneClass,
    ImageClass = ImageClass,
    CameraClass = CameraClass,
    RaycastClass = RaycastClass,
    MaterialsClass = MaterialsClass
}, {

})