local ADDONNAME, ns = ...

local db

local MOUNT = ns.RESULT_TYPES.MOUNT
local PET = ns.RESULT_TYPES.PET
local OTHER = ns.RESULT_TYPES.OTHER

local DATA = {
    -- [RESULT_TYPES] = {
    --    [itemID] = {
    --        [reageantItemID] = amount,
    --    },
    -- }
    [PET] = {
        [187734] = {
            [189157] = 1,
            [189153] = 1,
            [188957] = 350,
        },
        [189366] = {
            [189161] = 1,
            [189148] = 1,
            [188957] = 200,
        },
        [189381] = {
            [189165] = 1,
            [189152] = 1,
            [188957] = 300,
        },
        [187928] = {
            [189162] = 1,
            [187634] = 1,
            [188957] = 300,
        },
        [189370] = {
            [189162] = 1,
            [188957] = 400,
            [189146] = 1,
        },
        [189374] = {
            [189166] = 1,
            [189147] = 1,
            [188957] = 250,
        },
        [189378] = {
            [189145] = 1,
            [189168] = 1,
            [188957] = 400,
        },
        [189382] = {
            [187633] = 1,
            [189168] = 1,
            [188957] = 300,
        },
        [189363] = {
            [189160] = 1,
            [187634] = 1,
            [188957] = 250,
        },
        [189367] = {
            [189148] = 1,
            [189167] = 1,
            [188957] = 300,
        },
        [189371] = {
            [187636] = 1,
            [188957] = 300,
            [189166] = 1,
        },
        [189375] = {
            [189147] = 1,
            [189164] = 1,
            [188957] = 300,
        },
        [189379] = {
            [188957] = 150,
            [189155] = 1,
            [189170] = 1,
        },
        [189383] = {
            [189154] = 1,
            [189161] = 1,
            [188957] = 300,
        },
        [187713] = {
            [189160] = 1,
            [189153] = 1,
            [188957] = 300,
        },
        [187795] = {
            [189156] = 1,
            [188957] = 300,
            [189159] = 1,
        },
        [189364] = {
            [189169] = 1,
            [188957] = 300,
            [189151] = 1,
        },
        [189368] = {
            [189148] = 1,
            [189164] = 1,
            [188957] = 350,
        },
        [189372] = {
            [187636] = 1,
            [189165] = 1,
            [188957] = 400,
        },
        [187733] = {
            [189169] = 1,
            [189153] = 1,
            [188957] = 250,
        },
        [189380] = {
            [188957] = 300,
            [189155] = 1,
            [189158] = 1,
        },
        [187803] = {
            [189163] = 1,
            [189149] = 1,
            [188957] = 300,
        },
        [189377] = {
            [189145] = 1,
            [188957] = 300,
            [189170] = 1,
        },
        [189376] = {
            [189145] = 1,
            [188957] = 150,
            [189167] = 1,
        },
        [189365] = {
            [189163] = 1,
            [188957] = 400,
            [189151] = 1,
        },
        [189369] = {
            [189157] = 1,
            [188957] = 300,
            [189146] = 1,
        },
        [189373] = {
            [187636] = 1,
            [189159] = 1,
            [188957] = 450,
        },
        [187798] = {
            [189156] = 1,
            [189158] = 1,
            [188957] = 350,
        },
    },
    [OTHER] = {
    },
    [MOUNT] = {
        [187641] = {
            [189175] = 1,
            [187635] = 1,
            [188957] = 300,
        },
        [187630] = {
            [189172] = 1,
            [189156] = 1,
            [188957] = 400,
        },
        [187665] = {
            [189154] = 1,
            [189176] = 1,
            [188957] = 500,
        },
        [187667] = {
            [189175] = 1,
            [189150] = 1,
            [188957] = 350,
        },
        [187669] = {
            [189172] = 1,
            [188957] = 500,
            [189145] = 1,
        },
        [187677] = {
            [189171] = 1,
            [189152] = 1,
            [188957] = 400,
        },
        [187631] = {
            [189175] = 1,
            [189156] = 1,
            [188957] = 450,
        },
        [187666] = {
            [189180] = 1,
            [188957] = 400,
            [189150] = 1,
        },
        [187639] = {
            [187635] = 1,
            [188957] = 400,
            [189176] = 1,
        },
        [187678] = {
            [189177] = 1,
            [189152] = 1,
            [188957] = 450,
        },
        [187670] = {
            [189145] = 1,
            [188957] = 400,
            [189179] = 1,
        },
        [187672] = {
            [189145] = 1,
            [189177] = 1,
            [188957] = 350,
        },
        [187632] = {
            [189156] = 1,
            [188957] = 450,
            [189174] = 1,
        },
        [190580] = {
            [189172] = 1,
            [190388] = 1,
            [188957] = 500,
        },
        [187671] = {
            [189178] = 1,
            [188957] = 300,
            [189145] = 1,
        },
        [188809] = {
            [189178] = 1,
            [188957] = 350,
            [187633] = 1,
        },
        [188810] = {
            [187633] = 1,
            [188957] = 350,
            [189174] = 1,
        },
        [187679] = {
            [188957] = 500,
            [189176] = 1,
            [189152] = 1,
        },
        [187683] = {
            [187633] = 1,
            [189171] = 1,
            [188957] = 400,
        },
        [187663] = {
            [189154] = 1,
            [189179] = 1,
            [188957] = 350,
        },
        [187660] = {
            [189154] = 1,
            [189180] = 1,
            [188957] = 400,
        },
        [187664] = {
            [189154] = 1,
            [189173] = 1,
            [188957] = 450,
        },
        [187668] = {
            [189150] = 1,
            [189173] = 1,
            [188957] = 450,
        },
        [187638] = {
            [189178] = 1,
            [187635] = 1,
            [188957] = 450,
        },
    },
}

--@debug@
-- collects data for the DATA table
ns.RegisterEvent("OnDatabaseLoaded", function(_, database)
    local global = database.global
    local output = {}

    for _, value in pairs(ns.RESULT_TYPES) do
        output[value] = {}
    end

    local results = global.results
    for itemID, resultType  in pairs(results) do
        output[resultType][itemID] = {}
    end

    for reagentItemID, data in pairs(global.reagents) do
        for itemID, amount in pairs(data) do
            output[results[itemID] or OTHER][itemID][reagentItemID] = amount
        end
    end

    global.output = output
    return true
end, true)
--@end-debug@

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
                version = 0,
            },
            profile = {},
        }, true)

        -- import data the first time
        if db.global.version < 1 then
            local global = db.global
            local results = global.results
            local reagents = global.reagents

            for resultType, data in pairs(DATA) do
                for itemID, reagentData in pairs(data) do
                    results[itemID] = resultType

                    for reagentItemID, amount in pairs(reagentData) do
                        reagents[reagentItemID][itemID] = amount
                    end
                end
            end

            global.version = 1
        end
        DATA = nil -- mark as unused

        ns.FireEvent("OnDatabaseLoaded", db)
        return true
    end
end)
