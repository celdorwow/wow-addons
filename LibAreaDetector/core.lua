-- LibAreaDetector by Celdor <CeldorWoW@gmail.com>
-- All Rights Reserved

-- luacheck: globals LibAreaDetector

local addonName, addon = ...

-- Initialize
addon = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceComm-3.0", "AceEvent-3.0", "AceTimer-3.0")
addon.hbd = LibStub("HereBeDragons-2.0")
LibAreaDetector = addon

-- Throttle
local function Throttle (duration)
    local exptime = 0
    return function ()
        if GetTime() - duration >= exptime then
            exptime = GetTime()
            return true
        end
    end
end

-- Class for messags
local Message = {
    method = function (self, arg)
        -- do stuff
    end,
    isinarea = function (self)
        local x, y, currentMapID = addon.hbd:GetPlayerZonePosition()
        if self.mapid ~= currentMapID then return end
        return self:pointinpoly(x, y)
    end,
    pointinpoly = function (self, x, y)
        -- area is a polygon created from vertices on a map
        -- for best results use counterwise definition
        -- defined figures can contain holes
        if not x or not y then return end
        local inside = false
        local tx, ty = x, y
        local area = self.area
        local j = #area
        for i = 1, #area do
            local vxi, vyi = unpack(area[i])
            local vxj, vyj = unpack(area[j])
            if (vyi > ty) ~= (vyj > ty)
            and tx < (vxj - vxi)*(ty - vyi)/(vyj - vyi) + vxi
            then
                inside = not inside
            end
            j = i
        end
        return inside
    end,
    new = function (self, mapid, messageid, area, throttle)
        -- LAD_PLAYER_ENTERING_AREA:"MessageID"
        local th = throttle or 0.5
        local o = {
            mapid = mapid,
            id = messageid,
            area = area,
            throttle = Throttle(th),
        }
        setmetatable(o, self)
        return o
    end,
}
Message.__index = Message

local custom_areas = {}


function addon:OnInitialize()
end


function addon:OnEnable()
end


function addon:OnDisable()
end
