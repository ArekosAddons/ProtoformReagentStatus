local ADDONNAME = ...
local debug = false -- luacheck: ignore 311/debug
--@debug@
debug = true
--@end-debug@

local L = LibStub("AceLocale-3.0"):NewLocale(ADDONNAME, "enUS", true, debug) -- luacheck: ignore 113/LibStub
if not L then return end

L.TYPE_OTHER = "Others"
L.TYPE_MOUNT = _G.MOUNTS
L.TYPE_PET = _G.PETS

L.REAGENT_STATUS = "Reagent status"

L.NEEDED_MOTES_S = "%s: Needed amounts"
L.MOUNTS_D = "Mounts: %d"
L.FIRST_PETS_D = "First pets: %d"
L.SECOND_PETS_D = "Second pets: %d"
L.THIRD_PETS_D = "Third pets: %d"
L.OTHERS_D = "Others: %d"

L.MOTES_NO_NEED = "No known need"

L.NO_KNOWN_RECIPE_S = "%s: No known recipe for this reagent"

L.COLLECTED = "|cFF00FF00Collected|r"
L.MISSING = "|cFFFF0000Missing|r"
L.PET_COLLECTED_DD = "|cFF00FF00%d/%d|r"
L.PET_MISSING_DD = "|cFFFF0000%d/%d|r"
