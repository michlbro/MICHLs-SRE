local pixel = {}

function pixel:Intersects(instance, instanceColour, rayResult, material)
    self.ray.intersects = true
    self.ray.result = rayResult
    self.object.colour = instanceColour
    self.object.material = material
    self.instance = instance
end

local function new(screenPosition, material)
    local self = {}
    self.colour = Vector3.zero
    self.object = {
        material = material,
        colour = Vector3.zero,
        instance = nil
    }
    self.ray = {
        intersects = false
    }
    self.screen = {
        position = screenPosition
    }
    setmetatable(self, {
        __index = pixel
    })
    return self
end

return setmetatable({new = new}, {})