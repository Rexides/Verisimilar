VerisimilarGM.NPCFuncs={}


function VerisimilarGM:InitializeNPC(NPC)
	local x,y=GetPlayerMapPosition("player");
	SetMapToCurrentZone();
	NPC.enabled=false
	NPC.name=UnitName("target") or ""
	NPC.zone=GetCurrentMapAreaID();
	NPC.level=GetCurrentMapDungeonLevel();
	NPC.coordX=x
	NPC.coordY=y
	NPC.sayDistance=0.03;
	NPC.yellDistance=0.1;
	NPC.visibleDistance=0.06;
	NPC.actDistance=0.02;
	NPC.icon="Ability_Ambush"
	NPC.environmentIcon=true
	NPC.targetTalk=1;
	NPC.captureSayings=true;
	NPC.gossipOptions={[0]={text="",gossip=""}}
	NPC.gossipScriptText="function(NPC,player,choice)\n    local gossip=choice;\n    local options={};\n    for i=1,NPC:GetNumGossipOptions() do\n        if(i~=choice)then\n            table.insert(options,{text=i,choice=i});\n        end\n    end\n    return gossip,options;\nend";
	NPC.gossipScript=nil
	NPC.existenceScriptText="function(NPC,player,exists)\n    return exists;\nend";
	NPC.existenceScript=nil
end

function VerisimilarGM:AssignNPCFuncs(NPC)

	for methodName,method in pairs(VerisimilarGM.CommonFuncs)do
		NPC[methodName]=method;
	end
	
	for methodName,method in pairs(VerisimilarGM.NPCFuncs)do
		NPC[methodName]=method;
	end
	
	NPC:SetGossipScript(NPC:GetGossipScript());
	NPC:SetExistenceScript(NPC:GetExistenceScript());
	if(NPC:IsEnabled())then
		NPC:Enable();
	end
end

function VerisimilarGM.NPCFuncs:InitializePlayer(player)
	player.elements[self.id]={
							exists=true;
							defaultGossip={};
							}
	
end

function VerisimilarGM.NPCFuncs:SendPlayerData(player)
	local playerData=player.elements[self.id];
	local session=self:GetSession();
	local NPCdata=player.elements[self.id];
	NPCdata.defaultGossip.text=0;
	NPCdata.defaultGossip.options={};
	self:SendNewDefaultGossip(player)
	NPCdata.exists=self:existenceScript(player,NPCdata.exists);
	if(not NPCdata.exists)then
		VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"NPC_EXISTENCE",false);
	end
end

function VerisimilarGM.NPCFuncs:GetStub(player)
	if(self.stub.v==self.version)then return self.stub end
	local session=self:GetSession();
	local stub={id=self.netID,
				t="N",
				v=self.version,
				n=self.name,
				z=self.zone,
				l=self.level,
				c=VerisimilarPl:EncodeCoordinates(self.coordX,self.coordY),
				sd=VerisimilarPl:EncodeCoordinates(self.sayDistance),
				yd=VerisimilarPl:EncodeCoordinates(self.yellDistance),
				--vd=VerisimilarPl:EncodeCoordinates(self.visibleDistance),
				--ad=VerisimilarPl:EncodeCoordinates(self.actDistance),
				--i=self.icon,
				--ei=self.environmentIcon,
				tt=self.targetTalk,
				cs=self.captureSayings,
				--gossipGreetingsText=self:GetOptionText(nil),
				};
	stub.g={};
	for i=0,#self.gossipOptions do
		tinsert(stub.g,self.gossipOptions[i].text);
		tinsert(stub.g,self.gossipOptions[i].gossip);
	end
	self.stub=stub;
	return stub;
end

function VerisimilarGM.NPCFuncs:GetName()
	return self.name
end

function VerisimilarGM.NPCFuncs:SetName(name)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(name and self.name~=name)then
		self:GenerateNewVersion()
		self.name=name;
	end
end

function VerisimilarGM.NPCFuncs:GetZone()
	return self.zone, self.level;
end

function VerisimilarGM.NPCFuncs:SetZone(zone,level)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	zone=tonumber(zone);
	level=tonumber(level)
	if(zone and level and (zone~=self.zone or level~=self.level))then
		self:GenerateNewVersion()
		self.zone=zone;
		self.level=level;
	end
end

function VerisimilarGM.NPCFuncs:GetCoords()
	return self.coordX,self.coordY;
end

function VerisimilarGM.NPCFuncs:SetCoords(x,y)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	x=tonumber(x);
	y=tonumber(y);
	if(x and y)then
		x=x<1 and x or x/100;
		y=y<1 and y or y/100;
		if(self.coordX~=x or self.coordY~=y)then
			self:GenerateNewVersion()
			self.coordX=x;
			self.coordY=y;
		end
	end
