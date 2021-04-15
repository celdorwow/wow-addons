-- UIParentLoadAddOn("Blizzard_DebugTools")
-- DisplayTableInspectorWindow(myTable)

_, nameSpace = ...
CeldorPlayerRecorder = nameSpace
CeldorPlayerRecorderDB = CeldorPlayerRecorderDB or {}

-- local Player = nameSpace.Player;
local Parser = nameSpace.Parser;
local Print = nameSpace.Print;
local Array = nameSpace.Array;

local defaultOptions = {
   showlinks = false,
   output = "chat",
};

nameSpace.config = {
   lookuptable = { {"showlinks", 1}, },
   -- UI
   Toggle = function (self)
      if not nameSpace.UIPlayerEditor then
         nameSpace.UIPlayerEditor = config:CreateMenu()
         nameSpace.UIPlayerEditor:SetShown(false)
      end
      nameSpace.UIPlayerEditor:SetShown(not nameSpace.UIPlayerEditor:IsShown())
   end,
   CreateMenu = function (self)
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
   end,
   -- Help Frame
   CreateDiplayHelp = function (self)
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
   end,
   CheckConfig = function ()
      for k, v in pairs(defaultOptions) do
         if not CeldorPlayerRecorderDB[k] then
            CeldorPlayerRecorderDB[k] = v;
         end
      end
   end,
   SetOptions = function (self, ...)
      if select("#", ...) == 0 then
         Print(nameSpace.Player.wrn("Empty config parameters"));
         return;
      end
      local p_obj = Parser:New(table.concat({...}, " "));
      local paramsargs = p_obj:ParseAllInputs(self.lookuptable);
      if Array.IsEmpty(paramsargs) then
         Print(nameSpace.Player.wrn("Wrong parameters"))
         return
      else
         for i, crit in ipairs(paramsargs) do
            local param, arg = unpack(crit)
            if not param or param == "" then
               Print(nameSpace.Player.wrn("Wrong parameters"))
               return
            end
            if param == "showlinks" then
               if arg and arg ~= "" then
                  if arg:lower() == "yes" or arg:lower() == "true" or arg:lower() == "on" then
                     CeldorPlayerRecorderDB.showlinks = true;
                  elseif arg:lower() == "no" or arg:lower() == "false" or arg:lower() == "off" then
                     CeldorPlayerRecorderDB.showlinks = false;
                  elseif arg:lower() == "toggle" then
                     CeldorPlayerRecorderDB.showlinks = not CeldorPlayerRecorderDB.showlinks;
                  end
               end
               local flag = CeldorPlayerRecorderDB.showlinks and "on" or "off";
               Print("Links are turned "..flag);
            end
         end
      end
   end,
}
