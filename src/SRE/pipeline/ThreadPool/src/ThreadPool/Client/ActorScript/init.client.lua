--[[
    Multithreadpool-luau
    Author: XxprofessgamerxX (github: michlbro)
    09/06/2023
]]

local module, sharedTable, id, event = nil, nil, nil, nil

local actor = script:GetActor()

actor:BindToMessage("Setup", function(mt, st, ai, be)
    module, sharedTable, id, event = require(mt), st, ai, be
end)

actor:BindToMessage("RunThread", function(params)
    task.desynchronize()
    event:Fire(id, module(sharedTable, table.unpack(params)))
end)