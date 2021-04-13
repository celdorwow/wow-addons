AddOnTemplate = LibStub("AceAddon-3.0"):NewAddon("AddOnTemplate", "AceConsole-3.0", "AceEvent-3.0")

local options = {
    name = "AddOnTemplate",
    handler = AddOnTemplate,
    type = 'group',
    args = {
        msg = {
            type = "input",
            name = "Message",
            desc = "The message to be displayed when you get home.",
            usage = "<Your message>",
            get = "GetMessage",
            set = "SetMessage",
        },
        showInChat = {
            type = "toggle",
            name = "Show in Chat",
            desc = "Toggles the display of the message in the chat window.",
            get = "IsShowInChat",
            set = "ToggleShowInChat",
        },
        showOnScreen = {
            type = "toggle",
            name = "Show on Screen",
            desc = "Toggles the display of the message on the screen.",
            get = "IsShowOnScreen",
            set = "ToggleShowOnScreen"
        },
    },
}

function AddOnTemplate:OnInitialize()
    -- Called when the addon is loaded
    LibStub("AceConfig-3.0"):RegisterOptionsTable("AddOnTemplate", options, {"addontemplate", "at"})
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AddOnTemplate", "AddOnTemplate")
    self:RegisterChatCommand("addontemplate", "ChatCommand")
    self:RegisterChatCommand("at", "ChatCommand")
    self.message = "Welcome home!"
    self.showInChat = false
    self.showOnScreen = true
end

function AddOnTemplate:OnEnable()
    self:RegisterEvent("ZONE_CHANGED")   -- from AceEvents to register an event, e.g. "ZONE_CHANGED"
end

-- function AddOnTemplate:OnDisable()
--     -- Called when the addon is disabled
--     -- Events don't need to be unregistered OnDisable(). AceEvents does it automatically 
-- end

-- Response to ZONE_CHANGED
function AddOnTemplate:ZONE_CHANGED()
    if GetBindLocation() == GetSubZoneText() then
        if self.showInChat then
            self.Print(self.message)
        end

        if self.showOnScreen then
            UIErrorsFrame:AddMessage(self.message, 1.0, 1.0, 1.0, 5.0)
        end
    end
end

function AddOnTemplate:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("at", "AddOnTemplate", input)
    end
end

function AddOnTemplate:GetMessage(info)
    return self.message
end

function AddOnTemplate:SetMessage(info, newValue)
    self.message = newValue
end

function AddOnTemplate:IsShowInChat(info)
    return self.showInChat
end

function AddOnTemplate:ToggleShowInChat(info, value)
    self.showInChat = value
end

function AddOnTemplate:IsShowOnScreen(info)
    return self.showOnScreen
end

function AddOnTemplate:ToggleShowOnScreen(info, value)
    self.showOnScreen = value
end
