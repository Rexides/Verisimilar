VerisimilarGM.QuestFuncs={};

function VerisimilarGM:InitializeQuest(Quest)
	Quest.enabled=false;
	Quest.title="";
	Quest.level=1;
	Quest.category="Uncategorized";
	Quest.questDescription="";
	Quest.objectivesSummary="";
	Quest.progressText="";
	Quest.completionText="";
	Quest.returnToText="";
	Quest.specialItemId=nil;
	Quest.objectives={};
	Quest.events={};
	Quest.filter={};
	Quest.starters={};
	Quest.enders={};
	Quest.npcModelGUID=nil;
	Quest.npcModelName="";
	Quest.npcModelText="";
	Quest.autoComplete=false;
	Quest.objectivesScriptText="function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend"
	Quest.objectivesScript=nil;
	Quest.availabilityScriptText="function(Quest,player,event,parameter,arg1,arg2,arg3)\n    for questid,_ in pairs(Quest.previousQuests)do\n        if(not player.elements[questid].finished)then\n            return false\n        end\n    end\n    return true\nend";
	Quest.IsAvailableToPlayer=nil;
	Quest.previousQuests={};
	Quest.nextQuest=nil;
	Quest.acceptScriptText="function(Quest,player)\n\nend";
	Quest.acceptScript=nil;
	Quest.completionScriptText="function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend"
	Quest.completionScript=nil;
	Quest.abandonScriptText="function(Quest,player)\n\nend";
	Quest.abandonScript=nil;
	Quest.questRewards={};
end


function VerisimilarGM:AssignQuestFuncs(Quest)
	for methodName,method in pairs(VerisimilarGM.CommonFuncs)do
		Quest[methodName]=method;
	end
	
	for methodName,method in pairs(VerisimilarGM.QuestFuncs)do
		Quest[methodName]=method;
	end
	
	
	Quest:SetObjectivesScript(Quest:GetObjectivesScript());
	Quest:SetAvailabilityScript(Quest:GetAvailabilityScript());
	Quest:SetCompletionScript(Quest:GetCompletionScript());
	Quest:SetAcceptScript(Quest:GetAcceptScript());
	Quest:SetAbandonScript(Quest:GetAbandonScript());
	if(Quest:IsEnabled())then
		Quest:Enable();
	end
	local session=Quest:GetSession();
	for starterId,_ in pairs(Quest.starters)do
		if(not session.elements[starterId])then
			Quest.starters[starterId]=nil;
		end
	end
	for enderId,_ in pairs(Quest.enders)do
		if(not session.elements[enderId])then
			Quest.enders[enderId]=nil;
		end
	end
end

function VerisimilarGM.QuestFuncs:InitializePlayer(player)
	player.elements[self.id]={
							onQuest=false;
							finished=false;
							available=false;
							objectives={};
							}
							
	for i=1,#self.objectives do
		tinsert(player.elements[self.id].objectives,{currentValue=0,completed=false});
	end
	
end

function VerisimilarGM.QuestFuncs:SendPlayerData(player)
	local playerData=player.elements[self.id];
	local session=self:GetSession();
	playerData.available=self:IsAvailableToPlayer(player);
	if(playerData.available==true)then
		VerisimilarGM:SendSessionMessage(player,session,self,"QUEST_AVAILABILITY",true);
	end
	if(playerData.onQuest==true)then
		VerisimilarGM:SendSessionMessage(player,session,self,"OFFER_QUEST",1);
		self:InitializeObjectives(player)
	end
	if(playerData.finished==true)then
		VerisimilarGM:SendSessionMessage(player,session,self,"QUEST_COMPLETED");
	end
end

