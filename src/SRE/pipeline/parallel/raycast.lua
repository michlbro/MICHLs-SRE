return function(raycast)
    local rayParams = raycast
    return function(origin, direction, length)
        local rayResult = workspace:Raycast(origin, direction * length, rayParams)
        local ray = {}
        ray.intersected = false
        ray.direction = direction
        ray.origin = origin
        
        if rayResult and rayResult.Instance then
            ray.intersected = true
            ray.position = rayResult.Position
            ray.instance = rayResult.Instance
            ray.material = rayResult.Material
            ray.normal = rayResult.Normal
        end

        return ray
    end
end