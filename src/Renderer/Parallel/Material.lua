local Terrain = workspace.Terrain

return function(materialLookupTable)
    return function(instance, option)
        local instanceMaterial = instance.Material
        local material = materialLookupTable[instanceMaterial.Name] or materialLookupTable["None"]
        if option == "Weak" then
            return {
                material
            }
        end
        return {
            material,
            instance.ClassName == "Terrain" and Terrain:GetMaterialColor(instance.Material) or instance.Color
        }
    end
end