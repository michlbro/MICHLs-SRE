local function Color3ToVector3(color3)
    local r, g, b = color3.R, color3.G, color3.B
    return Vector3.new(r, g, b)
end
return function(materials)
    return function(instance)
        local material = {}
        material.colour = Color3ToVector3(instance.Color)
        if instance.ClassName == "Terrain" then
            material.colour = Color3ToVector3(instance:GetMaterialColor())
        end
        local materialObj = materials[`{instance.Material.Name}`] or materials.None
        for property, value in materialObj do
            material[property] = value
        end
        return material
    end
end