std = "lua51"

max_code_line_length = 120
max_string_line_length = false
max_comment_line_length = false

max_cyclomatic_complexity = 32

ignore = {
    "211/ADDONNAME",
    "211/ns",
    "212/self",
    "212/event",
    -- "212/...",
}

read_globals = {
    -- Addons
    "LibStub",

    -- WoW Constance
    "Enum.ItemQuality.Rare",

    "ITEM_QUALITY_COLORS",

    -- WoW Strings
    "RETRIEVING_DATA",

    -- WoW UI
    "CallErrorHandler",
    "Item.CreateFromItemID",

    -- WoW Frames
    "GameTooltip",
    "ItemRefTooltip",
    "WorldFrame",

    -- WoW API
    "CreateFrame",

    "C_Item.GetItemQualityByID",
    "GetItemCount",
    "GetItemInfo",

    "C_MountJournal.GetMountFromItem",
    "C_MountJournal.GetMountInfoByID",

    "C_PetJournal.GetNumCollectedInfo",
    "C_PetJournal.GetPetInfoByItemID",

    "C_TradeSkillUI.GetAllRecipeIDs",
    "C_TradeSkillUI.GetRecipeItemLink",
    "C_TradeSkillUI.GetRecipeNumReagents",
    "C_TradeSkillUI.GetRecipeReagentInfo",
    "C_TradeSkillUI.GetRecipeReagentItemLink",
    "C_TradeSkillUI.GetTradeSkillLine",

    "C_Timer.After",

    -- WoW Lua API
    "hooksecurefunc",
    "wipe",
}
