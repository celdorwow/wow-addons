-- UIParentLoadAddOn("Blizzard_DebugTools")
-- DisplayTableInspectorWindow(myTable)

_, nameSpace = ...
nameSpace.config = {}
CeldorPlayerRecorder = nameSpace
CeldorPlayerRecorderDB = CeldorPlayerRecorderDB or {}
local config = nameSpace.config


-- UI
function config:Toggle()
   if not nameSpace.UIPlayerEditor then
      nameSpace.UIPlayerEditor = config:CreateMenu()
      nameSpace.UIPlayerEditor:SetShown(false)
   end
   nameSpace.UIPlayerEditor:SetShown(not nameSpace.UIPlayerEditor:IsShown())
end

function config:CreateMenu()
   -- Main Frame
   local UIPlayerEditor = CreateFrame("Frame", "CPR_PlayerEditor", UIParent, "BasicFrameTemplateWithInset")
   UIPlayerEditor:SetSize(600, 360)
   UIPlayerEditor:SetPoint("CENTER", UIParent, "CENTER")

   -- Title
   UIPlayerEditor.title = UIPlayerEditor:CreateFontString(nil, "OVERLAY")
   UIPlayerEditor.title:SetFontObject("GameFontHighlight")
   UIPlayerEditor.title:SetPoint("LEFT", UIPlayerEditor.TitleBg, "LEFT", 5, 0)
   UIPlayerEditor.title:SetText("Player Recorder")

   -- Button
   UIPlayerEditor.saveButton = CreateFrame("Button", nil, UIPlayerEditor, "GameMenuButtonTemplate")
   UIPlayerEditor.saveButton:SetPoint("TOP", UIPLayerEditor, "TOP", 0, 0)
   UIPlayerEditor.saveButton:SetSize(120, 40)
   UIPlayerEditor.saveButton:SetText("Save")
   UIPlayerEditor.saveButton:SetNormalFontObject("GameFontNormalLarge")
   UIPlayerEditor.saveButton:SetHighlightFontObject("GameFontHighlightLarge")

   -- Edit Box
   UIPlayerEditor.editBox = CreateFrame("EditBox", nil, UIPlayerEditor)
   UIPlayerEditor.editBox:SetMultiLine(true)
   UIPlayerEditor.editBox:SetFontObject(ChatFontNormal)
   UIPlayerEditor.editBox:SetText(string.rep("Type here", 30))
   UIPlayerEditor.editBox:HighlightText()

   return UIPlayerEditor
end


-- Help Frame
function config:CreateDiplayHelp()
   local UIDislayHelp = CreateFrame("SimpleHTML", "CPRDisplayHelpHTML", UIParent);
   UIDislayHelp:SetPoint("CENTER", UIParent, "CENTER");
   local w, h = UIParent:GetSize();
   UIDislayHelp:SetSize(w/3, h/2);
   -- Texture
   local texture = UIDislayHelp:CreateTexture(nil, "BACKGROUND");
   texture:SetAllPoints()
   texture:SetColorTexture(0, 0, 0, 0.65)   -- DontString
   -- FontString
   local fontString = UIDislayHelp:CreateFontString(nil, "ARTWORK", "GameTooltipText");
   fontString:SetPoint("TOPLEFT", 0, 0)
   fontString:SetText(nameSpace.Db2Html(CeldorPlayerRecorderDB.players))

   UIDislayHelp:Show()
end
