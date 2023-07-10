local NextUnitVector = require(script.Parent.NextUnitVector)

return function(rayOrigin, rayDirection, camera, CastRay, materialFunc)
    local reflections = {}

    local origin, direction = rayOrigin, rayDirection

    for _ = 0, camera.bounces - 1 do
        local result: RaycastResult = CastRay(origin, direction * camera.length)

        if result and result.Instance then
            local material = materialFunc("weak", result.Instance)
            origin, direction = result.Position, NextUnitVector(result, material[1])
            table.insert(reflections, result)
        else
            break
        end
    end

    return reflections
end
