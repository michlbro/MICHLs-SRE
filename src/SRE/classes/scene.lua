local scene = {}

local function new()
    local self = {}

    
    setmetatable(self, {
        __index = scene
    })
    return self
end

return setmetatable({
    new = new
}, {})