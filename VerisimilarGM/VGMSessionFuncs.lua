VerisimilarGM.SessionFuncs={}

--Channels:"GUILD","RAID","xtensionxtooltip2","WHISPER"
function VerisimilarGM:NewSession(sessionName)
	if(sessionName=="")then
		return;
	end
	local sessionList=VerisimilarGM.db.global.sessions;
	if(sessionList[sessionName])then
			VerisimilarGM:Print("A session with that name already exists." );
			return;
		
	end
	if(strlen(sessionName)>60)then
			VerisimilarGM:Print("A session name cannot be longer than 40 characters" );
			return;
		
	end
    local session={};
	
	session.name=sessionName;
	session.version=VerisimilarGM.sessionVersion;
	--session.enabled=false; --We add this in assignfuncs
	--session.isLocal=true; --We add this in assignfuncs
	--session.keepPlayerData=true; --We add this in assignfuncs
	session.elType="Session";
	session.channel="WHISPER";
	session.elements={};
	--session.players={}; --We add this in assignfuncs
	session.password="";
	session.scripts={};
	session.welcomeMessage="";
	session.newPlayerScriptText="function(player)\n        local message=Session:GetWelcomeMessage()\n    Session:SendTextMessage(message,player)\nend";
	
	VerisimilarGM:GenerateSessionNetID(session)
	sessionList[session.name]=session;
	VerisimilarGM:AssignSessionFuncs(session);
	
	
	
	VerisimilarPl:AddSession({n=session.name,id=session.netID,gm=UnitName("player"),p=session.password})
	
	return session;
end

function VerisimilarGM:DeleteSession(session)
	local sessionList=self.db.global.sessions;
	
	
	session:Disable();
	VerisimilarGM:UnregisterSessionNetID(session)
	sessionList[session.name]=nil;

	
	for _,realm in pairs(VerisimilarGMDB.factionrealm)do
		realm.playerDataPerSession[session.name]=nil;
	end
	
	VerisimilarPl:RemoveSession(VerisimilarPl.sessions[UnitName("player").."_"..session.netID]);
	
	
end

