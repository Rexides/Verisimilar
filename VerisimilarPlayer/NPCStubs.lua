
VerisimilarPl.NPCName=nil;
VerisimilarPl.currentGossipStub=nil;
VerisimilarPl.gossipOptions={};
VerisimilarPl.availableQuests={};
VerisimilarPl.activeQuests={};

function VerisimilarPl:UpdateGossipInterfaceMerge()
	if(VerisimilarPl.db.char.mergeWithGossipInterface)then
		self:RawHook("GetGossipActiveQuests",true);
		self:RawHook("GetGossipAvailableQuests",true);
		self:RawHook("GetGossipOptions",true);
		self:RawHook("GetGossipText",true);
		self:RawHook("SelectGossipActiveQuest",true);
		self:RawHook("SelectGossipAvailableQuest",true);
		self:RawHook("SelectGossipOption",true);
		self:RawHook("GetAvailableQuestInfo",true);
		self:RawHook("GetNumGossipAvailableQuests",true);
		self:RawHook("GetNumGossipActiveQuests",true);
		self:RawHook("GetNumGossipOptions",true);
		for _,session in pairs(VerisimilarPl.sessions)do
			if(session.connected)then
				for _,stub in pairs(session.stubs)do
					if(stub.enabled and stub.type=="NPC" and stub.visible and not stub.environmentIcon)then
						VerisimilarPl:RemoveMinimapPoint(stub);
					end
				end
			end
		end	
	else
		self:Unhook("GetGossipActiveQuests",true);
		self:Unhook("GetGossipAvailableQuests",true);
		self:Unhook("GetGossipOptions",true);
		self:Unhook("GetGossipText",true);
		self:Unhook("SelectGossipActiveQuest",true);
		self:Unhook("SelectGossipAvailableQuest",true);
		self:Unhook("SelectGossipOption",true);
		self:Unhook("GetAvailableQuestInfo",true);
		self:Unhook("GetNumGossipAvailableQuests",true);
		self:Unhook("GetNumGossipActiveQuests",true);
		self:Unhook("GetNumGossipOptions",true);
		for _,session in pairs(VerisimilarPl.sessions)do
			if(session.connected)then
				for _,stub in pairs(session.stubs)do
					if(stub.enabled and stub.type=="NPC" and stub.visible and not stub.environmentIcon)then
						VerisimilarPl:AddMinimapPoint(stub);
					end
				end
			end
		end
	end
	--VerisimilarPl:UpdateStubsVisibility(true)
end

function VerisimilarPl:AddNPCStubData(stubData,stubInfo)
	stubData.type="NPC";
	stubData.name=stubInfo.n;
	stubData.zone=stubInfo.z;
	stubData.level=stubInfo.l;
	stubData.coordX,stubData.coordY=self:DecodeCoordinates(stubInfo.c);
	stubData.sayDistance=self:DecodeCoordinates(stubInfo.sd);
	stubData.yellDistance=self:DecodeCoordinates(stubInfo.yd);
	--stubData.visibleDistance=self:DecodeCoordinates(stubInfo.vd);
	--stubData.actDistance=self:DecodeCoordinates(stubInfo.ad);
	stubData.icon=stubInfo.i;
	stubData.environmentIcon=stubInfo.ei;
	stubData.targetTalk=stubInfo.tt;
	stubData.captureSayings=stubInfo.cs;
	stubData.gossipData={}
	for i=0,#stubInfo.g/2-1 do
		print(i)
		stubData.gossipData[i]={};
		stubData.gossipData[i].text=stubInfo.g[(i*2)+1];
		stubData.gossipData[i].gossip=stubInfo.g[(i*2)+2];
	end
	testNPC=stubData
end

function VerisimilarPl:InitializeNPCStub(stub)
	stub.visible=false;
	stub.actable=false;
	stub.gossip=nil;
	stub.defaultGossip={text=0};
	stub.exists=true;
	local x,y=GetPlayerMapPosition("player");
	if(self:CheckStubVisibility(stub,x,y))then
		self:EnviromentListUpdated();
	end
	--self:UpdateMinimapQuestPoints()
