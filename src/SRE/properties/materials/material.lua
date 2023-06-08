local material = {}

local defaultMaterials = {
    LightIntensity = 0,
    Smoothness = 0
}

local function new(name, properties)
    local self = {}
    self.name = name
    for property, value in defaultMaterials do
        if properties then
            self[property] = properties[property] ~= nil and properties[property] or value
            continue
        end
        self[property] = value
    end
    setmetatable(self, {
        __index = material
    })

    return self
end

return setmetatable({
    new = new
}, {})