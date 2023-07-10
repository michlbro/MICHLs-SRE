return function(reflectBuffer, MaterialFunc)
    local colourBuffer = {}
    for yCord, reflections in reflectBuffer do
        local incomingLight = Vector3.zero
        local rayColour = 1

        for _, result: RaycastResult in reflections do
            local instance = result.Instance
            local material = MaterialFunc(instance)
            local instanceColour = Vector3.new(instance.R, instance.G, instance.B)

            local emittedLight = instanceColour * material.LightIntensity
            incomingLight += (emittedLight * rayColour)
            rayColour *= instanceColour
        end
        colourBuffer[yCord] = incomingLight
    end
    return colourBuffer
end