end

function VerisimilarPl:DisableNPCStub(stub)
	VerisimilarPl:RemoveMinimapPoint(stub)
	self:EnviromentListUpdated();
	--self:UpdateMinimapQuestPoints()
end


function VerisimilarPl:NPCStubClicked(stub)
	HideUIPanel(GossipFrame);
	if(self.db.char.mergeWithGossipInterface)then
		if ( not GossipFrame:IsShown() ) then
				self.NPCName=stub.name;
				GossipFrameNpcNameText:SetText(self.NPCName);
				ShowUIPanel(GossipFrame);
		end
		GossipFrameUpdate();
		if(GossipFrameNpcNameText:GetText()==nil)then
			GossipFrameNpcNameText:SetText(self.NPCName);
		end
	else
		
	end
	
end

function VerisimilarPl:CheckGossipForName(name)
	if(name==nil)then return end
	for _,session in pairs(VerisimilarPl.sessions)do
		if(session.connected)then
			for _,stub in pairs(session.stubs)do
				if(stub.enabled and stub.type=="NPC" and stub.exists and stub.targetTalk>0 and stub.name==name and not UnitAffectingCombat("target"))then
					local close=CheckInteractDistance("target",3);
					local medium=CheckInteractDistance("target",1);
					--local far=not CheckInteractDistance("target",1);
					if(close or (stub.targetTalk==2 and medium) or stub.targetTalk==3)then
						HideUIPanel(GossipFrame);
						if(self.db.char.mergeWithGossipInterface)then
							if ( not GossipFrame:IsShown() ) then
									self.NPCName=name;
									GossipFrameNpcNameText:SetText(self.NPCName);
									ShowUIPanel(GossipFrame);
							end
							GossipFrameUpdate();
							if(GossipFrameNpcNameText:GetText()==nil)then
								GossipFrameNpcNameText:SetText(self.NPCName);
							end
							SetPortraitTexture(GossipFramePortrait, "target");
						else
							
						end
					end
					return
				end
			end
		end
	end
end

function VerisimilarPl:NPCSaying(session,message)
	local modeToRealMode={
							say="CHAT_MSG_MONSTER_SAY",
							emote="CHAT_MSG_MONSTER_EMOTE",
							yell="CHAT_MSG_MONSTER_YELL",
						}
	local stub=session.stubs[message.id];
	if(stub and stub.enabled and stub.type=="NPC" and stub.exists)then
		local plx,ply=GetPlayerMapPosition("player");
		local maxDistance;
		local event;
		if(message.message=="say")then
			maxDistance=stub.sayDistance;
		elseif(message.message=="emote")then
			maxDistance=stub.sayDistance;
		elseif(message.message=="yell")then
			maxDistance=stub.yellDistance;
		end
		
		if(VerisimilarPl:Distance(plx,ply,stub.coordX,stub.coordY)<maxDistance)then
			ChatFrame_OnEvent(DEFAULT_CHAT_FRAME,modeToRealMode[message.message],message.text,stub.name,message.language,"","","",0,0,"",0,25,"");
		end
	else
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME,modeToRealMode[message.message],message.text,message.name,message.language,"","","",0,0,"",0,25,"");
	end
end

function VerisimilarPl:NPC_SAY(stub,text)
	local plx,ply=GetPlayerMapPosition("player");
	if(self:Distance(plx,ply,stub.coordX,stub.coordY)<stub.sayDistance)then
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME,"CHAT_MSG_MONSTER_SAY",text,stub.name,"","","","",0,0,"",0,25,"");
	end
end

function VerisimilarPl:NPC_EMOTE(stub,text)
	local plx,ply=GetPlayerMapPosition("player");
	if(self:Distance(plx,ply,stub.coordX,stub.coordY)<stub.sayDistance)then
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME,"CHAT_MSG_MONSTER_EMOTE",text,stub.name,"","","","",0,0,"",0,25,"");
	end
end

