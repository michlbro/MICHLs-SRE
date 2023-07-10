local Screen = {}
Screen.__index = Screen

-- default pixel
local pixel = Instance.new("Part")
pixel.Size = Vector3.one
pixel.Anchored = true
pixel.Color = Color3.new()
pixel.Parent = script

function Screen.new(cframe, size, pixelSize, parent)
    local self = {}
    self.cframe = cframe or CFrame.new()
    self.size = size or Vector2.new(10, 10)
    self.pixelSize = pixelSize or 0.25

    self.parent = Instance.new("Model")
    self.parent.Parent = parent or workspace
    
    self.screen = {}
    self.colourBuffer = {}

    setmetatable(self, Screen)
    self:_CreateScreen()

    self.thread = task.defer(function()
        while true do
            task.wait(2)
            for x, cols in self.screen do
                for y, pixel in self.screen do
                    local bufferColour = self.colourBuffer[x][y]
                    local pixelColour = pixel.Color
                    if pixelColour.R ~= bufferColour.R or pixelColour.G ~= bufferColour.G or pixelColour.B ~= bufferColour.B then
                        pixel.Color = bufferColour
                    end
                end
            end
        end
    end)

    return self
end

function Screen:_CreateScreen()
    for x = 0, self.size.X - 1 do
        self.screen[x] = {}
        self.colourBuffer[x] = {}
        for y = 0, self.size.Y -1 do
            local pixel = pixel:Clone()
            pixel.Size *= self.pixelSize
            pixel.CFrame = self.cframe * CFrame.new(((self.size.X/2) - x) * self.pixelSize, ((self.size.Y/2)- y) * self.pixelSize, 0)
            pixel.Parent = self.parent
        end
    end
end

function Screen:DrawPixel(x, y, vector3)
    local colour = Color3.new(vector3.X, vector3.Y, vector3.Z)
    self.colourBuffer[x][y] = colour
end

return Screen