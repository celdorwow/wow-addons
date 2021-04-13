local addonName, moduleNs = ...

local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes")
local HL = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, false)
moduleNs.HL = HL

local next = next
local iconfolder = moduleNs.iconfolder

local function Debug(...)
    if debugf then
        debugf:AddMessage(string.join(", ", tostringall(...)))
    end
end


---------------------------------------------------------
-- Auxiliary functions

local function get_struct(uiMapID, coord)
    local moduleNs = moduleNs
    local point = (moduleNs.points[uiMapID] and moduleNs.points[uiMapID][coord]) or moduleNs.unknown
    return point, point ~= moduleNs.unknown
end

local function get_point(ioMapID, coord)
    local point = get_struct(uiMapID, coord)
    return point
end

local function get_icon(point)
    local struct
    if point.coralancient or point.treasure then
        struct = {
            icon = moduleNs.iconfolder .. point.iconfile,
            tCoordLeft = 0,
            tCoordRight = 1,
            tCoordTop = 0,
            tCoordBottom = 1,
        }
    -- elseif point.trasure then
    --     local texture, _, _, left, right, top, bottom = GetAtlasInfo(point.iconfile)
    --     struct = {
    --         icon = texture,
    --         tCoordLeft = left,
    --         tCoordRight = right,
    --         tCoordTop = top,
    --         tCoordBottom = bottom,
    --     }
    else
        local texture, _, _, left, right, top, bottom = GetAtlasInfo(point.iconfile)
        struct = {
            icon = texture,
            tCoordLeft = left,
            tCoordRight = right,
            tCoordTop = top,
            tCoordBottom = bottom,
        }
    end
    return struct
end

local function get_point_info(point)
    local label = point.label
    local icon = get_icon(point)
    local cont = point.cont
    -- different alphas and scales for different groups
    if point.coralancient then
        scale = moduleNs.db.icon_scale_coralancients*point.scale
        alpha = moduleNs.db.icon_alpha_coralancients*point.alpha
    elseif point.treasure then
        scale = moduleNs.db.icon_scale_treasures*point.scale
        alpha = moduleNs.db.icon_alpha_treasures*point.alpha
    end
    return label, icon, scale, alpha
end

local function set_tooltip(tooltip, uiMapID, coord)
    local point = get_struct(uiMapID, coord)
    -- Title
    tooltip:AddDoubleLine(point.label, " ", 1, 1, 1, 1, 1, 1)
    -- Texture
    local tooltipTextureInfo = {
        width=20,
        height=20,
        anchor = Enum.TooltipTextureAnchor.RightTop,
        margin = { left = 0, right = 0, top = 0, bottom = 0 },
        region = Enum.TooltipTextureRelativeRegion.RightLine,
    }
    -- get icon for tooltip
    -- fileID = GetFileIDFromPath(filePath)
    local fileID = moduleNs.iconfolder .. point.iconfile
    tooltip:AddTexture(fileID, tooltipTextureInfo)
    -- Extra lines
    if point.note then
        tooltip:AddDoubleLine(point.note, " ")
    end
    if point.extranote then
        tooltip:AddDoubleLine(point.extranote, " ", 0.54, 0.89, 0, nil, nil, nil)
    end
    tooltip:Show()
end

local function hideNode(button, uiMapID, coord)
    ns.hidden[uiMapID][coord] = true
    HL:Refresh()
end


---------------------------------------------------------
-- TomTom

local function createWaypoint(button, uiMapID, coord)
    if TomTom then
        local x, y = HandyNotes:getXY(coord)
        TomTom:AddWaypoint(uiMapID, x, y, {
            title = get_struct(uiMapID, coord)["label"],
            persistent = nil,
            minimap = true,
            world = true
        })
    end
end


---------------------------------------------------------
-- Plugin Handler to HandyNotes

HNHandler = {}

function HNHandler:OnEnter(uiMapID, coord)
    local tooltip = GameTooltip
    tooltip:SetOwner(self, "ANCHOR_RIGHT")

    -- Add pins
    -- local points = moduleNs.points
    set_tooltip(tooltip, uiMapID, coord)
end

local function hideNode(button, uiMapID, coord)
    ns.hidden[uiMapID][coord] = true
    HL:Refresh()