function VerisimilarPl:NPC_YELL(stub,text)
	local plx,ply=GetPlayerMapPosition("player");
	if(self:Distance(plx,ply,stub.coordX,stub.coordY)<stub.yellDistance)then
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME,"CHAT_MSG_MONSTER_YELL",text,stub.name,"","","","",0,0,"",0,25,"");
	end
end

function VerisimilarPl:NPC_EXISTENCE(stub,exists)
	stub.exists=exists;
	if(exists)then
		self:AddMinimapPoint(stub)
	else
		self:RemoveMinimapPoint(stub)
	end
	VerisimilarPl:UpdateMinimapQuestIcons();
end

function VerisimilarPl:NPC_DEFAULT_GOSSIP(stub,gossip)
	stub.defaultGossip={};
	if(type(gossip.t)=="number")then
		stub.defaultGossip.text=stub.gossipData[gossip.t].gossip
	else
		stub.defaultGossip.text=gossip.t;
	end
	for i=1,#gossip/2 do
		local text=gossip[((i-1)*2)+1];
		stub.defaultGossip[i]={};
		if(type(text)=="number")then
			stub.defaultGossip[i].text=stub.gossipData[text].text;
		else
			stub.defaultGossip[i].text=text;
		end
		stub.defaultGossip[i].choice=gossip[((i-1)*2)+2];
	end
end


function VerisimilarPl:NPC_GOSSIP(stub,gossip)
	stub.gossip={};
	if(type(gossip.t)=="number")then
		stub.gossip.text=stub.gossipData[gossip.t].gossip
	else
		stub.gossip.text=gossip.t;
	end
	for i=1,#gossip/2 do
		local text=gossip[((i-1)*2)+1];
		stub.gossip[i]={};
		if(type(text)=="number")then
			stub.gossip[i].text=stub.gossipData[text].text;
		else
			stub.gossip[i].text=text;
		end
		stub.gossip[i].choice=gossip[((i-1)*2)+2];
	end
	if(gossip.c==0)then
		self.currentGossipStub=nil;
	else
		self.currentGossipStub=stub;
	end
	if(self.db.char.mergeWithGossipInterface)then
		if ( not GossipFrame:IsShown() or  (GossipFrame:IsShown() and UnitName("npc")~=stub.name)) then
			HideUIPanel(GossipFrame);
			self.NPCName=stub.name;
			GossipFrameNpcNameText:SetText(self.NPCName);
			ShowUIPanel(GossipFrame);
		end
		GossipFrameUpdate();
		if(GossipFrameNpcNameText:GetText()==nil)then
			GossipFrameNpcNameText:SetText(self.NPCName);
		end
		if(not UnitExists("npc") and stub.targetTalk and UnitName("target")==stub.name)then
			SetPortraitTexture(GossipFramePortrait, "target");
		end
	else
		self:Print(stub.name," says:",stub.gossipTable.text)
		for i=1,#stub.gossipTable.quests do
			self:Print("(Quest)",stub.gossipTable.quests[i].title);
		end
		for i=1,#stub.gossipTable.options do
			self:Print("(Say)",stub.gossipTable.options[i].text);
		end
	end

end

function VerisimilarPl:GossipFrameHiden()
	for _,session in pairs(VerisimilarPl.sessions)do
		for _,stub in pairs(session.stubs)do
			if(stub.enabled and stub.type=="NPC")then
				stub.gossip=nil;
			end
		end
	end
	VerisimilarPl.NPCName=nil;
	VerisimilarPl.currentGossipStub=nil;
	VerisimilarPl.gossipOptions={};
	VerisimilarPl.availableQuests={};
	VerisimilarPl.activeQuests={};
end

