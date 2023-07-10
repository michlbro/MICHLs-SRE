local Material = require(script.Material)
local CastRay = require(script.CastRay)

local parallel = {
    RayTrace = require(script.TraceRay),
    Shader = require(script.Shader)
}

return function(materials, sceneObjects)
    local MaterialFunc = Material(materials)
    local CastRayFunc = CastRay(sceneObjects)
    return function(func, ...)
        return parallel[func](..., MaterialFunc, CastRayFunc)
    end
end