local raycast = {}

local function new()
    local self = {}

    
    setmetatable(self, {
        __index = raycast
    })
    return self
end

return setmetatable({
    new = new
}, {})