function VerisimilarPl:CreateActiveQuestsTable()
	local NPCName=UnitName("npc") or self.NPCName;
	self.activeQuests={};
	for _,session in pairs(self.sessions)do
		if(session.connected)then
			for _,questStub in pairs(session.stubs)do
				if(questStub.enabled and questStub.type=="Quest" and questStub.onQuest)then
					for enderId,_ in pairs(questStub.enders) do
						local NPCStub=session.stubs[enderId];
						if(NPCStub and NPCStub.enabled and NPCStub.type=="NPC" and NPCStub.name==NPCName and NPCStub.exists  and (NPCStub.visible or NPCStub.targetTalk))then
							tinsert(self.activeQuests,questStub);
						end	
					end
				end
			end
		end
	end
end

function VerisimilarPl:GetGossipActiveQuests()
	if(self.currentGossipStub)then return end
	local activeQuests=UnitExists("npc") and {self.hooks.GetGossipActiveQuests()} or {};
	local numEntries=self.hooks.GetNumGossipActiveQuests()*4
	for i=1,numEntries,4 do
		if(activeQuests[i+2]==nil)then activeQuests[i+2]=false end
		if(activeQuests[i+3]==nil)then activeQuests[i+3]=false end
	end
	self:CreateActiveQuestsTable();
	for i=1,#self.activeQuests do
		tinsert(activeQuests,self.activeQuests[i].title);
		tinsert(activeQuests,self.activeQuests[i].level);
		tinsert(activeQuests,false);
		if(self.activeQuests[i].completed)then
			tinsert(activeQuests,1);
		else
			tinsert(activeQuests,false);
		end
	end
	return unpack(activeQuests);
end

function VerisimilarPl:CreateAvailableQuestsTable()
	local NPCName=UnitName("npc") or self.NPCName;
	self.availableQuests={};
	for _,session in pairs(self.sessions)do
		if(session.connected)then
			for _,questStub in pairs(session.stubs)do
				if(questStub.enabled and questStub.type=="Quest" and not questStub.onQuest and questStub.available and not questStub.finished)then
					for starterId,_ in pairs(questStub.starters)do
						local NPCStub=session.stubs[starterId];
						if(NPCStub and NPCStub.enabled and NPCStub.type=="NPC" and NPCStub.name==NPCName and NPCStub.exists  and (NPCStub.visible or NPCStub.targetTalk))then
							tinsert(self.availableQuests,questStub);
						end
					end					
				end
			end
		end
	end
end

function VerisimilarPl:GetGossipAvailableQuests()
	if(self.currentGossipStub)then return  end
	local availableQuests=UnitExists("npc") and {self.hooks.GetGossipAvailableQuests()} or {};
	local numEntries=self.hooks.GetNumGossipAvailableQuests()*5
	for i=1,numEntries,5 do
		if(availableQuests[i+2]==nil)then availableQuests[i+2]=false end
		if(availableQuests[i+3]==nil)then availableQuests[i+3]=false end
		if(availableQuests[i+4]==nil)then availableQuests[i+4]=false end
	end
	self:CreateAvailableQuestsTable();
	for i=1,#self.availableQuests do
		
		tinsert(availableQuests,self.availableQuests[i].title);
		tinsert(availableQuests,self.availableQuests[i].level);
		tinsert(availableQuests,false);
		tinsert(availableQuests,false);
		tinsert(availableQuests,false);
	end
	
	return unpack(availableQuests)
end

function VerisimilarPl:CreateGossipOptionsTable()
	local NPCName=UnitName("npc") or VerisimilarPl.NPCName;
	self.gossipOptions={};
	if(self.currentGossipStub)then
		local gossip=self.currentGossipStub.gossip or self.currentGossipStub.defaultGossip;
		for i=1,#gossip do
			tinsert(self.gossipOptions,{stub=self.currentGossipStub,text=gossip[i].text,choice=gossip[i].choice,lastClicked=0});
		end
	else
		for _,session in pairs(self.sessions)do
			if(session.connected)then
				for _,stub in pairs(session.stubs)do
					if(stub.enabled and stub.type=="NPC" and stub.name==NPCName and stub.exists and (stub.visible or stub.targetTalk))then
						local gossip=stub.gossip or stub.defaultGossip;
						if(stub.gossip)then
							for key, val in pairs(stub.gossip)do
								self:Print(key,val)
							end
						end
						for i=1,#gossip do
							tinsert(self.gossipOptions,{stub=stub,text=gossip[i].text,choice=gossip[i].choice,lastClicked=0})
						end
					end
				end
			end
		end
	end
	
