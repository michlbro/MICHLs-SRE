local srePipeline = {}

function srePipeline.SceneSetup(sceneObj)
    -- Setup cameraProjectionRaycastParams to only include objects in this scene
    local cameraProjectionRaycastParams = RaycastParams.new()
    cameraProjectionRaycastParams.FilterDescendantsInstances = sceneObj.scene

    return {
        cameraProjection = {
            raycastParams = cameraProjectionRaycastParams
        },
        lightingObjects = sceneObj.lightingObjects
    }
end

function srePipeline.CameraProjection(sceneSetup, cameraObj, raycastObj, raycastBuffer)
    local cameraProjectionRaycastParams = sceneSetup.cameraProjection.raycastParams
    local CameraProjectionDistance = raycastObj.cameraProjection.distance

    local cameraOrigin = cameraObj.origin.Position

    for x = 0, cameraObj.size.X do
        for y = 0, cameraObj.size.Y do
            local direction = Vector3.new()

            local raycastResult = workspace:Raycast(cameraOrigin, direction*CameraProjectionDistance, cameraProjectionRaycastParams)
            if raycastResult and raycastResult.Instance then
                raycastBuffer.buffer[x][y].intersected = true
                raycastBuffer.buffer[x][y].result = raycastResult
            end
        end
    end
end

function srePipeline.DirectIllumination(sceneSetup, raycastBuffer, directIlluminationBuffer, cameraObj, sceneObj, materialsObj)
    local directillumination = require(script.directillumination)

    local cameraProjectionRaycastParams = sceneSetup.cameraProjection.raycastParams
    local lightingObjects = sceneSetup.lightingObjects
    
    for x, yCols in raycastBuffer.buffer do
        for y, rayResult in yCols do
            if not rayResult.intersected then
                continue
            end
            local directLight, finalColour = directillumination(rayResult.result, lightingObjects, cameraProjectionRaycastParams, cameraObj, sceneObj, materialsObj)
            directIlluminationBuffer.buffer[x][y].directlyIlluminated = directLight
            directIlluminationBuffer.buffer[x][y].colour = finalColour
        end
    end
end

return srePipeline