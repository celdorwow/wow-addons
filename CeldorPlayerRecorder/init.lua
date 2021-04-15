addonName, nameSpace = ...


local config = nameSpace.config;
local PTable = nameSpace.Player;

-------------------------------------------------------------------------------
-- Help
-------------------------------------------------------------------------------
function nameSpace.DisplayHelp ()
   local an = nameSpace.FormatColour.an
   local gf = nameSpace.FormatColour.gf
   local cm = nameSpace.FormatColour.cm
   local sc = nameSpace.FormatColour.sc
   local pr = nameSpace.FormatColour.pr
   local pl = nameSpace.FormatColour.pl
   local ct = nameSpace.FormatColour.ct
   local nu = nameSpace.FormatColour.nu

   local message = function (msg) DEFAULT_CHAT_FRAME:AddMessage(msg) end

   message("\n")
   nameSpace.Print()
   message(gf("SYNOPSIS"))
   message(an("/cpr").." "..cm("COMMAND").." "..sc("[SUBCOMMAND]").." "..nu("[NUMBER]")
   .." "..pl("PLAYER NAME").." "..pr("[COMMENT]"))
   message("\n")
   message(gf("DESCRIPTION"))
   message("Use to save, alter and remove comments about players in current dungeon")
   message("\n")
   message(gf("COMMANDS RELATED TO PLAYERS"))
   message(cm("help"))
   message("Output of a usage message and exit.")
   message("\n")
   message(cm("list"))
   message("Output of a full list of players")
   message("\n")
   message(cm("list").." ["..sc("filter").." "..ct("keyword1").." "..pr("parameter1").." ... ["..ct("keywordN").." "..pr("parameterN").."]")
   message(ct("keyword").." can be set to either "..sc("comment").." or "..sc("role"))
   message("If "..ct("keyword").." is specified to "..sc("role")..", then "..pr("parameter").." must be either tank, healer, or damager")
   message("If "..ct("keyword").." is specified to "..sc("comment")..", then, "..pr("parameter").." a matching part of comments")
   message("\n")
   message(cm("save").." "..sc("player").." "..pl("PLAYER NAME").." "..ct("COMMENT"))
   message(cm("add").." "..sc("player").." "..pl("PLAYER NAME").." "..ct("COMMENT"))
   message("Save a player and its information: provided COMMENT as well as date and time, and dungeon if applicable. Everything after PLAYER NAME is considered a comment.")
   message("\n")
   message(cm("display").." "..sc("player").." "..pl("PLAYER NAME"))
   message(cm("check").." "..sc("player").." "..pl("PLAYER NAME"))
   message("Display details about a single player. ")
   message("\n")
   message(cm("remove").." "..sc("player").." "..pl("PLAYER NAME"))
   message("Removes all information about the player.")
   message("\n")
   message(gf("SHORTCUTS"))
   message(cm("sp").." "..pl("PLAYER NAME").." "..ct("COMMENT"))
   message(cm("ap").." "..pl("PLAYER NAME").." "..ct("COMMENT"))
   message("See "..cm("save").." "..sc("player"))
   message("\n")
   message(cm("cp").." "..pl("PLAYER NAME"))
   message(cm("dp").." "..pl("PLAYER NAME"))
   message("See "..cm("display").." "..sc("player"))
   message("\n")
   message(cm("rp").." "..pl("PLAYER NAME"))
   message("See "..cm("remove").." "..sc("player"))
   message("\n")
   message(gf("COMMANDS RELATED TO COMMENTS"))
   message(cm("set").." "..sc("comment").." "..nu("NUMBER").." "..pl("PLAYER NAME").." "..ct("COMMENT"))
   message(cm("change").." "..sc("comment").." "..nu("NUMBER").." "..pl("PLAYER NAME").." "..ct("COMMENT"))
   message("Change an existing comment. NUMBER refers a section.")
   message("\n")
   message(cm("add").." "..sc("comment").." "..pl("PLAYER NAME").." "..ct("COMMENT"))
   message("Add a new comment to an existing player. The date is also collected as well as a dungeon name if a player is in one.")
   message("\n")
   message(cm("remove").." "..sc("comment").." "..nu("NUMBER").." "..pl("PLAYER NAME"))
   message("Removes an existing comment. "..nu("NUMBER").." refers to a section of interest.")
   message("\n")
   message(gf("PARAMETERS"))
   message(pl("PLAYER NAMES"))
   message("A player name or its matching part without a realm are accepted. When adding a new player additionally a role such as tank, a healer or damager are also accepted. If multiple players are found, e.g. damager, the addon will ask for a new query which finds a single player. As such DAMAGER in 5 man group will never work. Error if player name is not specified when expected.")
   message("\n")
   message(nu("NUMBERS"))
   message("An integer referring to a specific section with the comment as addon collects a number of comments per single player. The command list shows section numbers.")
   message("\n")
   message(ct("COMMENTS"))
   message("Any string in place where a comment is expected after PLAYER NAME. Error if a comment is not specified when expected. Additional text when comment is not expected is ignored.")
