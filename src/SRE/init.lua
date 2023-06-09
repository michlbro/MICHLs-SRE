local Scene = require(script.properties.scene)
local Materials = require(script.properties.materials)
local Camera = require(script.properties.camera)
local Screen = require(script.properties.screen)
local Threads = require(script.properties.threads)

local srePipeline = require(script.pipeline)
local PixelScreen = require(script.screen)

local sre = {}

function sre:Render()
    local pixelScreen = PixelScreen.new(self.properties.screen, self.properties.camera.size, self.properties.screen.name)
    srePipeline.Render(self.properties, function(pixel)
        --[[
        for _, pixel in heightBuffer do
            pixelScreen:DrawPixel(pixel[1][1], pixel[1][2], pixel[2], true, 0, 1)
        end]]--
        pixelScreen:DrawPixel(pixel[1][1], pixel[1][2], pixel[2], true, 0, 1)
    end)
end


local function new(camera, scene, materials, screen, threads)
    local self = {}
    self.properties = {}
    self.properties.camera = camera
    self.properties.threads = threads or Threads.new()
    self.properties.scene = scene or Screen.new()
    self.properties.materials = materials or Materials.new():AddMaterial(Materials.material.new("None"))
    self.properties.screen = screen or Screen.new()

    setmetatable(self, {
        __index = sre
    })
    return self
end

return setmetatable({
    new = new,
    Scene = Scene,
    Camera = Camera,
    Materials = Materials,
    Screen = Screen,
    Threads = Threads
}, {})