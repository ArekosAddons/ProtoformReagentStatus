local ADDONNAME, ns = ...


local TRADE_SKILL_LINE_ID = 2819 -- Protoform Synthesis

local RESULT_TYPES = {
    OTHER = "OTHER",
    MOUNT = "MOUNT",
    PET = "PET"
}
ns.RESULT_TYPES = RESULT_TYPES


local RecipesDB
local ReagentsDB -- luacheck: ignore 331/ReagentsDB
local ResultsDB -- luacheck: ignore 331/ResultsDB

local function reevaluate_reagents()
    if C_TradeSkillUI.GetBaseProfessionInfo().professionID ~= TRADE_SKILL_LINE_ID then return end

    for recipeID, _ in pairs(RecipesDB) do
        local recipeSchematic = C_TradeSkillUI.GetRecipeSchematic(recipeID, false)

        local itemID = recipeSchematic.outputItemID
        if itemID then -- can only be one of pet or mount but not both
            if C_MountJournal.GetMountFromItem(itemID) then
                ResultsDB[itemID] = RESULT_TYPES.MOUNT
            elseif C_PetJournal.GetPetInfoByItemID(itemID) then
                ResultsDB[itemID] = RESULT_TYPES.PET
            else
                --@debug@
                local link = "|cFFFFFF00|Hitem:".. itemID .. "|h[" .. itemID .. "]|h|r"
                print("[PRS] Recipe result of " .. link .. " is neither mount or pet.")
                --@end-debug@
                ResultsDB[itemID] = RESULT_TYPES.OTHER
            end

            for _, reagentSchematic in pairs(recipeSchematic.reagentSlotSchematics) do
                local reagentCount = reagentSchematic.quantityRequired
                local reagentItemID = reagentSchematic.reagents[1]

                if reagentItemID then
                    ReagentsDB[reagentItemID][itemID] = reagentCount
                end
            end
        end
    end

    ns.FireEvent("OnDataRefreshed")
end

local function get_all_recipeIDs()
    if C_TradeSkillUI.GetBaseProfessionInfo().professionID ~= TRADE_SKILL_LINE_ID then return end
    local hasChanges = false

    local recipeIDs = C_TradeSkillUI.GetAllRecipeIDs()
    for _, id in ipairs(recipeIDs) do
        if not RecipesDB[id] then
            hasChanges = true
        end
        RecipesDB[id] = true
    end

    --@debug@
    print("[PRS] Protoform recipes hasChanges:", hasChanges)
    --@end-debug@

    if hasChanges then
        reevaluate_reagents()
    end
end

ns.RegisterEvent("OnDatabaseLoaded", function(event, db)
    RecipesDB = db.global.recipes
    ReagentsDB = db.global.reagents
    ResultsDB = db.global.results

    ns.RegisterEvent("TRADE_SKILL_SHOW", function()
        if C_TradeSkillUI.GetBaseProfessionInfo().professionID ~= TRADE_SKILL_LINE_ID then return end

        C_Timer.After(1, get_all_recipeIDs)
    end)

    return true
end, true)
