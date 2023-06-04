local image = {}

local function new()
    local self = {}

    
    setmetatable(self, {
        __index = image
    })
    return self
end

return setmetatable({
    new = new
}, {})