return function(rt, rayResult)
    local baseColour = rt.utils.Colour3ToVector3(rayResult.Colour)

    for _, lightObject in rt.scene.lightObjects do
        local lightRayDirection = (lightObject.Position - rayResult.Position)
        local lightRayResult = workspace:Raycast(rayResult.Position, lightRayDirection)
    end
end
