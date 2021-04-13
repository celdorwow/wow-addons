local myname, ns = ...

ns.defaults = {
    profile = {
        show_on_world = true,
        show_on_minimap = true,
        show_cauldron = true,
        show_timeRift = true,
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
    name = myname:gsub("HandyNotes_", ""),
    get = function(info) return ns.db[info[#info]] end,
    set = function(info, v)
        ns.db[info[#info]] = v
        ns.HL:SendMessage("HandyNotes_NotifyUpdate", myname:gsub("HandyNotes_", ""))
    end,
    args = {
        icon = {
            type = "group",
            name = "Icon settings",
            inline = true,
            args = {
                desc = {
                    name = "These settings control the look and feel of the icon.",
                    type = "description",
                    order = 0,
                },
                icon_scale = {
                    type = "range",
                    name = "Icon Scale",
                    desc = "The scale of the icons",
                    min = 0.25, max = 2, step = 0.01,
                    order = 10,
                },
                icon_alpha = {
                    type = "range",
                    name = "Icon Alpha",
                    desc = "The alpha transparency of the icons",
                    min = 0, max = 1, step = 0.01,
                    order = 20,
                },
                show_on_world = {
                    type = "toggle",
                    name = "World Map",
                    desc = "Show icons on world map",
                    order = 30,
                },
                show_on_minimap = {
                    type = "toggle",
                    name = "Minimap",
                    desc = "Show icons on the minimap",
                    order = 40,
                },
            },
        },
        display = {
            type = "group",
            name = "What to display",
            inline = true,
            args = {
                show_cauldron = {
                    type = "toggle",
                    name = "Show Cauldrons",
                    desc = "Show Alchemy treasures that can be looted",
                    order = 0,
                },
                show_timeRift = {
                    type = "toggle",
                    name = "Show Time Rifts",
                    desc = "Show Tailoring treasures that can be looted",
                    order = 10,
                },
                show_Shrine = {
                    type = "toggle",
                    name = "Show Shrines",
                    desc = "Show Shrines which Jewelercrafters can use to create gems",
                    order = 20,
                },
                unhide = {
                    type = "execute",
                    name = "Reset hidden nodes",
                    desc = "Show all nodes that you manually hid by right-clicking on them and choosing \"hide\".",
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
    if point.cauldron and not ns.db.show_cauldron then
        return false
    end
    if point.timeRift and not ns.db.show_timeRift then
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
