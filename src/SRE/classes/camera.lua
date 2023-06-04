local camera = {}

local function new()
    local self = {}

    
    setmetatable(self, {
        __index = camera
    })
    return self
end

return setmetatable({
    new = new
}, {})