end

local function closeAllDropdowns()
    CloseDropDownMenus(1)
end

function HNHandler:OnLeave(uiMapID, coord)
    GameTooltip:Hide()
    ShoppingTooltip1:Hide()
end

---------------------------------------------------------
-- ???

do
    local currentZone, currentCoord
    local function generateMenu(button, level)
        if (not level) then return end
        wipe(info)
        if (level == 1) then
            -- Create the title of the menu
            info.isTitle      = 1
            info.text         = "HandyNotes - " .. addonName:gsub("Daily quest spots", "")
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info, level)
            wipe(info)

            if TomTom then
                -- Waypoint menu item
                info.text = L["Create waypoint"]
                info.notCheckable = 1
                info.func = createWaypoint
                info.arg1 = currentZone
                info.arg2 = currentCoord
                UIDropDownMenu_AddButton(info, level)
                wipe(info)
            end

            -- Hide menu item
            info.text         = L["Hide node"]
            info.notCheckable = 1
            info.func         = hideNode
            info.arg1         = currentZone
            info.arg2         = currentCoord
            UIDropDownMenu_AddButton(info, level)
            wipe(info)

            -- Close menu item
            info.text         = L["Close"]
            info.func         = closeAllDropdowns
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info, level)
            wipe(info)
        end
    end
    local HL_Dropdown = CreateFrame("Frame", addonName.."DropdownMenu")
    HL_Dropdown.displayMode = "MENU"
    HL_Dropdown.initialize = generateMenu

    function HNHandler:OnClick(button, down, uiMapID, coord)
        currentZone = uiMapID
        currentCoord = coord
        -- given we're in a click handler, this really *should* exist, but just in case...
        local point = moduleNs.points[currentZone] and moduleNs.points[currentZone][currentCoord]
        if button == "RightButton" and not down then
            ToggleDropDownMenu(1, nil, HL_Dropdown, self, 0, 0)
        end
    end
end

do
    -- This is a custom iterator we use to iterate over every node in a given zone
    local currentZone, isMinimap
    local function iter(t, prestate)
        if not t then return nil end
        local coord, point = next(t, prestate)
        while coord do -- Have we reached the end of this zone?
            if point and moduleNs.check_point(coord, point, currentZone, isMinimap) then
                local label, icon, scale, alpha = get_point_info(point)
                scale = (scale or 1) * moduleNs.db.icon_scale
                return coord, nil, icon, scale, moduleNs.db.icon_alpha * alpha
            end
            coord, point = next(t, coord) -- Get next data
        end
        return nil, nil, nil, nil
    end
    local function UnitHasBuff(unit, spellid)
        local buffname = GetSpellInfo(spellid)
        for i = 1, 40 do
            local name = UnitBuff(unit, i)
            if not name then
                -- reached the end, probably
                return
            end
            if buffname == name then
                return UnitBuff(unit, i)
            end
        end
    end
    function HNHandler:GetNodes2(uiMapID, minimap)
        Debug("GetNodes2", uiMapID, minimap)
        currentZone = uiMapID
        isMinimap = minimap
        if minimap and moduleNs.map_spellids[uiMapID] then
            if moduleNs.map_spellids[mapFile] == true then
                return iter
            end
            if UnitHasBuff("player", moduleNs.map_spellids[mapFile]) then
                return iter
            end
        end
        return iter, moduleNs.points[uiMapID], nil
    end
end

---------------------------------------------------------
-- Addon initialization, enabling and disabling

function HL:OnInitialize()
    -- Set up our database
    self.db = LibStub("AceDB-3.0"):New(addonName.."DB", moduleNs.defaults)
    moduleNs.db = self.db.profile
    moduleNs.hidden = self.db.char.hidden
    -- Initialize our database with HandyNotes
    HandyNotes:RegisterPluginDB(addonName:gsub("HandyNotes_", ""), HNHandler, moduleNs.options)

    -- watch for LOOT_CLOSED
    self:RegisterEvent("LOOT_CLOSED", "Refresh")
    self:RegisterEvent("ZONE_CHANGED_INDOORS", "Refresh")
end

function HL:Refresh()
    self:SendMessage("HandyNotes_NotifyUpdate", addonName:gsub("HandyNotes_", ""))
end
