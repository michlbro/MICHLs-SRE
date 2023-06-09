local TraceRay = require(script.TraceRay)


return function(pixel, config, raycast, material)
    local incomingLight = Vector3.zero
    for i = 0, config.MaxRays-1 do
        incomingLight += TraceRay(pixel, config.MaxBounces, raycast, material)
        print("Test")
    end

    incomingLight /= config.MaxRays
    return incomingLight
end