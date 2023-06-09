local scene = {}

function scene:AddObject(instance)
    table.insert(self.objects, instance)
end

local defaultProperties = {
    MaxBounces = 1,
    MaxRays = 1
}

local function new(properties)
    local self = {}
    self.objects = {}
    self.sceneProperties = {}
    for property, value in defaultProperties do
        if properties then
            self.sceneProperties[property] = if properties[property] ~= nil then properties[property] else value
            continue
        end
        self.sceneProperties[property] = value
    end
    print(self.sceneProperties)
    setmetatable(self, {
        __index = scene
    })
    return self
end

return setmetatable({
    new = new
}, {})