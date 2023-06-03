local CameraTrace = {}

function CameraTrace.Setup(rayFilter, cameraDistance, origin)
    return function(direction)
        return workspace:Raycast(origin, direction, rayFilter)
    end
end

return CameraTrace