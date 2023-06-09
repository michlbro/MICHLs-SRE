local screen = {}

local function Vector3ToColor3(vector, clamp, min, max)
    local x, y, z = vector.X, vector.Y, vector.Z
    if clamp then
        x, y, z = math.clamp(x, min, max), math.clamp(y, min, max), math.clamp(z, min, max)
        return Color3.new(x, y, z)
    end
    return Color3.new(x, y, z)
end

function screen:DrawPixel(x, y, colour, clamp, min, max)
    local pixelColour = Vector3ToColor3(colour, clamp, min, max)
    self.frame[x][y] = pixelColour
end

function screen:_Runtime()
    task.spawn(function()
        while true do
            task.wait(1)
            for x = 0, self.size.X-1 do
                for y = 0, self.size.Y-1 do
                    local pixelColour = self.frame[x][y]
                    local pixel = self.pixels[x][y]
                    pixel.Color = pixelColour
                end
            end
        end
    end)
end

local function new(screenObj, size, name)
    local self = {}
    self.screenProperties = screenObj

    self.screen = Instance.new("Model")
    self.screen.Name = name or "Screen"
    self.frame = {}
    self.pixels = {}
    self.size = size
    for x = 0, size.X-1 do
        self.frame[x] = {}
        self.pixels[x] = {}
        for y = 0, size.Y-1 do
            local pixel = Instance.new("Part")
            pixel.Size = Vector3.one * self.screenProperties.pixelSize
            pixel.Anchored = true
            pixel.CanCollide = false
            pixel.CanQuery = false
            pixel.CanTouch = false
            pixel.CastShadow = false
            self.frame[x][y] = Color3.new()
            self.pixels[x][y] = pixel
            pixel.CFrame = self.screenProperties.origin * CFrame.new(((x-1)*self.screenProperties.pixelSize), ((y)*self.screenProperties.pixelSize), 0)
            pixel.Parent = self.screen
        end
    end
    self.screen.Parent = workspace
    self.screen:PivotTo(self.screenProperties.origin)

    setmetatable(self, {
        __index = screen
    })
    self:_Runtime()
    return self
end

return setmetatable({
    new = new
}, {})