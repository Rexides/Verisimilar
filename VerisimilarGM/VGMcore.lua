VerisimilarGM = LibStub("AceAddon-3.0"):NewAddon("VerisimilarGM", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0","AceTimer-3.0", "AceSerializer-3.0")
--VerisimilarPrefix="VSML";
VerisimilarGM.sessionVersion=3;
local Tourist=LibStub("LibTourist-3.0");
--[[
TODO:
-Welcome screen
-Wizards		
-VGM Interface
	-Right click menu on sessions/elements
	-Mobs:
		-Kill script
-On line help
	-Documentation
	-Tutorials
-transfer sessions between players
-Copy elements (between sessions)
]]
local defaults={
	char = {
	    sessions = {
			},
		sessionStatus = {
			},
		
	    
	},
	global = {
		sessions = {
				},
		oldSessionsImported=false,
		showTooltips=true,
	},
	factionrealm = {
		playerDataPerSession = {
				},
	},
				
}

local options =				{
								name = "Verisimilar GM options",
								type = "group",
								handler=VerisimilarGM,
								args = {
										sessions={
														name = "Config panel options",
														type = "group",
														order = 1,
														guiInline = true,
														args = {
															description = {
																type = "description",
																name = "These options control how the config panel for creating and managing your sessions behaves",
																order = 1,
															},
															Tooltips={
																name="Tooltips",
																desc="Show helpful tooltips for various options",
																type="toggle",
																order = 2,
																set = function(info,val) VerisimilarGM.db.global.showTooltips = val end,
																get = function(info) return VerisimilarGM.db.global.showTooltips end
																},
														}
												},
										},
							}

function VerisimilarGM:OnInitialize()
    -- Called when the addon is loaded
	self.db = LibStub("AceDB-3.0"):New("VerisimilarGMDB",defaults);
	self:RegisterChatCommand("verisimilargm", "ToggleMainWindow")
	self:RegisterChatCommand("vgm", "ToggleMainWindow")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("VerisimilarGM", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("VerisimilarGM", "Game Master","Verisimilar")
	RegisterAddonMessagePrefix(VerisimilarPrefix)
	self:RegisterEvent("PLAYER_LOGOUT");
	--self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED","EventWatcher");
	--self:RegisterEvent("ZONE_CHANGED","EventWatcher");
	--self:RegisterEvent("ZONE_CHANGED_INDOORS","EventWatcher");
	self.version=tonumber(GetAddOnMetadata("VerisimilarGM","Version"));
	self:Print("Version:",self.version);
	self:CreateZoneMapInfo();
	local sessionList=VerisimilarGM.db.global.sessions;
	if(sessionList["Demo Session"]==nil)then
		sessionList["Demo Session"]=VerisimilarDemoSession;
	end
	if(VerisimilarGM.db.global.oldSessionsImported==false)then --This is so we can import the old per-character session lists to the new global list just once when 0.15 runs for the first time
		VerisimilarGM:ImportOldSessions(sessionList);
		VerisimilarGM.db.global.oldSessionsImported=true;
	end
	for sessionName,session in pairs(sessionList) do
		VerisimilarGM:UpdateSession(session);
		VerisimilarGM:RegisterSessionNetID(session)
		VerisimilarGM:AssignSessionFuncs(session);
		if(session:IsEnabled())then
			session:Enable();
		end
		VerisimilarPl:AddSession({n=session.name,id=session.netID,gm=UnitName("player"),c=session.channel,p=session.password})
	end
	VerisimilarGM:RegisterComm(VerisimilarPrefix);
	VerisimilarGM:InitializeInterface();
	VerisimilarGM:ScheduleRepeatingTimer("SendSessionLists", 60);
end



function VerisimilarGM:OnEnable()
    -- Called when the addon is enabled
	
end

function VerisimilarGM:OnDisable()
    -- Called when the addon is disabled
	
end

function VerisimilarGM:PLAYER_LOGOUT()
	local sessionList=VerisimilarGM.db.global.sessions;
	for sessionName,session in pairs(sessionList) do
		if(session.status.keepPlayerData==false)then
			self.db.factionrealm.playerDataPerSession[session.name]=nil;
		else
			for _,player in pairs(session.players)do
				player.connected=false;
			end
		end
		session.players=nil
		session.env=nil;
		session.status=nil;
		for varName,var in pairs(session) do
			if(type(var)=='function') then
				session[varName]=nil;
			end
		end
		for __,element in pairs(session.elements) do
			for varName,var in pairs(element)do
				if(type(var)=='function') then
					element[varName]=nil;
				end
			end
		end
	end
end

function VerisimilarGM:EventWatcher(event,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17)
	self:Print(event,"arg1",arg1,"arg2",arg2,"arg3",arg3,"arg4",arg4,"arg5",arg5,"arg6",arg6,"arg7",arg7,"arg8",arg8,"arg9",arg9,"arg10",arg10,"arg11",arg11,"arg12",arg12,"arg13",arg13,"arg14",arg14,"arg15",arg15,"arg16",arg16,"arg17",arg17)
end

function VerisimilarGM:Clicker()

end


VerisimilarGM.GMFuncLib={};

function VerisimilarGM.GMFuncLib.SubSpecialChars(text,player,synonyms)
	if(synonyms==nil)then
		synonyms={['female']='woman',['male']='man'};
	else
		if(synonyms['female']==nil) then synonyms['female']='woman' end
		if(synonyms['male']==nil) then synonyms['male']='man' end
	end
	
	text=string.gsub(text,"%%fn",player.firstName);
    text=string.gsub(text,"%%ln",player.lastName);
	text=string.gsub(text,"%%rk",player.rank);
    text=string.gsub(text,"%%nn",player.nickName);
	text=string.gsub(text,"%%tl",player.title);
	text=string.gsub(text,"%%r",synonyms[player.race] or string.lower(player.race));
    text=string.gsub(text,"%%c",synonyms[player.class] or string.lower(player.class));
    text=string.gsub(text,"%%g",synonyms[player.gender] or player.gender);
	
	return text
end

function VerisimilarGM.GMFuncLib.Distance(x1,y1,zone1,x2,y2,zone2)
	if(zone1~=zone2)then
		return 99999999999999999999
	end
	
	local xscale,yscale=Tourist:GetZoneYardSize(zone1)
	if(xscale==nil)then return 100000 end
	local xyards=(x1-x2)*xscale;
	local yyards=(y1-y2)*yscale;
	return sqrt(xyards*xyards+yyards*yyards);
	
end

function FindLArgestZone()
	local largestZone=""
	local largestSize=0;
	for zone in Tourist:IterateKalimdor() do
		local size=Tourist:GetZoneYardSize(zone)
		if(size and size>largestSize and zone~="Kalimdor")then
			largestZone=zone;
			largestSize=size;
		end
	end
	print(largestZone)
	print(largestSize)
	
	local largestZone=""
	local largestSize=0;
	for zone in Tourist:IterateEasternKingdoms() do
		local size=Tourist:GetZoneYardSize(zone)
		if(size and size>largestSize and zone~="Eastern Kingdoms")then
			largestZone=zone;
			largestSize=size;
		end
	end
	print(largestZone)
	print(largestSize)
	
	local largestZone=""
	local largestSize=0;
	for zone in Tourist:IterateOutland() do
		local size=Tourist:GetZoneYardSize(zone)
		if(size and size>largestSize and zone~="Outland")then
			largestZone=zone;
			largestSize=size;
		end
	end
	print(largestZone)
	print(largestSize)
	
	local largestZone=""
	local largestSize=0;
	for zone in Tourist:IterateNorthrend() do
		local size=Tourist:GetZoneYardSize(zone)
		if(size and size>largestSize and zone~="Northrend")then
			largestZone=zone;
			largestSize=size;
		end
	end
	print(largestZone)
	print(largestSize)
	
	local largestZone=""
	local largestSize=0;
	for zone in Tourist:IterateTheMaelstrom() do
		local size=Tourist:GetZoneYardSize(zone)
		if(size and size>largestSize and zone~="Kalimdor")then
			largestZone=zone;
			largestSize=size;
		end
	end
	print(largestZone)
	print(largestSize)
end

function VerisimilarGM.GMFuncLib.GiveGHRReputation(player,factionID,amount)
	if(GHR_Mod_ChangeReputation)then
		local playerName=player;
		if(type(player)=="table")then playerName=player.name end
		GHR_Mod_ChangeReputation(playerName,factionID,amount);
	end
end

VerisimilarGM.CommonFuncs={};

function VerisimilarGM.CommonFuncs:GenerateNewVersion()
	
	local newVersion;
	repeat
		newVersion=strchar(random(1,255),random(1,255));
	until(newVersion~=self.version)
	self.version=newVersion;
end

function VerisimilarGM.CommonFuncs:GetSession()
	return VerisimilarGM.db.global.sessions[self.sessionName];
end

function VerisimilarGM.CommonFuncs:Enable()
	self.enabled=true;
	local session=self:GetSession();
	if(session:IsEnabled())then
		for _,player in pairs(session.players) do
			if(player.connected)then
				player.elements[self.id].awaitingConcConfirm=true;
			end
		end
		VerisimilarGM:SendSessionMessage(nil,session,nil,"ENABLE",self.netID..self.version);
	end
	session:TransferStubs();
end

function VerisimilarGM.CommonFuncs:Disable()
	self.enabled=false;
	local session=self:GetSession();
	if(session:IsEnabled())then
		VerisimilarGM:SendSessionMessage(nil,session,nil,"DISABLE",self.netID);
	end
end

function VerisimilarGM.CommonFuncs:IsEnabled()
	return self.enabled;
end

function VerisimilarGM:ImportOldSessions(sessionList)
	if(VerisimilarGMDB.char==nil)then return end
	for _,player in pairs(VerisimilarGMDB.char)do
		for __,session in pairs(player.sessions)do
			if(session.name~="Demo Session")then
				local newName=session.name;
				local i=1;
				while(sessionList[newName]~=nil)do
					i=i+1;
					newName=session.name.."_"..i;
				end
				sessionList[newName]=session;
				session.enabled=nil;
				session.isLocal=nil;
				session.keepPlayerData=nil;
				session.players=nil;
				if(session.name~=newName)then
					session.name=newName;
					for NPCId, NPC in pairs(session.NPCs) do
						NPC.sessionName=newName;
					end
					for QuestId, Quest in pairs(session.Quests) do
						Quest.sessionName=newName;
					end
					for ItemId, Item in pairs(session.Items) do
						Item.sessionName=newName;
					end
					for ScriptId, Script in pairs(session.Scripts) do
						Script.sessionName=newName;
					end
					for MobId, Mob in pairs(session.Mobs) do
						Mob.sessionName=newName;
					end
				end
			end
		end
	end
end

