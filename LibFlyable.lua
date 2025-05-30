--[[--------------------------------------------------------------------
	LibFlyable
	Replacement for the IsFlyableArea API function in World of Warcraft.
	Author : Phanx <addons@phanx.net>
	License: Public Domain
	This is free and unencumbered software released into the public domain.
	https://github.com/phanx-wow/LibFlyable
	https://wow.curseforge.com/projects/libflyable
----------------------------------------------------------------------]]
-- TODO: Wintergrasp (mapID 501) status detection? Or too old to bother with?

local MAJOR, MINOR = "LibFlyable", 3
assert(LibStub, MAJOR.." requires LibStub")
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

----------------------------------------
-- Data
----------------------------------------

local spellForContinent = {
	-- Continents/instances requiring a spell to fly:
	-- Broken Isles Pathfinder
	[1220] = 233368, -- Broken Isles
	-- Battle for Azeroth Pathfinder
	[1642] = 278833, -- Zandalar
	[1643] = 278833, -- Kul Tiras
	[1718] = 278833, -- Nazjatar

	-- Unflyable continents/instances where IsFlyableArea returns true:
	[1191] = -1, -- Ashran (PvP)
	[1265] = -1, -- Tanaan Jungle Intro
	[1463] = -1, -- Helheim Exterior Area
	[1500] = -1, -- Broken Shore (scenario for DH Vengeance artifact)
	[1669] = -1, -- Argus (mostly OK, few spots are bugged)

	-- Unflyable class halls where IsFlyableArea returns true:
	-- Note some are flyable at the entrance, but not inside;
	-- flying serves no purpose here, so we'll just say no.
	[1519] = -1, -- The Fel Hammer (Demon Hunter)
	[1514] = -1, -- The Wandering Isle (Monk)
	[1469] = -1, -- The Heart of Azeroth (Shaman)
	[1107] = -1, -- Dreadscar Rift (Warlock)
	[1479] = -1, -- Skyhold (Warrior)

	-- Unflyable island expeditions where IsFlyableArea returns true:
	[1813] = -1, -- Un'gol Ruins
	[1814] = -1, -- Havenswood
	[1879] = -1, -- Jorundall
	[1882] = -1, -- Verdant Wilds
	[1883] = -1, -- Whispering Reef
	[1892] = -1, -- Rotting Mire
	[1893] = -1, -- The Dread Chain
	[1897] = -1, -- Molten Clay
	[1898] = -1, -- Skittering Hollow
	[1907] = -1, -- Snowblossom Village
	[2124] = -1, -- Crestfall

	-- Unflyable Dungeons where IsFlyableArea returns true:
	[1208] = -1, -- Grimrail Depot
	[1763] = -1, -- Atal'dazar

	-- Flyable Dungeons where IsFlyableArea returns false:

	-- Unflyable Warfronts where IsFlyableArea returns true:
	[1943] = -1, -- The Battle of Stormgarde
	[1876] = -1, -- Warfronts Arathi - Horde

	-- Unflyable Raids where IsFlyableArea returns true:
	[2169] = -1, -- Uldir: The Oblivion Door
	[2296] = -1, -- Castle Nathria

	-- Flyable Raids where IsFlyableArea returns false:

	-- Unflyable Scenarios where IsFlyableArea returns true:
	[1662] = -1, -- Assault of the Sanctum of Order
	[1906] = -1, -- Zandalar Continent Finale
	[1917] = -1, -- Mag'har Scenario

	-- Unflyable Lesser Visions where IsFlyableArea returns true:
	[2275] = -1, -- Vale of Eternal Twilight

	-- Unflyable Covenant areas where IsFlyableArea returns true:
	[2363] = -1, -- Ardenweald Queens Conservatory
}

local noFlySubzones = {
	-- Unflyable subzones where IsFlyableArea() returns true:
	["Nespirah"] = true, ["Неспира"] = true, ["네스피라"] = true, ["奈瑟匹拉"] = true, ["奈斯畢拉"] = true,
}

----------------------------------------
-- Logic
----------------------------------------

local GetInstanceInfo = GetInstanceInfo
local GetSubZoneText = GetSubZoneText
local IsFlyableArea = IsFlyableArea
local IsSpellKnown = IsSpellKnown

function lib.IsFlyableArea()
	if not IsFlyableArea() or noFlySubzones[GetSubZoneText() or ""] then
		return false
	end

	local _, _, _, _, _, _, _, instanceMapID = GetInstanceInfo()
	local reqSpell = spellForContinent[instanceMapID]
	if reqSpell then
		return reqSpell > 0 and IsSpellKnown(reqSpell)
	end

	return true
end
