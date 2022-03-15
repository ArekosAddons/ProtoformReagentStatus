local ADDONNAME = ...
local debug = false -- luacheck: ignore 311/debug
--@debug@
debug = true
--@end-debug@

local L = LibStub("AceLocale-3.0"):NewLocale(ADDONNAME, "enUS", true, debug) -- luacheck: ignore 113/LibStub
if not L then return end

L.OTHER = "Others"
L.MOUNT = _G.MOUNTS
L.PET = _G.PETS

L.COLLECTED = "|cFF00FF00Collected|r"
L.MISSING = "|cFFFF0000Missing|r"
L.PET_COLLECTED_DD = "|cFF00FF00%d/%d|r"
L.PET_MISSING_DD = "|cFFFF0000%d/%d|r"
