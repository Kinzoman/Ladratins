local EventQueue = {}

EventQueue.__index = EventQueue

local instance = nil
local function newEventQueue()
    local this = {
        globalEvents = {},
        specificEvents = {}
    }

    return setmetatable(this, EventQueue)
end

function EventQueue:getInstance()
    if not instance then
        instance = newEventQueue()
    end
    return instance
end

function EventQueue:push(event)
    table.insert(self.globalEvents, event)
end

function EventQueue:observe(event)
    if self.globalEvents[1] == event then
        table.remove(self.globalEvents, 1)
        return true
    end
    return false
end

function EventQueue:listenEvent(event, callback)
    if not self.specificEvents[event] then self.specificEvents[event] = {} end
    table.insert(self.specificEvents[event], callback)
end

function EventQueue:announceEvent(event, ...)
    if self.specificEvents[event] then
        for _, callback in pairs(self.specificEvents[event]) do
            callback(...)
        end
    end
end

return EventQueue
