local addonName, moduleNs = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, false)

moduleNs.DEFAULT_SCALE = 2.0
moduleNs.DEFAULT_ALPHA = 1.0
moduleNs.DEFAULT_CONTINENT = true
moduleNs.iconfolder = "Interface\\Addons\\"..addonName.."\\Icons\\"
moduleNs.points = {}

function moduleNs.collectlocations(points, locstruct)
    if not points then return end
    if not locstruct then return end
    for mapid, locs in pairs(locstruct) do
        if not points[mapid] then points[mapid] = {} end
        for loc, val in pairs(locs) do
            points[mapid][loc] = val
        end
    end
end

moduleNs.unknown = {
    ["label"] = L["Unknown"],
    ["note"] = L["Unknown"],
    ["iconfile"] = "map-icon-SuramarDoor.tga",
    ["cont"] = moduleNs.DEFAULT_CONTINENT,
    ["alpha"] = moduleNs.DEFAULT_ALPHA,
    ["scale"] = moduleNs.DEFAULT_SCALE,
}

moduleNs.map_spellids = {
    [862] = 0, -- Zuldazar
    [863] = 0, -- Nazmir
    [864] = 0, -- Vol'dun
    [895] = 0, -- Tiragarde Sound
    [896] = 0, -- Drustvar
    [942] = 0, -- Stormsong Valley
    [1355] = 0, -- Nazjatar
    [1462] = 0, -- Mechagon Island,
}
