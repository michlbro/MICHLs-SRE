local MaterialClass = require(script.material)

local materials = {}

function materials:GetMaterial(materialName)
    return self.materials[materialName] or self.materials.None
end

function materials:DumpMaterials()
    return self.materials
end

local function new(arrayOfMaterials)
    local self = {}
    self.materials = {
        None = MaterialClass.new()
    }

    for _, material in arrayOfMaterials do
        self.materials[material.material] = material
    end

    setmetatable(self, {
        __index = materials
    })
    return self
end

return setmetatable({
    new = new
}, {
    MaterialClass = MaterialClass
})