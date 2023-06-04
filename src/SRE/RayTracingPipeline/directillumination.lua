local function Reflect(incidentDirection, surfaceNormal)
    local dotProduct = incidentDirection:Dot(surfaceNormal)
    return incidentDirection - 2 * dotProduct * surfaceNormal
end
return function(cameraProjectionResult, lightingObjects, cameraProjectionRaycastParams, cameraObj, sceneObj, materialsObj)
    local origin = cameraProjectionResult.Position

    local tempColor = sceneObj.ambientColour
    local sceneAmbientColour = Vector3.new(tempColor.R, tempColor.G, tempColor.B)

    local surfaceMaterial = materialsObj:GetMaterial(cameraProjectionResult.Material)
    
    local finalSurfaceColour = sceneAmbientColour

    local reachesIlluminatedObject = false
    for _, lightObject in lightingObjects do
        local direction:Vector3 = lightObject.Position - origin
        local raycastResult = workspace:Raycast(origin, direction, cameraProjectionRaycastParams)

        if raycastResult and raycastResult.Instance then
            if raycastResult.Instance == lightObject then
                reachesIlluminatedObject = true
                local lightObjectMaterial = materialsObj:GetMaterial(lightObject.Material)
                local surfaceColour = (function()
                    local color = raycastResult.Instance.Color
                    return Vector3.new(color.R, color.G, color.B)
                end)()

                local lightObjectColour = Vector3.new(lightObject.Color.R, lightObject.Color.G, lightObject.Color.B)
                local lightFactor = cameraProjectionResult.Normal:Dot(direction.Unit)
                local diffuseLight = surfaceColour * math.max(lightFactor, 0) * lightObjectColour * lightObjectMaterial.lightIntensity

                local reflectionDirection = Reflect(-direction.Unit, cameraProjectionResult.Normal)
                local specularIntensity = reflectionDirection:Dot((origin - cameraObj.origin.Position).Unit)
                local specularColour = math.pow(math.max(specularIntensity, 0), surfaceMaterial.glossFactor) * surfaceMaterial.specularColour

                finalSurfaceColour += diffuseLight + specularColour
            end
        end
    end
    return reachesIlluminatedObject, Vector3.new(math.clamp(finalSurfaceColour.X, 0, 1), math.clamp(finalSurfaceColour.Y, 0, 1), math.clamp(finalSurfaceColour.Z, 0, 1))
end