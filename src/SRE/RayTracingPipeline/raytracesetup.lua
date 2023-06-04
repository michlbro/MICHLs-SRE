local utils = script.utils
return function(sceneObj, cameraObj, raycastObj, materialsObj)
    local raytrace = {}

    raytrace.utils = {}
    raytrace.utils.Colour3ToVector3 = require(utils.Colour3ToVector3)

    raytrace.objects = {
        scene = sceneObj,
        camera = cameraObj,
        raycast = raycastObj,
        materials = materialsObj
    }

    raytrace.raycast = {}
    raytrace.raycast.raycastParams = RaycastParams.new()
    raytrace.raycast.raycastParams.FilterDescendantsInstances = sceneObj.scene
    raytrace.raycast.raycastParams.FilterType = Enum.RaycastFilterType.Include
    raytrace.raycast.raycastDistance = raycastObj.raycastDistance

    raytrace.materials = materialsObj:DumpMaterials()

    raytrace.scene = {}
    lightObjects = sceneObj.lightObjects

    return raytrace
end
