-- LibCeldorMedia by Celdor <CeldorWoW@gmail.com>
-- All Rights Reserved

-- luacheck: globals LibCeldorMedia

local addonName = ...
-- Initialize
local media = LibStub("LibSharedMedia-3.0")
local folder = [[Interface\Addons\]] .. addonName .. [[\Libs\Media\]]

local registerMedia = {
    -- Status bars
    -- By Celdor
    {"statusbar", "Celdor Concave Grey", folder .. [[Statusbars\concave_grey.tga]]},
    {"statusbar", "Celdor Concave", folder .. [[Statusbars\concave.tga]]},
    {"statusbar", "Celdor Concrete", folder .. [[Statusbars\concrete-bar.tga]]},
    {"statusbar", "Celdor Fibre Grey", folder .. [[Statusbars\fibre_grey.tga]]},
    {"statusbar", "Celdor Fibre Transparent", folder .. [[Statusbars\fibre_transparent.tga]]},
    {"statusbar", "Celdor Fibre", folder .. [[Statusbars\fibre.tga]]},
    {"statusbar", "Celdor Metal Solid", folder .. [[Statusbars\metal_solid.tga]]},
    {"statusbar", "Celdor Metal Transparent", folder .. [[Statusbars\metal_transparent.tga]]},
    {"statusbar", "Celdor Metal", folder .. [[Statusbars\metal.tga]]},
    {"statusbar", "Celdor Motif", folder .. [[Statusbars\motif.tga]]},
    {"statusbar", "Celdor Simplistic", folder .. [[Statusbars\simplistic.tga]]},
    {"statusbar", "Celdor Smooth", folder .. [[Statusbars\smooth.tga]]},
    {"statusbar", "Celdor Stone", folder .. [[Statusbars\stone.tga]]},
    {"statusbar", "Celdor Wooded Bar C", folder .. [[Statusbars\wooden-colour.tga]]},
    {"statusbar", "Celdor Wooded Bar", folder .. [[Statusbars\wooden.tga]]},
    -- Blizzard
    {"statusbar", "WorldState Score", [[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT.BLP]]},

    -- Fonts
    -- From Details
    {"font", "Accidental Presidency", folder .. [[Fonts\Accidental Presidency.ttf]]},
    {"font", "FORCED SQUARE", folder .. [[Fonts\FORCED SQUARE.ttf]]},
    {"font", "Harry P", folder .. [[Fonts\HARRYP__.TTF]]},
    {"font", "Nueva Std Cond", folder .. [[Fonts\NuevaStd-Cond.otf]]},
    {"font", "Oswald", folder .. [[Fonts\Oswald-Regular.otf]]},
    {"font", "TrashHand", folder .. [[Fonts\TrashHand.TTF]]},

    -- Sounds
    -- From ElvUI
    {"sound", "Whisper Alert", folder .. [[Sounds\whisper.ogg]]},
}

for _, m in ipairs(registerMedia) do
    local mediatype, key, data = unpack(m)
    if not media:IsValid(mediatype, key) then
        media:Register(mediatype, key, data)
    end
end