function VerisimilarGM:UpdateSession(session)
	if(session.version<0.3)then
		session.version=0.3
	end
	if(session.version<1)then
		if(session.name=="Demo Session")then
			VerisimilarGM.db.global.sessions["Demo Session"]=VerisimilarDemoSession
			
		else
			session.Mobs={};
			if(not session.players)then
				session.players={};
			end
			for playerName, player in pairs(session.players) do
				player.items={};
			end
			
			for _,quest in pairs(session.Quests)do
				quest.acceptScriptText="function(Quest,player)\n\nend";
				quest.abaddonScriptText="function(Quest,player)\n\nend"
				local funcHeader
				local funcBody=strsub(quest.objectivesScriptText,54)
				quest.objectivesScriptText="function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n"..funcBody
				
				quest.returnToText="";
				funcHeader=strsub(quest.detailsScriptText,1,24)
				funcBody=strsub(quest.detailsScriptText,25)
				quest.detailsScriptText=funcHeader.."    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n"..funcBody
				
				funcHeader=strsub(quest.detailsScriptText,1,-6)
				funcBody=strsub(quest.detailsScriptText,-5)
				quest.detailsScriptText=funcHeader..",returnToText"..funcBody
				
				quest.questRewards={};
				for _,objective in pairs(quest.objectives)do
					objective.poix=0;
					objective.poiy=0;
				end
			end
			
			for _,npc in pairs(session.NPCs)do
				npc.targetTalk=true;
			end
			
			session.version=1;
		end
	end
	
	if(session.version<2)then
		
		local newQuestList={}
		for _,quest in pairs(session.Quests)do
			for i=1,#quest.objectives do
				local obj=quest.objectives[i]
				if(obj.event=="Item")then
					if(session.Items[obj.filter])then
						obj.filter=strsub(gsub(obj.filter,"[^%a%d_]",""),1,30)
					end
				end
			end
			
			for i=1,#quest.questRewards do
				if(quest.questRewards[i].id)then
					quest.questRewards[i].id=strsub(gsub(quest.questRewards[i].id,"[^%a%d_]",""),1,30)
				end
			end
			
			if(quest.previousQuest)then
				quest.previousQuest=strsub(gsub(quest.previousQuest,"[^%a%d_]",""),1,30)
			end
			if(quest.nextQuest)then
				quest.nextQuest=strsub(gsub(quest.nextQuest,"[^%a%d_]",""),1,30)
			end
			if(quest.starterId)then
				quest.starterId=strsub(gsub(quest.starterId,"[^%a%d_]",""),1,30)
			end
			if(quest.enderId)then
				quest.enderId=strsub(gsub(quest.enderId,"[^%a%d_]",""),1,30)
			end
			if(quest.specialItemId)then
				quest.specialItemId=strsub(gsub(quest.specialItemId,"[^%a%d_]",""),1,30)
			end
			quest.id=strsub(gsub(quest.id,"[^%a%d_]",""),1,30)
			newQuestList[quest.id]=quest;
		end
		session.Quests=newQuestList;
		
		local newItemList={}
		for _,item in pairs(session.Items)do
			item.id=strsub(gsub(item.id,"[^%a%d_]",""),1,30)
			newItemList[item.id]=item;
		end
		session.Items=newItemList;
		
		local newScriptList={}
		for _,script in pairs(session.Scripts)do
			script.id=strsub(gsub(script.id,"[^%a%d_]",""),1,30)
			newScriptList[script.id]=script;
		end
		session.Scripts=newScriptList;
		
		local newNPCList={}
		for _,npc in pairs(session.NPCs)do
			npc.id=strsub(gsub(npc.id,"[^%a%d_]",""),1,30)
			newNPCList[npc.id]=npc;
		end
		session.NPCs=newNPCList;
		
		local newMobList={}
		for _,mob in pairs(session.Mobs)do
			for i=1,#mob.lootTable do
				if(mob.lootTable[i].item)then
					mob.lootTable[i].item=strsub(gsub(mob.lootTable[i].item,"[^%a%d_]",""),1,30)
				end
				if(mob.lootTable[i].quest)then
					mob.lootTable[i].quest=strsub(gsub(mob.lootTable[i].quest,"[^%a%d_]",""),1,30)
				end
			end
			mob.id=strsub(gsub(mob.id,"[^%a%d_]",""),1,30)
			newMobList[mob.id]=mob;
		end
		session.Mobs=newMobList;
	
		
		session.version=2;
		
	end
	if(session.version<3)then
		session.elType="Session";
		session.channel="WHISPER";
		VerisimilarGM:GenerateSessionNetID(session);
		session.elements={};
		session.scripts={};
		for __,item in pairs(session.Items)do
			item.usable=false;
			item.range=0;
			item.ooc=false;
			item.quests={};
			item.useScriptText=gsub(item.useScriptText,"targetName,targetGuid,targetDistance","targetName,targetDistance");
			item.useDescription="";
			item.flavorText="";
			item.range=item.range and 1 or 0;
			item.stub={v=""};
			for i=#item.tooltip,6 do
				tinsert(item.tooltip,{lText="",lr=1,lg=1,lb=1,rText="",rr=1,rg=1,rb=1})
			end
			local i=1;
			local id=item.id;
			while(session.elements[id])do
				i=i+1;
				id=item.id..i;
			end
			session.elements[id]=item;
		end
		session.Items=nil
		for __,quest in pairs(session.Quests)do
			quest.abandonScriptText=quest.abaddonScriptText; --Supid typo
			quest.abaddonScriptText=nil;
			
			quest.detailsScriptText=nil; --Begone, foul knave!
			for i=1,#quest.objectives do
				quest.objectives[i].level=0;
				quest.objectives[i].zone=0;
				if(quest.objectives[i].event=="Subzone")then
					quest.objectives[i].event="Area";
					quest.objectives[i].filter[1]="";
				end
			end
			quest.starters={};
			if(quest.starterId)then
				quest.starters[quest.starterId]=true;
				quest.starterId=nil
			end
			quest.enders={};
			if(quest.enderId)then
				quest.enders[quest.enderId]=true;
				quest.enderId=nil
			end
			quest.previousQuests={};
			if(quest.previousQuest)then
				quest.previousQuests[quest.previousQuest]=true;
				quest.previousQuest=nil
			end
			
			quest.npcModelName="";
			quest.npcModelText="";
			quest.stub={v=""};
			local i=1;
			local id=quest.id;
			while(session.elements[id])do
				i=i+1;
				id=quest.id..i;
			end
			session.elements[id]=quest;
		end
		session.Quests=nil
		for __,mob in pairs(session.Mobs)do
			mob.stub={v=""};
			local i=1;
			local id=mob.id;
			while(session.elements[id])do
				i=i+1;
				id=mob.id..i;
			end
			session.elements[id]=mob;
		end
		session.Mobs=nil
		for __,npc in pairs(session.NPCs)do
			npc.stub={v=""};
			npc.captureSayings=true;
			npc.gossipScriptText="function(NPC,player,choice)\n    local gossip=choice;\n    local options={};\n    for i=1,NPC:GetNumGossipOptions() do\n        if(i~=choice)then\n            table.insert(options,{text=i,choice=i});\n        end\n    end\n    return gossip,options;\nend";
			npc.existenceScriptText="function(NPC,player,exists)\n    return exists;\nend";
			npc.zone=0;
			npc.level=0;
			npc.targetTalk=npc.targetTalk and 1 or 0;
			npc.sayDistance=0.03;
			npc.emoteDistance=nil;
			npc.yellDistance=0.1;
			npc.visibleDistance=0.06;
			npc.actDistance=0.02;
			local i=1;
			local id=npc.id;
			while(session.elements[id])do
				i=i+1;
				id=npc.id..i;
			end
			session.elements[id]=npc;
		end
		session.NPCs=nil
		
		for __,script in pairs(session.Scripts)do
			tinsert(session.scripts,{name=script.id,scriptText=script.scriptText,period=script.period});
		end
		session.Scripts=nil

		for __,el in pairs(session.elements)do
			VerisimilarGM:GenerateElementNetID(el,session)
			VerisimilarGM.CommonFuncs.GenerateNewVersion(el)
		end
		for _,player in pairs(session.players)do
			player.elements={}
		end
		session.newPlayerScriptText="function(player)\n        local message=Session:GetWelcomeMessage()\n    Session:SendTextMessage(message,player)\nend";
		session.version=3;
	end
