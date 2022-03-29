local ADDONNAME, ns = ...


local L = LibStub("AceLocale-3.0"):GetLocale(ADDONNAME)

local RareQuality = Enum.ItemQuality.Rare or 3
local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS

local MOUNT_ICON = 631718 -- mountjournalportrait
local PET_ICON = 631719 -- petjournalportrait
local QUESTIONMARK_ICON = 134400 -- inv_misc_questionmark

local GENESIS_MOTE_ITEM_ID = 188957 -- Genesis Mote
local RESULT_TYPES = ns.RESULT_TYPES
local DISPALY_TYPES = {
    NONE    = 0,
    MOTE    = 1,
    SOUL    = 2,
    LATTICE  = 3,
}

local scanTooltip = CreateFrame("GameTooltip", ADDONNAME .. "Tooltip", nil, "SharedTooltipTemplate")
local scanTooltipName = scanTooltip:GetName()
scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local start_scan, PROTOFORM_SYNTHESIS_STRING, COLOUR_HEX, TAG do
    local delay = 0

    local function scan()
        scanTooltip:ClearLines()
        scanTooltip:SetItemByID(GENESIS_MOTE_ITEM_ID)

        PROTOFORM_SYNTHESIS_STRING = _G[scanTooltipName .. "TextLeft2"]:GetText()
        if PROTOFORM_SYNTHESIS_STRING == nil then
            --@debug@
            print("[PRS] String is nil")
            --@end-debug@
            delay = delay + 3
            return C_Timer.After(delay, scan)
        end
        COLOUR_HEX = PROTOFORM_SYNTHESIS_STRING:match("(|c%x%x%x%x%x%x%x%x)") or "|cFF66BBFF"
        TAG = COLOUR_HEX .. L.REAGENT_STATUS .. "|r"
    end

    local function delay_scan()
        -- re-logging does not have the data on ContinueOnItemLoad, so delay for a second
        C_Timer.After(1, scan)
    end

    function start_scan()
        local item = Item:CreateFromItemID(GENESIS_MOTE_ITEM_ID)
        item:ContinueOnItemLoad(delay_scan)
    end
end

local ReagentsDB
local ResultsDB


local function get_mount_info(itemID)
    local mountID = C_MountJournal.GetMountFromItem(itemID)
    if not mountID then return false, nil, nil end
    local name, _, icon, _, _, _, _, _, _, _, isCollected
        = C_MountJournal.GetMountInfoByID(mountID)

    return mountID, name, icon, isCollected
end

local function get_pet_info(itemID)
    local name, icon, _, _, _, _, _, _, _, _, _, _, speciesID
        = C_PetJournal.GetPetInfoByItemID(itemID)
    if not name then return false, nil, nil, 0, 3 end
    local numCollected, limit = C_PetJournal.GetNumCollectedInfo(speciesID)

    return speciesID, name, icon, numCollected, limit
end

local get_display_style, clear_style_cache do
    local cache = { -- NOTE: change here need to be applied to `clear_style_cache` too
        [GENESIS_MOTE_ITEM_ID] = DISPALY_TYPES.MOTE,
    }

    function get_display_style(id)
        if cache[id] then return cache[id] end
        local style = DISPALY_TYPES.NONE

        local _, _, quality, _, _, _, _, _, _, _, _, _, _, _, _, _, isCraftingReagent
            = GetItemInfo(id)

        if isCraftingReagent then
            scanTooltip:ClearLines()
            scanTooltip:SetItemByID(id)

            if _G[scanTooltipName .. "TextLeft2"]:GetText() == PROTOFORM_SYNTHESIS_STRING then
                if quality == RareQuality then
                    style = DISPALY_TYPES.SOUL
                else
                    style = DISPALY_TYPES.LATTICE
                end
            end
        end

        cache[id] = style
        return style
    end

    function clear_style_cache()
        wipe(cache)
        cache[GENESIS_MOTE_ITEM_ID] = DISPALY_TYPES.MOTE
    end
