local screen = {}

local defaultScreen = {
    name = "Scren",
    pixelSize = 0.2,
    origin = CFrame.new()
}

local function new(properties)
    local self = {}
    for property, value in defaultScreen do
        if properties then
            self[property] = properties[property] ~= nil and properties[property] or value
            continue
        end
        self[property] = value
    end
    setmetatable(self, {
        __index = screen
    })

    return self
end

return setmetatable({
    new = new
}, {})