end


-------------------------------------------------------------------------------
-- Commands
-------------------------------------------------------------------------------
-- Requres revamp e.g.
nameSpace.commands = {
   ["editor"] = config.Toggle,
   -- General
   ["list"] = function(self, ...) self.ListPlayers:List(...) end,
   ["help"] = nameSpace.DisplayHelp,
   -- PLayers
   ["save"] = {
      ["player"] = PTable.SavePlayer,
   },
   ["add"] = {
      ["player"] = PTable.SavePlayer,
      ["comment"] = PTable.AddComment,
   },
   ["remove"] = {
      PTable.RemovePlayer,
   },
   ["check"] = {
      ["player"] = function(self, pname) self:CheckPlayer(pname, true) end,
   },
   ["display"] = {
      ["player"] = function(self, pname) self:CheckPlayer(pname, true) end,
   },
   ["sp"] = PTable.SavePlayer,
   ["ap"] = PTable.SavePlayer,
   ["rp"] = PTable.RemovePlayer,
   ["cp"] = function(self, pname) self:CheckPlayer(pname, true) end,
   ["dp"] = function(self, pname) self:CheckPlayer(pname, true) end,
   -- alter elements
   ["set"] = {
      ["comment"] = PTable.SetComment,
   },
   ["change"] = {
      ["comment"] = PTable.SetComment,
   },
   -- Other commands
   ["resetgroup"] = PTable.ResetGroup,
   ["populategroup"] = PTable.PopulateGroup,
   ["config"] = config.SetOptions,
}

local function HandleSlashCommands(str)
   if #str == 0 then
      nameSpace.DisplayHelp()
      return
   end

   str = str:gsub("%s+", " ")
   local path = nameSpace.commands

   str = {string.split(" ", str)}
   for id, arg in pairs(str) do
      if type(path[arg]) == "function" then
         -- The functions are methods and requires table to provide as `self`
         if arg == "editor" then
            path[arg](select(id + 1, unpack(str)))
         elseif arg == "config" then
            path[arg](config, select(id + 1, unpack(str)))
         else
            path[arg](PTable, select(id + 1, unpack(str)))
         end
         return true
      elseif type(path[arg]) == "table" then
         path = path[arg]
      end
   end

   -- Wrong command. Display help.
   local an = nameSpace.FormatColour.an
   local cm = nameSpace.FormatColour.cm
   nameSpace.Print("Wrong parameters. Help: "..an("/cpr").." "..cm("help"))
end


-------------------------------------------------------------------------------
-- EVENTS
-------------------------------------------------------------------------------
function nameSpace:handleEvents(event, ...)
   if event == "ADDON_LOADED"
   then
      local name = ...
      if name == "CeldorPlayerRecorder"
      then
         nameSpace:init()
      end
   elseif event == "PLAYER_ENTERING_WORLD"
   then
      PTable:ResetGroup()
      PTable:ResetActiveGroup()
      PTable:UpdateGroup()
      PTable:CheckCurrentGroup()
   elseif event == "GROUP_ROSTER_UPDATE"
   then
      PTable:ResetActiveGroup()
      PTable:UpdateGroup()
      PTable:CheckCurrentGroup()
   end
end


function nameSpace:init()
   -- allow arrow keys
   for i = 1, NUM_CHAT_WINDOWS do
      _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false)
   end

   -- Register slah commands
   SLASH_CeldorPlayerRecorder1 = "/cpr"
   SLASH_CeldorPlayerRecorder2 = "/celdorplayerrecorder"
   SlashCmdList.CeldorPlayerRecorder = HandleSlashCommands

   -- Check configuration
   config.CheckConfig();

   PTable.dataBase = CeldorPlayerRecorderDB.players
   nameSpace.config.output = CeldorPlayerRecorderDB.output

   nameSpace.Print("Welcome :)")
end


-------------------------------------------------------------------------------
-- Initialize addon
-------------------------------------------------------------------------------
local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("GROUP_ROSTER_UPDATE")
events:SetScript("OnEvent", nameSpace.handleEvents)


--ViragDevTool_AddData({...}, "TEST1")
