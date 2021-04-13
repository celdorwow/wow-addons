local addonName, moduleNs = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, false)

local collectlocations = moduleNs.collectlocations

local prototype = {
    ["label"] = L["Unknown"],
    ["note"] = L["Unknown"],
    ["iconfile"] = "treasure.tga",  -- ShipMissionIcon-Treasure-Map, Garr_TreasureIcon, ClassHall-TreasureIcon-Desaturated
    ["cont"] = moduleNs.DEFAULT_CONTINENT,
    ["alpha"] = moduleNs.DEFAULT_ALPHA,
    ["scale"] = moduleNs.DEFAULT_SCALE,
}

local mt = {
    __index = function(_, k)
        return prototype[k]
    end
}

local function new (fields)
    setmetatable(fields, mt)
    return fields
end

local locations = {
		[1462] = { -- Mechagon
				[20647150] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["Next to another chest which requires Mechanized Supply Key"],
				}),
				[26165291] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
				}),
				[30785164] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["In a cave"],
				}),
				[35693830] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["Toothy Shallows - under water"],
				}),
				[38265227] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["In a cave"],
				}),
				[43434995] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["On a cliff"],
				}),
				[45417580] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["South part of Junkwatt Depot"],
				}),
				[48427585] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["On the way up the mountain, next to tree stump"],
				}),
				[49003000] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["On top of the waterfall, next to Rolly Gulper"],
				}),
				[50652859] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["In a cave"],
				}),
				[56993873] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["Bondo's Yard - up at the hill "],
				}),
				[57112278] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["In a cave"],
				}),
				[60006350] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["Between the wall and some contraption that looks like a water heater"],
				}),
				[62307400] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["Behind a tree on top of the ledge overlooking the Overflow"],
				}),
				[63566750] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["Next to a tree behind the Awakened Grease"],
				}),
				[65526482] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["On top of the small waterfall"],
				}),
				[66717762] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
				}),
				[67322288] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["In a cave"],
				}),
				[72136565] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["Next to a tree"],
				}),
				[72904960] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["On top of the hill, beside Motor Ape"],
				}),
				[80424836] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["Underwater right next to a big metal scrap"]

				}),
				[85106320] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
				}),
				[86202040] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["Just at the entrance of the cave, among the cobwebs"],
				}),
				[88812024] = new({
						["label"] = L["Chest"],
						["note"] = L["Treasure"],
						["treasure"] = true,
						["iconfile"] = "treasure.tga",
						["extranote"] = L["Spiders"],
				}),
		},
}

collectlocations(moduleNs.points, locations)
