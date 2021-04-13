local myname, ns = ...

local merge = ns.merge
local path = ns.path

ns.points = {
    [862] = { -- Zuldazar
        [43146435] = {
            ["label"] = "Shrine of Nature",
            ["cont"] = true,
            Shrine = true,
            ["note"] = "Laribole", -- green
            ["pathto"] = "Interface\\Addons\\"..myname.."\\Icons\\green_shrine.tga",
        },
    },

    [863] = { -- Nazmir
        [61323724] = {
            ["label"] = "Shrine of the Dawning",
            ["cont"] = true,
            Shrine = true,
            ["note"] = "Scarlet Diamond", -- red
            ["pathto"] = "Interface\\Addons\\"..myname.."\\Icons\\red_shrine.tga",
        },
    },

    [864] = { -- Vol'dun
        [44183805] = {
            ["label"] = "Shrine of the Sands",
            ["cont"] = true,
            Shrine = true,
            ["note"] = "Amberblaze", -- orange
            ["pathto"] = "Interface\\Addons\\"..myname.."\\Icons\\orange_shrine.tga",
        },
    },

    [895] = { -- Tiragarde Sound
        [46362345] = {
            ["label"] = "Shrine of the Sea",
            ["cont"] = true,
            Shrine = true,
            ["note"] = "Royal Quartz", -- blue
            ["pathto"] = "Interface\\Addons\\"..myname.."\\Icons\\blue_shrine.tga",
        },
    },

    [896] = { -- Drustvar
        [34133546] = {
            ["label"] = "Shrine of the Eventide",
            ["cont"] = true,
            Shrine = true,
            ["note"] = "Tidal Amethyst", -- purple
            ["pathto"] = "Interface\\Addons\\"..myname.."\\Icons\\purple_shrine.tga",
        },
    },

    [942] = { -- Stormsong Valley
        [60705851] = {
            ["label"] = "Shrine of Storms",
            ["cont"] = true,
            Shrine = true,
            ["note"] = "Owlseye", -- yellow
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
