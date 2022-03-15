local ADDONNAME = ...





local L = LibStub("AceLocale-3.0"):NewLocale(ADDONNAME, "deDE") -- luacheck: ignore 113/LibStub
if not L then return end

L.OTHER = "Anderes"
L.MOUNT = _G.MOUNTS
L.PET = _G.PETS

L.COLLECTED = "|cFF00FF00Eingesammelt|r"
L.MISSING = "|cFFFF0000Fehltr"
L.PET_COLLECTED_DD = "|cFF00FF00%d/%d|r"
L.PET_MISSING_DD = "|cFFFF0000%d/%d|r"
