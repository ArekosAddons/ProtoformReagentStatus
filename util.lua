local ADDONNAME, ns = ...

do-- Event handling
    local frame = CreateFrame("Frame")
    local events = setmetatable({}, {
        __index = function(t, k)
            local v = {}
            t[k] = v
            return v
        end,
    })

    local function call_callbacks(callbacks, event, ...)
        local xpcall, CallErrorHandler = xpcall, CallErrorHandler

        for callback in pairs(callbacks) do
            local success, clear = xpcall(callback, CallErrorHandler, event, ...)

            if success and clear then
                callbacks[callback] = nil
            end
        end
    end

    ns.RegisterEvent = function(event, callback, skipRegisterEvent)
        if not skipRegisterEvent then
            xpcall(frame.RegisterEvent, CallErrorHandler, frame, event)
        end

        events[event][callback] = true
    end

    ns.FireEvent = function(event, ...)
        call_callbacks(events[event], event, ...)
    end

    frame:SetScript("OnEvent", function(self, event, ...)
        local callbacks = events[event]
        call_callbacks(callbacks, event, ...)

        if next(callbacks) == nil then
            frame:UnregisterEvent(event)
        end
    end)
end
