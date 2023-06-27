local RunService = game:GetService("RunService")

local actorTemplate = script.Actor

local function CreateThread(parent, bindableEvent, id, module, ...)
    local actor: Actor = actorTemplate:Clone()
    actor.Name = id
    actor.Parent = parent
    if RunService:IsClient() then
        actor.Client.Enabled = true
    else
        actor.Server.Enabled = true
    end
    actor:SendMessage("Setup", id, bindableEvent, module, ...)
    return actor
end

local thread = {}

function thread:_CreateThread(module, ...)
    self.threadCount += 1
    return CreateThread(self.parent, self.bindableEvent, self.threadCount, module, ...)
end

function thread:GiveTask(...)
    if self.threadCount < self.threadMaxCount then
        local actor = self:_CreateThread(self.setupParams.module, self.setupParams.params)
        self.threads[self.threadCount] = actor
        actor:BindToMessage("Run", ...)
    end
    table.insert(self.threadQueue, {...})
end

function thread:SetupThreads(module, ...)
    self.setupParams = {
        module = module,
        params = {...}
    }
end

function thread:Join()
    local currentThread = coroutine.running()
    table.insert(self.joinThreads, currentThread)
    coroutine.yield()
end



local function new(threadCount, parent, callbackFunc)
    local self = {}
    self.parent = parent or script

    self.threadMaxCount = threadCount or 10
    self.threadCount = 0

    self.threads = {}
    self.freeThreads = {}
    self.threadQueue = {}

    self.joinThreads = {}

    self.bindableEvent = Instance.new("BindableEvent")
    self.bindableEvent.Parent = self.parent

    self.bindableEvent.Event:Connect(function(id, results)
        task.defer(callbackFunc, results)
        table.insert(self.freeThreads, id)

        if #self.threadQueue > 0 then
            local taskParam = table.remove(self.threadQueue, 1)
            local actorId = table.remove(self.freeThreads, 1)
            local actor = self.threads[actorId]
            actor:SendMessage("Run", table.unpack(taskParam))
        else
            for _, joinThread in self.joinThreads do
                task.defer(joinThread)
            end
        end
    end)

    setmetatable(self, {
        __index = thread
    })

    return self
end

return new