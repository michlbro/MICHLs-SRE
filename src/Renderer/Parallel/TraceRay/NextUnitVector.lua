local function Reflect(dirIn, normal)
    return dirIn - 2 * dirIn:Dot(normal) * normal
end

return function(ray, material)
    local diffuseDirection = (ray.Normal + Random.new():NextUnitVector()).Unit
    local specularDirection = Reflect(ray.Direction, ray.Normal)
    return diffuseDirection:Lerp(specularDirection, material.Smoothness)
end