local ADDONNAME = ...





local L = LibStub("AceLocale-3.0"):NewLocale(ADDONNAME, "deDE") -- luacheck: ignore 113/LibStub
if not L then return end

L.TYPE_OTHER = "Anderes"
L.TYPE_MOUNT = _G.MOUNTS
L.TYPE_PET = _G.PETS

L.REAGENT_STATUS = "Reagenz Status"

L.NEEDED_MOTES_S =  "%s: Noch benötigte menge"
L.MOUNTS_D =  "Reittiere: %d"
L.FIRST_PETS_D =  "Erstes Haustier: %d"
L.SECOND_PETS_D =  "Zweites Haustier: %d"
L.THIRD_PETS_D =  "Drittes Haustier: %d"
L.OTHERS_D =  "Anderes: %d"

L.MOTES_NO_NEED =  "Keine bekannter Bedarf"

L.NO_KNOWN_RECIPE_S =  "%s: Kein bekanntes Rezept für dieses Reagenz"

L.COLLECTED = "|cFF00FF00Eingesammelt|r"
L.MISSING = "|cFFFF0000Fehlt|r"
L.PET_COLLECTED_DD = "|cFF00FF00%d/%d|r"
L.PET_MISSING_DD = "|cFFFF0000%d/%d|r"
