local Pixel = require(script.Pixel)

local CameraTrace = require(script.CameraTrace)

local configuration = require(script.Configuration)

local render = {}

function render.render(imageProperties, cameraProperties)
    local pixelBuffer = {}

    local image = {}
    image.width = imageProperties.width or 100
    image.height = imageProperties.height or 100
    image.aspectRatio = image.width / image.height

    local camera = {}
    camera.distance = cameraProperties.distance or 500
    camera.viewportHeight = 2.0
    camera.viewportWidth = image.aspectRatio * camera.viewportHeight
    camera.focalLength = cameraProperties.focalLength or 1

    camera.origin = cameraProperties.origin or Vector3.zero
    camera.horizontal = Vector3.new(camera.viewportWidth, 0, 0)
    camera.vertical = Vector3.new(0, camera.viewportHeight, 0)
    camera.lowerLeftCorner = camera.origin - camera.horizontal/2 - camera.vertical/2 - Vector3.new(0, 0, camera.focalLength)

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = cameraProperties.scene
    raycastParams.FilterType = Enum.RaycastFilterType.Include

    local cameraTrace = CameraTrace.Setup(raycastParams, camera.distance, camera.origin)

    for y = image.height, 0, -1 do
        pixelBuffer[y] = {}
        for x = 0, image.width do
            local u = x / (image.width-1)
            local v = y / (image.height-1)
            local screenDirection = camera.lowerLeftCorner + u*camera.horizontal + v*camera.vertical - camera.origin
            local rayResult = cameraTrace(screenDirection)
            local pixel = Pixel.new(Vector2.new(x, y), configuration.Materials.None)
            if rayResult and rayResult.Instance then
                do
                    local instanceType = rayResult.Instance.ClassName
                    local instanceColour = Vector3.zero
                    if instanceType == "Terrain" then
                        instanceColour = rayResult.Instance:GetMaterialColor()
                    else
                        instanceColour = rayResult.Instance.Color
                    end
                    pixel:Intersects(rayResult.Instance, instanceColour, rayResult, configuration.Materials[rayResult.Material] or configuration.Materials.None)
                end
                
            else

            end
            pixelBuffer[y][x] = pixel
        end
    end
end

return render