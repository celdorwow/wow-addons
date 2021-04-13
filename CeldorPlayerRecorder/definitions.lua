--- Definitions

addonName, nameSpace = ...

-------------------------------------------------------------------------------
--- Local functions
-------------------------------------------------------------------------------

local String = {
   StrTrim = function(s)
      return s:match "^%s*(.*)":match "(.-)%s*$";
   end,
   StrSplit = function(s)
      local t = {};
      for w in s:gmatch("%w+") do
         table.insert(t, w);
      end
      return t;
   end,
};


-------------------------------------------------------------------------------
--- Functions in the name space
-------------------------------------------------------------------------------

function nameSpace.Print (msg)
   local appname = "|cFF7ff01cCeldor Player Recorder|r"
   DEFAULT_CHAT_FRAME:AddMessage(appname..(msg and msg ~= "" and ": "..msg or ":"))
end


function nameSpace.IsReturnSingleResult (e)
   if e ~= nil and #e == 1 then
      return true
   end
   if (e == nil) or (e ~= nil and #e == 0) then
      return false, 1
   elseif e ~= nil and #e > 1 then
      return false, 2
   end
end


function nameSpace.Db2Html(itsdb)
   if itsdb == nil then return end
   local html_str = "<html><body><table>"
   html_str = html_str .. "<thead><tr><td>Name</td><td>Realm</td><td>Class</td><td>#</td><td>Date</td><td>Instance</td><td>Role</td><td>Comment</td></tr></thead>"

   -- CeldorPlayerRecorderDB
   html_str = html_str .. "<tbody>"
   local char_fields = {"name", "realm", "class"}
   local spec_fields = {"timestamp", "instanceName", "role", "comment"}
   for _, pl in pairs(itsdb) do
      -- build TBODY
      local n = #pl["entries"]
      if n == 1 then
         html_str = html_str .. "<tr>"
         for _, field in ipairs(char_fields) do
            html_str = html_str .. string.format("<td>%s</td>", pl[field])
         end
         html_str = html_str .. string.format("<td>%d</td>", 1)
         for _, field in ipairs(spec_fields) do
            local val = pl["entries"][1][field] or ""
            html_str = html_str .. "<td>" .. val .. "</td>"
         end
         html_str = html_str .. "</tr>"
      else
         for e = 1, n do
            html_str = html_str .. "<tr>"
            if e == 1 then
               for _, field in ipairs(char_fields) do
                  html_str = html_str .. string.format("<td rowspan=%d>%s</td>", n, pl[field])
               end
            end
            html_str = html_str .. string.format("<td>%d</td>", e)
            for _, field in ipairs(spec_fields) do
               local val = pl["entries"][e][field] or ""
               html_str = html_str .. "<td>" .. val .. "</td>"
            end
            html_str = html_str .. "</tr>"
         end -- end of for i = 1, n do
      end -- end of if n == 1 then
   end -- for _, pl in pairs(CeldorPlayerRecorderDB) do
   html_str = html_str .. "</tbody>"
   html_str = html_str .. "</table></body></html>"
   return html_str
end


function nameSpace.Db2PPrint(itsdb)
   if itsdb == nil then return end

   -- Local auxiliary functions
   local getHigher = function (var, t, field)
      return t[field] and strlen(t[field]) > var and strlen(t[field]) or var
   end
   local function getMaxes (indb)
      local tf = "%A. %d %b %Y. %H:%M"
      local name, realm, class, maxn, timest, instn, role, comm = 0, 0, 0, 0, 0, 0, 0, 0
      for _, char in pairs(indb) do
         name = getHigher(name, char, "name")
         realm = getHigher(realm, char, "realm")
         class = getHigher(class, char, "class")
         for _, entry in ipairs(char["entries"]) do
            local d = date(tf, entry["timestamp"])
            timest = strlen(d) > timest and strlen(d) or timest
            instn = getHigher(instn, entry, "instanceName")
            role = getHigher(role, entry, "role")
            comm = getHigher(comm, entry, "comment")
         end
         local n = #char["entries"]
         maxn = n > maxn and n or maxn
      end
      return name, realm, class, maxn, timest, instn, role, comm
   end
   local function getFmt (...)
      local str = ""
      for i, n in ipairs({...}) do
         if i == 1 then
            str = string.format(" %%-%ds", n)
         else
            str = string.format("%s | %%-%ds", str, n)
         end
      end
      str = str .. " "
      return str
   end

   local fmt = getFmt(getMaxes(itsdb))
   local cf = {"name", "realm", "class"}
   local sf = {"timestamp", "instanceName", "role", "comment"}
   local plain_str = ""
   for _, pl in pairs(itsdb) do
      -- build TBODY
      local n = #pl["entries"]
      if n == 1 then
         local s = pl["entries"][1]
         plain_str = plain_str .. string.format(fmt, pl[cf[1]], pl[cf[2]], pl[cf[3]],
            tostring(1), s[sf[1]], s[sf[2]] or "", s[sf[3]] or "", s[sf[4]] or "")
         plain_str = plain_str .. "\n"
      else
         for e = 1, n do
            local s = pl["entries"][e]
            if e == 1 then
               plain_str = plain_str .. string.format(fmt, pl[cf[1]], pl[cf[2]], pl[cf[3]],
                  tostring(1), s[sf[1]], s[sf[2]] or "", s[sf[3]] or "", s[sf[4]] or "")
            else
               plain_str = plain_str .. string.format("", "", "",
                  tostring(1), s[sf[1]], s[sf[2]] or "", s[sf[3]] or "", s[sf[4]] or "")
            end
            plain_str = plain_str .. "\n"
         end -- end of for i = 1, n do
      end -- end of if n == 1 then
   end -- for _, pl in pairs(CeldorPlayerRecorderDB) do
   return plain_str
end


function nameSpace.splitBySpace(s)
   -- Removes trailing and repeated spaces
   -- before splitting a string
   if not s or s == "" then return end
   s = strtrim(s, " "):gsub("%s+", " ")
   return strsplit(" ", s)
end



-------------------------------------------------------------------------------
--- TABLES in the name space
-------------------------------------------------------------------------------

nameSpace.Array = {
   Empty = function(t)
      for _ = 1, #t do
         table.remove(t);
      end
   end,
   Copy = function(tsource, tdest)
      tdest = tdest or {};
      for _, v in ipairs(tsource) do
         table.insert(tdest, v);
      end
   end,
   Find = function(par, t)
      local i;
      while next(t, i) do
         i = next(t, i);
         if t[i] == par then
            return i;
         end
      end
   end,
   IsEmpty = function(t)
      if type(t) ~= "table" then
         return
      end
      return not next(t)
   end,
   IsArray = function (t)
      if not t then return end
      return next(t) ~= nil
   end,
};


nameSpace.Parser = {
   storedargs = {},
   localargs = {},
   __populatetable = function(t_args, p_name, n, l_args)
      local ni = nameSpace.Array.Find(p_name, l_args)
      while ni do
         local temp = { p_name };
         for i = 1, n do
            table.insert(temp, l_args[ni + i]);
         end
         table.insert(t_args, temp);
         -- remove elements already found from temp
         for _ = 1, n + 1 do
            table.remove(l_args, ni);
         end
         -- Check for repeated parameter
         ni = nameSpace.Array.Find(p_name, l_args)
      end
   end,
   -- API
   ParseInput = function(self, p_name, n_args)
      n_args = tonumber(n_args) or 0
      nameSpace.Array.Empty(self.storedargs);
      nameSpace.Array.Empty(self.localargs);
      nameSpace.Array.Copy(self.allargs, self.localargs);
      self.__populatetable(self.storedargs, p_name, n_args, self.localargs)
      return self.storedargs;
   end,
   ParseAllInputs = function(self, lookuptable)
      nameSpace.Array.Empty(self.storedargs);
      nameSpace.Array.Empty(self.localargs);
      nameSpace.Array.Copy(self.allargs, self.localargs);
      for _, e in ipairs(lookuptable) do
         local n_args = tonumber(e[2]) or 0
         self.__populatetable(self.storedargs, e[1], n_args, self.localargs)
      end
      return self.storedargs;
   end,
   New = function(self, str)
      if not str or str == "" then
         return ;
      end
      local o = {
         s = String.StrTrim(str),
         allargs = String.StrSplit(String.StrTrim(str):gsub("[ ]+", " ")),
      };
      setmetatable(o, self);
      self.__index = self;
      return o;
   end,
};


nameSpace.FormatColour = {
   an = function(msg) return "|cFF".."7ff01c"..msg.."|r" end, -- addon
   gf = function(msg) return "|cFF".."ccff33"..msg.."|r" end, -- general format
   cm = function(msg) return "|cFF".."ff66ff"..msg.."|r" end, -- command
   sc = function(msg) return "|cFF".."ff8a05"..msg.."|r" end, -- subcommand
   pr = function(msg) return "|cFF".."cccc00"..msg.."|r" end, -- properties
   pl = function(msg) return "|cFF".."4d8eff"..msg.."|r" end, -- player
   ct = function(msg) return "|cFF".."33ff05"..msg.."|r" end, -- comment
   nu = function(msg) return "|cFF".."00ff80"..msg.."|r" end, -- number
   ni = function(msg) return "|cFF".."fff00f"..msg.."|r" end, -- instance name
   da = function(msg) return "|cFF".."66ffff"..msg.."|r" end, -- date
   mi = function(msg) return "|cFF".."a0a0a0"..msg.."|r" end, -- missing entry
}
