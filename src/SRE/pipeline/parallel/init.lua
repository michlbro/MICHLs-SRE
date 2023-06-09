local fragment = require(script.fragment)
local material = require(script.material)
local raycast = require(script.raycast)
--[[
return function(_, id, height, config)
    local Budget = 1/60 -- seconds
    local expireTime = 0

    -- Call at start of process.
    local function ResetTimer()
        expireTime = os.clock() + Budget
    end

    -- Call where appropriate, such as at the top of loops.
    local function MaybeYield()
        if os.clock() >= expireTime then
            task.wait() -- insert preferred yielding method
            ResetTimer()
        end
    end



    local materialFunc = material(config.materials)
    local raycastFunc = raycast(config.raycast.raycastParams)

    local bottomLeftLocal = height.bottomLeftLocal

    local heightBuffer = {}

    for y = 0, height.size.Y-1 do
        --[[
        if y % 20 == 0 then
            task.wait()
        end
        if id == 0 then
            print((y/height.size.Y) * 100)
        end
        MaybeYield()
        local pixel = {}
        pixel.uv = Vector2.new(height.currentWidth/(height.size.X), y/(height.size.Y))
        pixel.cords = {height.currentWidth, y}
        local pointLocal = bottomLeftLocal + Vector3.new(height.size.X * pixel.uv.X, height.size.Y * pixel.uv.Y, 0)
        local point = height.CFrame.Position + height.CFrame.RightVector * pointLocal.X + height.CFrame.UpVector * pointLocal.Y + height.CFrame.LookVector * pointLocal.Z
        pixel.point = point
        pixel.direction = (point - height.CFrame.Position).unit
        pixel.origin = height.CFrame.Position
        pixel.size = height.size
        heightBuffer[y] = {pixel.cords, fragment(pixel, config, raycastFunc, materialFunc)}
    end
    return heightBuffer
end]]--

return function(_, id, pixel, config)
    local materialFunc = material(config.materials)
    local raycastFunc = raycast(config.raycast.raycastParams)

    return {pixel.cords, fragment(pixel, config, raycastFunc, materialFunc)}
end

