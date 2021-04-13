local addonName, moduleNs = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, false)

local collectlocations = moduleNs.collectlocations

local prototype = {
    ["label"] = L["Unknown"],
    ["note"] = L["Unknown"],
    ["pathto"] = "map-icon-SuramarDoor.tga",
    ["iconfile"] = "coral_ancient.tga",
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
    [1355] = { -- Nazjatar
        [35577508] = new({
            ["label"] = L["Gloomchasm Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [37108535] = new({
            ["label"] = L["Gloomchasm Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [41887410] = new({
            ["label"] = L["Gloomchasm Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [45088555] = new({
            ["label"] = L["Gloomchasm Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [49037272] = new({
            ["label"] = L["Gloomchasm Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [40478147] = new({
            ["label"] = L["Murkbloom Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
            ["extranote"] = L["A number of elementals inside an underwater cave"],
        }),
        [31202935] = new({
            ["label"] = L["Staghorn Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [33084801] = new({
            ["label"] = L["Staghorn Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [36203750] = new({
            ["label"] = L["Staghorn Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [36333739] = new({
            ["label"] = L["Staghorn Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [37734244] = new({
            ["label"] = L["Staghorn Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [53822604] = new({
            ["label"] = L["Petrified Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [54262532] = new({
            ["label"] = L["Petrified Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [54245256] = new({
            ["label"] = L["Seashelf Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [59164595] = new({
            ["label"] = L["Seashelf Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [61555560] = new({
            ["label"] = L["Seashelf Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [63775449] = new({
            ["label"] = L["Seashelf Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [64755441] = new({
            ["label"] = L["Seashelf Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [74002633] = new({
            ["label"] = L["Sunbleached Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [70903956] = new({
            ["label"] = L["Sunbleached Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [79703346] = new({
            ["label"] = L["Sunbleached Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
        [80753728] = new({
            ["label"] = L["Sunbleached Reefwalker"],
            ["note"] = L["Coral Ancient"],
            ["coralancient"] = true,
            ["iconfile"] = "coral_ancient.tga",
        }),
    },
}

collectlocations(moduleNs.points, locations)

--[[
moduleNs.points = {
    [uiMapID] = { -- "_terrain1" etc will be stripped from attempts to fetch this
        [coord] = new({
            label=[string], -- label: text that'll be the label, optional
            item=[id], -- itemid
            quest=[id], -- will be checked, for whether character already has it
            currency=[id], -- currencyid
            achievement=[id], -- will be shown in the tooltip
            junk=[bool], -- doesn't count for achievement
            npc=[id], -- related npc id, used to display names in tooltip
            note=[string], -- some text which might be helpful
            hide_before=[id], -- hide if quest not completed
        }),
        [coord2] = {
            ...
        }
    },
}
--]]

--[[
    [1462] = { -- Mechagon Island
        -- ["label"] = L["Shrine of Nature"],        -- ["note"] = L["Laribole"], -- green
        -- ["iconfile"] = "green_shrine.tga",    }, 

    [862] = { -- Zuldazar
    },
    [1183] = { -- Thornheart
    },
    [1161] = { -- Boralus
    },
    [1165] = { -- Dazar'alor
    },
--]]

--[[
local map_name_od = {
	[12]  = true, -- Kalimdor
	[13]  = true, -- Azeroth
	[101] = true, -- Outlands
	[113] = true, -- Northrend
	[424] = true, -- Pandaria
	[572] = true, -- Draenor
	[619] = true, -- Broken Isles
	[875] = true, -- Zandalar
    [876] = true, -- Kul Tiras
    [1355] = true, -- Nazjatar
    [1462] = true, -- Mechagon Island, 
	
	-- mapFile compat entries
    ["Kalimdor"] = 12,
    ["Azeroth"] = 13,
    ["Expansion01"] = 101,
    ["Northrend"] = 113,
    ["TheMaelstromContinent"] = 948,
    ["Vashjir"] = 203,
    ["Pandaria"] = 424,
    ["Draenor"] = 572,
    ["BrokenIsles"] = 619,
    ["Nazjatar"] = 1355,
    ["Mechagon Island"] = 1462, 
}
]]--
