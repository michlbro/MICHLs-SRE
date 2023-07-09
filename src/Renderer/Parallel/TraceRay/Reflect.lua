return function(castRay,rayOrigin, rayDirection, reflectionProperties)
    local reflections = {}

    local origin, direction = rayOrigin, rayDirection

    for _ = 0, reflectionProperties.reflections do
        local result: RaycastResult = castRay(origin, direction * reflectionProperties.length)

        if result and result.Instance then
            -- check lightsource
            table.insert(reflections, result)
            if true then -- Temp
                break
            end
            origin, direction = result.Position, -- Next Unit vector to be determined
        end
    end

    return reflections
end
