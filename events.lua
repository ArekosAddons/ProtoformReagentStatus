local ADDONNAME, ns = ...


local MOUNT = ns.RESULT_TYPES.MOUNT
local PET = ns.RESULT_TYPES.PET

local ResultsDB


local mount_of_interest do
    local cache = {}

    function mount_of_interest(mountID)
        if cache[mountID] ~= nil then return cache[mountID] end

        for itemID, resultType in pairs(ResultsDB) do
            if resultType == MOUNT then
                local _mountID = C_MountJournal.GetMountFromItem(itemID)

                if _mountID then
                    cache[_mountID] = true

                    if _mountID == mountID then
                        return true
                    end
                end
            end
        end

        cache[mountID] = false
        return false
    end
end

local pet_of_interest do
    local cache = {}

    function pet_of_interest(petID)
        local speciesID = C_PetJournal.GetPetInfoByPetID(petID) or 0
        if cache[speciesID] ~= nil then return cache[speciesID] end

        for itemID, resultType in pairs(ResultsDB) do
            if resultType == PET then
                local _, _, _, _, _, _, _, _, _, _, _, _, _speciesID = C_PetJournal.GetPetInfoByItemID(itemID)
                if _speciesID then
                    cache[_speciesID] = true

                    if _speciesID == speciesID then
                        return true
                    end
                end
            end
        end

        cache[speciesID] = false
        return false
    end
end

local function new_mount_added(event, mountID)
    if mount_of_interest(mountID) then
        ns.FireEvent("OnDataRefreshed")
    end
end

local function new_pet_added(event, petID)
    if pet_of_interest(petID) then
        ns.FireEvent("OnDataRefreshed")
    end
end


ns.RegisterEvent("OnDatabaseLoaded", function(event, db)
    ResultsDB = db.global.results

    ns.RegisterEvent("NEW_MOUNT_ADDED", new_mount_added)
    ns.RegisterEvent("NEW_PET_ADDED", new_pet_added)

    -- pre-cache item data
    for itemID in pairs(ResultsDB) do
        C_Item.RequestLoadItemDataByID(itemID)
    end

    return true
end, true)
