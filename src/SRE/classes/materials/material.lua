local function ConvertColor3ToVector3(color3)
    return Vector3.new(color3.R, color3.G, color3.B)
end

local defaultProperties = {
    albedo = 0,
    reflectance = 0,
    roughness = 1,
    emitLight = false,
    lightIntensity = 1,
    glossFactor = 0.5,
    specularColour = ConvertColor3ToVector3(Color3.new(1.000000, 1.000000, 1.000000)),
    emission = 0
}

local material = {}

local function new(materialName, properties)
    local self = {}
    self.material = materialName
    self.properties = table.clone(defaultProperties)

    if properties then
        for property, _ in defaultProperties do
            if properties[property] then
                self.properties[property] = properties[property]
            end
        end
    end
    setmetatable(self, {
        __index = material
    })
    return self
end

return setmetatable({
    new = new,
    ConvertColor3ToVector3 = ConvertColor3ToVector3
}, {})