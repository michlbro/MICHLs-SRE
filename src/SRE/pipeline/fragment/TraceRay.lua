local Reflect = require(script.Parent.Reflect)

return function(pipeline, pixel)
    local incomingLight = Vector3.zero
    local rayColour = 1

    local ray
    local origin, direction = pixel.origin, pixel.direction

    for _ = 0, pipeline.scene.MaxBounces - 1 do
        ray = pipeline.ray(origin, direction, 100)
        if ray.Intersected then
            local material = pipeline.material(ray.Instance)

            origin = ray.Position
            local diffuseDirection = (ray.Normal + Random.new():NextUnitVector()).Unit
            local specularDirection = Reflect(ray.Direction, ray.Normal)
            direction = diffuseDirection:Lerp(specularDirection, material.Smoothness)
            
            local emittedLight = pipeline.Color3ToVector3(material.colour) * material.LightIntensity
            incomingLight += (emittedLight * rayColour)
            rayColour *= pipeline.Color3ToVector3(material.colour)
        else
            break
        end
    end

    return incomingLight
end