end

function VerisimilarGM:AssignSessionFuncs(session)
	
	
	if(self.db.factionrealm.playerDataPerSession[session.name]==nil)then
		self.db.factionrealm.playerDataPerSession[session.name]={}
	end
	session.players=self.db.factionrealm.playerDataPerSession[session.name]
	
	if(self.db.char.sessionStatus[session.name]==nil)then
		self.db.char.sessionStatus[session.name]={enabled=false,isLocal=true,keepPlayerData=true}
	end
	session.status=self.db.char.sessionStatus[session.name]
	
	for methodName,method in pairs(VerisimilarGM.SessionFuncs)do
		session[methodName]=method;
	end
	session.env={	Session=session,
					type=type,
					math=math,
					string=string,
					table=table,
					pairs=pairs,
				}
	for funcName, func in pairs(VerisimilarGM.GMFuncLib) do
		session.env[funcName]=func;
	end
	for id,element in pairs(session.elements)do
		session.env[id]=element;
		VerisimilarGM:RegisterElementNetID(element,session);
		if(element.elType=="NPC")then VerisimilarGM:AssignNPCFuncs(element);
		elseif(element.elType=="Quest")then VerisimilarGM:AssignQuestFuncs(element);
		elseif(element.elType=="Item")then VerisimilarGM:AssignItemFuncs(element);
		elseif(element.elType=="Mob")then VerisimilarGM:AssignMobFuncs(element);
		elseif(element.elType=="Area")then VerisimilarGM:AssignAreaFuncs(element);
		end
	end
	session:SetNewPlayerScript(session:GetNewPlayerScript());
	for i=1,session:GetNumScripts() do
		session:SetScriptText(i,session:GetScriptText(i));
	end
