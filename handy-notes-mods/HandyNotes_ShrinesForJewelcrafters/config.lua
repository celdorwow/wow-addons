local myname, ns = ...
local L = LibStub("AceLocale-3.0"):GetLocale(myname, false)

ns.defaults = {
    profile = {
        show_on_world = true,
        show_on_minimap = true,
        show_Shrine = true,
        repeatable = true,
        icon_scale = 1.0,
        icon_alpha = 1.0,
    },
    char = {
        hidden = {
            ['*'] = {},
        },
    },
}

ns.options = {
    type = "group",
    name = myname:gsub("HandyNotes_", ""):gsub("([A-Z])", " %1"):gsub("^%s+", ""),
    get = function(info) return ns.db[info[#info]] end,
    set = function(info, v)
        ns.db[info[#info]] = v
        ns.HL:SendMessage("HandyNotes_NotifyUpdate", myname:gsub("HandyNotes_", ""))
    end,
    args = {
        icon = {
            type = "group",
            name = L["Icon settings"],
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
                    min = 0.25, max = 2, step = 0.01,
                    order = 10,
                },
                icon_alpha = {
                    type = "range",
                    name = L["Icon Alpha"],
                    desc = L["The alpha transparency of the icons"],
                    min = 0, max = 1, step = 0.01,
                    order = 20,
                },
                show_on_world = {
                    type = "toggle",
                    name = L["World Map"],
                    desc = L["Show icons on world map"],
                    order = 30,
                },
                show_on_minimap = {
                    type = "toggle",
                    name = L["Minimap"],
                    desc = L["Show icons on the minimap"],
                    order = 40,
                },
            },
        },
        display = {
            type = "group",
            name = L["What to display"],
            inline = true,
            args = {
                show_Shrine = {
                    type = "toggle",
                    name = L["Show Shrines"],
                    desc = L["Show Shrines which Jewelercrafters can use to create gems"],
                    order = 20,
                },
                unhide = {
                    type = "execute",
                    name = L["Reset hidden nodes"],
                    desc = L["Show all nodes that you manually hid by right-clicking on them and choosing \"hide\"."],
                    func = function()
                        for map,coords in pairs(ns.hidden) do
                            wipe(coords)
                        end
                        ns.HL:Refresh()
                    end,
                    order = 30,
                },
            },
        },
    },
}

local player_faction = UnitFactionGroup("player")
local player_name = UnitName("player")
ns.should_show_point = function(coord, point, currentZone, isMinimap)
    if isMinimap and not ns.db.show_on_minimap and not point.minimap then
        return false
    elseif not isMinimap and not ns.db.show_on_world then
        return false
    end
    if ns.hidden[currentZone] and ns.hidden[currentZone][coord] then
        return false
    end
    if ns.outdoors_only and IsIndoors() then
        return false
    end
    if point.faction and point.faction ~= player_faction then
        return false
    end
    if point.Shrine and not ns.db.show_Shrine then
        return false
    end
    if point.hide_before and not ns.db.upcoming then
        return false
    end
    return true
end
