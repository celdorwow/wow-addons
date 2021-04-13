local addonName, moduleNs = ...
local HL = moduleNs.HL
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, false)

moduleNs.defaults = {
    profile = {
        show_on_world = true,
        show_on_minimap = true,
        show_coralancient = true,
        show_treasure = true,
        icon_scale = 1.0,
        icon_alpha = 1.0,
        icon_scale_coralancients = 1.0,
        icon_alpha_coralancients = 1.0,
        icon_scale_treasures = 1.0,
        icon_alpha_treasures = 1.0,
    },
    char = {
        hidden = {
            ['*'] = {},
        },
    },
}

moduleNs.options = {
    type = "group",
    name = addonName:gsub("HandyNotes_", ""):gsub("([A-Z])", " %1"):gsub("^%s+", ""),
    get = function(info) return moduleNs.db[info[#info]] end,
    set = function(info, v)
        moduleNs.db[info[#info]] = v
        HL:SendMessage("HandyNotes_NotifyUpdate", addonName:gsub("HandyNotes_", ""))
    end,
    args = {
        icon_general = {
            type = "group",
            name = L["General settings"],
            inline = true,
            args = {
                desc = {
                    name = L["These settings control the look of the icon."],
                    type = "description",
                    order = 0,
                },
                icon_scale = {
                    type = "range",
                    name = L["Icon Scale"],
                    desc = L["The scale of the icons"],
                    min = 0.25, max = 2, step = 0.05,
                    order = 10,
                },
                icon_alpha = {
                    type = "range",
                    name = L["Icon Alpha"],
                    desc = L["The alpha traparency of the icons"],
                    min = 0, max = 1, step = 0.05,
                    order = 20,
                },
                show_on_world = {
                    type = "toggle",
                    name = L["World Map"],
                    desc = L["Show icon on world map"],
                    order = 30,
                },
                show_on_minimap = {
                    type = "toggle",
                    name = L["Minimap"],
                    desc = L["Show icon on the minimap"],
                    order = 40,
                },
            },
        },
        icon_coralancients = {
            type = "group",
            name = L["Scale and alpha for Coral Ancients"],
            inline = true,
            args = {
                icon_scale_coralancients = {
                    type = "range",
                    name = L["Icon Scale"],
                    desc = L["The scale of the icons"],
                    min = 0.25, max = 2, step = 0.05,
                    order = 10,
                },
                icon_alpha_coralancients = {
                    type = "range",
                    name = L["Icon Alpha"],
                    desc = L["The alpha traparency of the icons"],
                    min = 0, max = 1, step = 0.05,
                    order = 20,
                },
            },
        },
        icon_treasures = {
            type = "group",
            name = L["Scale and alpha for Treasures"],
            inline = true,
            args = {
                icon_scale_treasures = {
                    type = "range",
                    name = L["Icon Scale"],
                    desc = L["The scale of the icons"],
                    min = 0.25, max = 2, step = 0.05,
                    order = 10,
                },
                icon_alpha_treasures = {
                    type = "range",
                    name = L["Icon Alpha"],
                    desc = L["The alpha traparency of the icons"],
                    min = 0, max = 1, step = 0.05,
                    order = 20,
                },
            },
        },
        display = {
            type = "group",
            name = L["What to display"],
            inline = true,
            args = {
                show_coralancient = {
                    type = "toggle",
                    name = L["Show Coral Ancients"],
                    desc = L["Show icons at locations of Coral Ancient"],
                    order = 20,
                },
                show_treasure = {
                    type = "toggle",
                    name = L["Show Treasures"],
                    desc = L["Show icons at locations of Trasures"],
                    order = 30,
                },
                unhide = {
                    type = "execute",
                    name = L["Reset hidden nodes"],
                    desc = L["Show all nodes that you manually hid by right-clicking on them and choosing \"hide\"."],
                    func = function()
                        for map,coords in pairs(moduleNs.hidden) do
                            wipe(coords)
                        end
                        HL:Refresh()
                    end,
                    order = 40,
                },
            },
        },
    },
}

local player_faction = UnitFactionGroup("player")
local player_name = UnitName("player")
moduleNs.check_point = function (coord, point, currentZone, isMinimap)
    if isMinimap and not moduleNs.db.show_on_minimap and not point.minimap then
        return false
    elseif not isMinimap and not moduleNs.db.show_on_world then
        return false
    end
    if moduleNs.hidden[currentZone] and moduleNs.hidden[currentZone][coord] then
        return false
    end
    if moduleNs.outdoors_only and IsIndoors() then
        return false
    end
    if point.faction and point.faction ~= player_faction then
        return false
    end
    if point.coralancient and not moduleNs.db.show_coralancient then
        return false
    end
    if point.treasure and not moduleNs.db.show_treasure then
        return false
    end
    -- if point.<other sub mode> and not moduleNs.db.show_submodname then
    --     return false
    -- end
    -- ...
    if point.hide_before and not moduleNs.db.upcoming then
        return false
    end
    return true
end
