local camera = {}

local function new(cameraPart, size, focalLength)
    local self = {}
    self.CFrame = cameraPart.CFrame
    self.size = size
    self.focalLength = focalLength or 1
    setmetatable(self, {
        __index = camera
    })
    return self
end

return setmetatable({
    new = new
}, {})