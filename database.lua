local ADDONNAME, ns = ...

local db

ns.RegisterEvent("ADDON_LOADED", function(event, addonName)
    if addonName == ADDONNAME then
        db = LibStub("AceDB-3.0"):New("ProtoformReagentStatusDB", {
            global = {
                recipes = {
                    -- [recipeID] = true,
                },
                reagents = {
                    ['*'] = { -- reagent itemID
                        -- [result itemID] = amount of reagents,
                    },
                },
                results = {
                    -- [result itemID] = ResultType,
                },
            },
            profile = {},
        }, true)

        ns.FireEvent("OnDatabaseLoaded", db)
        return true
    end
end)