end


function VerisimilarGM.SessionFuncs:Enable()
	self.status.enabled=true;
	
	if(self.status.isLocal==false and self.channel~="GUILD" and self.channel~="WHISPER" and self.channel~="RAID" and self.channel~="xtensionxtooltip2")then
		JoinTemporaryChannel(self.channel);
	end
	
	local enabledList="";
	for _,element in pairs(self.elements)do
		if(element:IsEnabled())then
			for _,player in pairs(self.players)do
				if(player.connected)then
					player.elements[element.id].awaitingConcConfirm=true;
				end
			end
			enabledList=enabledList..element.netID..element.version;
		end
	end
	if(strlen(enabledList)>0)then
		VerisimilarGM:SendSessionMessage(nil,self,nil,"ENABLE",enabledList);
	end
	self:TransferStubs();
	
	for i=1,self:GetNumScripts() do
		if(self:GetScriptPeriod(i)>0)then
			self.scripts[i].timer=VerisimilarGM:ScheduleRepeatingTimer("PeriodicScriptExecution",self:GetScriptPeriod(i),self.scripts[i].func)
		end
	end
	VerisimilarGM:LogEvent(self.name.." was enabled.")
end

local leaveCustomChannel=function(session)
	if(session.channel~="GUILD" and session.channel~="WHISPER" and session.channel~="RAID" and session.channel~="xtensionxtooltip2")then
		VerisimilarPl:LeaveChannel(session.channel)
	end
end
function VerisimilarGM.SessionFuncs:Disable()
	self.status.enabled=false;
	
	VerisimilarGM:SendSessionMessage(nil,self,nil,"DISABLE",nil,nil,leaveCustomChannel,session);
	for i=1,self:GetNumScripts() do
		if(self.scripts[i].timer)then
			VerisimilarGM:CancelTimer(self.scripts[i].timer)
			self.scripts[i].timer=nil
		end
	end
	
	VerisimilarGM:LogEvent(self.name.." was disabled.")
end

function VerisimilarGM.SessionFuncs:IsEnabled()
	return self.status.enabled;
end


function VerisimilarGM.SessionFuncs:AddPlayer(playerName)
	local playerList=self.players;
	
	if(playerList[playerName])then
		playerList[playerName].connected=true
	else
		playerList[playerName]={name=playerName,elements={},connected=true,joinScriptHasRun=false};
		for __,element in pairs(self.elements)do
			element:InitializePlayer(playerList[playerName])
		end
	end
	VerisimilarGM:UpdateInterface();
	VerisimilarGM:LogEvent(playerName.." joined session "..self.name)
end

function VerisimilarGM.SessionFuncs:KickPlayer(player)
	local playerList=self.players;
	
	if(playerList[player.name]==nil)then
		return
	end
	VerisimilarGM:SendSessionMessage(player,self,nil,"KICK");
	playerList[player.name]=nil;
	VerisimilarGM:UpdateInterface();
	VerisimilarGM:LogEvent(player.name.." was kicked out of "..self.name)
end

function VerisimilarGM.SessionFuncs:SetLocal(choice)
	if(choice)then
		self.status.isLocal=true;
		for _,player in pairs(self.players)do
			if(player.name~=UnitName("player"))then
				self:DISCONNECT(player);
				VerisimilarGM:SendSessionMessage(player,self,nil,"KICK");
			end
		end
		VerisimilarGM:UpdateInterface();
	else
		self.status.isLocal=false;
	end