end

local get_mote_usage, clear_mote_cache do
    local mounts, pets1, pets2, pets3, others
    local isScheduleActive = false

    function get_mote_usage(data)
        if mounts then return mounts, pets1, pets2, pets3, others end
        local scheduleCacheClear = false
        mounts, pets1, pets2, pets3, others = 0, 0, 0, 0, 0

        for itemID, amount in pairs(data) do
            local resultType = ResultsDB[itemID]

            if resultType == RESULT_TYPES.MOUNT then
                local mountID, _, _, isCollected = get_mount_info(itemID)

                if mountID == false then
                    scheduleCacheClear = true
                end

                if not isCollected  then
                    mounts = mounts + amount
                end
            elseif resultType == RESULT_TYPES.PET then
                local speciesID, _, _, numCollected, limit = get_pet_info(itemID)

                if speciesID == false then
                    scheduleCacheClear = true
                end

                if numCollected == 0 then
                    pets1 = pets1 + amount

                    if limit >= 2 then
                        pets2 = pets2 + amount

                        if limit >= 3 then
                            pets3 = pets3 + amount
                        end
                    end
                elseif numCollected == 1 and limit >= 2 then
                    pets2 = pets2 + amount

                    if limit >= 3 then
                        pets3 = pets3 + amount
                    end
                elseif numCollected == 2 and limit >= 3 then
                    pets3 = pets3 + amount
                end
            else
                others = others + amount
            end
        end

        if scheduleCacheClear and not isScheduleActive then
            isScheduleActive = true
            C_Timer.After(1 , clear_mote_cache)
        end

        return mounts, pets1, pets2, pets3, others
    end

    function clear_mote_cache()
        mounts = nil
        isScheduleActive = false
    end
end

