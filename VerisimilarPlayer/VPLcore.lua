VerisimilarPl = LibStub("AceAddon-3.0"):NewAddon("VerisimilarPl", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0","AceTimer-3.0", "AceSerializer-3.0","AceHook-3.0")
VerisimilarPrefix="VRML";
VerisimilarPl.currentZone="";
VerisimilarPl.lastPlayerPositionX=0;
VerisimilarPl.lastPlayerPositionY=0;
VerisimilarPl.GMIsAlive={};
VerisimilarPl.sessions={};
VerisimilarPl.scriptVersion=3;
VerisimilarPl.aggroList={};





local defaults={
	char = {
		savedSessionInfo={},
		MMBOpenDefault="Player",
		mergeWithQuestInterface=true,
		mergeWithGossipInterface=true,
		mergeWithLootInterface=true,
		mergeWithBagInterface=true,
		showEvnIconsOnMinimap=true,
		xtensionxtooltip2=true,
		firstName=UnitName("player"),
		lastName="",
		nickName="",
		rank="",
		title="",
		class=UnitClass("player"),
		race=UnitRace("player"),
	},
	factionrealm = {
		sessionStubsChache={},
	},
	global = {
		debugMode=false,
	}
}

local options = { 
    name = "Verisimilar Player",
    handler = VerisimilarPl,
    type = "group",
    args = {
		mergers={
				name = "Merge with WoW Interface",
				type = "group",
				order = 1,
				guiInline = true,
				args = {
					quests = {
						type = "toggle",
						name = "Quests",
						desc = "Disable if you have any errors with quest-related add-ons.",
						get = function() return VerisimilarPl.db.char.mergeWithQuestInterface end,
						set = function(info, value) VerisimilarPl.db.char.mergeWithQuestInterface=value;VerisimilarPl:UpdateQuestInterfaceMerge() end,
					},
					gossip = {
						type = "toggle",
						name = "NPC Gossip",
						desc = "Disable if you have any errors with gossip-related add-ons.",
						get = function() return VerisimilarPl.db.char.mergeWithGossipInterface end,
						set = function(info, value) VerisimilarPl.db.char.mergeWithGossipInterface=value;VerisimilarPl:UpdateGossipInterfaceMerge() end,
					},
					loot = {
						type = "toggle",
						name = "Loot panel",
						desc = "Disable if you have any errors with loot-related add-ons. There is no alternative to self currently, so don't disable it.",
						get = function() return VerisimilarPl.db.char.mergeWithLootInterface end,
						set = function(info, value) VerisimilarPl.db.char.mergeWithLootInterface=value;VerisimilarPl:UpdateLootInterfaceMerge() end,
					},
					bags = {
						type = "toggle",
						name = "Bags",
						desc = "Disable if you have any errors with bag-related add-ons.",
						get = function() return VerisimilarPl.db.char.mergeWithBagInterface end,
						set = function(info, value) VerisimilarPl.db.char.mergeWithBagInterface=value;VerisimilarPl:UpdateBagInterfaceMerge() end,
					},
				}
		},	
		minimap={
				name = "Minimap",
				type = "group",
				order = 2,
				guiInline = true,
				args = {
					envIcons = {
						type = "toggle",
						name = "Environment Icons",
						desc = "Show environment icons on the minimap",
						get = function() return VerisimilarPl.db.char.showEvnIconsOnMinimap end,
						set = function(info, value) VerisimilarPl.db.char.showEvnIconsOnMinimap=value;VerisimilarPl:UpdateMinimapIconsShowStatus()end,
					},
				}
		},	
		communication={
				name = "Communication",
				type = "group",
				order = 3,
				guiInline = true,
				args = {
					envIcons = {
						type = "toggle",
						name = "Use xtensionxtooltip2",
						desc = "Join the xtensionxtooltip2 channel in order to use public sessions",
						get = function() return VerisimilarPl.db.char.xtensionxtooltip2 end,
						set = function(info, value) VerisimilarPl.db.char.xtensionxtooltip2=value; VerisimilarPl:UpdateXToolSetting();end,
					},
				}
		},	
		charDetails={
				name = "Character Details",
				type = "group",
				order = 4,
				guiInline = true,
				args = {
					rank = {
						type = "input",
						name = "Rank",
						desc = "Your rank, it will appear before your name",
						get = function() return VerisimilarPl.db.char.rank end,
						set = function(info, value) VerisimilarPl.db.char.rank=value;VerisimilarPl:SendPlayerInfo();end,
					},
					firstName = {
						type = "input",
						name = "First name",
						desc = "Your character's first name",
						get = function() return VerisimilarPl.db.char.firstName end,
						set = function(info, value) VerisimilarPl.db.char.firstName=value;VerisimilarPl:SendPlayerInfo();end,
					},
					lastName = {
						type = "input",
						name = "Last name",
						desc = "Your character's last name",
						get = function() return VerisimilarPl.db.char.lastName end,
						set = function(info, value) VerisimilarPl.db.char.lastName=value;VerisimilarPl:SendPlayerInfo();end,
					},
					nickName = {
						type = "input",
						name = "Nickname",
						desc = "Your 'nickname'",
						get = function() return VerisimilarPl.db.char.nickName end,
						set = function(info, value) VerisimilarPl.db.char.rank=nickName;VerisimilarPl:SendPlayerInfo();end,
					},
					title = {
						type = "input",
						name = "Title",
						desc = "Your title, it will appear last (ie, 'The Great')",
						get = function() return VerisimilarPl.db.char.title end,
						set = function(info, value) VerisimilarPl.db.char.title=value;VerisimilarPl:SendPlayerInfo();end,
					},
					race = {
						type = "input",
						name = "Race",
						desc = "Your race. Can be a player-race, or a custom. Remember to capitalize the first letter!",
						get = function() return VerisimilarPl.db.char.race end,
						set = function(info, value) VerisimilarPl.db.char.race=value;VerisimilarPl:SendPlayerInfo();end,
					},
					class = {
						type = "input",
						name = "Class",
						desc = "Your class. Can be a player-class, or a custom. Remember to capitalize the first letter!",
						get = function() return VerisimilarPl.db.char.class end,
						set = function(info, value) VerisimilarPl.db.char.class=value;VerisimilarPl:SendPlayerInfo();end,
					},
				}
		},	
    },
}

local Tourist=LibStub("LibTourist-3.0");

function VerisimilarPl:OnInitialize()
    -- Called when the addon is loaded
	self.db = LibStub("AceDB-3.0"):New("VerisimilarPlDB",defaults);
	LibStub("AceConfig-3.0"):RegisterOptionsTable("VerisimilarPl", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("VerisimilarPl", "Verisimilar")
	self:RegisterChatCommand("verisimilarpl", "ToggleMainWindow")
    self:RegisterChatCommand("verisimilar", "ToggleMainWindow")
	self:RegisterChatCommand("vpl", "ToggleMainWindow")
	RegisterAddonMessagePrefix(VerisimilarPrefix)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	self:RegisterEvent("PLAYER_LEVEL_UP");
	self:RegisterEvent("PLAYER_LOGOUT");
	self.version=tonumber(GetAddOnMetadata("VerisimilarPlayer","Version"));
	
	self:RegisterEvent("CHAT_MSG_SAY","LocalSayingReceived","s");
	self:RegisterEvent("CHAT_MSG_TEXT_EMOTE","LocalSayingReceived","e");
	self:RegisterEvent("CHAT_MSG_EMOTE","LocalSayingReceived","t");
	self:RegisterEvent("CHAT_MSG_YELL","LocalSayingReceived","y");
	
	self:RegisterEvent("CHAT_MSG_CHANNEL","ChannelMessageRecieved");
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED","CombatLogEvent");
	self:RegisterEvent("ZONE_CHANGED","ZONE_CHANGED_NEW_AREA");
	self:RegisterEvent("ZONE_CHANGED_INDOORS","ZONE_CHANGED_NEW_AREA");
	self:RegisterEvent("CHAT_MSG_LOOT","InventoryUpdateEvent");
	
	self:RegisterEvent("PLAYER_TARGET_CHANGED","ChangedTargetEvent")
	self:SecureHookScript(TargetFrame, "OnClick", "TargetClicked")
	
	self:RegisterEvent("MINIMAP_UPDATE_ZOOM");
	--[[local updateLog=function(event) self:QuestLog_OnEvent(nil,event) end
	self:RegisterEvent("QUEST_ACCEPTED",updateLog);
	self:RegisterEvent("UNIT_QUEST_LOG_CHANGED",updateLog);]]
	
	--self:RegisterEvent("GOSSIP_CLOSED");
	GossipFrame:HookScript("OnHide", self.GossipFrameHiden)

	self:UpdateGossipInterfaceMerge();
	QuestFrame:HookScript("OnHide", self.QuestFrameHiden)
	self:UpdateQuestInterfaceMerge();
	self:UpdateLootInterfaceMerge();
	self:UpdateBagInterfaceMerge();
	--self:Hook("ChatFrame_OnEvent",true);
	
	
	
	
	self:RegisterComm(VerisimilarPrefix);
	self:InitializeInterface();
	self:ScheduleRepeatingTimer("UpdateStubsVisibility", 0.3);
	
	SetMapToCurrentZone();
	self.currentZone=GetCurrentMapAreaID();
	self.currentLevel=GetCurrentMapDungeonLevel();
	self:UpdateMinimapIconsShowStatus();
	self:ScheduleRepeatingTimer("UpdateAggroList", 10 , 10);
	self:ScheduleRepeatingTimer("CommUpkeep", 3 , 3 );
	for id,sessionInfo in pairs(self.db.char.savedSessionInfo) do
		self:AddSession(sessionInfo)
	end
	
	self:ScheduleTimer("UpdateXToolSetting",20);
end

function VerisimilarPl:OnEnable()
    -- Called when the addon is enabled
	
end

function VerisimilarPl:OnDisable()
    -- Called when the addon is disabled
end

function VerisimilarPl:PLAYER_LOGOUT()
	
	
end

function VerisimilarPl:AddSession(sessionStub)
	local sessionList=VerisimilarPl.sessions;
	local localID=sessionStub.gm.."_"..sessionStub.id;
    if(sessionList[localID])then
		return;
	end
	session={};
	session.name=sessionStub.n;
	session.id=sessionStub.id;
	session.gm=sessionStub.gm;
	session.channel="";
	session.connected=false;
	session.sendSay=false;
	session.password=sessionStub.password or "";
	session.stubs={};
	--session.stubData={};
	
	
	
	sessionList[localID]=session;
	
	VerisimilarPl:SessionListUpdated();
end


function VerisimilarPl:RemoveSession(session)

	local sessionList=VerisimilarPl.sessions;
	if(session.connected)then
		self:DisconnectFromSession(session)
	end
	session.stubs=nil --LUA does Mark and Sweep for garbage collection, but I think it's good practice to eliminate circular connections.
	sessionList[session.gm.."_"..session.id]=nil;
	VerisimilarPl:SessionListUpdated();
end

function VerisimilarPl:ConnectToSession(session)
	session.connected=true;
	if(session.channel~="GUILD" and session.channel~="WHISPER" and session.channel~="RAID" and session.channel~="xtensionxtooltip2")then
		JoinTemporaryChannel(session.channel);
	end
	VerisimilarPl:SendPlayerInfo(session);
	
	
end

function VerisimilarPl:DisconnectFromSession(session)
	
	
	for _,stub in pairs(session.stubs)do
		self:DisableStub(stub);
	end
	
	session.connected=false;
	if(session.channel~="GUILD" and session.channel~="WHISPER" and session.channel~="RAID" and session.channel~="xtensionxtooltip2")then
		self:LeaveChannel(session.channel)
	end
	session.channel="";
end

function VerisimilarPl:AddStubData(session,stubInfo)
	
	if(not session.stubData[stubInfo.id])then
		session.stubData[stubInfo.id]={sessionName=session.name, id=stubInfo.id, version=""};
	end
	
	local stubData=session.stubData[stubInfo.id];
	if(stubData.version~=stubInfo.v)then
		stubData.version=stubInfo.v;
		if(stubInfo.t=="N")then
			VerisimilarPl:AddNPCStubData(stubData,stubInfo);
		elseif(stubInfo.t=="Q")then
			VerisimilarPl:AddQuestStubData(stubData,stubInfo);
		elseif(stubInfo.t=="I")then
			VerisimilarPl:AddItemStubData(stubData,stubInfo);
		elseif(stubInfo.t=="M")then
			VerisimilarPl:AddMobStubData(stubData,stubInfo);
		elseif(stubInfo.t=="A")then
			VerisimilarPl:AddAreaStubData(stubData,stubInfo);
		end
		if(session.stubs[stubData.id])then
			session.stubs[stubData.id].initialize=true;
		end
	end
	
end

function VerisimilarPl:EnableStub(session,stubID,GMVersion)
	if(not session.stubs[stubID])then
		session.stubs[stubID]={id=stubID,session=session,GMVersion=""};
	end
	local stub=session.stubs[stubID];
	if(stub.enabled==false or stub.GMVersion~=GMVersion)then
		stub.GMVersion=GMVersion;
		stub.enabled=true;
		stub.initialize=true;
	end
	
	
end

function VerisimilarPl:InitializeStub(stub)
	if(stub.initialize)then
		if(stub.type=="NPC")then
			VerisimilarPl:InitializeNPCStub(stub);
		elseif(stub.type=="Quest")then
			VerisimilarPl:InitializeQuestStub(stub);
		elseif(stub.type=="Item")then
			VerisimilarPl:InitializeItemStub(stub);
		elseif(stub.type=="Mob")then
			VerisimilarPl:InitializeMobStub(stub);
		elseif(stub.type=="Area")then
			VerisimilarPl:InitializeAreaStub(stub);
		end
		stub.initialize=false;
	end
end

function VerisimilarPl:DisableStub(stub)
	if(stub)then
		stub.enabled=false;
	
		if(stub.type)then
			if(stub.type=="NPC")then
				VerisimilarPl:DisableNPCStub(stub);
			elseif(stub.type=="Quest")then
				VerisimilarPl:DisableQuestStub(stub);
			elseif(stub.type=="Item")then
				VerisimilarPl:DisableItemStub(stub);
			elseif(stub.type=="Mob")then
				VerisimilarPl:DisableMobStub(stub);
			elseif(stub.type=="Area")then
				VerisimilarPl:DisableAreaStub(stub);
			end
		end
	end
	
end

function VerisimilarPl:SendPlayerInfo(session)
	local info={};
	info.r=UnitRace("player");
	_,info.c=UnitClass("player");
	info.l=UnitLevel("player");
	info.g=UnitSex("player");
	info.z=self.currentZone;
	info.ml=self.currentLevel;
	
	if(session)then
		self:SendSessionMessage(session,nil,"PLAYER_INFO",info);
	else
		for _,session in pairs(self.sessions)do
			if(session.connected)then
				self:SendSessionMessage(session,nil,"PLAYER_INFO",info);
			end
		end
	end
end

function VerisimilarPl:PLAYER_LEVEL_UP()
	for _,session in pairs(self.sessions)do
		if(session.connected)then
			self:SendSessionMessage(session,nil,"PLAYER_INFO",{l=UnitLevel("player")});
		end
	end
end

function VerisimilarPl:ZONE_CHANGED_NEW_AREA()
	local selectedMap=GetCurrentMapAreaID();
	local selectedLevel=GetCurrentMapDungeonLevel();
	SetMapToCurrentZone();
	local currZone=GetCurrentMapAreaID();
	local currLevel=GetCurrentMapDungeonLevel();
	SetMapByID(selectedMap);
	SetDungeonMapLevel(selectedLevel)
	
	if(VerisimilarPl.currentZone~=currZone or VerisimilarPl.currentLevel~=currLevel)then
		VerisimilarPl.currentZone=currZone;
		VerisimilarPl.currentLevel=currLevel;
		
		for _,session in pairs(self.sessions)do
			if(session.connected)then
				self:SendSessionMessage(session,nil,"PLAYER_INFO",{z=VerisimilarPl.currentZone,ml=VerisimilarPl.currentLevel});
			end
		end
		VerisimilarPl:UpdateStubsNewZone(VerisimilarPl.currentZone);
	end
	VerisimilarPl:SubzoneChangedEvent();
end


function VerisimilarPl:UpdateStubsNewZone(zone)
	for _,session in pairs(VerisimilarPl.sessions)do
		if(session.connected)then
			for _,stub in pairs(session.stubs)do
				if(stub.enabled and stub.type=="NPC" and stub.zone and stub.zone~=zone)then
					stub.visible=false
					VerisimilarPl:RemoveMinimapPoint(stub)
				end
				--[[if(stub.enabled and stub.type=="Area")then
					stub.inside=false
				end]]
			end
		end
	end
	--self:UpdateMinimapQuestPoints()
end

local raidStrings={}
local raidPetStrings={}

for i=1,40 do
	raidStrings[i]="raid"..i;
	raidPetStrings[i]="raidpet"..i
end

local partyStrings={}
local partyPetStrings={}

for i=1,4 do
	partyStrings[i]="party"..i;
	partyPetStrings[i]="partypet"..i
end

function VerisimilarPl:CombatLogEvent(...)
	local timestamp, event, hideCaster, sourceGUID,	sourceName,	sourceFlags, destGUID, destName=select(2,...)
	if(event=="UNIT_DIED" and VerisimilarPl.aggroList[destGUID])then
		local guid=strsub(destGUID,13);
		for _,session in pairs(VerisimilarPl.sessions)do
			if(VerisimilarPl:CheckKillObjective(session,destName) or VerisimilarPl:CheckLootableMobKill(session,destName,guid))then
				
				self:SendSessionMessage(session,nil,"EVENT_MOB_KILLED",{n=destName,g=guid});
			end
		end
	elseif(strfind(event,"_DAMAGE"))then
		
		local tag=false
		local raidMembers=GetNumRaidMembers()
		for i=1,raidMembers do
			if(UnitName(raidStrings[i])==sourceName or UnitName(raidPetStrings[i])==sourceName)then
				tag=true
				break;
			end
		end
		local partyMembers=GetNumPartyMembers()
		if(raidMembers==0)then
			for i=1,partyMembers do
				if(UnitName(partyStrings[i])==sourceName or UnitName(partyPetStrings[i])==sourceName)then
					tag=true
					break;
				end
			end
		end
		if(tag==true or sourceName==UnitName("player") or sourceName==UnitName("pet"))then
			VerisimilarPl.aggroList[destGUID]=0;
		end
	end
end

function VerisimilarPl:UpdateAggroList(interval) --Also, the quest watch list because I won't put another timer
	for i,_ in pairs(VerisimilarPl.aggroList) do
		VerisimilarPl.aggroList[i]=VerisimilarPl.aggroList[i]+interval;
		if(VerisimilarPl.aggroList[i]>60)then
			VerisimilarPl.aggroList[i]=nil;
		end
	end
	
	for i=1,#VerisimilarPl.questWatch do
		if(VerisimilarPl.questWatch[i] and VerisimilarPl.questWatch[i].watchTime~=nil)then
			VerisimilarPl.questWatch[i].currentTime=VerisimilarPl.questWatch[i].currentTime+interval
			if(VerisimilarPl.questWatch[i].currentTime>VerisimilarPl.questWatch[i].watchTime)then
				tremove(VerisimilarPl.questWatch,i);
				WatchFrame_Update();
			end
		end
	end
end

function VerisimilarPl:InventoryUpdateEvent(...)
	local lootString=select(2,...)
	if(strsub(lootString,1,4)=="You ")then
		local itemName=strmatch(lootString,"%[([^%[%]]*)%]")
		if(itemName==nil)then return end
		local amount=tonumber(strmatch(lootString,"x(%d+)%.$"))
		if(amount==nil)then amount=1 end
		for _,session in pairs(VerisimilarPl.sessions)do
			if(VerisimilarPl:CheckItemObjective(session,itemName))then
				self:SendSessionMessage(session,nil,"EVENT_GAINED_ITEM",{n=itemName,a=GetItemCount(itemName, true)+amount});
				
			end
		end
	end
end

function VerisimilarPl:SubzoneChangedEvent(...)
	local subzone=GetMinimapZoneText();
	for _,session in pairs(VerisimilarPl.sessions)do
		if(VerisimilarPl:CheckSubzoneObjective(session,subzone))then
			self:SendSessionMessage(session,nil,"EVENT_SUBZONE",subzone);
		end
	end
end

function VerisimilarPl:ChangedTargetEvent(...)
	if(UnitIsDead("target"))then
		--VerisimilarPl:LootTarget() --It just doesn't "feel" right.
	else
		VerisimilarPl:CheckGossipForName(UnitName("target"))
	end
end

function VerisimilarPl:TargetClicked(frame,button,down)
	if(button=="LeftButton")then
		if(UnitIsDead("target"))then
			VerisimilarPl:LootTarget()
		else
			VerisimilarPl:CheckGossipForName(UnitName("target"))
		end
	end
end

function VerisimilarPl:UpdateStubsVisibility(force)
	local x,y=GetPlayerMapPosition("player");
	local visibilityChanged=false;
	if((x==VerisimilarPl.lastPlayerPositionX and y==VerisimilarPl.lastPlayerPositionY) and not force)then return end;
	VPlEnvironmentList:Refresh();
	VerisimilarPl.lastPlayerPositionX=x;
	VerisimilarPl.lastPlayerPositionY=y;
	for _,session in pairs(VerisimilarPl.sessions)do
		if(session.connected)then
			for _,stub in pairs(session.stubs)do
				if(stub.enabled and stub.type=="NPC" and stub.exists)then
					--visibilityChanged=VerisimilarPl:CheckStubVisibility(stub,x,y);
				end
				if(stub.enabled and stub.type=="Area")then
					self:CheckArea(stub);
				end
			end
		end
	end
	if(visibilityChanged)then
		VerisimilarPl:EnviromentListUpdated();
	end
end

function VerisimilarPl:CheckStubVisibility(stub,x,y)
	local visibilityChanged=false;
	if(stub.zone==VerisimilarPl.currentZone and stub.level==VerisimilarPl.currentLevel and stub.icon)then
		local distance=VerisimilarPl:Distance(x,y,stub.coordX,stub.coordY);
		if(stub.visibleDistance>0)then
			if(distance<stub.visibleDistance and stub.visible==false)then
				stub.visible=true;
				visibilityChanged=true;
				if(stub.environmentIcon or not VerisimilarPl.db.char.mergeWithGossipInterface)then
					VerisimilarPl:AddMinimapPoint(stub);
				end
			elseif(distance>stub.visibleDistance and stub.visible==true)then
				stub.visible=false;
				visibilityChanged=true;
				if(stub.environmentIcon or not VerisimilarPl.db.char.mergeWithGossipInterface)then
					VerisimilarPl:RemoveMinimapPoint(stub);
				end
			end
		end
		if(stub.visible)then
			if(stub.actDistance>0)then
				if(distance<stub.actDistance and stub.actable==false)then
					stub.actable=true;
				elseif(distance>stub.actDistance and stub.actable==true)then
					stub.actable=false;
				end
			end
		end
	end
	return visibilityChanged;
end



function VerisimilarPl:UpdateXToolSetting()
	if(self.db.char.xtensionxtooltip2==true)then
		JoinTemporaryChannel("xtensionxtooltip2");
	else
		if((not FlagRSP) and (not flagRSP2) and ((not TRP2_GetConfigValueFor) or (TRP2_GetConfigValueFor and not TRP2_GetConfigValueFor("ChannelToUse")=="xtensionxtooltip2")))then
			LeaveChannelByName("xtensionxtooltip2");
		end
	end
	
end

function VerisimilarPl:LeaveChannel(channel)
	local leave=true;
	
	for _,session in pairs(self.sessions)do
		if(session.channel==channel and session.connected==true)then
			leave=false;
		end
	end
	
	if(VerisimilarGM)then
		for _,session in pairs(VerisimilarGM.db.global.sessions)do
			if(session:GetChannel()==channel and session:GetLocal()==false and session:IsEnabled()==true)then
				leave=false;
			end
		end
	end
	
	if(leave)then
		LeaveChannelByName(channel)
	end
end

local modeToDistance={s="sayDistance",e="sayDistance",t="sayDistance",y="yellDistance"}
function VerisimilarPl:LocalSayingReceived(mode,event,text,author)
	if(author==UnitName("player"))then
		local x,y=GetPlayerMapPosition("player");
		for _,session in pairs(self.sessions)do
			if(session.connected and session.sendSay)then
				local data={t=text,m=mode,n=""};
				for _,stub in pairs(session.stubs)do
					if(stub.enabled and stub.type=="NPC" and stub.captureSayings and stub.zone==self.currentZone and stub.level==self.currentLevel and self:Distance(x,y,stub.coordX,stub.coordY)<=stub[modeToDistance[mode]])then
						data.n=data.n..stub.id;
					end
				end
				if(data.n~="")then
					self:SendSessionMessage(session,nil,"PLAYER_SAYING",data);
				end
			end
		end	
	end
end

function VerisimilarPl:SubSpecialChars(text)
	local gender={'man','woman'};
	
	text=string.gsub(text,"%%fn",self.db.char.firstName);
    text=string.gsub(text,"%%ln",self.db.char.lastName);
	text=string.gsub(text,"%%rk",self.db.char.rank);
    text=string.gsub(text,"%%nn",self.db.char.nickName);
	text=string.gsub(text,"%%tl",self.db.char.title);
	text=string.gsub(text,"%%r",string.lower(self.db.char.race));
    text=string.gsub(text,"%%c",string.lower(self.db.char.class));
    text=string.gsub(text,"%%g",gender[UnitSex("player")]);
	
	return text
end

--/dump LibStub("LibTourist-3.0"):GetZoneYardSize("Dalaran")
function VerisimilarPl:Distance(x1,y1,x2,y2)
	--local xscale,yscale=Tourist:GetZoneYardSize(VerisimilarPl.currentZone)
	--if(xscale==nil)then return 100000 end
	local x=(x1-x2);
	local y=(y1-y2);
	return sqrt(x*x+y*y);
end

function VerisimilarPl:EncodeCoordinates(x,y)
	local c1,c2,c3,c4;
	x=tonumber(x);
	if(x)then
		x=floor(x*10000);
		c1=floor(x/100)+11;
		c2=floor(x%100)+11;
	end
	y=tonumber(y);
	if(y)then
		y=floor(y*10000);
		c3=floor(y/100)+11;
		c4=floor(y%100)+11;
	end
	return c3 and c4 and strchar(c1,c2,c3,c4) or strchar(c1,c2); --Seriously, Lua can be a little daft some times, though this must be because it's a native implementation...
end

function VerisimilarPl:DecodeCoordinates(codeString)
	local c1,c2,c3,c4=strbyte(codeString or "",1,4);
	local x,y;
	if(c1 and c2)then
		x=((c1-11)*100 + (c2-11))/10000;
	end
	if(c3 and c4)then
		y=((c3-11)*100 + (c3-11))/10000;
	end
	return x,y;
end

function VerisimilarPl:PrintDebug(...)
	if(VerisimilarPl.db.global.debugMode)then
		self:Print(...)
	end
end

function VerisimilarPl:SetDebugMode(switch)
	switch=switch and true or false;
	VerisimilarPl.db.global.debugMode=switch;
end