end

function VerisimilarGM.SessionFuncs:GetLocal()
	return self.status.isLocal;
end

function VerisimilarGM.SessionFuncs:NewNPC(NPCId)
	if(VerisimilarGM:EnforceIDNamingRules(NPCId)==false)then return end
	if(self.elements[NPCId])then
		VerisimilarGM:Print("An element with that Id already exists");
		return
	end
	
	local NPC={	id=NPCId,
				elType="NPC",
				stub={v=""},
				sessionName=self.name};
	
	VerisimilarGM:InitializeNPC(NPC);
	VerisimilarGM:AssignNPCFuncs(NPC);
	for _,player in pairs(self.players)do
		NPC:InitializePlayer(player);
	end
	NPC:GenerateNewVersion();
	VerisimilarGM:GenerateElementNetID(NPC,self);
	self.env[NPC.id]=NPC;
	self.elements[NPCId]=NPC;
	VerisimilarGM:LogEvent("NPC "..NPC.id.." added to "..self.name)
	return NPC
end

function VerisimilarGM.SessionFuncs:NewItem(ItemId)
	if(VerisimilarGM:EnforceIDNamingRules(ItemId)==false)then return end
	if(self.elements[ItemId])then
		VerisimilarGM:Print("An element with that Id already exists");
		return
	end
	local Item={	id=ItemId,
				elType="Item",
				stub={v=""},
				sessionName=self.name};
	
	VerisimilarGM:InitializeItem(Item);
	VerisimilarGM:AssignItemFuncs(Item);
	for _,player in pairs(self.players)do
		Item:InitializePlayer(player);
	end
	Item:GenerateNewVersion();
	VerisimilarGM:GenerateElementNetID(Item,self)
	self.env[Item.id]=Item;
	self.elements[ItemId]=Item;
	VerisimilarGM:LogEvent("Item "..Item.id.." added to "..self.name)
	return Item
end

function VerisimilarGM.SessionFuncs:NewQuest(QuestId)
	if(VerisimilarGM:EnforceIDNamingRules(QuestId)==false)then return end
	if(self.elements[QuestId])then
		VerisimilarGM:Print("An element with that Id already exists");
		return
	end
	
	local Quest={	id=QuestId,
					elType="Quest",
					stub={v=""},
					sessionName=self.name};
	
	VerisimilarGM:InitializeQuest(Quest);
	VerisimilarGM:AssignQuestFuncs(Quest);
	for _,player in pairs(self.players)do
		Quest:InitializePlayer(player);
	end
	Quest:GenerateNewVersion();
	VerisimilarGM:GenerateElementNetID(Quest,self);
	self.env[Quest.id]=Quest;
	self.elements[QuestId]=Quest
	VerisimilarGM:LogEvent("Quest "..Quest.id.." added to "..self.name)
	return Quest;
end

function VerisimilarGM.SessionFuncs:NewMob(MobId)
	if(VerisimilarGM:EnforceIDNamingRules(MobId)==false)then return end
	if(self.elements[MobId])then
		VerisimilarGM:Print("An element with that Id already exists");
		return
	end
	local Mob=	{	id=MobId,
					elType="Mob",
					stub={v=""},
					sessionName=self.name};
	
	VerisimilarGM:InitializeMob(Mob);
	VerisimilarGM:AssignMobFuncs(Mob);
	for _,player in pairs(self.players)do
		Mob:InitializePlayer(player);
	end
	Mob:GenerateNewVersion();
	VerisimilarGM:GenerateElementNetID(Mob,self)
	self.env[Mob.id]=Mob;
	self.elements[MobId]=Mob;
	VerisimilarGM:LogEvent("Mob "..Mob.id.." added to "..self.name)
	return Mob;
end

