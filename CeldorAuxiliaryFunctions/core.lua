-- luacheck: globals N_Celdor TomTom Cel_Format

local addon, ns = ...


local function getListOfSaved(israid)
	local savedDungeons = {}
	local savedRaids = {}

	for i = 1, GetNumSavedInstances() do
		local n, _, r, _, _, _, _, ir, _, d = GetSavedInstanceInfo(i)
		if ir then
			tinsert(savedRaids, {
				name = string.format("%-20s", n),
				remain = string.format("%.2d:%.2d:%.2d", r / (60 * 60), r / 60%60, r%60),
				dungeon = d,
			})
		else
			tinsert(savedDungeons, {
				name = string.format("%-20s", n),
				remain = string.format("%.2d:%.2d:%.2d", r / (60 * 60), r / 60%60, r%60),
				dungeon = d,
			})
		end
	end
	if israid then
		table.sort(savedRaids, function(a, b) return a.name < b.name end)
		return savedRaids
	end
  table.sort(savedDungeons, function(a, b) return a.name < b.name end)
	return savedDungeons
end

local function printSaved(itslist, title, notitle, indent)
	if #itslist > 0 then
		print(string.format(title, #itslist))
		for i, v in ipairs(itslist) do
			print(indent .. v.name .. "   " .. v.dungeon)
		end
	else
		if notitle then
			print(notitle)
		end
	end
end


N_Celdor = {
	RandomMessage = function (self)
		local messages = {
			"(Rare %l) %n %h% @(%c)",
			"Rare: %n %h%, @(%c)",
			"%n is up %h%, @(%c)",
			"%n (%h%) @(%c)",
		}
		return self.RareMessage(messages[math.random(1, #messages)])
	end,
	RareMessage = function (msg, unit, sep)
		unit = unit or "target"
		sep = sep or " "
		if not UnitExists(unit) then return end
		local name = UnitName(unit)
		local health = Round(UnitHealth(unit) / UnitHealthMax(unit) * 100)
		local rare = UnitClassification(unit):match("rare") and "R" or ""
		local elite = UnitClassification(unit):match("elite") and "+" or ""
		local level = UnitLevel(unit) == -1 and "??" or UnitLevel(unit)
		local _, x, y = TomTom:GetCurrentPlayerPosition()
		local coords = ("%.1f" .. sep .. "%.1f"):format((x or 0) * 100, (y or 0) * 100)

		return (msg:gsub("%%n", name):gsub("%%l", level .. rare .. elite):gsub("%%h", health):gsub("%%c", coords))
	end,
	ListSavedDungeons = function(title, notitle, indent)
		title = title or "Saved on %d dungeon(s):"
		notitle = notitle or "Not saved on any dungeon:"
    indent = indent or "    "
		printSaved(getListOfSaved(), title, notitle, indent)
	end,
	ListSavedRaids = function(title, notitle, indent)
    local thelist = getListOfSaved(true)
		title = title or "Saved on %d raid(s):"
		notitle = notitle or "Not saved on any raid:"
    indent = indent or "    "
		printSaved(thelist, title, notitle, indent)
	end,
	UN = UnitName,
	UC = UnitClassification,
	UL = UnitLevel,
	UH = UnitHealth,
	UHM = UnitHealthMax,
	UE = UnitExists,
}


Cel_Format = {}

function Cel_Format.isvalid(num, predicate)
	-- return bool
	if not tonumber(num) or (predicate and not predicate(num)) then return end
	return true
end

function Cel_Format.seconds(t, threshold, colour)
	-- return string
	if not Cel_Format.isvalid(t, function(x) return x > 0 end) then return "" end
	threshold = threshold or 5
	local f_str
	f_str = string.format(t >= threshold and "%.0f" or "%.1f", t)
	f_str = colour and t < threshold and "|cFFFF0000"..f_str.."|r" or f_str
	return f_str
end

function Cel_Format.formatduration(t, threshold, colour)
	-- returns string
	if not Cel_Format.isvalid(t, function(x) return x > 0 end) then return "" end
	return t > 3600 and ceil(t / 3600).."h" or t > 60 and ceil(t / 60).."m" or Cel_Format.seconds(t, threshold, colour)
end
