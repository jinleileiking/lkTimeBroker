local L = LibStub:GetLibrary( "AceLocale-3.0" ):GetLocale("lkTimeBroker")
local L_Hour = L["Hour"]
local L_Minite = L["Minite"]
local L_Second = L["Second"]
local L_TotalTime = L["TotalTime"]
local L_InstanceTime = L["InstanceTime"]
local L_Time = L["Time"]

local InstanceStart = GetTime()
local LoginStart = GetTime()

local Time = CreateFrame("Frame", "lkTimeBroker")
local ldbTimer = LibStub("LibDataBroker-1.1"):NewDataObject("Time", {type = "data source" ,icon = "Interface\\Icons\\INV_Misc_PocketWatch_03"})
local Timer = LibStub("AceAddon-3.0"):NewAddon("Timer", 'AceTimer-3.0')

function Timer:OnEnable()
	self:ScheduleRepeatingTimer("UpdateTimeStrings", 1)
end

function Timer:UpdateTimeStrings()
	ldbTimer.text = FormatTime(GetTime() - InstanceStart, L_Hour, L_Minite, L_Second)
end

function ldbTimer.OnTooltipShow(tip)
	--show the totaltime
	tip:AddLine(L_Time)
	tip:AddDoubleLine(L_TotalTime, FormatTime(GetTime() - LoginStart, L_Hour, L_Minite, L_Second))
	tip:AddDoubleLine(L_InstanceTime, FormatTime(GetTime() - InstanceStart, L_Hour, L_Minite, L_Second))
end



Time:RegisterEvent("PLAYER_ENTERING_WORLD")
Time:RegisterEvent("PLAYER_LOGIN")
Time:SetScript("OnEvent", function(_, event, ...)
	Time[event](Time, ...)
end)

function Time:PLAYER_ENTERING_WORLD()
	local inInstance, instanceType = IsInInstance();
	if ( (instanceType == "pvp") or (instanceType == "arena")  or  (instanceType == "party") or (instanceType == "raid")) then
		InstanceStart = GetTime()
		DEFAULT_CHAT_FRAME:AddMessage("You Have entered A new Zone! Start At:" .. FormatTime(GetTime(), L_Hour, L_Minite, L_Second)); 
	end
end



function Time:PLAYER_LOGIN()
	LoginStart = GetTime()
	InstanceStart = GetTime()
end




function FormatTime(sec, L_Hour, L_Minite, L_Second)
	if sec == nil then
		return ""
	end
	local s = math.floor(sec)
	local lhour = math.floor(s / 3600)
	s = s - lhour * 3600
	local lmin = math.floor(s / 60)
	local lsec = s - lmin * 60
	if lhour == 0 and lmin == 0 and lsec == 0 then
		return ""
	end
	if lhour == 0 then
		return ("%d" .. L_Minite .. "%d" .. L_Second):format(lmin, lsec)
	end
	return ("%d" .. L_Hour .. "%d" .. L_Minite .. "%d" .. L_Second):format(lhour, lmin, lsec)
--	if lhour == 0 then
--		return ("%d" .. ":" .. "%d"):format(lmin, lsec)
--	end
--	return ("%d" .. ":" .. "%d" .. ":" .. " %d"):format(lhour, lmin, lsec)	
end