function VerisimilarGM.SessionFuncs:NewArea(AreaId)
	if(VerisimilarGM:EnforceIDNamingRules(AreaId)==false)then return end
	if(self.elements[AreaId])then
		VerisimilarGM:Print("An element with that Id already exists");
		return
	end
	local Area=	{	id=AreaId,
					elType="Area",
					stub={v=""},
					sessionName=self.name};
	
	VerisimilarGM:InitializeArea(Area);
	VerisimilarGM:AssignAreaFuncs(Area);
	for _,player in pairs(self.players)do
		Area:InitializePlayer(player);
	end
	Area:GenerateNewVersion();
	VerisimilarGM:GenerateElementNetID(Area,self)
	self.env[Area.id]=Area;
	self.elements[AreaId]=Area;
	VerisimilarGM:LogEvent("Area "..Area.id.." added to "..self.name)
	return Area;
end

function VerisimilarGM.SessionFuncs:GetElementFromNetID(netID)
	for __,element in pairs(self.elements)do
		if(element.netID==netID)then
			return element;
		end
	end
end

local genderTable = { "neuter or unknown", "male", "female" };
function VerisimilarGM.SessionFuncs:PLAYER_INFO(player,info)
	player.class=info.c or player.class;
	player.level=info.l or player.level;
	player.race=info.r or player.race;
	player.gender=genderTable[info.g] or player.gender;
	player.zone=info.z or player.zone;
	player.mapLevel=info.ml or player.mapLevel;
	VerisimilarGM:UpdateInterface();
end

function VerisimilarGM.SessionFuncs:DeleteElement(element)
	if(element:IsEnabled())then element:Disable() end
	self.elements[element.id]=nil;
	for _,player in pairs(self.players)do
		player.elements[element.id]=nil;
	end
	VerisimilarGM:UnregisterElementNetID(element,self)
	self.env[element.id]=nil;
end

function  VerisimilarGM.SessionFuncs:EVENT_GAINED_ITEM(player,itemInfo)
	self:Event(player,"Item",itemInfo.n,itemInfo.a);
end

function  VerisimilarGM.SessionFuncs:EVENT_MOB_KILLED(player,mobInfo)
	self:Event(player,"Kill",mobInfo.n,mobInfo.g);
end

function  VerisimilarGM.SessionFuncs:EVENT_SUBZONE(player,subzone)
	self:Event(player,"Subzone",subzone);
end

function VerisimilarGM.SessionFuncs:Event(player,event,parameter,arg1,arg2,arg3)
	for _,element in pairs(self.elements)do
		element:Event(player,event,parameter,arg1,arg2,arg3);
	end
	VerisimilarGM:LogEvent("Event from player "..player.name..":"..event..", parameter:"..parameter)
end

function VerisimilarGM.SessionFuncs:PLAYER_SAYING(player,data)
	for i=1,strlen(data.n) do
		local npc=self:GetElementFromNetID(strsub(data.n,i,i));
		if(npc and npc.enabled and npc.elType=="NPC")then
			VerisimilarGM:AddPlayerSaying(npc,player,data.m,data.t);
		end
	end
end

function VerisimilarGM.SessionFuncs:SetChannel(chanName)
	if(self:IsEnabled())then return end
	self.channel=chanName;
end

function VerisimilarGM.SessionFuncs:GetChannel(chanName)
	return self.channel;
end

function VerisimilarGM.SessionFuncs:SendNPCMessageToPlayer(NPCname,text,mode,player)
	if(text=="" or text==nil)then return end;
	if(mode=="emote" and string.find(text,"%%s")==nil)then text="%s "..text; end
	local message={
					t="saying",
					id=nil,
					name=NPCname,
					sessionName=self.name,
					message=mode,
					language="",
					text=text};
	VerisimilarGM:SendMessage(message,player)
end

function VerisimilarGM.SessionFuncs:SendTextMessage(text,player)
	if(text=="" or text==nil)then return end;
	VerisimilarGM:SendSessionMessage(player,self,nil,"TEXT_MESSAGE",text,"BULK");