end

function VerisimilarGM.NPCFuncs:GetSayDistance()
	return self.sayDistance;
end

function VerisimilarGM.NPCFuncs:SetSayDistance(distance)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	distance=tonumber(distance)
	if(distance and self.sayDistance~=distance)then
		self:GenerateNewVersion()
		self.sayDistance=distance;
	end
end

function VerisimilarGM.NPCFuncs:GetYellDistance()
	return self.yellDistance;
end

function VerisimilarGM.NPCFuncs:SetYellDistance(distance)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	distance=tonumber(distance)
	if(distance and self.yellDistance~=distance)then
		self:GenerateNewVersion()
		self.yellDistance=distance;
	end
end

function VerisimilarGM.NPCFuncs:GetVisibleDistance()
	return self.visibleDistance;
end

function VerisimilarGM.NPCFuncs:SetVisibleDistance(distance)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	distance=tonumber(distance)
	if(distance and self.visibleDistance~=distance)then
		self:GenerateNewVersion()
		self.visibleDistance=distance;
	end
end

function VerisimilarGM.NPCFuncs:GetActDistance()
	return self.actDistance;
end

function VerisimilarGM.NPCFuncs:SetActDistance(distance)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	distance=tonumber(distance)
	if(distance and self.actDistance~=distance)then
		self:GenerateNewVersion()
		self.actDistance=distance;
	end
end

function VerisimilarGM.NPCFuncs:GetIcon()
	return self.icon;
end

function VerisimilarGM.NPCFuncs:SetIcon(icon)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(icon and self.icon~=icon)then
		self:GenerateNewVersion()
		self.icon=icon;
	end
end

local filterNPCSaying=function(player,session,NPC,message,data)
	return player.zone==NPC.zone and player.mapLevel==NPC.level and player.elements[NPC.id].exists;
end

function VerisimilarGM.NPCFuncs:Say(text,delay)
	if(text=="" or text==nil)then return end;
	if(delay==nil or delay==0)then
		VerisimilarGM:SendSessionMessage(filterNPCSaying,self:GetSession(),self,"NPC_SAY",text);
	else 
		VerisimilarGM:ScheduleTimer(function() self:Say(text) end,delay);
	end
		
	--ChatFrame_OnEvent(DEFAULT_CHAT_FRAME,"CHAT_MSG_MONSTER_SAY",message.text,self:GetName(),message.language,"","","",0,0,"",0,25,"");
end

function VerisimilarGM.NPCFuncs:Emote(text,delay)
	if(text=="" or text==nil)then return end;
	if(string.find(text,"%%s")==nil)then text="%s "..text; end
	if(delay==nil or delay==0)then
		VerisimilarGM:SendSessionMessage(filterNPCSaying,self:GetSession(),self,"NPC_EMOTE",text);
	else 
		VerisimilarGM:ScheduleTimer(function() self:Emote(text) end,delay);
	end
end

function VerisimilarGM.NPCFuncs:Yell(text,delay)
	if(text=="" or text==nil)then return end;
	if(delay==nil or delay==0)then
		VerisimilarGM:SendSessionMessage(filterNPCSaying,self:GetSession(),self,"NPC_YELL",text);
	else 
		VerisimilarGM:ScheduleTimer(function() self:Yell(text) end,delay);
	end
end

function VerisimilarGM.NPCFuncs:ExistsForPlayer(player)
	return player.elements[self.id].exists;
end

function VerisimilarGM.NPCFuncs:SetExistenceForPlayer(player,exists)
	exists=exists and true or false;
	if(player.elements[self.id].exists~=exists)then
		player.elements[self.id].exists=exists;
		if(self.enabled and self:GetSession():IsEnabled())then
			VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"NPC_EXISTENCE",player.elements[self.id].exists);
		end
	end	
end

function VerisimilarGM.NPCFuncs:GetGossipScript()
	return self.gossipScriptText;
end

function VerisimilarGM.NPCFuncs:SetGossipScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.gossipScriptText=scriptText;
	self.gossipScript=func();
	setfenv(self.gossipScript,self:GetSession().env);
end

function VerisimilarGM.NPCFuncs:GetExistenceScript()
	return self.existenceScriptText;
end

function VerisimilarGM.NPCFuncs:SetExistenceScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.existenceScriptText=scriptText;
	self.existenceScript=func();
	setfenv(self.existenceScript,self:GetSession().env);
end



function VerisimilarGM.NPCFuncs:GetOptionText(index)
	index=index or 0
	return self.gossipOptions[index] and self.gossipOptions[index].text;
