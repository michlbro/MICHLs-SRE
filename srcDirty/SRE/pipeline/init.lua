local PipelineSetup = require(script.setup)
local PipelineFragment = require(script.fragment)

local pipeline = {}

function pipeline.Render(scene, materials, camera)
    local config = PipelineSetup.SetupPipeline(scene, materials, camera)
    local pixelScreen = {}

    local bottomLeftLocal = Vector3.new(-camera.size.X/2, -camera.size.Y/2, camera.focalLength)

    for x = 0, camera.size.X do
        pixelScreen[x] = {}
        for y = 0, camera.size.Y do
            pixelScreen[x][y] = Vector3.zero
            local pixel = {}
            pixel.uv = Vector2.new(x/(camera.size.X-1), y/(camera.size.Y-1))

            local pointLocal = bottomLeftLocal + Vector3.new(camera.size.X * pixel.uv.X, camera.size.Y * pixel.uv.Y, 0)
            local point = camera.CFrame.Position + camera.CFrame.RightVector * pointLocal.X + camera.CFrame.UpVector * pointLocal.Y + camera.CFrame.LookVector * pointLocal.Z
            pixel.point = point
            pixel.direction = (point - camera.CFrame.Position).unit
            pixel.origin = camera.CFrame.Position
            pixel.size = camera.size
            pixelScreen[x][y] = PipelineFragment(config, pixel)
        end
    end
    return pixelScreen
end

return pipeline