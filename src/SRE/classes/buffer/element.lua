local pixel = {}

function pixel:Destroy()
    self.position = nil
    self.type = nil
    self = nil
end

local function new(position, bufferDataType)
    local self = {}
    self.position = position
    self.type = table.clone(bufferDataType)
    setmetatable(self, {
        __index = pixel
    })
    return self
end

return setmetatable({
    new = new
}, {})