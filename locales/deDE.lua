local ADDONNAME = ...





local L = LibStub("AceLocale-3.0"):NewLocale(ADDONNAME, "deDE") -- luacheck: ignore 113/LibStub
if not L then return end

L.TYPE_OTHER = "Anderes"
L.TYPE_MOUNT = _G.MOUNTS
L.TYPE_PET = _G.PETS

-- L.NEEDED_MOTES_S =  "%s: Needed amounts"
-- L.MOUNTS_D =  "Mounts: %d"
-- L.FIRST_PETS_D =  "First pets: %d"
-- L.SECOND_PETS_D =  "Second pets: %d"
-- L.THIRD_PETS_D =  "Third pets: %d"
-- L.OTHERS_D =  "Others: %d"

-- L.MOTES_NO_NEED =  "No known need"

-- L.NO_KNOWN_RECIPE_S =  "%s: No known recipe for this reagent"

L.COLLECTED = "|cFF00FF00Eingesammelt|r"
L.MISSING = "|cFFFF0000Fehltr"
L.PET_COLLECTED_DD = "|cFF00FF00%d/%d|r"
L.PET_MISSING_DD = "|cFFFF0000%d/%d|r"
