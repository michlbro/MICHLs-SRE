local function RandomNormalDistribution(float)
    local theta = 2 * math.pi * Random.new(float):NextNumber()
    local rho = math.sqrt(-2 * math.log(Random.new(float):NextNumber()))
    return rho * math.cos(theta)
end

local function RandomDirection(float)
    local vector = Vector3.new(
        RandomNormalDistribution(float),
        RandomNormalDistribution(float),
        RandomNormalDistribution(float)
    )
    return vector.Unit
end

local function RandomHemisphericalDirection(normal, float)
    local direction = Random.new():NextUnitVector() --RandomDirection(float)
    return direction * math.sign(normal:Dot(direction))
end

return function(pipeline, pixel)

    local incomingLight = Vector3.zero

    local rayCount = 0

    for j = 0, pipeline.MaxRays do
        local origin, direction = pixel.origin, pixel.direction
        local ray
        local rayLight = Vector3.zero
        local rayColour = 1
        for i = 0, pipeline.MaxBounce do
            ray = pipeline.ray(origin, direction, 100)
            if ray.Intersected then
                origin = ray.Position
                direction = RandomHemisphericalDirection(ray.Normal)

                local material = pipeline.material(ray.Instance)
                local emittedLight = pipeline.Color3ToVector3(material.colour) * material.lightIntensity
                rayLight += (emittedLight * rayColour)
                rayColour *= pipeline.Color3ToVector3(material.colour)
            else
                break
            end
        end
        incomingLight += rayLight
    end

    incomingLight /= pipeline.MaxRays
    local r, g, b = incomingLight.X, incomingLight.Y, incomingLight.Z
    r, g, b = math.clamp(r, 0, 1), math.clamp(g, 0, 1), math.clamp(b, 0, 1)
    return Vector3.new(r, g, b)
end