end

local EMC={} --Error Message to code

for i=1,#VerisimilarPl.ErrorMessages do
	EMC[VerisimilarPl.ErrorMessages[i] ]=strchar(i);
end

function VerisimilarGM.SessionFuncs:SendErrorMessage(text,player)
	if(text=="" or text==nil)then return end;
	
	if(EMC[text])then
		text=EMC[text];
	end
	VerisimilarGM:SendSessionMessage(player,self,nil,"ERROR_MESSAGE",text);
end

function VerisimilarGM.SessionFuncs:GetWelcomeMessage()
	return self.welcomeMessage;
end

function VerisimilarGM.SessionFuncs:SetWelcomeMessage(text)
	self.welcomeMessage=text;
end

function VerisimilarGM.SessionFuncs:GetPassword()
	return self.password;
end

function VerisimilarGM.SessionFuncs:SetPassword(text)
	self.password=text;
end

function VerisimilarGM.SessionFuncs:GetNewPlayerScript()
	return self.newPlayerScriptText;
end


function VerisimilarGM.SessionFuncs:SetNewPlayerScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.newPlayerScriptText=scriptText;
	self.newPlayerScript=func();
	setfenv(self.newPlayerScript,self.env);
end

function VerisimilarGM.SessionFuncs:GetNumScripts()
	return #self.scripts;
