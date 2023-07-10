local actor = script:GetActor()

local actorId, event, func = nil

actor:BindToMessage("Setup", function(id, bindableEvent, module, ...)
    actorId = id
    event = bindableEvent
    func = require(module)(...)
end)

actor:BindToMessage("Run", function(...)
    task.desynchronize()
    local results = func(...)
    task.synchronize()
    event:Fire(actorId, results)
end)