end

function VerisimilarPl:GetGossipOptions()
	local gossipOptions={self.hooks.GetGossipOptions()};
	self:CreateGossipOptionsTable()
	for i=1,#self.gossipOptions do
		tinsert(gossipOptions,self.gossipOptions[i].text);
		tinsert(gossipOptions,"gossip");
	end
	
	
	return unpack(gossipOptions);
end

function VerisimilarPl:GetGossipText()
	local NPCName=UnitName("npc") or self.NPCName;
	if(self.currentGossipStub)then
		if(self.currentGossipStub.gossip)then
			return self:SubSpecialChars(self.currentGossipStub.gossip.text);
		else
			return self:SubSpecialChars(self.currentGossipStub.defaultGossip.text);
		end
	else
		local gossipText="";
		if(UnitExists("npc"))then
			gossipText=self.hooks.GetGossipText().."\n\n";
		end
		for _,session in pairs(self.sessions)do
			if(session.connected)then
				for _,stub in pairs(session.stubs)do
					if(stub.enabled and stub.type=="NPC" and stub.name==NPCName and stub.exists and (stub.visible or stub.targetTalk))then
						local gossip=stub.gossip or stub.defaultGossip;
						gossipText=gossipText..gossip.text.."\n\n";
					end
				end
			end
		end
		return self:SubSpecialChars(gossipText);
	end
end

function VerisimilarPl:SelectGossipActiveQuest(index)
	local numWoWQuests=self.hooks.GetNumGossipActiveQuests();
	if(index>numWoWQuests)then
		self:ShowQuestProgress(self.activeQuests[index-numWoWQuests]);
	else
		return self.hooks.SelectGossipActiveQuest(index);
	end
end

function VerisimilarPl:SelectGossipAvailableQuest(index)
	local numWoWQuests=self.hooks.GetNumGossipAvailableQuests();
	if(index>numWoWQuests)then
		self:ShowQuestDetails(self.availableQuests[index-numWoWQuests]);
	else
		return self.hooks.SelectGossipAvailableQuest(index);
	end
end

function VerisimilarPl:GetAvailableQuestInfo(index)
	--VerisimilarPl:Print(index)
	local numWoWQuests=self.hooks.GetNumGossipAvailableQuests();
	if(index>numWoWQuests)then
		return nil,nil,nil
	else
		local info={self.hooks.GetAvailableQuestInfo(index)}
		return info[1],info[2],info[3]
	end
end

function VerisimilarPl:SelectGossipOption(index)
	local numWoWOptions=self.hooks.GetNumGossipOptions();
	if(index>numWoWOptions)then
		VerisimilarPl:SendGossipOption(VerisimilarPl.gossipOptions[index-numWoWOptions]);
	else
		return self.hooks.SelectGossipOption(index);
	end
end

function VerisimilarPl:GetNumGossipAvailableQuests()
	if(self.currentGossipStub)then return 0 end
	self:CreateAvailableQuestsTable()
	return self.hooks.GetNumGossipAvailableQuests()+#self.availableQuests;
end

function VerisimilarPl:GetNumGossipActiveQuests()
	if(self.currentGossipStub)then return 0 end
	self:CreateActiveQuestsTable();
	return self.hooks.GetNumGossipActiveQuests()+#self.activeQuests;
end

function VerisimilarPl:GetNumGossipOptions()
	self:CreateGossipOptionsTable();
	return self.hooks.GetNumGossipOptions()+#self.gossipOptions;
end

function VerisimilarPl:SendGossipOption(option)
	self:Print(option.text,option.choice)
	local curTime=GetTime();
	if(option.lastClicked+3>curTime)then return end --Antispam measures
	option.lastClicked=curTime;
	self:SendSessionMessage(option.stub.session,option.stub,"GOSSIP_OPTION",option.choice);
end
