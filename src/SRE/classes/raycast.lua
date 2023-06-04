local defaultRaycastProperties = {
    raycastDistance = 100
}

local raycast = {}

local function new(properties)
    local self = {}
    for property, value in defaultRaycastProperties do
        if properties then
            if not properties[property] then
                self[property] = value
            else
                self[property] = properties[property]
            end
        end
    end
    
    setmetatable(self, {
        __index = raycast
    })
    return self
end

return setmetatable({
    new = new
}, {})