end

function VerisimilarGM.NPCFuncs:SetOptionText(index,text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	index=index or 0
	if(self.gossipOptions[index] and text and self.gossipOptions[index].text~=text)then
		self:GenerateNewVersion()
		self.gossipOptions[index].text=text;
	end
end

function VerisimilarGM.NPCFuncs:GetOptionGossip(index)
	index=index or 0
	return self.gossipOptions[index] and self.gossipOptions[index].gossip;
end

function VerisimilarGM.NPCFuncs:SetOptionGossip(index,text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	
	index=index or 0
	if(self.gossipOptions[index] and text and self.gossipOptions[index].gossip~=text)then
		self:GenerateNewVersion()
		self.gossipOptions[index].gossip=text;
	end
end

function VerisimilarGM.NPCFuncs:AddOption()
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	tinsert(self.gossipOptions,{text="",gossip=""})
end

function VerisimilarGM.NPCFuncs:RemoveOption(index)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	tremove(self.gossipOptions,index);
end

function VerisimilarGM.NPCFuncs:GetNumGossipOptions()
	return #self.gossipOptions
end

function VerisimilarGM.NPCFuncs:HasEnvironmentIcon()
	return self.environmentIcon;
end

function VerisimilarGM.NPCFuncs:SetEnvironmentIcon(choice)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	choice=choice and true or false;
	if(self.environmentIcon~=choice)then
		self:GenerateNewVersion()
		self.environmentIcon=choice;
	end
end

function VerisimilarGM.NPCFuncs:IsTargetTalkable()
	return self.targetTalk;
end

function VerisimilarGM.NPCFuncs:SetTargetTalkable(choice)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	choice=tonumber(choice);
	if(choice~=nil and self.targetTalk~=choice)then
		self:GenerateNewVersion();
		self.targetTalk=choice;
	end
end

function VerisimilarGM.NPCFuncs:IsCapturingSayings()
	return self.captureSayings;
end

function VerisimilarGM.NPCFuncs:SetCaptureSayings(choice)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	choice=choice and true or false;
	if(self.captureSayings~=choice)then
		self:GenerateNewVersion()
		self.captureSayings=choice;
	end
end

function VerisimilarGM.NPCFuncs:GOSSIP_OPTION(player,choice)
	self:SendGossip(player,choice)
end

local checkOptions=function(options,newOptions)
	if(#options~=#newOptions)then
		return true;
	end
	
	for i=1,#options do
		if(options[i].text~=newOptions[i].text or options[i].choice~=newOptions[i].choice)then
			return true
		end
	end
	return false;
end

function VerisimilarGM.NPCFuncs:SendNewDefaultGossip(player)
	local session=self:GetSession();
	
	local NPCdata=player.elements[self.id];
	local gossipText,options=self:gossipScript(player,0);
	
	if(NPCdata.defaultGossip.text~=gossipText or checkOptions(NPCdata.defaultGossip.options,options))then
		NPCdata.defaultGossip.text=gossipText;
		NPCdata.defaultGossip.options=options;
		local data={t=NPCdata.defaultGossip.text}
		for i=1,#NPCdata.defaultGossip.options do
			tinsert(data,NPCdata.defaultGossip.options[i].text);
			tinsert(data,NPCdata.defaultGossip.options[i].choice);
		end
		VerisimilarGM:SendSessionMessage(player,session,self,"NPC_DEFAULT_GOSSIP",data);
	end
end

function VerisimilarGM.NPCFuncs:SendGossip(player,choice)
	local session=self:GetSession();
	local gossip,options=self:gossipScript(player,choice);
	local data={t=gossip,c=choice}
	for i=1,#options do
		tinsert(data,options[i].text);
		tinsert(data,options[i].choice);
	end
	VerisimilarGM:SendSessionMessage(player,session,self,"NPC_GOSSIP",data);
end

function VerisimilarGM.NPCFuncs:Event(player,event,parameter,arg1,arg2,arg3)
	if(event=="NEW_DEFAULT_GOSSIP")then
		if((parameter and parameter==self or parameter==self.id) or not parameter)then
			self:SendNewDefaultGossip(player);
		end
	end
	if(event=="UPDATE_EXISTENCE")then
		if((parameter and parameter==self or parameter==self.id) or not parameter)then
			local NPCData=player.elements[self.id];
			local newExistence=self:existenceScript(player,NPCData.exists);
			if(NPCData.exists~=newExistence)then
				NPCData.exists=newExistence;
				if(self.enabled and self:GetSession():IsEnabled())then
					VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"NPC_EXISTENCE",NPCData.exists);
				end
			end	
		end
	end
end
