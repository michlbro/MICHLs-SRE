local function Reflect(dirIn, normal)
    return dirIn - 2 * dirIn:Dot(normal) * normal
end

return function(pixel, maxBounces, raycast, materialFunc)
    local ticked = os.clock() + 1/60

    local incomingLight = Vector3.zero
    local rayColour = 1

    local ray
    local origin, direction = pixel.origin, pixel.direction
    for _ = 0, maxBounces - 1 do
        if os.clock() > ticked then
            print(pixel.cords[1]/pixel.size.X)
            task.wait()
            ticked = os.clock() + 1/60
        end


        ray = raycast(origin, direction, 2000)
        if ray.intersected then
            local material = materialFunc(ray.instance)


            origin = ray.position
            local diffuseDirection = (ray.normal + Random.new():NextUnitVector()).Unit
            local specularDirection = Reflect(ray.direction, ray.normal)
            direction = diffuseDirection:Lerp(specularDirection, material.Smoothness)
            local emittedLight = material.colour * material.LightIntensity
            incomingLight += (emittedLight * rayColour)
            rayColour *= material.colour
        else
            break
        end
    end
    return incomingLight
end