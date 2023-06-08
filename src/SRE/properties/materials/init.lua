local material = require(script.material)

local materials = {}

function materials:DumpMaterials()
    return self.materials
end

function materials:AddMaterial(material)
    self.materials[material.name] = material
end

local function new()
    local self = {}
    self.materials = {}

    setmetatable(self, {
        __index = materials
    })

    return self
end

return setmetatable({
    new = new,
    material = material
}, {})