return function(cameraProjectionBuffer, xCord, reflectionProperties)
    local reflectionBuffer = {}

    for yCord, pixel in cameraProjectionBuffer[xCord] do
        reflectionBuffer[yCord] = {}
    end
end