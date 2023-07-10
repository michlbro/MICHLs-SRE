return function(sceneObjects)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = sceneObjects
    raycastParams.FilterType = Enum.RaycastFilterType.Include
    return function(origin, direction)
        return workspace:Raycast(origin, direction, raycastParams)
    end
end