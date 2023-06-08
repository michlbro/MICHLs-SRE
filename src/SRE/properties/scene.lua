local scene = {}

function scene:AddObject(instance)
    table.insert(self.objects, instance)
end

local function new()
    local self = {}
    self.objects = {}

    setmetatable(self, {
        __index = scene
    })
    return self
end

return setmetatable({
    new = new
}, {})