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
    if C_TradeSkillUI.GetTradeSkillLine() ~= TRADE_SKILL_LINE_ID then return end

    for recipeID, _ in pairs(RecipesDB) do
        local itemLink = C_TradeSkillUI.GetRecipeItemLink(recipeID)
        local itemID = tonumber(itemLink and itemLink:match("item:(%d+)"))

        if itemID then -- can only be one of pet or mount but not both
            if C_MountJournal.GetMountFromItem(itemID) then
                ResultsDB[itemID] = RESULT_TYPES.MOUNT
            elseif C_PetJournal.GetPetInfoByItemID(itemID) then
                ResultsDB[itemID] = RESULT_TYPES.PET
            else
                local link = "|cFFFFFF00|Hitem:".. itemID .. "|h[" .. itemID .. "]|h|r"
                print("[PRS] Recipe result of " .. link .. " is neither mount or pet.")
                ResultsDB[itemID] = RESULT_TYPES.OTHER
            end

            local numReagents = C_TradeSkillUI.GetRecipeNumReagents(recipeID) or 0

            for i=1, numReagents do
                local link = C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, i)
                local reagentItemID = tonumber(link and link:match("item:(%d+)"))

                if reagentItemID then
                    local _, _, reagentCount = C_TradeSkillUI.GetRecipeReagentInfo(recipeID, i)

                    ReagentsDB[reagentItemID][itemID] = reagentCount
                --@debug@
                else
                    print("[PRS] Failed to lookup reagent#" ..  i .. " for recipeID:", recipeID)
                --@end-debug@
                end
            end
        end
    end

    ns.FireEvent("OnDataRefreshed")
end

local function get_all_recipeIDs()
    if C_TradeSkillUI.GetTradeSkillLine() ~= TRADE_SKILL_LINE_ID then return end
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
        if C_TradeSkillUI.GetTradeSkillLine() ~= TRADE_SKILL_LINE_ID then return end

        C_Timer.After(1, get_all_recipeIDs)
    end)

    return true
end, true)
