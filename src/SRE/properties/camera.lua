local camera = {}

local function new(cameraPart, size)
    local self = {}
    self.CFrame = cameraPart.CFrame
    self.size = size
    setmetatable(self, {
        __index = camera
    })
    return self
end

return setmetatable({
    new = new
}, {})