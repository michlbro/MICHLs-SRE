local ThreadPool = require(script.ThreadPool)
local parallel = script.parallel

local pipeline = {}

local function SetupTable(sreProperties)
    local properties = {}
    properties.materials = sreProperties.materials:DumpMaterials()
    properties.raycast = {}
    properties.raycast.objects = sreProperties.scene.objects
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = sreProperties.scene.objects
    raycastParams.FilterType = Enum.RaycastFilterType.Include
    properties.raycast.raycastParams = raycastParams
    properties.MaxRays = sreProperties.scene.sceneProperties.MaxRays
    properties.MaxBounces = sreProperties.scene.sceneProperties.MaxBounces
    return properties
end

function pipeline.Render(sreProperties, pixelCallbackFunc)
    local threadpool = ThreadPool.CreateThreadPool(sreProperties.threads.threads, parallel, nil, function(params)
        pixelCallbackFunc(params)
    end)

    local config = SetupTable(sreProperties)

    local camera = sreProperties.camera
    local bottomLeftLocal = Vector3.new(-camera.size.X/2, -camera.size.Y/2, camera.focalLength)
    --[[

    for x = 0, camera.size.X-1 do
        local height = {}
        height.size = camera.size
        height.bottomLeftLocal = bottomLeftLocal
        height.currentWidth = x
        height.CFrame = camera.CFrame
        threadpool:QueueTask(height, config)
    end]]--

    for x = 0, camera.size.X-1 do
        for y = 0, camera.size.Y-1 do
            local pixel = {}
            pixel.uv = Vector2.new(x/(camera.size.X), y/(camera.size.Y))
            pixel.cords = {x, y}
            local pointLocal = bottomLeftLocal + Vector3.new(camera.size.X * pixel.uv.X, camera.size.Y * pixel.uv.Y, 0)
            local point = camera.CFrame.Position + camera.CFrame.RightVector * pointLocal.X + camera.CFrame.UpVector * pointLocal.Y + camera.CFrame.LookVector * pointLocal.Z
            pixel.point = point
            pixel.direction = (point - camera.CFrame.Position).unit
            pixel.origin = camera.CFrame.Position
            pixel.size = camera.size
            threadpool:QueueTask(pixel, config)
        end
    end

    threadpool:Join()
end

return pipeline