end
function VerisimilarGM.SessionFuncs:AddScript()
	tinsert(self.scripts,{name="",period=0});
	self:SetScriptText(#self.scripts,"function()\n \nend");
end

function VerisimilarGM.SessionFuncs:RemoveScript(index)
	tremove(self.scripts,index);
end

function VerisimilarGM.SessionFuncs:GetScriptName(index)
	return self.scripts[index] and self.scripts[index].name;
end

function VerisimilarGM.SessionFuncs:SetScriptName(index,name)
	if(self.scripts[index] and name and VerisimilarGM:EnforceIDNamingRules(name))then
		self.env[self.scripts[index].name]=nil;
		self.scripts[index].name=name;
		self.env[self.scripts[index].name]=self.scripts[index].func;
	end
end

function VerisimilarGM.SessionFuncs:GetScriptText(index)
	return self.scripts[index] and self.scripts[index].scriptText;
end

function VerisimilarGM.SessionFuncs:SetScriptText(index,scriptText)
	if(self.scripts[index] and scriptText)then
		local func,message=loadstring("return "..scriptText);
		assert(func~=nil,message);
		self.scripts[index].scriptText=scriptText;
		self.scripts[index].func=func();
		setfenv(self.scripts[index].func,self.env);
		self.env[self.scripts[index].name]=self.scripts[index].func;
	end
end

function VerisimilarGM.SessionFuncs:GetScriptPeriod(index)
	return self.scripts[index] and self.scripts[index].period;
end

function VerisimilarGM.SessionFuncs:SetScriptPeriod(index,period)
	period=tonumber(period) or 0;
	if(self.scripts[index] and period)then
		self.scripts[index].period=period;
	end
end

function VerisimilarGM:PeriodicScriptExecution(func)
	func();
end

function VerisimilarGM.SessionFuncs:DISCONNECT(player)
	local playerName=player.name
	if(self.status.keepPlayerData)then
		player.connected=false;
	else
		player=nil;
	end
	VerisimilarGM:UpdateInterface();
	VerisimilarGM:LogEvent("Player "..playerName.." disconnected from "..self.name)
end

function VerisimilarGM.SessionFuncs:CACHED_STUBS(player,stubList)
	for _,elementData in pairs(player.elements)do
		elementData.version="";
	end
	for i=1,strlen(stubList),3 do
		local element=self:GetElementFromNetID(strsub(stubList,i,i));
		if(element)then
			player.elements[element.id].version=strsub(stubList,i+1,i+2);
		end
	end
	
	player.stubTransferPending=true;
	local enabledList="";
	for _,element in pairs(self.elements)do
		if(element:IsEnabled())then
			player.elements[element.id].awaitingConcConfirm=true;
			enabledList=enabledList..element.netID..element.version;
		end
	end
	if(strlen(enabledList)>0)then
		VerisimilarGM:SendSessionMessage(player,self,nil,"ENABLE",enabledList,"BULK");
	end
	self:TransferStubs();
end

function VerisimilarGM.SessionFuncs:CONCURRENT(player)
	if(player.joinScriptHasRun~=true)then
		self.newPlayerScript(player);
		player.joinScriptHasRun=true;
	end
	for __,el in pairs(self.elements)do
		if(player.elements[el.id].awaitingConcConfirm)then
			el:SendPlayerData(player);
			player.elements[el.id].awaitingConcConfirm=false;
		end
	end
end

function VerisimilarGM.SessionFuncs:TransferStubs()
	if(self:IsEnabled()==false)then return end
	if(self:GetChannel()=="WHISPER")then
		for _,player in pairs(self.players)do
			if(player.connected)then
				local stubList={};
				for id, elementData in pairs(player.elements)do
					local element=self.elements[id];
					if(element and element.version~=elementData.version)then
						
						tinsert(stubList,element:GetStub())
						elementData.version=element.version;
					end
				end
				if(#stubList>0)then
					local prio=nil;
					if(player.stubTransferPending)then
						prio="BULK";
					end
					VerisimilarGM:SendSessionMessage(player,self,nil,"STUBS",stubList,prio);
				end
			end
		end
	else
		--First, we send the elements that people who were already connected need
		local stubList={};
		for _,player in pairs(self.players)do
			if(player.connected and not player.stubTransferPending)then
				for id, elementData in pairs(player.elements)do
					local element=self.elements[id];
					if(element and element.version~=elementData.version)then
						local insert=true;
						for i=1,#stubList do
							if(stubList[i].id==element.netID)then
								insert=false;
								break;
							end
						end
						if(insert)then
							tinsert(stubList,element:GetStub());
						end
						elementData.version=element.version;
					end
				end
			end
		end
		
		if(#stubList>0)then
			VerisimilarGM:SendSessionMessage(nil,self,nil,"STUBS",stubList);
		end
		
		--And now we send any extra that people who just connected need
		local extraStubList={}
		local nPendingTransfers=0;
		local pendingPlayer=nil;
		for _,player in pairs(self.players)do
			if(player.connected and player.stubTransferPending)then
				pendingPlayer=player;
				nPendingTransfers=nPendingTransfers+1;
				for id, elementData in pairs(player.elements)do
					local element=self.element[id];
					if(element and element.version~=elementData.version)then
						local insert=true;
						for i=1,#stubList do --This is correct, we need to check this list too
							if(stubList[i].id==element.netID)then
								insert=false;
								break;
							end
						end
						for i=1,#extraStubList do
							if(extraStubList[i].id==element.netID)then
								insert=false;
								break;
							end
						end
						if(insert)then
							tinsert(extraStubList,element:GetStub());
						end
						elementData.version=element.version;
					end
				end
			end
		end
		
		if(#extraStubList>0)then
			local player=nil;
			if(nPendingTransfers==1)then
				player=pendingPlayer;
			end
			VerisimilarGM:SendSessionMessage(player,self,nil,"STUBS",extraStubList,"BULK");
		end
	end
end


function VerisimilarGM:EnforceIDNamingRules(name)
	if(name==nil)then return false end
	if(strlen(name)>30)then
		message("IDs must be no longer than 30 characters")
		return false
	else
		if(strfind(name,"^[%a][%a%d_]*$")==nil)then
			message("IDs must start with a letter, and may contain only letters, numbers, and the underscore ('_'). No spaces or punctuation allowed")
			return false
		else
			return true
		end
	end
end

