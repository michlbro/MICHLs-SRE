local threads = {}

local defaultThreads = {
    threads = 10
}

local function new(properties)
    local self = {}
    for property, value in defaultThreads do
        if properties then
            self[property] = properties[property] ~= nil and properties[property] or value
            continue
        end
        self[property] = value
    end
    setmetatable(self, {
        __index = threads
    })

    return self
end

return setmetatable({
    new = new
}, {})