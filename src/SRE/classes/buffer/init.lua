local Element = require(script.element)

local Buffer = {}

function Buffer:Destroy()
    for _, cols in self.buffer do
        for _, element in cols do
            element:Destroy()
        end
        cols = nil
    end
    self.buffer = nil
    self.size = nil
    self = nil
end

local function new(size, bufferDataType, start)
    start = start or Vector2.zero

    local self = {}
    self.buffer = {}
    self.size = 0

    for x = start.X, size.X - 1 do
        self.buffer[x] = {}
        for y = start.Y, size.Y - 1 do
            self.buffer[x][y] = Element.new(Vector2.new(x, y), bufferDataType)
            self.size += 1
        end
    end

    setmetatable(self, {
        __index = Buffer
    })
    return self
end

return setmetatable({
    new = new
}, {})