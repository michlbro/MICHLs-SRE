local Reflect = require(script.Reflect)

return function(cameraProjectionBuffer, camera, MaterialFunc, CastRay)
    local reflectionBuffer = {}

    for yCord, pixel in cameraProjectionBuffer do
        reflectionBuffer[yCord] = Reflect(pixel[1], pixel[2], camera, CastRay, MaterialFunc)
    end
    return reflectionBuffer
end