local TraceRay = require(script.TraceRay)

return function(pipeline, pixel)
    local incomingLight = Vector3.zero

    for _ = 0, pipeline.scene.MaxRays - 1 do
        incomingLight += TraceRay(pipeline, pixel)
    end

    incomingLight /= pipeline.scene.MaxRays
    return pipeline.ClampVector(incomingLight, 0, 1)
end
