local parallel = {
    RayTrace = require(script.TraceRay),
    Shader = require(script.Shader)
}

return function(func, ...)
    return parallel[func](...)
end