local myname, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(myname, false)

local path_meta = {__index = {
    label = "Path to treasure",
    atlas = "map-icon-SuramarDoor.tga",
    path = true,
    scale = 1.1,
}}

ns.map_spellids = {
    -- [862] = 0, -- Zuldazar
    -- [863] = 0, -- Nazmir
    -- [864] = 0, -- Vol'dun
    -- [895] = 0, -- Tiragarde Sound
    -- [896] = 0, -- Drustvar
    -- [942] = 0, -- Stormsong Valley
}

ns.points = {
    [862] = { -- Zuldazar
        [43146435] = {
            ["label"] = L["Shrine of Nature"],
            ["cont"] = true,
            Shrine = true,
            ["note"] = L["Laribole"], -- green
            ["pathto"] = "Interface\\Addons\\"..myname.."\\Icons\\green_shrine.tga",
        },
    },

    [863] = { -- Nazmir
        [61323724] = {
            ["label"] = L["Shrine of the Dawning"],
            ["cont"] = true,
            Shrine = true,
            ["note"] = L["Scarlet Diamond"], -- red
            ["pathto"] = "Interface\\Addons\\"..myname.."\\Icons\\red_shrine.tga",
        },
    },

    [864] = { -- Vol'dun
        [44183805] = {
            ["label"] = L["Shrine of the Sands"],
            ["cont"] = true,
            Shrine = true,
            ["note"] = L["Amberblaze"], -- orange
            ["pathto"] = "Interface\\Addons\\"..myname.."\\Icons\\orange_shrine.tga",
        },
    },

    [895] = { -- Tiragarde Sound
        [46362345] = {
            ["label"] = L["Shrine of the Sea"],
            ["cont"] = true,
            Shrine = true,
            ["note"] = L["Royal Quartz"], -- blue
            ["pathto"] = "Interface\\Addons\\"..myname.."\\Icons\\blue_shrine.tga",
        },
    },

    [896] = { -- Drustvar
        [34133546] = {
            ["label"] = L["Shrine of the Eventide"],
            ["cont"] = true,
            Shrine = true,
            ["note"] = L["Tidal Amethyst"], -- purple
            ["pathto"] = "Interface\\Addons\\"..myname.."\\Icons\\purple_shrine.tga",
        },
    },

    [942] = { -- Stormsong Valley
        [60705851] = {
            ["label"] = L["Shrine of Storms"],
            ["cont"] = true,
            Shrine = true,
            ["note"] = L["Owlseye"], -- yellow
            ["pathto"] = "Interface\\Addons\\"..myname.."\\Icons\\yellow_shrine.tga",
        },
    },

    [1183] = { -- Thornheart
    },

    [1161] = { -- Boralus
    },

    [1165] = { -- Dazar'alor
    },
}
