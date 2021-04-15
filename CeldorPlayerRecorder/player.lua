addon, nameSpace = ...

local Announcement = {
   players = {},

   CopyTable = function(t)
      local temp = {}
      for guid, b in pairs(t) do
         temp[guid] = b
      end
      return temp
   end,
   Add = function (self, guid)
      if not self:Check(guid) then
         self.players[guid] = true
      end
   end,
   Remove = function (self, guid)
      if self:Check(guid) then
         self.players[guid] = nil
      end
   end,
   Check = function (self, guid)
      return self.players[guid]
   end,
   Update = function (self, currentplayers)
      local p = self.CopyTable(self.players)
      for guid, _ in pairs(p) do
         if currentplayers[guid] == nil then
            self:Remove(guid)
         end
      end
   end,
};


-- Table for processing Players
nameSpace.Player = {
   groupMembers = {}, -- table reset only in the next dngeon
   activeGroupMembers = {}, -- table reset on every roster update
   timeFormat = "%A. %d %b %Y. %H:%M",
   dataBase = {},

   Announce = Announcement, -- table reset every time group roster updated
   wrn = function (msg)
      return "|cFFFFA000"..msg.."|r"
   end,
   FindPlayer = function (self, inputName)
      if not inputName or inputName == "" then
         nameSpace.Print("Missing input player name!")
         return
      end
      for guid, char in pairs(self.dataBase) do
         if char["name"]:lower():match(inputName:lower())
         then
            return guid, char
         end
      end
   end,
   IsPlayerInGroup = function (type)
      type = type or "party"
      local inInstance, instanceType = IsInInstance()
      return inInstance and instanceType == type
   end,
   GetUnitCharacteristics = function (unit)
      if not unit:match("party%d")
      -- and not unit == "player"   -- for testing
      then
         return
      end
      local guid = UnitGUID(unit)
      local className = UnitClass(unit)
      local role = UnitGroupRolesAssigned(unit)
      local name, realm = UnitName(unit)
      -- set realm manually because realm is nil If unit's realm is the same as player's realm
      realm = realm or select(2, UnitFullName("player"))
      local instanceName, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo()
      instanceID = instanceType ~= "none" and instanceID or nil
      instanceName = instanceType ~= "none" and instanceName or nil
      return guid, name, realm, role, className, instanceName, instanceID
   end,
   GetUnitCharacteristicsFromRole = function (self, inputRole)
      -- TANK, HEALER, DAMAGER
      inputRole = inputRole:upper() or "TANK"
      -- Check against wrong roles
      if inputRole ~= "DAMAGER" and inputRole ~= "HEALER" and inputRole ~= "TANK"
      then
         return
      end
      -- Collect players
      local roles = {}
      for guid, char in pairs(self.groupMembers) do
         if inputRole == char["role"] then
            tinsert(roles, {guid, char})
         end
      end

      -- If someting's wrong return
      if not nameSpace.Array.IsArray(roles) then return end
      -- Return role(s) in a table even of lengh 1
      return roles
   end,
   GetUnitCharacteristicsFromName = function (self, inputName)
      if not inputName then
         nameSpace.Print("Missing player name!")
         return
      end
      local names = {}
      for guid, char in pairs(self.groupMembers) do
         if char["name"]:lower():match(inputName:lower())
         then
            tinsert(names, {guid, char})
         end
      end
      if not nameSpace.Array.IsArray(names) then return end
      return names
   end,
   FormatUnitName = function (char)
      -- char is a table with Unit Characteristics: name, realm, class, comment, counter etc.
      local cc = select(4, GetClassColor(strupper(char["class"]):gsub("%s+", "")));
      local name = char["name"].."-"..char["realm"];
      if CeldorPlayerRecorderDB.showlinks then
         name = "|Hplayer:"..name.."|h[|c"..cc..name.."|r]";
      else
         name = "|c"..cc..name.."|r";
      end
      return name;
   end,
   SavePlayer = function (self, ...)
      --if not isPlayerInGroup("party") then return end
      local inputName = ...
      local comment = table.concat({select(2, ...)}, " ")

      -- Is input valid
      if not inputName or inputName == "" then
         nameSpace.Print("Missing input player name!")
         return
      end
      -- Get Player Name from Role
      local elements
      if inputName:lower() == "tank"
      or inputName:lower() == "healer"
      or inputName:lower() == "damager"
      then
         elements = self:GetUnitCharacteristicsFromRole(inputName)
      else
         elements = self:GetUnitCharacteristicsFromName(inputName)
      end

      -- Does unit exist?
      if elements == nil then
         nameSpace.Print(self.wrn("Error saving").." "..inputName.."!. "..self.wrn("No such Player!"))
         return
      end

      -- Check results
      local test, code = nameSpace.IsReturnSingleResult(elements)
      if not test then
         if code == 1 then
            nameSpace.Print(self.wrn("Error finding elements!"))
         else
            nameSpace.Print(self.wrn("Multiple elements. Use a different command"))
         end
         return
      end

      -- Unpack table
      local guid, gr_mem = unpack(elements[1])

      -- Check if already exists
      if self.dataBase[guid] then
         nameSpace.Print(self.FormatUnitName(gr_mem).." already exists.")
         return
      end

      -- Add new player with the first entry
      self.dataBase[guid] = {
         ["name"] = gr_mem["name"],
         ["realm"] = gr_mem["realm"],
         ["class"] = gr_mem["class"],
         ["entries"] = {
            {
               ["instanceName"] = gr_mem["instanceName"],
               ["instanceId"] = gr_mem["instanceId"],
               ["role"] = gr_mem["role"],
               ["comment"] = comment,
               ["timestamp"] = GetServerTime(),
            },
         },
      }
      nameSpace.Print("Added "..gr_mem["name"]..".")
      return true
   end,
   RemovePlayer = function (self, inputName)
      --if not isPlayerInGroup("party") then return end
      local guid, char = self:FindPlayer(inputName)
      if guid then
         self.dataBase[guid] = nil
         nameSpace.Print(self.FormatUnitName(char) .. " has been removed.")
         return true
      end
      if not playerFound then
         nameSpace.Print(self.wrn("Error removing ")..inputName..self.wrn("! Player not found"))
      end
   end,
   CheckPlayer = function (self, inputName)
      local char = select(2, self:FindPlayer(inputName))
      if char then
         self:DisplayPlayer(char)
         return true
      else
         if displaymsg then
            DEFAULT_CHAT_FRAME:AddMessage(self.wrn("No such a player as ")..inputName..self.wrn("!"))
         end
      end
      --if not isPlayerInGroup("party") then return end
      --DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000Error removing player: "..dispPlayer.."!|r")
   end,
   DisplayPlayer = function (self, char, headline)
      -- char is a table with Unit Characteristics: name, realm, class, comment, counter etc.
      local nu = nameSpace.FormatColour.nu -- number
      local da = nameSpace.FormatColour.da -- date
      local ni = nameSpace.FormatColour.ni -- name instance
      local mi = nameSpace.FormatColour.mi -- missing entry
      -- Display head-title
      if headline == nil then headline = true end
      -- Print
      if headline then
         nameSpace.Print()
      end
      DEFAULT_CHAT_FRAME:AddMessage("- "..self.FormatUnitName(char)..":")
      for i, entry in ipairs(char["entries"]) do
         local dateStr = date(self.timeFormat, entry["timestamp"])
         DEFAULT_CHAT_FRAME:AddMessage("    "..tostring(nu(i))
            ..(entry["instanceName"] ~= nil and ":"..ni(entry["instanceName"]) or "")
            ..(entry["role"] and entry["role"] ~= "" and entry["role"] ~= "NONE" and ":"..nu(entry["role"]) or ":"..mi("NONE"))
            ..": "..entry["comment"]..". Date: "..da(dateStr))
      end
   end,
   -- /cpr list [filter] [keyword] string
   ListPlayers = {
      sc = nameSpace.FormatColour.sc,   -- subcommand
      ct = nameSpace.FormatColour.ct,   -- comment
      lookuptable = { {"role", 1}, {"name", 1}, {"comment", 1}, },

      CheckMatch = function (predicate, itsChar)
         if itsChar == nil or #itsChar["entries"] == 0 then return end
         local isValue = false
         for _, item in ipairs(itsChar["entries"]) do
            if predicate(item) then
               isValue = isValue or true
            end
         end
         return isValue
      end,
      PopulateList = function (self, predicate, fullDB)
         local innerDB = {}
         for _, char in pairs(fullDB) do
            if predicate and self.CheckMatch(predicate, char) or not predicate then
               tinsert(innerDB, char)
            end
         end
         return innerDB
      end,
      List = function (self, ...)
         if not nameSpace.Array.IsArray(nameSpace.Player.dataBase) then
            nameSpace.Print(nameSpace.Player.wrn("Empty database"))
            return
         end

         local locDB
         if ... ~= "filter" then
            locDB = self:PopulateList(nil, nameSpace.Player.dataBase)
         else
            -- Setup constrains
            if select("#", ...) <= 1 then
               nameSpace.Print(nameSpace.Player.wrn("Empty criteria"))
               return
            end
            local inputs = table.concat({select(2, ...)}, " ");
            local p_obj = nameSpace.Parser:New(inputs)
            local paramsargs = p_obj:ParseAllInputs(self.lookuptable)
            if nameSpace.Array.IsEmpty(paramsargs) then
               nameSpace.Print(nameSpace.Player.wrn("Wrong parameters"))
               return
            else
               for i, crit in ipairs(paramsargs) do
                  local predicate
                  local param, arg = unpack(crit)
                  if not param or param == "" or not arg or arg == "" then
                     nameSpace.Print(nameSpace.Player.wrn("Wrong parameters"))
                     return
                  end
                  if param == "role" then
                     predicate = function (e) return arg:lower() == e["role"]:lower() end
                  elseif param == "comment" then
                     predicate = function (e) return e["comment"]:lower():match(arg:lower()) end
                  else
                     nameSpace.Print(nameSpace.Player.wrn("Wrong parameters"))
                     return
                  end
                  -- Shrink local DB
                  if i == 1 then
                     locDB = self:PopulateList(predicate, nameSpace.Player.dataBase)
                  else
                     locDB = self:PopulateList(predicate, locDB)
                  end
               end
            end
         end

         if #locDB == 0 then
            nameSpace.Print(nameSpace.Player.wrn("Empty output"))
            return
         end

         -- Sort alphabetically by the filed name
         table.sort(locDB, function(char1, char2)
            return char1["name"] < char2["name"]
         end)
         -- List players from a sorted table
         nameSpace.Print("List of players:")
         for _, char in ipairs(locDB) do
            nameSpace.Player:DisplayPlayer(char, false)
         end
      end,
      NoFilter = function (self)
         return self:PopulateList()
      end,
      FilterByRole = function (self)
         local role = self.inputs.parameter
         local predicate = function (e) return role:lower() == e["role"]:lower() end
         return self:PopulateList(predicate)
      end,
      FilterByComment = function (self)
         local comm = self.inputs.parameter
         local predicate = function (e) return e["comment"]:lower():match(comm:lower()) end
         return self:PopulateList(predicate)
      end,
   },
   AddComment = function (self, ...)
      local inputName = ...
      local comment = table.concat({select(2, ...)}, " ")
      local _, char = self:FindPlayer(inputName)
      if char then
         if comment and comment ~= "" then
            local elements = self:GetUnitCharacteristicsFromName(inputName)
            -- Check results
            local test, code = nameSpace.IsReturnSingleResult(elements)
            if not test then
               if code == 1 then
                  nameSpace.Print(self.wrn("Error finding elements!"))
               else
                  nameSpace.Print(self.wrn("Multiple elements. Narrow your query"))
               end
               return
            end
            local guid, gr_mem = unpack(elements[1])
            -- Add new entry
            tinsert(self.dataBase[guid]["entries"],
               {
                  ["instanceName"] = gr_mem["instanceName"],
                  ["instanceId"] = gr_mem["instanceId"],
                  ["role"] = gr_mem["role"],
                  ["comment"] = comment,
                  ["timestamp"] = GetServerTime(),
               }
            )
            nameSpace.Print("Appended new comment to "..self.FormatUnitName(char)..".")
            return true
         else
            nameSpace.Print(self.wrn("Empty comment"))
         end
         nameSpace.Print(self.wrn("No such a player as ")..inputName..self.wrn("!"))
      end
   end,
   SetComment = function (self, ...)
      -- section number, player name
      local section, inputName = ...
      local comment = table.concat({select(3, ...)}, " ")
      section = tonumber(string.format("%d", section))
      local guid, char = self:FindPlayer(inputName)
      local nu = nameSpace.FormatColour.nu -- number
      -- Is player
      if guid == nil then
         nameSpace.Print(self.wrn("No such a player as ")..inputName..self.wrn("!"))
         return
      end
      -- Is valid section
      if section == nil or section == 0 then
         nameSpace.Print(self.wrn("Wrong number"))
         return
      elseif section > #char["entries"] then
         nameSpace.Print(self.wrn("Valid section number is between ")
            ..nu("1").." and "..nu(tostring(#char["entries"]))..self.wrn(" for ")..self.FormatUnitName(char)
         )
         return
      end
      -- Is valid comment
      if comment == nil or comment == "" then
         nameSpace.Print(self.wrn("Empty comment"))
         return
      end
      char["entries"][section]["comment"] = comment
      nameSpace.Print("Set new comment for "..self.FormatUnitName(char)..".")
      return true
   end,
   -- Check the whole group
   CheckCurrentGroup = function (self)
      for guid, char in pairs(self.activeGroupMembers) do
         if self:CheckPlayer(char["name"], false) and not self.Announce:Check(guid) then
            C_Timer.After(0.25, function() PlaySound(SOUNDKIT["TELL_MESSAGE"], "Dialog") end)
            self.Announce:Add(guid)
         end
      end
   end,
   UpdateGroup = function (self)
      for i = 1, 4 do
         local unit = "party"..i
         local guid, name, realm, role, className, instanceName, instanceID = self.GetUnitCharacteristics(unit)
         if guid then
            self.groupMembers[guid] = {
               ["name"] = name,
               ["realm"] = realm,
               ["class"] = className,
               ["role"] = role,
               ["instanceId"] = instanceID,
               ["instanceName"] = instanceName,
               ["comment"] = nil,
               ["counter"] = 0,
               ["date"] = nil,
            }
            self.activeGroupMembers[guid] = {
               ["name"] = name,
               ["realm"] = realm,
            }
         end
      end
   end,
   ResetGroup = function (self)
      wipe(self.groupMembers)
      -- local n = #self.groupMembers
      -- for i = 1,n do tremove(self.groupMembers)
   end,
   ResetActiveGroup = function (self)
      wipe(self.activeGroupMembers)
      -- local n = #self.activeGroupMembers
      -- for i = 1,n do tremove(self.activeGroupMembers)
   end,
   PopulateGroup = function (self)
      self:ResetGroup()
      self:ResetActiveGroup()
      self:UpdateGroup()
   end,
}