function VerisimilarGM.QuestFuncs:GetStub()
	if(self.stub.v==self.version)then return self.stub end
	local session=self:GetSession();
	local stub={id=self.netID,
				t="Q",
				v=self.version,
				qd=self.questDescription,
				os=self.objectivesSummary,
				rt=self.returnToText,
				pt=self.progressText,
				ct=self.completionText,
				tl=self.title,
				l=self.level,
				c=self.category,
				
				};
	local startersString="";
	for elementId,_ in pairs(self.starters)do
		local starter=session.elements[elementId];
		if(starter)then
			startersString=startersString..starter.netID;
		end
	end
	if(strlen(startersString)>0)then
		stub.s=startersString;
	end
	local endersString="";
	for elementId,_ in pairs(self.enders)do
		local ender=session.elements[elementId];
		if(ender)then
			endersString=endersString..ender.netID;
		end
	end
	if(strlen(endersString)>0)then
		stub.e=endersString;
	end
	if(self:GetNPCModelGUID())then
		stub.ng=self:GetNPCModelGUID();
		stub.nn=self:GetNPCModelName();
		stub.nt=self:GetNPCModelText();
	end
	if(self.autoComplete)then
		stub.ac=true;
	end
	if(self:GetSpecialItem())then
		stub.si=self:GetSpecialItem().netID;
	end
	if(self.nextQuest and session.elements[self.nextQuest])then
		stub.nq=session.elements[self.nextQuest].netID;
	end
	if(#self.questRewards>0)then
		stub.r={}
		for i=1,#self.questRewards do
			local choosable="f";
			if(self.questRewards[i].choosable)then
				choosable="t";
			end
			tinsert(stub.r,self:GetQuestReward(i).netID..choosable..self.questRewards[i].amount);
		end
	end
	if(#self.objectives>0)then
		stub.o={};
		for i=1,#self.objectives do
			stub.o[i]={
						ot=self:GetObjectiveText(i);
						tv=self:GetObjectiveTargetValue(i);
						};
			if(self.objectives[i].event~="Script")then
				for j=1,#VerisimilarPl.eventList do
					if(self.objectives[i].event==VerisimilarPl.eventList[j])then
						stub.o[i].e=j;
					end
				end
			end
			if(self.objectives[i].event=="Item" and session.elements[self.objectives[i].filter[1]])then
				stub.o[i].f=session.elements[self.objectives[i].filter[1]].netID;
			else
				stub.o[i].f=self:GetEventFilter(i);
			end
			if(self:GetObjectivePOIZone(i))then
				stub.o[i].z,stub.o[i].l=self:GetObjectivePOIZone(i);
				local x,y=self:GetObjectivePOICoordinates(i);
				stub.o[i].c=VerisimilarPl:EncodeCoordinates(x,y);
			end
		end
	end
	self.stub=stub;
	return stub;
	
end

function VerisimilarGM.QuestFuncs:InitializeObjectives(player)
	playerData=player.elements[self.id];
	for i=1,#playerData.objectives do
		if(self.objectives[i].event=="Item")then
			playerData.objectives[i].currentValue=0;
			playerData.objectives[i].completed=false;
			local itemData=player.elements[self.objectives[i].filter[1]];
			if(itemData)then
				playerData.objectives[i].currentValue=itemData.amount;
				if(playerData.objectives[i].currentValue>=self.objectives[i].targetValue)then
					playerData.objectives[i].currentValue=self.objectives[i].targetValue;
					playerData.objectives[i].completed=true;
				end
			end
		end
		if(playerData.objectives[i].currentValue>0)then
			VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"OBJECTIVE_UPDATED",strchar(i).."n"..playerData.objectives[i].currentValue);
		end
	end
	self:CheckCompletion(player);
end

function VerisimilarGM.QuestFuncs:GetTitle()
	return self.title
end

function VerisimilarGM.QuestFuncs:SetTitle(title)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(title and self.title~=title)then
		self:GenerateNewVersion()
		self.title=title;
	end
end

function VerisimilarGM.QuestFuncs:IsStarter(elementId)
	local session=self:GetSession();
	if(elementId==nil)then return false; end
	if(type(elementId)=="table")then
		elementId=elementId.id;
	end
	return self.starters[elementId] or false;
end

function VerisimilarGM.QuestFuncs:AddStarter(starter)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(starter and not self:IsStarter(starter))then
		self:GenerateNewVersion()
		if(type(starter)=="table")then
			self.starters[starter.id]=true;
		else
			self.starters[starter]=true;
		end
	end
end

function VerisimilarGM.QuestFuncs:RemoveStarter(starter)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(starter and self:IsStarter(starter))then
		self:GenerateNewVersion()
		if(type(starter)=="table")then
			self.starters[starter.id]=nil;
		else
			self.starters[starter]=nil;
		end
	end
end

function VerisimilarGM.QuestFuncs:IsEnder(elementId)
	local session=self:GetSession();
	if(elementId==nil)then return false; end
	if(type(elementId)=="table")then
		elementId=elementId.id;
	end
	return self.enders[elementId] or false;
end

function VerisimilarGM.QuestFuncs:AddEnder(ender)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(ender and not self:IsEnder(ender))then
		self:GenerateNewVersion()
		if(type(ender)=="table")then
			self.enders[ender.id]=true;
		else
			self.enders[ender]=true;
		end
	end
end

function VerisimilarGM.QuestFuncs:RemoveEnder(ender)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(ender and self:IsEnder(ender))then
		self:GenerateNewVersion()
		if(type(ender)=="table")then
			self.enders[ender.id]=nil;
		else
			self.enders[ender]=nil;
		end
	end
end

function VerisimilarGM.QuestFuncs:SetNPCModelGUID(guid)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	guid=tonumber(guid)
	if(self.npcModelGUID~=guid)then
		self:GenerateNewVersion()
		self.npcModelGUID=guid;
	end
end

function VerisimilarGM.QuestFuncs:GetNPCModelGUID()
	return self.npcModelGUID;
end

function VerisimilarGM.QuestFuncs:SetNPCModelName(name)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(name and self.npcModelName~=name)then
		self:GenerateNewVersion()
		self.npcModelName=name;
	end
end

function VerisimilarGM.QuestFuncs:GetNPCModelName()
	return self.npcModelName;
end

function VerisimilarGM.QuestFuncs:SetNPCModelText(text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(text and self.npcModelText~=text)then
		self:GenerateNewVersion()
		self.npcModelText=text;
	end
end

function VerisimilarGM.QuestFuncs:GetNPCModelText()
	return self.npcModelText;
end

function VerisimilarGM.QuestFuncs:IsAutoComplete()
	return self.autoComplete;
end

function VerisimilarGM.QuestFuncs:SetAutoComplete(switch)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	switch=switch and true or false;
	if(switch~=self.autoComplete)then
		self:GenerateNewVersion();
		self.autoComplete=switch;
	end
end

function VerisimilarGM.QuestFuncs:GetLevel()
	return self.level;
end

function VerisimilarGM.QuestFuncs:SetLevel(level)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	local numLevel=tonumber(level);
	if(numLevel and self.level~=numLevel)then
		self:GenerateNewVersion()
		self.level=numLevel;
	end
end

function VerisimilarGM.QuestFuncs:GetCategory()
	return self.category;
end

function VerisimilarGM.QuestFuncs:SetCategory(category)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(category and self.category~=category)then
		self:GenerateNewVersion()
		self.category=category;
	end
end

function VerisimilarGM.QuestFuncs:GetSpecialItem()
	local session=self:GetSession();
	if(session.elements[self.specialItemId])then
		return session.elements[self.specialItemId];
	end
end

function VerisimilarGM.QuestFuncs:SetSpecialItem(item)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(type(item)=="table")then
		item=item.id
	end
	if(self.specialItemId~=item)then
		self:GenerateNewVersion();
		self.specialItemId=item;
	end
end

function VerisimilarGM.QuestFuncs:SetQuestDescription(text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(text and self.questDescription~=text)then
		self:GenerateNewVersion()
		self.questDescription=text;
	end
end

function VerisimilarGM.QuestFuncs:GetQuestDescription()
	return self.questDescription;
end

function VerisimilarGM.QuestFuncs:SetObjectivesSummary(text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(text and self.objectivesSummary~=text)then
		self:GenerateNewVersion()
		self.objectivesSummary=text;
	end
end

function VerisimilarGM.QuestFuncs:GetObjectivesSummary()
	return self.objectivesSummary;
end

function VerisimilarGM.QuestFuncs:SetProgressText(text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(text and self.progressText~=text)then
		self:GenerateNewVersion()
		self.progressText=text;
	end
end

function VerisimilarGM.QuestFuncs:GetProgressText()
	return self.progressText;
end

function VerisimilarGM.QuestFuncs:SetCompletionText(text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(text and self.completionText~=text)then
		self:GenerateNewVersion()
		self.completionText=text;
	end
end

function VerisimilarGM.QuestFuncs:GetCompletionText()
	return self.completionText;
end

function VerisimilarGM.QuestFuncs:SetReturnToText(text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(text and self.returnToText~=text)then
		self:GenerateNewVersion()
		self.returnToText=text;
	end
end

function VerisimilarGM.QuestFuncs:GetReturnToText()
	return self.returnToText;
end


function VerisimilarGM.QuestFuncs:Offer(player)
	if(player.elements[self.id].onQuest==false)then
		player.elements[self.id].onQuest=true;
		VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"OFFER_QUEST",3);
		if(self:GetSpecialItem())then
			self:GetSpecialItem():GiveTo(player,1,"gain");
		end
		self:acceptScript(player);
		self:InitializeObjectives(player);
	end
end



function VerisimilarGM.QuestFuncs:Reset(player,dontSend)
	local questData=player.elements[self.id];
	questData.finished=false;
	questData.completed=false;
	if(questData.onQuest==true)then
		self:abandonScript(player);
		questData.onQuest=false;
		self:abandonScript();
		if(self:GetSpecialItem())then
			self:GetSpecialItem():GiveTo(player,-1);
		end
	end
	for i=1,#questData.objectives do
		questData.objectives[i].currentValue=0;
		questData.objectives[i].completed=false;
	end
	if(not dontSend)then
		VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"RESET_QUEST");
		questData.available=self:IsAvailableToPlayer(player);
		
		if(questData.available)then
			VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"QUEST_AVAILABILITY",true);
		end
	end
end



function VerisimilarGM.QuestFuncs:RegisterEvent(index,event)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(self.objectives[index] and self.objectives[index].event~=event)then
		self:GenerateNewVersion()
		self.objectives[index].event=event
	end
end

function VerisimilarGM.QuestFuncs:GetEventFilter(index)
	local filterText="";
	if(self.objectives[index])then
		for i=1,#self.objectives[index].filter do
			filterText=filterText..self.objectives[index].filter[i]
			if(i<#self.objectives[index].filter)then
				filterText=filterText..","
			end
		end
		return filterText;
	end
end

function VerisimilarGM.QuestFuncs:SetEventFilter(index,filterText)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(self.objectives[index])then
		self:GenerateNewVersion()
		self.objectives[index].filter={ strsplit(",", filterText) }
	end
end

function VerisimilarGM.QuestFuncs:GetObjectivesScript()
	return self.objectivesScriptText;
end

function VerisimilarGM.QuestFuncs:SetObjectivesScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.objectivesScriptText=scriptText;
	self.objectivesScript=func();
	setfenv(self.objectivesScript,self:GetSession().env);
end


function VerisimilarGM.QuestFuncs:Event(player,event,parameter,arg1,arg2,arg3)
	self:EvaluateObjectives(player,event,parameter,arg1,arg2,arg3);
	self:CheckAvailability(player,event,parameter,arg1,arg2,arg3);
end

function VerisimilarGM.QuestFuncs:CheckAvailability(player,event,parameter,arg1,arg2,arg3)
	local questVar=player.elements[self.id];
	
	local prevAvailable=questVar.available;
	questVar.available=self:IsAvailableToPlayer(player,event,parameter,arg1,arg2,arg3);
	if(questVar.available~=prevAvailable)then
		VerisimilarGM:SendSessionMessage(player,session,self,"QUEST_AVAILABILITY",questVar.available);
	end
end


local FilterParameter =	function(parameter,filter)
							for i=1,#filter do
								if(filter[i]~="" and strfind(strlower(parameter),strlower(filter[i])))then
									return true;
								end
							end
							return false
						end
						
						
							
function VerisimilarGM.QuestFuncs:EvaluateObjectives(player,event,parameter,arg1,arg2,arg3)
	local questVariables=player.elements[self.id];
	for i=1,#self.objectives do
		if(event==self:GetObjectiveEvent(i) and FilterParameter(parameter,self.objectives[i].filter))then
			local newValue=self.objectivesScript(self,player,questVariables.objectives[i].currentValue,event,parameter,arg1,arg2,arg3);
			self:SetObjectiveValue(player,i,newValue);
		end
	end
	self:CheckCompletion(player);
end

function VerisimilarGM.QuestFuncs:SetObjectiveValue(player,obj,newValue)
	local questVariables=player.elements[self.id];
	local valueChanged=false;
	if(newValue==nil or not questVariables.objectives[obj])then return end
	if(newValue>questVariables.objectives[obj].currentValue)then
		if(not questVariables.objectives[obj].completed)then
			valueChanged=true;
			questVariables.objectives[obj].currentValue=newValue;
			if(newValue>=self:GetObjectiveTargetValue(obj))then
				questVariables.objectives[obj].currentValue=self:GetObjectiveTargetValue(obj);
				questVariables.objectives[obj].completed=true;
			end
		end
	elseif(newValue<questVariables.objectives[obj].currentValue)then
		if(questVariables.objectives[obj].currentValue>0)then
			valueChanged=true;
			questVariables.objectives[obj].currentValue=newValue;
			questVariables.objectives[obj].completed=false;
		end
	end
	if(valueChanged)then
		VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"OBJECTIVE_UPDATED",strchar(obj).."a"..questVariables.objectives[obj].currentValue);
	end
	
	
end

function VerisimilarGM.QuestFuncs:CheckCompletion(player)
	local questVariables=player.elements[self.id];
	questVariables.completed=true;
	for i=1,#questVariables.objectives do
		if(questVariables.objectives[i].completed==false)then
			questVariables.completed=false;
			break;
		end
	end
	if(questVariables.completed)then
		VerisimilarGM:LogEvent("Player "..player.name.." completed the objectives of "..self.title)
	end
end

function VerisimilarGM.QuestFuncs:AddObjective()
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	local x,y=GetPlayerMapPosition("player");
	SetMapToCurrentZone();
	tinsert(self.objectives,{text="",targetValue=1,filter={},poix=x,poiy=y,zone=GetCurrentMapAreaID(),level=GetCurrentMapDungeonLevel()})
	for _,player in pairs(self:GetSession().players)do
		tinsert(player.elements[self.id].objectives,{currentValue=0,completed=false});
	end
end

function VerisimilarGM.QuestFuncs:RemoveObjective(objNum)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	tremove(self.objectives,objNum);
	for _,player in pairs(self:GetSession().players)do
		tremove(player.elements[self.id].objectives,objNum);
	end
end

function VerisimilarGM.QuestFuncs:GetObjectiveText(objNum)
	return objNum and self.objectives[objNum] and self.objectives[objNum].text;
end

function VerisimilarGM.QuestFuncs:SetObjectiveText(objNum,text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(self.objectives[objNum] and self.objectives[objNum].text~=text)then
		self:GenerateNewVersion()
		self.objectives[objNum].text=text;
	end
end



function VerisimilarGM.QuestFuncs:GetObjectiveEvent(objNum)
	return objNum and self.objectives[objNum] and self.objectives[objNum].event;
end

function VerisimilarGM.QuestFuncs:GetObjectiveTargetValue(objNum)
	return objNum and self.objectives[objNum] and self.objectives[objNum].targetValue;
end

function VerisimilarGM.QuestFuncs:SetObjectiveTargetValue(objNum,value)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	value=tonumber(value);
	if(value and self.objectives[objNum] and self.objectives[objNum].targetValue~=value)then
		
		self.objectives[objNum].targetValue=value;
	end
end

function VerisimilarGM.QuestFuncs:GetObjectivePOICoordinates(objNum)
	return self.objectives[objNum].poix,self.objectives[objNum].poiy;
end

function VerisimilarGM.QuestFuncs:SetObjectivePOICoordinates(objNum,x,y)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	x=tonumber(x);
	y=tonumber(y);
	x=x<1 and x or x/100;
	y=y<1 and y or y/100;
	if(x and y and self.objectives[objNum] and (self.objectives[objNum].poix~=x or self.objectives[objNum].poiy~=y))then
		self:GenerateNewVersion()
		self.objectives[objNum].poix=x;
		self.objectives[objNum].poiy=y;
	end
end

function VerisimilarGM.QuestFuncs:GetObjectivePOIZone(objNum)
	if(not self.objectives[objNum])then return end
	return self.objectives[objNum].zone,self.objectives[objNum].level;
end

function VerisimilarGM.QuestFuncs:SetObjectivePOIZone(objNum,zone,level)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	zone=tonumber(zone);
	level=tonumber(level)
	if(self.objectives[objNum] and (zone~=self.objectives[objNum].zone or level~=self.objectives[objNum].level))then
		self:GenerateNewVersion()
		self.objectives[objNum].zone=zone;
		self.objectives[objNum].level=level;
	end
end

function VerisimilarGM.QuestFuncs:ShowProgress(player)
	local questVariables=player.elements[self.id];
	if(questVariables.completed==true and questVariables.onQuest==true)then
		VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"QUEST_PROGRESS");
	end
end

function VerisimilarGM.QuestFuncs:IsPreviousQuest(elementId)
	local session=self:GetSession();
	if(elementId==nil)then return false; end
	if(type(elementId)=="table")then
		elementId=elementId.id;
	end
	return self.previousQuests[elementId] or false;
end

function VerisimilarGM.QuestFuncs:AddPreviousQuest(prevQuest)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	--self:GenerateNewVersion()
	if(type(prevQuest)=="table")then
		if(prevQuest==self)then return end
		self.previousQuests[prevQuest.id]=true;
	else
		if(prevQuest==self.id)then return end
		self.previousQuests[prevQuest]=true;
	end
end

function VerisimilarGM.QuestFuncs:RemovePreviousQuest(prevQuest)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	--self:GenerateNewVersion()
	if(type(prevQuest)=="table")then
		self.previousQuests[prevQuest.id]=nil;
	else
		self.previousQuests[prevQuest]=nil;
	end
end

function VerisimilarGM.QuestFuncs:GetNextQuest()
	local session=self:GetSession();
	if(session.elements[self.nextQuest])then
		return session.elements[self.nextQuest];
	end
end

function VerisimilarGM.QuestFuncs:SetNextQuest(nextQuest)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(type(nextQuest)=="table")then
		nextQuest=nextQuest.id;
	end
	if(self.nextQuest~=nextQuest)then
		self:GenerateNewVersion()
		self.nextQuest=nextQuest
	end
end

function VerisimilarGM.QuestFuncs:GetAvailabilityScript()
	return self.availabilityScriptText;
end

function VerisimilarGM.QuestFuncs:SetAvailabilityScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.availabilityScriptText=scriptText;
	self.IsAvailableToPlayer=func();
	setfenv(self.IsAvailableToPlayer,self:GetSession().env);
end

function VerisimilarGM.QuestFuncs:GetCompletionScript()
	return self.completionScriptText;
end

function VerisimilarGM.QuestFuncs:SetCompletionScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.completionScriptText=scriptText;
	self.completionScript=func();
	setfenv(self.completionScript,self:GetSession().env);
end

function VerisimilarGM.QuestFuncs:GetAcceptScript()
	return self.acceptScriptText;
end

function VerisimilarGM.QuestFuncs:SetAcceptScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.acceptScriptText=scriptText;
	self.acceptScript=func();
	setfenv(self.acceptScript,self:GetSession().env);
end

function VerisimilarGM.QuestFuncs:GetAbandonScript()
	return self.abandonScriptText;
end

function VerisimilarGM.QuestFuncs:SetAbandonScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.abandonScriptText=scriptText;
	self.abandonScript=func();
	setfenv(self.abandonScript,self:GetSession().env);
end

function VerisimilarGM.QuestFuncs:GetNumQuestRewards()
	return #self.questRewards
end

function VerisimilarGM.QuestFuncs:AddQuestReward()
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	tinsert(self.questRewards,{id="",amount=1,choosable=false})
end

function VerisimilarGM.QuestFuncs:SetQuestReward(i,item)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(type(item)=="table")then
		item=item.id;
	end
	if(self.questRewards[i] and self.questRewards[i].id~=item)then
		self:GenerateNewVersion()
		self.questRewards[i].id=item;
	end
end

function VerisimilarGM.QuestFuncs:GetQuestReward(i)
	local session=self:GetSession();
	if(self.questRewards[i] and session.elements[self.questRewards[i].id])then
		return session.elements[self.questRewards[i].id];
	end
end

function VerisimilarGM.QuestFuncs:SetQuestRewardChoosability(i,choosable)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	choosable=choosable and true or false;
	if(self.questRewards[i] and self.questRewards[i].choosable~=choosable)then
		self:GenerateNewVersion()
		self.questRewards[i].choosable=choosable;
	end
end

function VerisimilarGM.QuestFuncs:GetQuestRewardChoosability(i)
	return self.questRewards[i] and self.questRewards[i].choosable;
end

function VerisimilarGM.QuestFuncs:SetQuestRewardAmount(i,amount)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	amount=tonumber(amount);
	if(self.questRewards[i] and self.questRewards[i].amount~=amount)then
		self:GenerateNewVersion()
		self.questRewards[i].amount=amount;
	end
end

function VerisimilarGM.QuestFuncs:GetQuestRewardAmount(i)
	return self.questRewards[i] and self.questRewards[i].amount;
end

function VerisimilarGM.QuestFuncs:RemoveQuestReward(i)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	tremove(self.questRewards,i)
end


function VerisimilarGM:GetQuestProgressQuery(message,channel,sender)
	local session=VerisimilarGM.db.global.sessions[message.sessionName]
	if(session and session.players[sender])then
		local Quest=session.elements[message.QuestId];
		if(Quest)then
			Quest:ShowProgress(session.players[sender])
		end
	end
end

function VerisimilarGM.QuestFuncs:QUEST_ACCEPTED(player)
	local questData=player.elements[self.id];
	if(questData.available==true and questData.onQuest==false and questData.finished==false)then
		questData.onQuest=true;
		VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"OFFER_QUEST",2);
		if(self:GetSpecialItem())then
			self:GetSpecialItem():GiveTo(player,1,"gain");
		end
		self:acceptScript(player);
		self:EvaluateObjectives(player);
		VerisimilarGM:LogEvent("Player "..player.name.." accepted quest "..self.title);
	end
end

function VerisimilarGM.QuestFuncs:TURN_IN_QUEST(player,choice)
	local questVariables=player.elements[self.id];
	print(questVariables.completed)
	print(questVariables.onQuest)
	
	if(questVariables.completed==true and questVariables.onQuest==true)then
		print("yoyo")
		if(self:GetSpecialItem())then
			self:GetSpecialItem():GiveTo(player,-1);
		end
		for i=1,#self.objectives do
			local item=self:GetSession().elements[self.objectives[i].filter[1]];
			if(item)then
				item:GiveTo(player,-self.objectives[i].targetValue);
			end
			questVariables.objectives[i].currentValue=0;
			questVariables.objectives[i].completed=false;
		end
		for i=1,self:GetNumQuestRewards() do
			local item=self:GetQuestReward(i)
			if(self:GetQuestRewardChoosability(i)==false or (self:GetQuestRewardChoosability(i)==true and type(choice)=="number" and choice==i))then
				item:GiveTo(player,self:GetQuestRewardAmount(i),"gain");				
			end
		end
		self:completionScript(player);
		questVariables.onQuest=false;
		questVariables.finished=true;
		for _, quest in pairs(self:GetSession().elements)do
			if(quest.elType=="Quest")then
				quest:CheckAvailability(player);
			end
		end
		VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"QUEST_COMPLETED",true);
		VerisimilarGM:UpdateInterface();
		VerisimilarGM:LogEvent("Player "..player.name.." completed quest "..self.title)
	end
end


function VerisimilarGM.QuestFuncs:ABANDON_QUEST(player)
	local questData=player.elements[self.id]
	if(questData.onQuest==true)then
		self:Reset(player,true);
		VerisimilarGM:LogEvent("Player "..player.name.." abandoned quest "..self.title)
	end
end

