local PipelineSRE = require(script.pipeline)

local Scene = require(script.properties.scene)
local Materials = require(script.properties.materials)
local Camera = require(script.properties.camera)

local sre = {}

function sre:Render()
    local pixels = PipelineSRE.Render(self.scene, self.materials, self.camera)

    local origin = workspace.CurrentCamera.CFrame.Position
    local size = 0.01
    local screen = Instance.new("Model")
    for x, cols in pixels do
        for y, colour in cols do
            local pixel = Instance.new("Part")
            pixel.Size = Vector3.one * size
            pixel.Position = origin + Vector3.new((x-1) * size, (y-1) * size)
            pixel.Color = Color3.new(colour.X, colour.Y, colour.Z)
            pixel.Anchored = true
            pixel.CanCollide = false
            pixel.Parent = screen
        end
    end
    screen.Parent = workspace
end


local function new(scene, materials, camera, screen)
    local self = {}
    self.scene = scene
    self.materials = materials
    self.camera = camera
    self.screen = screen

    setmetatable(self, {
        __index = sre
    })
    return self
end

return setmetatable({
    new = new,
    Scene = Scene,
    Camera = Camera,
    Materials = Materials
}, {})