local get_use_list, clear_list_cache do
    local NAME_SS = "%s (%s|T4287471:0|t)" -- 4287471: inv_progenitor_protoformsynthesis
    local cache = {}
    local isScheduleActive = false

    function get_use_list(data)
        if cache[data] then return unpack(cache[data]) end
        local scheduleCacheClear = false
        local mounts, pets, other
            -- o = owned, l = limit
            = { o = 0, l = 0, },
              { o = 0, l = 0, },
              { o = 0, l = 0, }

        local motes = ReagentsDB[GENESIS_MOTE_ITEM_ID]

        for itemID in pairs(data) do
            local resultType = ResultsDB[itemID]
            local cost = motes[itemID] or "?"
            local quality = C_Item.GetItemQualityByID(itemID)
            if not quality then
                scheduleCacheClear = true
                quality = 0
            end

            if resultType == RESULT_TYPES.MOUNT then
                local _, name, icon, isCollected = get_mount_info(itemID)
                if not name then
                    scheduleCacheClear = true
                    name = RETRIEVING_DATA
                end
                if not icon then
                    scheduleCacheClear = true
                    icon = QUESTIONMARK_ICON
                end

                local state = L.MISSING
                if isCollected then
                    state = L.COLLECTED

                    mounts.o = mounts.o + 1
                end
                mounts.l = mounts.l + 1

                mounts[#mounts + 1] = {
                    string.format(NAME_SS, ITEM_QUALITY_COLORS[quality].hex .. "[" .. name .. "]|r", cost),
                    state,
                    icon
                }
            elseif resultType == RESULT_TYPES.PET then
                local _, name, icon, numCollected, l = get_pet_info(itemID)
                if not name then
                    scheduleCacheClear = true
                    name = RETRIEVING_DATA
                end
                if not icon then
                    scheduleCacheClear = true
                    icon = QUESTIONMARK_ICON
                end

                local state
                if numCollected > 0 then
                    state = string.format(L.PET_COLLECTED_DD, numCollected, l)

                    pets.o = pets.o + 1
                else
                    state = string.format(L.PET_MISSING_DD, numCollected, l)
                end
                pets.l = pets.l + 1

                pets[#pets + 1] = {
                    string.format(NAME_SS, ITEM_QUALITY_COLORS[quality].hex .. "[" .. name .. "]|r", cost),
                    state,
                    icon
                }
            else
                local _, link, _, _, _, _, _, _, _, icon = GetItemInfo(itemID)
                local isCollected = GetItemCount(itemID, true) > 0
                if not link then
                    scheduleCacheClear = true
                    link = RETRIEVING_DATA
                end
                if not icon then
                    scheduleCacheClear = true
                    icon = QUESTIONMARK_ICON
                end

                local state = L.MISSING
                if isCollected then
                    state = L.COLLECTED

                    other.o = other.o + 1
                end
                other.l = other.l + 1

                other[#other + 1] = { string.format(NAME_SS, link, cost), state, icon }
            end
        end

        if scheduleCacheClear and not isScheduleActive then
            isScheduleActive = true
            C_Timer.After(1, clear_list_cache)
        end

        cache[data] = {mounts, pets, other}
        return unpack(cache[data])
    end

    function clear_list_cache()
        wipe(cache)
        isScheduleActive = false
    end
end

ns.RegisterEvent("OnDataRefreshed", function(event)
    clear_style_cache()
    clear_mote_cache()
    clear_list_cache()
end, true)


local function render_title(tooltip, resultType, owend, available)
    -- Title (2/3)
    local title = L["TYPE_" .. resultType] or resultType
    tooltip:AddLine(string.format("%s%s|r (|cFFFFFFFF%d|r/|cFFFFFFFF%d|r)", COLOUR_HEX, title, owend, available))
end

local TEXTUREINFO = {margin={left=5, top=2, right=2}}
local function render_items(tooltip, data)
    -- Icon[Item name] <-> 1/3
    tooltip:AddDoubleLine(data[1], data[2], nil, nil, nil, 1, 1, 1)
    tooltip:AddTexture(data[3], TEXTUREINFO)
end


local function soul_and_lattice_render(tooltip, data)
    local mounts, pets, others = get_use_list(data)

    if #mounts > 0 then
        render_title(tooltip, RESULT_TYPES.MOUNT, mounts.o, mounts.l)
        for _, mount in ipairs(mounts) do
            render_items(tooltip, mount)
        end
    end

    if #pets > 0 then
        render_title(tooltip, RESULT_TYPES.PET, pets.o, pets.l)
        for _, pet in ipairs(pets) do
            render_items(tooltip, pet)
        end
    end

    if #others > 0 then
        render_title(tooltip, RESULT_TYPES.OTHER, others.o, others.l)
        for _, other in ipairs(others) do
            render_items(tooltip, other)
        end
    end
end

local RENDERS = {
    [DISPALY_TYPES.MOTE] = function(tooltip, data)
        local mounts, pets1, pets2, pets3, others = get_mote_usage(data)

        tooltip:AddLine(string.format(L.NEEDED_MOTES_S, TAG), 1, 1, 1)

        local hasAnyNeed = false
        if mounts > 0 then
            hasAnyNeed = true
            tooltip:AddLine(string.format(L.MOUNTS_D, mounts), 1, 1, 1)
            tooltip:AddTexture(MOUNT_ICON, TEXTUREINFO)
        end
        if pets1 > 0 then
            hasAnyNeed = true
            tooltip:AddLine(string.format(L.FIRST_PETS_D, pets1), 1, 1, 1)
            tooltip:AddTexture(PET_ICON, TEXTUREINFO)
        end
        if pets2 > 0 then
            hasAnyNeed = true
            tooltip:AddLine(string.format(L.SECOND_PETS_D, pets2), 1, 1, 1)
            tooltip:AddTexture(PET_ICON, TEXTUREINFO)
        end
        if pets3 > 0 then
            hasAnyNeed = true
            tooltip:AddLine(string.format(L.THIRD_PETS_D, pets3), 1, 1, 1)
            tooltip:AddTexture(PET_ICON, TEXTUREINFO)
        end
        if others > 0 then
            hasAnyNeed = true
            tooltip:AddLine(string.format(L.OTHERS_D, pets3), 1, 1, 1)
        end

        if not hasAnyNeed then
            tooltip:AddLine(L.MOTES_NO_NEED, 1, 1, 1)
        end
    end,
    [DISPALY_TYPES.SOUL] = soul_and_lattice_render,
    [DISPALY_TYPES.LATTICE] = soul_and_lattice_render,
}

local function onTooltip(tooltip, link)
    local id = tonumber(link and link:match("item:(%d+)"))
    if not id then return end

    local style = get_display_style(id)
    if style == DISPALY_TYPES.NONE then return end

    local data = ReagentsDB[id]
    if next(data) == nil then
        tooltip:AddLine(string.format(L.NO_KNOWN_RECIPE_S, TAG), 1, 1, 1)
    else
        RENDERS[style](tooltip, data)
    end
    tooltip:Show()
end


local HookTooltip do-- HookTooltip
    local hooked = {}

    local function SetXItem(self)
        local _, link = self:GetItem()
        onTooltip(self, link)
    end
    local function SetRecipeResultItem(self, recipeID)
        local link = C_TradeSkillUI.GetRecipeItemLink(recipeID)
        onTooltip(self, link)
    end
    local function SetRecipeReagentItem(self, recipeID, index)
        local link = C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, index)
        onTooltip(self, link)
    end

    function HookTooltip(tooltip)
        if hooked[tooltip] then return end
        hooked[tooltip] = true

        hooksecurefunc(tooltip, "SetBagItem", SetXItem)
        hooksecurefunc(tooltip, "SetBuybackItem", SetXItem)
        hooksecurefunc(tooltip, "SetCompareItem", SetXItem)
        hooksecurefunc(tooltip, "SetGuildBankItem", SetXItem)
        hooksecurefunc(tooltip, "SetHyperlink", SetXItem)
        hooksecurefunc(tooltip, "SetInboxItem", SetXItem)
        hooksecurefunc(tooltip, "SetInventoryItem", SetXItem)
        hooksecurefunc(tooltip, "SetInventoryItemByID", SetXItem)
        hooksecurefunc(tooltip, "SetItemKey", SetXItem)
        hooksecurefunc(tooltip, "SetLootItem", SetXItem)
        hooksecurefunc(tooltip, "SetLootRollItem", SetXItem)
        hooksecurefunc(tooltip, "SetMerchantCostItem", SetXItem)
        hooksecurefunc(tooltip, "SetMerchantItem", SetXItem)
        hooksecurefunc(tooltip, "SetOwnedItemByID", SetXItem)
        hooksecurefunc(tooltip, "SetRecipeReagentItem", SetRecipeReagentItem)
        hooksecurefunc(tooltip, "SetRecipeResultItem", SetRecipeResultItem)
        hooksecurefunc(tooltip, "SetSendMailItem", SetXItem)
        hooksecurefunc(tooltip, "SetTradePlayerItem", SetXItem)
        hooksecurefunc(tooltip, "SetTradeTargetItem", SetXItem)

        -- GameTooltip:HookScript("OnTooltipSetItem")
    end
end

--@debug@
local delayCount = 0
--@end-debug@
local function add_hooks()
    if not PROTOFORM_SYNTHESIS_STRING then
        -- delay hooking until we have the protoform string
        --@debug@
        delayCount = delayCount + 1
        --@end-debug@
        return C_Timer.After(1.5, add_hooks)
    end

    HookTooltip(GameTooltip)
    HookTooltip(ItemRefTooltip)

    --@debug@
    print("[PRS] hooked tooltip after", delayCount, "|4delay:delays;")
    --@end-debug@
end

ns.RegisterEvent("OnDatabaseLoaded", function(event, db)
    ReagentsDB = db.global.reagents
    ResultsDB = db.global.results

    start_scan()
    C_Timer.After(2, add_hooks)

    return true
end, true)
