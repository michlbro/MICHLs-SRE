local Terrain = workspace.Terrain

return function(materialLookupTable)
    return function(instance, option)
        local instanceMaterial = instance.Material
        local material = materialLookupTable[instanceMaterial.Name] or materialLookupTable["None"]
        return {
            material
        }
    end
end