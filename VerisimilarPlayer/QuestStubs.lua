VerisimilarPl.offeredQuest=nil;
VerisimilarPl.questLogSelectedQuestIndex=nil;
VerisimilarPl.questLog={};
VerisimilarPl.questWatch={};
VerisimilarPl.autoQuestPopUps={};
VerisimilarPl.questPOIList={};
VerisimilarPl.alphabetizedCategories={};
VerisimilarPl.questsPerCategory={};
VerisimilarPl.numLogEntries=0;
VerisimilarPl.numLogQuests=0;
VerisimilarPl.selectedQuestName="";


function VerisimilarPl:UpdateQuestInterfaceMerge()
	if(self.db.char.mergeWithQuestInterface)then
		self:RawHook("GetTitleText",true);
		self:RawHook("GetQuestText",true);
		self:RawHook("GetObjectiveText",true);
		self:RawHook("GetProgressText",true);
		self:RawHook("GetRewardText",true);
		self:RawHook("GetNumQuestRewards",true);
		self:RawHook("GetNumQuestChoices",true);
		self:RawHook("GetNumRewardCurrencies",true);
		self:RawHook("GetRewardSkillPoints",true);
		self:RawHook("GetRewardSpell",true);
		self:RawHook("GetRewardMoney",true);
		self:RawHook("GetRewardHonor",true);
		self:RawHook("GetRewardTalents",true);
		self:RawHook("GetRewardTitle",true);
		self:RawHook("AcceptQuest",true);
		self:RawHook("CompleteQuest",true);
		self:RawHook("GetQuestReward",true);
		self:RawHook("DeclineQuest",true);
		self:RawHook("GetNumQuestLogEntries",true);
		self:RawHook("GetQuestLogSelection",true);
		self:RawHook("GetQuestLogTitle",true);
		self:RawHook("SelectQuestLogEntry",true);
		self:RawHook("ExpandQuestHeader",true);
		self:RawHook("CollapseQuestHeader",true);
		self:RawHook("IsCurrentQuestFailed",true);
		self:RawHook("IsQuestCompletable",true);
		self:RawHook("GetQuestLogQuestText",true);
		self:RawHook("GetQuestLogTimeLeft",true);
		self:RawHook("GetNumQuestLeaderBoards",true);
		self:RawHook("GetQuestLogLeaderBoard",true);
		self:RawHook("GetQuestLogRequiredMoney",true);
		self:RawHook("GetQuestLogGroupNum",true);
		self:RawHook("GetNumQuestLogRewards",true);
		self:RawHook("GetNumQuestLogChoices",true);
		self:RawHook("GetNumQuestLogRewardCurrencies",true);
		self:RawHook("GetQuestLogRewardMoney",true);
		self:RawHook("GetQuestLogRewardTalents",true);
		self:RawHook("GetQuestLogRewardSkillPoints",true);
		self:RawHook("GetQuestLogRewardTitle",true);
		self:RawHook("GetQuestLogRewardSpell",true);
		self:RawHook("GetNumQuestWatches",true);
		self:RawHook("AddQuestWatch",true);
		self:RawHook("GetQuestIndexForWatch",true);
		self:RawHook("IsQuestWatched",true);
		self:RawHook("RemoveQuestWatch",true);
		self:RawHook("SetAbandonQuest",true);
		self:RawHook("AbandonQuest",true);
		self:RawHook("GetAbandonQuestName",true);
		self:RawHook("GetQuestLink",true);
		self:RawHook("QuestLog_Update",true);
		self:RawHook("GetQuestLogPushable",true);
		self:RawHook("GetQuestLogChoiceInfo",true);
		self:RawHook("GetQuestLogRewardInfo",true);
		self:RawHook("IsUnitOnQuest",true);
		self:RawHook("QuestLogPushQuest",true);
		self:RawHook("GetQuestLogCompletionText",true);
		self:RawHook("GetQuestItemInfo",true);
		self:RawHook("GetRewardXP",true);
		self:RawHook("GetQuestLogRewardXP",true);
		self:RawHook("GetNumQuestItems",true);
		self:RawHook("GetQuestLogSpecialItemInfo",true);
		self:SecureHook("UseQuestLogSpecialItem");
		self:RawHook("GetQuestLogSpecialItemCooldown",true);
		self:RawHook("IsQuestLogSpecialItemInRange",true);
		self:RawHook("QuestMapUpdateAllQuests",true);
		self:RawHook("QuestPOIGetQuestIDByVisibleIndex",true);
		self:RawHook("QuestPOIGetIconInfo",true);
		self:RawHook("QuestPOIUpdateIcons",true);
		self:RawHook("GetQuestPOILeaderBoard",true);
		self:RawHook("GetNumQuestItemDrops",true);
		self:RawHook("GetQuestLogItemDrop",true);
		self:RawHook("GetQuestWorldMapAreaID",true);
		self:RawHook("QuestPOI_HideButtons",true);
		self:RawHook("GetAutoQuestPopUp",true);
		self:RawHook("GetNumAutoQuestPopUps",true);
		self:RawHook("GetQuestLogIndexByID",true);
		self:RawHook("ShowQuestOffer",true);
		self:RawHook("ShowQuestComplete",true);
		self:RawHook("QuestGetAutoAccept",true);
		self:RawHook("GetQuestLogIsAutoComplete",true);
		self:RawHook("RemoveAutoQuestPopUp",true);
		self:RawHook(GameTooltip,"SetQuestItem",true);
		self:RawHook(GameTooltip,"SetQuestLogItem",true);
		self:RawHook(GameTooltip,"SetQuestLogSpecialItem",true);
		VerisimilarPl.questLogSelectedQuestIndex=self.hooks.GetQuestLogSelection()
		self:ScheduleTimer(function() event="QUEST_LOG_UPDATE";QuestLog_Update();WatchFrame_Update(); end,3) 
		
		
	else
		self:Unhook("GetTitleText",true);
		self:Unhook("GetQuestText",true);
		self:Unhook("GetObjectiveText",true);
		self:Unhook("GetProgressText",true);
		self:Unhook("GetRewardText",true);
		self:Unhook("GetNumQuestRewards",true);
		self:Unhook("GetNumQuestChoices",true);
		self:Unhook("GetNumRewardCurrencies",true);
		self:Unhook("GetRewardSkillPoints",true);
		self:Unhook("GetRewardSpell",true);
		self:Unhook("GetRewardMoney",true);
		self:Unhook("GetRewardHonor",true);
		self:Unhook("GetRewardTalents",true);
		self:Unhook("GetRewardTitle",true);
		self:Unhook("AcceptQuest",true);
		self:Unhook("CompleteQuest",true);
		self:Unhook("GetQuestReward",true);
		self:Unhook("DeclineQuest",true);
		self:Unhook("GetNumQuestLogEntries",true);
		self:Unhook("GetQuestLogSelection",true);
		self:Unhook("GetQuestLogTitle",true);
		self:Unhook("SelectQuestLogEntry",true);
		self:Unhook("ExpandQuestHeader",true);
		self:Unhook("CollapseQuestHeader",true);
		self:Unhook("IsCurrentQuestFailed",true);
		self:Unhook("IsQuestCompletable",true);
		self:Unhook("GetQuestLogQuestText",true);
		self:Unhook("GetQuestLogTimeLeft",true);
		self:Unhook("GetNumQuestLeaderBoards",true);
		self:Unhook("GetQuestLogLeaderBoard",true);
		self:Unhook("GetQuestLogRequiredMoney",true);
		self:Unhook("GetQuestLogGroupNum",true);
		self:Unhook("GetNumQuestLogRewards",true);
		self:Unhook("GetNumQuestLogChoices",true);
		self:Unhook("GetNumQuestLogRewardCurrencies",true);
		self:Unhook("GetQuestLogRewardMoney",true);
		self:Unhook("GetQuestLogRewardTalents",true);
		self:Unhook("GetQuestLogRewardSkillPoints",true);
		self:Unhook("GetQuestLogRewardTitle",true);
		self:Unhook("GetQuestLogRewardSpell",true);
		self:Unhook("GetNumQuestWatches",true);
		self:Unhook("AddQuestWatch",true);
		self:Unhook("GetQuestIndexForWatch",true);
		self:Unhook("IsQuestWatched",true);
		self:Unhook("RemoveQuestWatch",true);
		self:Unhook("SetAbandonQuest",true);
		self:Unhook("AbandonQuest",true);
		self:Unhook("GetAbandonQuestName",true);
		self:Unhook("GetQuestLink",true);
		self:Unhook("QuestLog_Update",true);
		self:Unhook("GetQuestLogPushable",true);
		self:Unhook("GetQuestLogChoiceInfo",true);
		self:Unhook("GetQuestLogRewardInfo",true);
		self:Unhook("IsUnitOnQuest",true);
		self:Unhook("QuestLogPushQuest",true);
		self:Unhook("GetQuestLogCompletionText",true);
		self:Unhook("GetQuestItemInfo",true);
		self:Unhook("GetRewardXP",true);
		self:Unhook("GetQuestLogRewardXP",true);
		self:Unhook("GetNumQuestItems",true);
		self:Unhook("GetQuestLogSpecialItemInfo",true);
		self:Unhook("UseQuestLogSpecialItem",true);
		self:Unhook("GetQuestLogSpecialItemCooldown",true);
		self:Unhook("IsQuestLogSpecialItemInRange",true);
		self:Unhook("QuestMapUpdateAllQuests",true);
		self:Unhook("QuestPOIGetQuestIDByVisibleIndex",true);
		self:Unhook("QuestPOIGetIconInfo",true);
		self:Unhook("QuestPOIUpdateIcons",true);
		self:Unhook("GetQuestPOILeaderBoard",true);
		self:Unhook("GetNumQuestItemDrops",true);
		self:Unhook("GetQuestLogItemDrop",true);
		self:Unhook("GetQuestWorldMapAreaID",true);
		self:Unhook("QuestPOI_HideButtons",true);
		self:Unhook("GetAutoQuestPopUp",true);
		self:Unhook("GetNumAutoQuestPopUps",true);
		self:Unhook("GetQuestLogIndexByID",true);
		self:Unhook("ShowQuestOffer",true);
		self:Unhook("ShowQuestComplete",true);
		self:Unhook("QuestGetAutoAccept",true);
		self:Unhook("GetQuestLogIsAutoComplete",true);
		self:Unhook("RemoveAutoQuestPopUp",true);
		self:Unhook(GameTooltip,"SetQuestItem",true);
		self:Unhook(GameTooltip,"SetQuestLogItem",true);
		self:Unhook(GameTooltip,"SetQuestLogSpecialItem",true);
		self:ScheduleTimer(function() event="QUEST_LOG_UPDATE";QuestLog_Update();WatchFrame_Update(); end,3) 
	end

end


local choosableTable={t=true,f=false};
function VerisimilarPl:AddQuestStubData(stubData,stubInfo)
	stubData.type="Quest";
	stubData.questDescription=stubInfo.qd;
	stubData.objectivesSummary=stubInfo.os;
	stubData.returnToText=stubInfo.rt;
	stubData.progressText=stubInfo.pt;
	stubData.completionText=stubInfo.ct;
	stubData.title=stubInfo.tl;
	stubData.level=stubInfo.l;
	stubData.category=stubInfo.c;
	stubData.nextQuest=stubInfo.nq;
	
	stubData.objectivesInfo={};
	if(stubInfo.o)then
		for i=1,#stubInfo.o do
			local x,y=self:DecodeCoordinates(stubInfo.o[i].c);
			self:PrintDebug("Filter:",stubInfo.o[i].f);
			tinsert(stubData.objectivesInfo,{text=stubInfo.o[i].ot,targetValue=stubInfo.o[i].tv,event=VerisimilarPl.eventList[stubInfo.o[i].e],filter={strsplit(",",stubInfo.o[i].f)},zone=stubInfo.o[i].z,level=stubInfo.o[i].l,x=x,y=y});
		end
	end
	stubData.starters={};
	if(stubInfo.s)then
		for i=1,strlen(stubInfo.s)do
			stubData.starters[strsub(stubInfo.s,i,i)]=true;
		end
	end
	stubData.enders={};
	if(stubInfo.e)then
		for i=1,strlen(stubInfo.e)do
			stubData.enders[strsub(stubInfo.e,i,i)]=true;
		end
	end
	if(stubInfo.ng)then
		stubData.npcModelGUID=stubInfo.ng;
		stubData.npcModelName=stubInfo.nn;
		stubData.npcModelText=stubInfo.nt;
	end
	stubData.autoComplete=stubInfo.ac;
	stubData.specialItem=stubInfo.si;
	if(stubInfo.r)then
		stubData.rewards={};
		for i=1,#stubInfo.r do
			tinsert(stubData.rewards,{id=strsub(stubInfo.r[i],1,1),choosable=choosableTable[strsub(stubInfo.r[i],2,2)],amount=tonumber(strsub(stubInfo.r[i],3))});
		end
	end
end

function VerisimilarPl:InitializeQuestStub(stub)
	stub.onQuest=false;
	stub.finished=false;
	stub.available=false;
	stub.completed=nil;
	stub.objectives={};
	for i=1,#stub.objectivesInfo do
		tinsert(stub.objectives,{completed=false,value=0});
	end
	self:UpdateMinimapQuestIcons()
end

function VerisimilarPl:DisableQuestStub(stub)
	self:RemoveFromQuestLog(stub);
	self:UpdateMinimapQuestIcons()
end

function VerisimilarPl:RemoveFromQuestLog(stub)
	if(stub.onQuest==false)then return end
	
	if(self.db.char.mergeWithQuestInterface)then
		RemoveAutoQuestPopUp(stub.id);
	end
	local quests=VerisimilarPl.questsPerCategory[stub.category];
	for i=1,#quests do
		if(stub==quests[i])then
			tremove(quests,i);
			break;
		end
	end
	if(#quests==0)then
		VerisimilarPl.questsPerCategory[stub.category]=nil
		for i=1,#VerisimilarPl.alphabetizedCategories do
			if(stub.category==VerisimilarPl.alphabetizedCategories[i])then
				tremove(VerisimilarPl.alphabetizedCategories,i);
				break;
			end
		end
	end
	for i=1,#VerisimilarPl.questLog do
		if(type(VerisimilarPl.questLog[i])=="table" and VerisimilarPl.questLog[i]==stub)then
			RemoveQuestWatch(i);
			break
		end
	end
	stub.onQuest=false;
	for i=1,#stub.objectives do
		stub.objectives[i].completed=false;
		stub.objectives[i].value=0;
	end
	stub.completed=nil;
	event="QUEST_LOG_UPDATE"
	VerisimilarPl:QuestLog_Update();
	WatchFrame_Update();
	VerisimilarPl:QuestListUpdated();
	self:UpdateMinimapQuestIcons()
end


function VerisimilarPl:CheckQuestCompletion(stub)
	if(stub.onQuest)then
		stub.completed=1;
		for i=1,#stub.objectives do
			if(stub.objectives[i].completed==false)then
				stub.completed=nil;
				break;
			end
		end
	end
end

function VerisimilarPl:QUEST_AVAILABILITY(stub,available)
	if(available)then
		stub.available=true;
		self:PrintDebug("Quest ",stub.title," available")
	else
		stub.available=false;
		self:PrintDebug("Quest ",stub.title," not available")
	end
	self:UpdateMinimapQuestIcons()
end

function VerisimilarPl:RESET_QUEST(stub)
	stub.finished=false;
	stub.available=false;
	self:RemoveFromQuestLog(stub);
end

function VerisimilarPl:GetQuestIDFromStub(stub)
	return stub.session.gm.."_"..stub.session.id..stub.id
end

function VerisimilarPl:GetStubFromQuestID(questId)
	local session=self.sessions[strsub(questId,1,-2)];
	if(session)then
		return session.stubs[strsub(questId,-1)];
	end
end


--I think I will document self function because it turned out too complicated
function VerisimilarPl:QuestLog_Update(...)
	if(self.db.char.mergeWithQuestInterface==false)then return end;
	if(event=="QUEST_LOG_UPDATE")then --We only update on QUEST_LOG_UPDATE events because the rest are useless. QUEST_LOG_CHANGED on abandoned quest? Ha...
		
		VerisimilarPl.questLog={}; --First, we reset the internal quest list, as well as the number of entries
		VerisimilarPl.numLogEntries=0; 
		VerisimilarPl.numLogQuests=0;
		local categoriesPointer=1; --When we need to determine if we need to add one of our own categories, self points to the next category in alphabetizedCategories to be considered.
		local questsPointer; --Whenever we are currently adding quests inside a header/category, self will point to the next custom quest to be added from questsPerCategory[category] (they are already sorted by level and name)
		local currentHeader; --self variable holds the current header we are adding quests under. It's only used for headers that have normal WoW quests, as the custom headers will add all their quests at the moment they are inserted thmselves
		local selectQuest; --If selectedQuest holds a quest name (in case of expanding/collapsing a header only), then self var will be assinged the new index for the quest in case it is hidden/revealed
		local numEntries, numQuests = self.hooks.GetNumQuestLogEntries()
		for i=1,numEntries do --We traverse the normal quest log
			local questTitle,questLevel,_,__,isHeader,isCollapsed=self.hooks.GetQuestLogTitle(i) --First, we get an entry, we don't know if it is a header or a quest yet
			if(isHeader)then --If it is a header...
				--Check to see if we have any left over custom quests from the last header
				if(VerisimilarPl.questsPerCategory[currentHeader] and not VerisimilarPl.questsPerCategory[currentHeader].isCollapsed)then
					local quest=VerisimilarPl.questsPerCategory[currentHeader][questsPointer]
					while(quest)do
						tinsert(VerisimilarPl.questLog,quest);
						if(quest.title==VerisimilarPl.selectedQuestName)then
							selectQuest=#VerisimilarPl.questLog;
						end
						questsPointer=questsPointer+1;
						quest=VerisimilarPl.questsPerCategory[currentHeader][questsPointer]
					end
				end
				questsPointer=1; --We reset the quests pointer
				currentHeader=questTitle; --We set it as the current header
				local category=VerisimilarPl.alphabetizedCategories[categoriesPointer] --We get the next eligible category from our alphabetized categories
				while(category and category<currentHeader)do --First, we check to see if there are still any categories left, and then add it if it is lower alphabeticaly than the current header
					tinsert(VerisimilarPl.questLog,category);
					if(VerisimilarPl.questsPerCategory[category].isCollapsed==nil)then --Also, if it is not collapsed, we add it's quests beneath it
						for j=1,#VerisimilarPl.questsPerCategory[category] do
							tinsert(VerisimilarPl.questLog,VerisimilarPl.questsPerCategory[category][j]);
							if(VerisimilarPl.questsPerCategory[category][j].title==VerisimilarPl.selectedQuestName)then
								selectQuest=#VerisimilarPl.questLog; --If that quest was the selected one when there was a category expansion/collapse, we need to save it's new index so we can reselect it
							end
						end
					end
					categoriesPointer=categoriesPointer+1;
					category=VerisimilarPl.alphabetizedCategories[categoriesPointer]
				end
				if(category==currentHeader)then --The above loop does not take into account finishing on a category that already has custom quests, so we advance the category pointer by one step
					categoriesPointer=categoriesPointer+1;
					VerisimilarPl.questsPerCategory[category].isCollapsed=isCollapsed --Also, we set out custom category's expansion status to be the same as the real one, for bookkeeping
				end
				tinsert(VerisimilarPl.questLog,i); --Finally, when we are done with the custom categories, we add our own
			else --If it is a quest...
				if(VerisimilarPl.questsPerCategory[currentHeader]==nil)then --If we don't have any custom quests in the current category, just add the normal ones
					tinsert(VerisimilarPl.questLog,i);
					if(questTitle==VerisimilarPl.selectedQuestName)then --Again, check to see if the quest was selected
						selectQuest=#VerisimilarPl.questLog;
					end
				else --We have custom quests under the current header, so we need to be careful
					local quest=VerisimilarPl.questsPerCategory[currentHeader][questsPointer] --First, we get the next eligible quest for entry
					while(quest and (quest.level>questLevel or (quest.level==questLevel and quest.title<questTitle)))do --If there IS a quest (we did not reach the end of the table), and it is higher level than the normal one we are holding back adding (and if it is the same, if it's title is lower alphabetically), then add it now
						tinsert(VerisimilarPl.questLog,quest);
						if(quest.title==VerisimilarPl.selectedQuestName)then --Again, check to see if the quest was selected
							selectQuest=#VerisimilarPl.questLog;
						end
						questsPointer=questsPointer+1;
						quest=VerisimilarPl.questsPerCategory[currentHeader][questsPointer]
					end
					tinsert(VerisimilarPl.questLog,i);
					if(questTitle==VerisimilarPl.selectedQuestName)then --Again, check to see if the quest was selected
						selectQuest=#VerisimilarPl.questLog;
					end
				end
			end
		end
		--The nomral quest log entries have ended, but it is still possible to have some leftover quests we need to add in the trail
		if(VerisimilarPl.questsPerCategory[currentHeader] and not VerisimilarPl.questsPerCategory[currentHeader].isCollapsed)then
			local quest=VerisimilarPl.questsPerCategory[currentHeader][questsPointer]
			while(quest)do
				tinsert(VerisimilarPl.questLog,quest);
				if(quest.title==VerisimilarPl.selectedQuestName)then
					selectQuest=#VerisimilarPl.questLog;
				end
				questsPointer=questsPointer+1;
				quest=VerisimilarPl.questsPerCategory[currentHeader][questsPointer]
			end
		end
		--And finally (for now), we need to add any left over custom categories
		local category=VerisimilarPl.alphabetizedCategories[categoriesPointer]
		while(category)do 
			tinsert(VerisimilarPl.questLog,category);
			if(VerisimilarPl.questsPerCategory[category].isCollapsed==nil)then --Also, if it is not collapsed, we add it's quests beneath it
				for j=1,#VerisimilarPl.questsPerCategory[category] do
					tinsert(VerisimilarPl.questLog,VerisimilarPl.questsPerCategory[category][j]);
					if(VerisimilarPl.questsPerCategory[category][j].title==VerisimilarPl.selectedQuestName)then
						selectQuest=#VerisimilarPl.questLog; --If that quest was the selected one when there was a category expansion/collapse, we need to save it's new index so we can reselect it
					end
				end
			end
			categoriesPointer=categoriesPointer+1;
			category=VerisimilarPl.alphabetizedCategories[categoriesPointer]
		end
		
		VerisimilarPl.numLogEntries=#VerisimilarPl.questLog; --We can now calculate the number of entries that are showing
		
		--Next, we add any left-over quests in the normal quest log that are NOT showing, and exist at the end of the index range
		local i=numEntries+1;
		local questTitle,questLevel=self.hooks.GetQuestLogTitle(i)
		while(questTitle)do
			tinsert(VerisimilarPl.questLog,i);
			if(questTitle==VerisimilarPl.selectedQuestName)then
				selectQuest=#VerisimilarPl.questLog;
			end
			i=i+1;
			questTitle,questLevel=self.hooks.GetQuestLogTitle(i)
		end
		
		--Now we calculate the number of quests, whether they are showing or not
		VerisimilarPl.numLogQuests=numQuests
		for category,quests in pairs(VerisimilarPl.questsPerCategory)do
			VerisimilarPl.numLogQuests=VerisimilarPl.numLogQuests+#quests;
			if(quests.isCollapsed==1)then --...and while we are traversing the quest categories anyway, we might as well add out own quests that don't show in the trail end
				for i=1,#quests do
					tinsert(VerisimilarPl.questLog,quests[i]);
					if(quests[i].title==VerisimilarPl.selectedQuestName)then
						selectQuest=#VerisimilarPl.questLog;
					end
				end
			end
		end
		--[[for i=1,#VerisimilarPl.questLog do
			self:Print(VerisimilarPl.questLog[i]);
		end]]
		
		if(selectQuest)then --A header was expanded or collapsed
			SelectQuestLogEntry(selectQuest)
		elseif(VerisimilarPl.selectedQuestName~="")then --It means that a quest was abandoned
		
			for i=1,#VerisimilarPl.questLog do
				questTitle,questLevel,_,__,isHeader=GetQuestLogTitle(i)
				if(not isHeader)then
					SelectQuestLogEntry(i)
					if(QuestLogFrame:IsVisible())then
						QuestLog_SetSelection(i)
					end
				end
			end
			
		end
		VerisimilarPl.selectedQuestName="";
		QuestMapUpdateAllQuests()
		self.hooks.QuestLog_Update(...)
	end
end


--[[function VerisimilarPl:QuestLog_OnEvent(frame,event,...)
	
	self.hooks.QuestLog_OnEvent(frame,event,...)
end]]

function VerisimilarPl:CheckKillObjective(session,mobName)

			for _,stub in pairs(session.stubs)do
				if(stub.type=="Quest" and stub.enabled and stub.onQuest)then
					for j=1,#stub.objectivesInfo do
						local objective=stub.objectivesInfo[j]
						if(objective.event=="Kill")then
							for i=1,#objective.filter do
								if(objective.filter[i]~="" and strfind(strlower(mobName),strlower(objective.filter[i])))then
									return true
								end
							end
						end
					end
				end
			end

end

function VerisimilarPl:CheckItemObjective(session,itemName)
	

			for _,stub in pairs(session.stubs)do
				if(stub.type=="Quest" and stub.enabled and stub.onQuest)then

					for j=1,#stub.objectivesInfo do
						local objective=stub.objectivesInfo[j]
						if(objective.event=="Item" and strlower(objective.filter[1])==strlower(itemName))then
							return true;
						end
					end
					
				end
			end

end


function VerisimilarPl:OFFER_QUEST(stub,offerType) --offerType: 1 - Element was enabled notification, just add to questlog, 2 - quest was just accepted, play sound and display message, 3 - Auto quest, also show pop-up
	
	stub.onQuest=true;
	stub.finished=false;
	self:CheckQuestCompletion(stub);
	for i=1,#stub.objectivesInfo do
		if(stub.objectivesInfo[i].event=="Item" and GetItemCount(stub.objectivesInfo[i].filter[1],true)>0)then
			self:SendSessionMessage(stub.session,nil,"EVENT_GAINED_ITEM",{n=stub.objectivesInfo[i].filter[1],a=GetItemCount(stub.objectivesInfo[i].filter[1],true)});
		end
	end
	if(not VerisimilarPl.questsPerCategory[stub.category])then
		VerisimilarPl.questsPerCategory[stub.category]={stub,isCollapsed=nil};
		local pos=1
		for i=1,#VerisimilarPl.alphabetizedCategories do
			if(stub.category>VerisimilarPl.alphabetizedCategories[i])then
				pos=pos+1;
			else
				break
			end
		end
		tinsert(VerisimilarPl.alphabetizedCategories,pos,stub.category);
	else
		local quests=VerisimilarPl.questsPerCategory[stub.category];
		local inserted=false;
		for i=1,#quests do
			if(stub.level>quests[i].level or (stub.level==quests[i].level and stub.title<quests[i].title))then
				tinsert(quests,i,stub);
				inserted=true;
				break;
			end
		end
		if(inserted==false)then
			tinsert(quests,stub);
		end
	end
	event="QUEST_LOG_UPDATE"
	VerisimilarPl.selectedQuestName=stub.title;
	VerisimilarPl:QuestLog_Update();
	local index=GetQuestLogSelection();
	if (
		VerisimilarPl.db.char.mergeWithQuestInterface==true and
		AUTO_QUEST_WATCH == "1" and 
		GetNumQuestWatches() < MAX_WATCHABLE_QUESTS 
		--and WatchFrame_GetRemainingSpace() >= WatchFrame_GetHeightNeededForQuest(index)
		) then
		AddQuestWatch(index);
		WatchFrame_OnEvent (WatchFrame, "QUEST_LOG_UPDATE")
	end
	VerisimilarPl:QuestListUpdated()
	self:UpdateMinimapQuestIcons()
	if(offerType>1)then
		PlaySound("QUESTADDED");
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME,"CHAT_MSG_SYSTEM","Quest accepted: "..stub.title,0,0,"",0,140);
		if(VerisimilarPl.db.char.mergeWithQuestInterface)then
			if(offerType==3)then
				tinsert(VerisimilarPl.autoQuestPopUps,{stub=stub,type="OFFER"});
				WatchFrame_Update(WatchFrame);
				WatchFrame_Expand(WatchFrame);
			end
		end
	end
end

StaticPopupDialogs["VERISIMILAR_ACCEPT_QUEST"] = {
		text = "Accept %s?",
		button1 = "Accept",
		button2 = "Decline",
		OnAccept = function()
			VerisimilarPl:AcceptCustomQuest();
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}

function VerisimilarPl:ShowQuestDetails(stub)
	VerisimilarPl.offeredQuest=stub;
	if(not VerisimilarPl.db.char.mergeWithQuestInterface)then
		self:Print("Quest Title:",VerisimilarPl.offeredQuest.title);
		self:Print("Quest Description:",self:SubSpecialChars(VerisimilarPl.offeredQuest.questDescription));
		self:Print("Quest Objectives:",self:SubSpecialChars(VerisimilarPl.offeredQuest.objectivesSummary));
		StaticPopup_Show("VERISIMILAR_ACCEPT_QUEST",VerisimilarPl.offeredQuest.title);
	else	
		QuestFrame_OnEvent(nil,"QUEST_DETAIL");
		for starterId,_ in pairs(stub.starters)do
			local NPCStub=stub.session.stubs[starterId];
			if(NPCStub and NPCStub.enabled and NPCStub.type=="NPC" and NPCStub.name==UnitName("target"))then
				SetPortraitTexture(QuestFramePortrait, "target");
				break;
			end
		end
		print("welp")
		self:ShowQuestNPCModel(stub)
	end
end

function VerisimilarPl:ShowQuestNPCModel(stub)
	if(stub.npcModelGUID)then
		QuestNPCModel:SetParent(QuestFrame);
		QuestNPCModel:ClearAllPoints();
		QuestNPCModel:SetPoint("TOPLEFT", QuestFrame, "TOPRIGHT", -33, -62);
		QuestNPCModel:Show();
		QuestFrame_UpdatePortraitText(stub.npcModelText);
		
		if (stub.npcModelName and stub.npcModelName ~= "") then
			QuestNPCModelNameplate:Show();
			QuestNPCModelBlankNameplate:Hide();
			QuestNPCModelNameText:Show();
			QuestNPCModelNameText:SetText(stub.npcModelName);
		else
			QuestNPCModelNameplate:Hide();
			QuestNPCModelBlankNameplate:Show();
			QuestNPCModelNameText:Hide();
		end
		QuestNPCModel:SetCreature(stub.npcModelGUID);
	end
end

function VerisimilarPl:AcceptCustomQuest()
	self:SendSessionMessage(VerisimilarPl.offeredQuest.session,VerisimilarPl.offeredQuest,"QUEST_ACCEPTED");
	--self.offeredQuest=nil;
end

StaticPopupDialogs["VERISIMILAR_CONTINUE_QUEST"] = {
		text = "Continue %s?",
		button1 = "Continue",
		button2 = "Cancel",
		OnAccept = function()
			--VerisimilarPl:ScheduleTimer("ShowQuestCompletion",1);
			VerisimilarPl:ShowQuestCompletion()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
function VerisimilarPl:QUEST_PROGRESS(stub)
	if(self.db.char.mergeWithQuestInterface)then
		tinsert(self.autoQuestPopUps,{stub=stub,type="COMPLETE"});
		WatchFrame_Update(WatchFrame);
		WatchFrame_Expand(WatchFrame);
	else
		self:ShowQuestProgress(stub);
	end
end


function VerisimilarPl:ShowQuestProgress(stub)
	self.offeredQuest=stub;
	
	if(not self.db.char.mergeWithQuestInterface)then
		if(stub.completed)then
			self:ShowQuestCompletion()
		else
			self:Print("Quest Title:",stub.title);
			self:Print("Quest Progress:",self:SubSpecialChars(stub.progressText));
			if(stub.completed)then
				StaticPopup_Show("VERISIMILAR_CONTINUE_QUEST",stub.title)
			end
		end
	else
		local hasItems=false;
		for i=1,#stub.objectivesInfo do
			if(stub.objectivesInfo[i].event=="Item")then
				hasItems=true;
				break;
			end
		end
		if((not stub.completed) or hasItems)then
			QuestFrame_OnEvent(nil,"QUEST_PROGRESS");
		else
			QuestFrame_OnEvent(nil,"QUEST_COMPLETE");
		end
		for enderId,_ in pairs(stub.enders) do
		local NPCStub=stub.session.stubs[enderId];
			if(NPCStub and NPCStub.enabled and NPCStub.type=="NPC" and NPCStub.name==UnitName("target"))then
				SetPortraitTexture(QuestFramePortrait, "target");
				break;
			end
		end
			
	end
end

StaticPopupDialogs["VERISIMILAR_COMPLETE_QUEST"] = {
		text = "Complete %s?",
		button1 = "Complete",
		button2 = "Cancel",
		OnAccept = function()
			VerisimilarPl:SendQuestCompleteConfirmation(VerisimilarPl.offeredQuest)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}

function VerisimilarPl:ShowQuestCompletion()
	self:Print("Quest Title:",VerisimilarPl.offeredQuest.title);
	self:Print("Completion Text:",self:SubSpecialChars(VerisimilarPl.offeredQuest.completionText));
	StaticPopup_Show("VERISIMILAR_COMPLETE_QUEST",VerisimilarPl.offeredQuest.title)
end

function VerisimilarPl:QUEST_COMPLETED(stub,wasJustCompleted)
	if(stub.onQuest and wasJustCompleted)then
		PlaySound("QUESTCOMPLETED")
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME,"CHAT_MSG_SYSTEM",stub.title.." completed.",0,0,"",0,140);
		VerisimilarPl.selectedQuestName=VerisimilarPl.offeredQuest.title;
		if(self.offeredQuest==stub)then
			QuestFrame:Hide();
		end
		self:RemoveFromQuestLog(stub);
		local nextQuest=stub.session.stubs[stub.nextQuest];
		if(nextQuest and nextQuest.enabled and nextQuest.available and not nextQuest.finished)then
			self:ShowQuestDetails(nextQuest);
		end
	end
	stub.finished=true
	self:UpdateMinimapQuestIcons()
end

local objAlertTable={a=true,n=false};
function VerisimilarPl:OBJECTIVE_UPDATED(stub,objectiveInfo)
	local obj=strbyte(strsub(objectiveInfo,1,1));
	local alert=objAlertTable[strsub(objectiveInfo,2,2)];
	local newValue=tonumber(strsub(objectiveInfo,3));
	
	stub.objectives[obj].value=newValue
	stub.objectives[obj].completed=(stub.objectives[obj].value==stub.objectivesInfo[obj].targetValue);
	self:CheckQuestCompletion(stub);
	QuestLog_Update();
	
	
		
	local index=GetQuestLogSelection()
	if ( AUTO_QUEST_PROGRESS == "1" and 
		 GetNumQuestLeaderBoards(index) > 0 and 
		 GetNumQuestWatches() < MAX_WATCHABLE_QUESTS
		  ) then
		AddQuestWatch(index,MAX_QUEST_WATCH_TIME);
	end
	WatchFrame_Update();
	WorldMapFrame_OnEvent(WorldMapFrame,"QUEST_POI_UPDATE");
	if(alert)then
		UIErrorsFrame_OnEvent(UIErrorsFrame, "UI_INFO_MESSAGE",stub.objectivesInfo[obj].text..": "..stub.objectives[obj].value.."/"..stub.objectivesInfo[obj].targetValue)
	end
	
	if(stub.completed and stub.autoComplete)then
		VerisimilarPl:QUEST_PROGRESS(stub);
	end
	self:UpdateMinimapQuestIcons()
end

function VerisimilarPl:IsQuestCompletable()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(VerisimilarPl.offeredQuest)then
			if(VerisimilarPl.offeredQuest.completed)then
				return true;
			else
				return false;
			end
		else
			return self.hooks.IsQuestCompletable();	
		end
end

function VerisimilarPl:GetTitleText()
	if(VerisimilarPl.offeredQuest)then
		return VerisimilarPl.offeredQuest.title;
	else
		return self.hooks.GetTitleText()
	end 
end

function VerisimilarPl:GetQuestText()
	if(VerisimilarPl.offeredQuest)then
		return self:SubSpecialChars(VerisimilarPl.offeredQuest.questDescription);
	else
		return unpack({self.hooks.GetQuestText()})
	end 
end

function VerisimilarPl:GetObjectiveText()
	if(VerisimilarPl.offeredQuest)then
		return self:SubSpecialChars(VerisimilarPl.offeredQuest.objectivesSummary);
	else
		return self.hooks.GetObjectiveText()
	end 
end

function VerisimilarPl:GetProgressText()
	if(VerisimilarPl.offeredQuest)then
		return self:SubSpecialChars(VerisimilarPl.offeredQuest.progressText);
	else
		return self.hooks.GetProgressText()
	end 
end

function VerisimilarPl:GetRewardText()
	if(VerisimilarPl.offeredQuest)then
		return self:SubSpecialChars(VerisimilarPl.offeredQuest.completionText);
	else
		return self.hooks.GetRewardText()
	end 
end

function VerisimilarPl:GetNumQuestRewards()
	if(VerisimilarPl.offeredQuest)then
		if(VerisimilarPl.offeredQuest.rewards~=nil)then
			local count=0;
			for i=1,#VerisimilarPl.offeredQuest.rewards do
				local item=VerisimilarPl.offeredQuest.session.stubs[VerisimilarPl.offeredQuest.rewards[i].id];
				if(item and item.enabled and VerisimilarPl.offeredQuest.rewards[i].choosable==false)then
					count=count+1;
				end
			end
			return count;
		else
			return 0;
		end
	else
		return self.hooks.GetNumQuestRewards()
	end 
end

function VerisimilarPl:GetNumQuestChoices()
	if(VerisimilarPl.offeredQuest)then
		if(VerisimilarPl.offeredQuest.rewards~=nil)then
			local count=0;
			for i=1,#VerisimilarPl.offeredQuest.rewards do
				local item=VerisimilarPl.offeredQuest.session.stubs[VerisimilarPl.offeredQuest.rewards[i].id];
				if(item and item.enabled and VerisimilarPl.offeredQuest.rewards[i].choosable==true)then
					count=count+1;
				end
			end
			return count;
		else
			return 0;
		end
	else
		return self.hooks.GetNumQuestChoices()
	end 
end

function VerisimilarPl:GetNumRewardCurrencies()
	if(VerisimilarPl.offeredQuest)then
		return 0;
	else
		return self.hooks.GetNumRewardCurrencies()
	end 
end

function VerisimilarPl:GetRewardSkillPoints()
	if(VerisimilarPl.offeredQuest)then
		return 0;
	else
		return self.hooks.GetRewardSkillPoints()
	end 
end

function VerisimilarPl:GetRewardSpell()
	if(VerisimilarPl.offeredQuest)then
		return nil;
	else
		return self.hooks.GetRewardSpell()
	end 
end

function VerisimilarPl:GetRewardMoney()
	if(VerisimilarPl.offeredQuest)then
		return 0;
	else
		return self.hooks.GetRewardMoney()
	end 
end

function VerisimilarPl:GetRewardHonor()
	if(VerisimilarPl.offeredQuest)then
		return 0;
	else
		return self.hooks.GetRewardHonor()
	end 
end

function VerisimilarPl:GetRewardTalents()
	if(VerisimilarPl.offeredQuest)then
		return 0;
	else
		return self.hooks.GetRewardTalents()
	end 
end

function VerisimilarPl:GetRewardTitle()
	if(VerisimilarPl.offeredQuest)then
		return nil;
	else
		return self.hooks.GetRewardTitle()
	end 
end

function VerisimilarPl:GetRewardXP()
	if(VerisimilarPl.offeredQuest)then
		return 0;
	else
		return self.hooks.GetRewardXP()
	end 
end

function VerisimilarPl:AcceptQuest()
	if(VerisimilarPl.offeredQuest)then
		VerisimilarPl:AcceptCustomQuest();
		QuestLog_Update();
		
		QuestFrame:Hide();
	else
		return self.hooks.AcceptQuest()
	end 
end

function VerisimilarPl:CompleteQuest()
	if(VerisimilarPl.offeredQuest)then
		QuestFrame_OnEvent(nil,"QUEST_COMPLETE");
	else
		return self.hooks.CompleteQuest()
	end 
end

function VerisimilarPl:GetQuestReward(itemChoice)
	if(self.offeredQuest)then
		local choice=nil;
		if(self.offeredQuest.rewards~=nil)then
			local count=0;
			for i=1,#self.offeredQuest.rewards do
				local item=self.offeredQuest.session.stubs[self.offeredQuest.rewards[i].id];
				if(item and item.enabled and self.offeredQuest.rewards[i].choosable==true)then
					count=count+1;
				end
			end
			choice=count;
		end
		self:SendSessionMessage(self.offeredQuest.session,self.offeredQuest,"TURN_IN_QUEST",choice);
	else
		return self.hooks.GetQuestReward(itemChoice);
	end 
end

function VerisimilarPl:DeclineQuest()
	if(VerisimilarPl.offeredQuest)then
		QuestFrame:Hide();
		QuestLog_Update();
	else
		return self.hooks.DeclineQuest()
	end 
end

function VerisimilarPl:GetNumQuestLogEntries()
	return VerisimilarPl.numLogEntries, VerisimilarPl.numLogQuests
end

function VerisimilarPl:GetQuestLogSelection()
	return VerisimilarPl.questLogSelectedQuestIndex
end

function VerisimilarPl:GetQuestLogTitle(index)
	if(#VerisimilarPl.questLog==0)then
			event="QUEST_LOG_UPDATE";
			QuestLog_Update();
	end
	if(VerisimilarPl.questLog[index]==nil)then
		return nil;
	end
	if(type(VerisimilarPl.questLog[index])=="table")then
		local quest=VerisimilarPl.questLog[index];
		return quest.title,quest.level, quest.questTag, quest.suggestedGroup or 0, nil, nil, quest.completed, quest.isDaily,quest.id;
	elseif(type(VerisimilarPl.questLog[index])=="string")then
		local header=VerisimilarPl.questsPerCategory[VerisimilarPl.questLog[index]]
		return VerisimilarPl.questLog[index],0, nil, 0, 1, header.isCollapsed, nil, nil;
	else
		local info={self.hooks.GetQuestLogTitle(VerisimilarPl.questLog[index])}
		for i=1,9 do
			if(info[i]==nil)then info[i]=false end
		end
		return unpack(info);
	end
end

function VerisimilarPl:SelectQuestLogEntry(index)
	
	if(type(VerisimilarPl.questLog[index])=="table")then
		VerisimilarPl.questLogSelectedQuestIndex=index
	elseif(type(VerisimilarPl.questLog[index])=="number")then
		local _,__,___,____,isHeader = self.hooks.GetQuestLogTitle(VerisimilarPl.questLog[index])
		if(not isHeader)then
			VerisimilarPl.questLogSelectedQuestIndex=index
			self.hooks.SelectQuestLogEntry(VerisimilarPl.questLog[index])
		end
	end
end

function VerisimilarPl:ExpandQuestHeader(index)
	VerisimilarPl.selectedQuestName=GetQuestLogTitle(VerisimilarPl.questLogSelectedQuestIndex)
	if(index==0)then
		for _,category in pairs(VerisimilarPl.questsPerCategory)do
			category.isCollapsed=nil;
		end
		self.hooks.ExpandQuestHeader(0);
	elseif(type(VerisimilarPl.questLog[index])=="string")then
		VerisimilarPl.questsPerCategory[VerisimilarPl.questLog[index]].isCollapsed=nil;
	else
		self.hooks.ExpandQuestHeader(VerisimilarPl.questLog[index]);
	end
	event="QUEST_LOG_UPDATE"
	VerisimilarPl:QuestLog_Update();
	VerisimilarPl.selectedQuestName=""
end

function VerisimilarPl:CollapseQuestHeader(index)
	VerisimilarPl.selectedQuestName=GetQuestLogTitle(VerisimilarPl.questLogSelectedQuestIndex)
	if(index==0)then
		for _,category in pairs(VerisimilarPl.questsPerCategory)do
			category.isCollapsed=1;
		end
		self.hooks.CollapseQuestHeader(0);
	elseif(type(VerisimilarPl.questLog[index])=="string")then
		VerisimilarPl.questsPerCategory[VerisimilarPl.questLog[index]].isCollapsed=1;
	else
		self.hooks.CollapseQuestHeader(VerisimilarPl.questLog[index]);
	end	
	event="QUEST_LOG_UPDATE"
	VerisimilarPl:QuestLog_Update();
	VerisimilarPl.selectedQuestName=""
end

function VerisimilarPl:IsCurrentQuestFailed()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return selectedQuest.failed;
		else
			return self.hooks.IsCurrentQuestFailed();	
		end
end



function VerisimilarPl:GetQuestLogQuestText()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return self:SubSpecialChars(selectedQuest.questDescription), self:SubSpecialChars(selectedQuest.objectivesSummary);
		else
			return unpack({self.hooks.GetQuestLogQuestText()});	
		end
end

function VerisimilarPl:GetQuestLogTimeLeft()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return selectedQuest.timeLeft;
		else
			return self.hooks.GetQuestLogTimeLeft();	
		end
end

function VerisimilarPl:GetNumQuestLeaderBoards(questIndex)
		if(questIndex)then
			local selectedQuest=VerisimilarPl.questLog[questIndex];
			if(type(selectedQuest)=="table")then
				return #selectedQuest.objectives;
			else
				return self.hooks.GetNumQuestLeaderBoards(selectedQuest);	
			end
		else
			local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
			if(type(selectedQuest)=="table")then
				return #selectedQuest.objectives;
			else
				return self.hooks.GetNumQuestLeaderBoards();	
			end
		end
		

end

function VerisimilarPl:GetQuestLogLeaderBoard(i,questIndex)
		if(questIndex)then
			local selectedQuest=VerisimilarPl.questLog[questIndex];
			if(type(selectedQuest)=="table")then
				return selectedQuest.objectivesInfo[i].text..": "..selectedQuest.objectives[i].value.."/"..selectedQuest.objectivesInfo[i].targetValue, "object",selectedQuest.objectives[i].completed;
			else
				return unpack({self.hooks.GetQuestLogLeaderBoard(i,VerisimilarPl.questLog[questIndex])});	
			end
		else
			local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
			if(type(selectedQuest)=="table")then
				return selectedQuest.objectivesInfo[i].text..": "..selectedQuest.objectives[i].value.."/"..selectedQuest.objectivesInfo[i].targetValue, "object",selectedQuest.objectives[i].completed;
			else
				return unpack({self.hooks.GetQuestLogLeaderBoard(i)});	
			end
		end
end

function VerisimilarPl:GetQuestLogRequiredMoney()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return 0;
		else
			return self.hooks.GetQuestLogRequiredMoney();	
		end
end

function VerisimilarPl:GetQuestLogGroupNum()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return selectedQuest.groupNum or 0;
		else
			return self.hooks.GetQuestLogGroupNum();	
		end
end

function VerisimilarPl:GetNumQuestLogRewards()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			if(selectedQuest.rewards~=nil)then
				local count=0;
				for i=1,#selectedQuest.rewards do
					local item=selectedQuest.session.stubs[selectedQuest.rewards[i].id];
					if(item and item.enabled and selectedQuest.rewards[i].choosable==false)then
						count=count+1;
					end
				end
				return count;
			else
				return 0;
			end
		else
			return self.hooks.GetNumQuestLogRewards();	
		end
end

function VerisimilarPl:GetNumQuestLogChoices()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			if(selectedQuest.rewards~=nil)then
				local count=0;
				for i=1,#selectedQuest.rewards do
					local item=selectedQuest.session.stubs[selectedQuest.rewards[i].id];
					if(item and item.enabled and selectedQuest.rewards[i].choosable==true)then
						count=count+1;
					end
				end
				return count;
			else
				return 0;
			end
		else
			return self.hooks.GetNumQuestLogChoices();	
		end
end

function VerisimilarPl:GetNumQuestLogRewardCurrencies()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return 0; --Maybe I should implement currencies at some point
		else
			return self.hooks.GetNumQuestLogRewardCurrencies();	
		end
end

function VerisimilarPl:GetQuestLogRewardMoney()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return 0;
		else
			return self.hooks.GetQuestLogRewardMoney();	
		end
end

function VerisimilarPl:GetQuestLogRewardTalents()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return 0;
		else
			return self.hooks.GetQuestLogRewardTalents();	
		end
end

function VerisimilarPl:GetQuestLogRewardSkillPoints()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return 0;
		else
			return self.hooks.GetQuestLogRewardSkillPoints();	
		end
end

function VerisimilarPl:GetQuestLogRewardTitle()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return nil;
		else
			return self.hooks.GetQuestLogRewardTitle();	
		end
end

function VerisimilarPl:GetQuestLogRewardSpell()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return nil;
		else
			return unpack({self.hooks.GetQuestLogRewardSpell()});	
		end
end

function VerisimilarPl:GetNumQuestWatches()
	return self.hooks.GetNumQuestWatches()+#VerisimilarPl.questWatch
end


function VerisimilarPl:AddQuestWatch(questIndex,watchTime)

		if(event=="QUEST_WATCH_UPDATE")then
			self.hooks.AddQuestWatch(questIndex,watchTime);
		elseif(type(VerisimilarPl.questLog[questIndex])=="table" and VerisimilarPl:IsQuestWatched(questIndex)==nil)then
			tinsert(VerisimilarPl.questWatch,{stub=VerisimilarPl.questLog[questIndex],currentTime=0,watchTime=watchTime});
		elseif(type(VerisimilarPl.questLog[questIndex])=="number")then
			self.hooks.AddQuestWatch(VerisimilarPl.questLog[questIndex],watchTime);
		end
end

function VerisimilarPl:GetQuestIndexForWatch(watchIndex)
		if(#VerisimilarPl.questLog==0)then
			event="QUEST_LOG_UPDATE";
			QuestLog_Update();
		end
		if(watchIndex<=self.hooks.GetNumQuestWatches())then
			local realIndex=self.hooks.GetQuestIndexForWatch(watchIndex);
			for i=1,#VerisimilarPl.questLog do
				if(VerisimilarPl.questLog[i]==realIndex)then
					return i;
				end
			end
		else
			for i=1,#VerisimilarPl.questLog do
				if(VerisimilarPl.questLog[i]==VerisimilarPl.questWatch[watchIndex-self.hooks.GetNumQuestWatches()].stub)then
					return i;
				end
			end
		end
		
end

function VerisimilarPl:IsQuestWatched(questIndex)
		if(type(VerisimilarPl.questLog[questIndex])=="table")then
			for i=1,#VerisimilarPl.questWatch do
				if(VerisimilarPl.questWatch[i].stub==VerisimilarPl.questLog[questIndex])then
					return 1;
				end
			end
		elseif(type(VerisimilarPl.questLog[questIndex])=="number")then
			return self.hooks.IsQuestWatched(VerisimilarPl.questLog[questIndex]);
		end
		return nil;
end

function VerisimilarPl:RemoveQuestWatch(questIndex)
		if(type(VerisimilarPl.questLog[questIndex])=="table")then
			for i=1,#VerisimilarPl.questWatch do
				if(VerisimilarPl.questWatch[i] and VerisimilarPl.questWatch[i].stub==VerisimilarPl.questLog[questIndex])then
					tremove(VerisimilarPl.questWatch,i);
				end
			end
		elseif(type(VerisimilarPl.questLog[questIndex])=="number")then
			self.hooks.RemoveQuestWatch(VerisimilarPl.questLog[questIndex]);
		end
end

function VerisimilarPl:SetAbandonQuest()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			VerisimilarPl.abandonQuest=selectedQuest;
		else
			VerisimilarPl.abandonQuest=nil;
			return self.hooks.SetAbandonQuest();	
		end
end

function VerisimilarPl:AbandonQuest()
		if(self.abandonQuest)then
			self:AbandonQuestStub(self.abandonQuest)
			
		else
			self.hooks.AbandonQuest();	
		end
		
end

function VerisimilarPl:AbandonQuestStub(stub)
	self:SendSessionMessage(self.abandonQuest.session,self.abandonQuest,"ABANDON_QUEST");
	self:RemoveFromQuestLog(self.abandonQuest);
	self.abandonQuest=nil;
	PlaySound("igQuestCancel");
end

function VerisimilarPl:GetAbandonQuestName()
		if(VerisimilarPl.abandonQuest)then
			return VerisimilarPl.abandonQuest.title;
		else
			return self.hooks.GetAbandonQuestName();	
		end
end

function VerisimilarPl:GetQuestLink(questIndex)
		if(type(VerisimilarPl.questLog[questIndex])=="table")then
			local quest=VerisimilarPl.questLog[questIndex];
			return "[Verisimilar quests cannon be linked]";
		elseif(type(VerisimilarPl.questLog[questIndex])=="number")then
			return self.hooks.GetQuestLink(VerisimilarPl.questLog[questIndex]);
		end
end

function VerisimilarPl:GetQuestLogPushable()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(VerisimilarPl.offeredQuest)then
			return nil;
		else
			return self.hooks.GetQuestLogPushable();	
		end
end

function VerisimilarPl:GetQuestLogChoiceInfo(itemIndex)
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			local count=0;
			for i=1,#selectedQuest.rewards do
				local item=selectedQuest.session.stubs[selectedQuest.rewards[i].id];
				if(item and item.enabled and selectedQuest.rewards[i].choosable==true)then
					count=count+1;
					if(count==itemIndex)then
						if(item.enabled)then
							return item.name, "Interface\\Icons\\"..item.icon, selectedQuest.rewards[i].amount, 100,true
						else
							count=count-1;
						end
					end
				end
			end
		else
			return unpack({self.hooks.GetQuestLogChoiceInfo(itemIndex)});	
		end
end

function VerisimilarPl:GetQuestLogRewardInfo(itemIndex)
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			local count=0;
			for i=1,#selectedQuest.rewards do
				local item=selectedQuest.session.stubs[selectedQuest.rewards[i].id];
				if(item and item.enabled and selectedQuest.rewards[i].choosable==false)then
					count=count+1;
					if(count==itemIndex)then
						return item.name, "Interface\\Icons\\"..item.icon, selectedQuest.rewards[i].amount, 100,true
					end
				end
			end
		else
			return unpack({self.hooks.GetQuestLogRewardInfo(itemIndex)});	
		end
end

function VerisimilarPl:GetQuestLogRewardXP()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return 0
		else
			return self.hooks.GetQuestLogRewardXP()
		end
end

function VerisimilarPl:IsUnitOnQuest(index,unit)
	if(VerisimilarPl.questLog[index]==nil)then
		return nil;
	end
	if(type(VerisimilarPl.questLog[index])=="table")then
		return nil
	else
		return unpack({self.hooks.IsUnitOnQuest(VerisimilarPl.questLog[index],unit)});
	end
end

function VerisimilarPl:QuestLogPushQuest()
		local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
		if(type(selectedQuest)=="table")then
			return nil;
		else
			return unpack({self.hooks.QuestLogPushQuest()});	
		end
end

function VerisimilarPl:GetQuestLogCompletionText(questIndex)
	if(type(VerisimilarPl.questLog[questIndex])=="table")then
		local quest=VerisimilarPl.questLog[questIndex];
		return self:SubSpecialChars(quest.returnToText);
	elseif(type(VerisimilarPl.questLog[questIndex])=="number")then
		return self.hooks.GetQuestLogCompletionText(VerisimilarPl.questLog[questIndex]);
	end
end

function VerisimilarPl:GetQuestItemInfo(itemType, itemNum)
	if(VerisimilarPl.offeredQuest)then
		local switch;
		if(itemType=="reward")then
			switch=false;
		elseif(itemType=="choice")then
			switch=true;
		elseif(itemType=="required")then
			local count=0;
			for i=1,#VerisimilarPl.offeredQuest.objectivesInfo do
				local wItem=VerisimilarPl.offeredQuest.objectivesInfo[i].filter[1];
				local icon=GetItemIcon(wItem, true);
				local itemStub=VerisimilarPl.offeredQuest.session.stubs[wItem];
				if(VerisimilarPl.offeredQuest.objectivesInfo[i].event=="Item" and (icon or (itemStub and itemStub.type=="Item" and itemStub.enabled)))then
					count=count+1;
					if(count==itemNum)then
						if(icon~=nil)then
							return wItem, icon,VerisimilarPl.offeredQuest.objectives[i].targetValue
						else
							return itemStub.name,"Interface\\Icons\\"..itemStub.icon,VerisimilarPl.offeredQuest.objectivesInfo[i].targetValue
						end
					end
				end
			end
		end
		local count=0;
		for i=1,#VerisimilarPl.offeredQuest.rewards do
			local item=VerisimilarPl.offeredQuest.session.stubs[VerisimilarPl.offeredQuest.rewards[i].id];
			if(item and item.enabled and VerisimilarPl.offeredQuest.rewards[i].choosable==switch)then
				count=count+1;
				if(count==itemNum)then
					return item.name, "Interface\\Icons\\"..item.icon, VerisimilarPl.offeredQuest.rewards[i].amount, 100,true
				end
			end
		end
	else
		return unpack({self.hooks.GetQuestItemInfo(itemType, itemNum)})
	end 
end

function VerisimilarPl:SetQuestItem(tooltip,itemType, itemNum)
	if(VerisimilarPl.offeredQuest)then
		local switch;
		if(itemType=="reward")then
			switch=false;
		elseif(itemType=="choice")then
			switch=true;
		elseif(itemType=="required")then
			return nil;
		end
		local count=0;
		local button;
		for i=1,10 do
			button=_G["QuestInfoItem"..i]
			if(button.type==itemType and button:GetID()==itemNum)then break end
		end
		for i=1,#VerisimilarPl.offeredQuest.rewards do
			local item=VerisimilarPl.offeredQuest.session.stubs[VerisimilarPl.offeredQuest.rewards[i].id];
			if(item and item.enabled and VerisimilarPl.offeredQuest.rewards[i].choosable==switch)then
				count=count+1;
				if(count==itemNum)then
					VerisimilarPl:ShowItemTooltip(item,button);
				end
			end
		end
	else
		self.hooks[GameTooltip].SetQuestItem(tooltip,itemType, itemNum)
	end 
end

function VerisimilarPl:SetQuestLogItem(tooltip,itemType, itemNum)
	local selectedQuest=VerisimilarPl.questLog[VerisimilarPl.questLogSelectedQuestIndex];
	if(type(selectedQuest)=="table")then
		local switch;
		if(itemType=="reward")then
			switch=false;
		elseif(itemType=="choice")then
			switch=true;
		elseif(itemType=="required")then
			return nil;
		end
		local count=0;
		local button;
		for i=1,10 do
			button=_G["QuestInfoItem"..i]
			if(button.type==itemType and button:GetID()==itemNum)then break end
		end
		for i=1,#selectedQuest.rewards do
			local item=selectedQuest.session.stubs[selectedQuest.rewards[i].id];
			if(item and item.enabled and selectedQuest.rewards[i].choosable==switch)then
				count=count+1;
				if(count==itemNum)then
					VerisimilarPl:ShowItemTooltip(item,button);
				end
			end
		end
	else
		self.hooks[GameTooltip].SetQuestLogItem(tooltip,itemType, itemNum)
	end
end

function VerisimilarPl:GetNumQuestItems()
	if(VerisimilarPl.offeredQuest)then
		local count=0;
		for i=1,#VerisimilarPl.offeredQuest.objectivesInfo do
			if(VerisimilarPl.offeredQuest.objectivesInfo[i].event=="Item")then
				count=count+1;
			end
		end
		if(count>6)then count=6 end
		return count;
	else
		return self.hooks.GetNumQuestItems()
	end 
end

function VerisimilarPl:QuestFrameHiden()
	if(VerisimilarPl.offeredQuest)then
		VerisimilarPl.offeredQuest.autoQuest=nil;
		VerisimilarPl.offeredQuest=nil;
		WatchFrame_Update();
	end
end


function VerisimilarPl:GetQuestLogSpecialItemInfo(questIndex)
	if(type(VerisimilarPl.questLog[questIndex])=="table")then
		local quest=VerisimilarPl.questLog[questIndex];
		local item=quest.session.stubs[quest.specialItem]
		if(item)then
			return item.name,"Interface\\Icons\\"..item.icon,0
		end
	elseif(type(VerisimilarPl.questLog[questIndex])=="number")then
		return unpack({self.hooks.GetQuestLogSpecialItemInfo(VerisimilarPl.questLog[questIndex])});
	end
end

function VerisimilarPl:UseQuestLogSpecialItem(questIndex)
	if(type(VerisimilarPl.questLog[questIndex])=="table")then
		local quest=VerisimilarPl.questLog[questIndex];
		local item=quest.session.stubs[quest.specialItem]
		if(item)then
			VerisimilarPl:ItemStubClicked(item)
		end
	end
end

function VerisimilarPl:IsQuestLogSpecialItemInRange(questIndex)
	if(type(VerisimilarPl.questLog[questIndex])=="table")then
		local quest=VerisimilarPl.questLog[questIndex];
		if(quest.session.stubs[quest.specialItem])then
			return self:IsItemStubInRange(quest.session.stubs[quest.specialItem]);
		end
	elseif(type(VerisimilarPl.questLog[questIndex])=="number")then
		return self.hooks.IsQuestLogSpecialItemInRange(VerisimilarPl.questLog[questIndex]);
	end
end

function VerisimilarPl:GetQuestLogSpecialItemCooldown(questIndex)
	if(type(VerisimilarPl.questLog[questIndex])=="table")then
		local quest=VerisimilarPl.questLog[questIndex];
		local item=quest.session.stubs[quest.specialItem]
		if(item)then
			return item.cdStart,item.cdDuration,1
		else
			return 0,0,0
		end
	elseif(type(VerisimilarPl.questLog[questIndex])=="number")then
		return unpack({self.hooks.GetQuestLogSpecialItemCooldown(VerisimilarPl.questLog[questIndex])});
	end
end

function VerisimilarPl:SetQuestLogSpecialItem(tooltip,questIndex)
	if(type(VerisimilarPl.questLog[questIndex])=="table")then
		local quest=VerisimilarPl.questLog[questIndex];
		local item=quest.session.stubs[quest.specialItem]
		local button=_G["WatchFrameItem1"];
		local i=1
		while(button)do
			if(button:IsVisible() and button:GetID()==questIndex)then break end
			i=i+1
			button=_G["WatchFrameItem"..i]
		end
		if(item)then
			VerisimilarPl:ShowItemTooltip(item,button,"ANCHOR_RIGHT")
		end
	elseif(type(VerisimilarPl.questLog[questIndex])=="number")then
		self.hooks[GameTooltip].SetQuestLogSpecialItem(tooltip,VerisimilarPl.questLog[questIndex])
	end 
end

function VerisimilarPl:QuestMapUpdateAllQuests()
	local WoWQuests=self.hooks.QuestMapUpdateAllQuests()
	VerisimilarPl.questPOIList={}
	for i=1,WoWQuests do
		local questID, realLogIndex=self.hooks.QuestPOIGetQuestIDByVisibleIndex(i)
		if(self.hooks.IsQuestWatched(realLogIndex)==nil)then
			break
		end
		local logIndex;
		for j=1,#VerisimilarPl.questLog do
			if(VerisimilarPl.questLog[j]==realLogIndex)then
				logIndex=j
				break;
			end
		end
		tinsert(VerisimilarPl.questPOIList,{questID=questID,logIndex=logIndex})
	end
	for i=self.hooks.GetNumQuestWatches()+1,GetNumQuestWatches() do
		if(VerisimilarPl:CheckForQuestPois(VerisimilarPl.questLog[GetQuestIndexForWatch(i)]))then 
			tinsert(VerisimilarPl.questPOIList,{questID=VerisimilarPl.questLog[GetQuestIndexForWatch(i)].id,logIndex=GetQuestIndexForWatch(i)})
		end
	end
	for i=1,#VerisimilarPl.questLog do
		local logEntry=VerisimilarPl.questLog[i];
		if(type(logEntry)=="table")then
			if(VerisimilarPl:CheckForQuestPois(logEntry) and not IsQuestWatched(i))then 
				tinsert(VerisimilarPl.questPOIList,{questID=logEntry.id,logIndex=i})
			end
		elseif(type(logEntry)=="number")then
			local questTitle,___,_,__,isHeader=self.hooks.GetQuestLogTitle(logEntry)
			if(not isHeader and not self.hooks.IsQuestWatched(logEntry))then
				for j=1,WoWQuests do
					local questID, realLogIndex=self.hooks.QuestPOIGetQuestIDByVisibleIndex(j)
					if(realLogIndex==logEntry)then
						tinsert(VerisimilarPl.questPOIList,{questID=questID,logIndex=i})
						break
					end
				end
			end
		end
	end
	
	return #VerisimilarPl.questPOIList;
end

function VerisimilarPl:CheckForQuestPois(stub)
	if(stub==nil)then return false end
	if(stub.completed)then
		for enderId,_ in pairs(stub.enders) do
			local ender= stub.session.stubs[enderId];
			if(ender and ender.enabled==true and ender.type=="NPC" and ender.zone==GetRealZoneText())then
				return true;
			end
		end
		return false;
	end
	local zone=GetCurrentMapAreaID();
	local level=GetCurrentMapDungeonLevel();
	for i=1,#stub.objectivesInfo do
		if(stub.objectivesInfo[i].zone==zone and stub.objectivesInfo[i].level==level and not stub.objectives[i].completed)then
			return true
		end
	end
	return false
end

function VerisimilarPl:QuestPOIGetQuestIDByVisibleIndex(index)
	return VerisimilarPl.questPOIList[index].questID,VerisimilarPl.questPOIList[index].logIndex
end

function VerisimilarPl:QuestPOIGetIconInfo(questId)
	if(type(questId)=="string")then
		local quest
		for _,session in pairs(VerisimilarPl.sessions)do
			if(session.stubs[questId])then
				quest=session.stubs[questId]
				break
			end
		end
		local zone=GetCurrentMapAreaID();
		local level=GetCurrentMapDungeonLevel();
		if(quest.completed)then
			local closestEnder;
			local shortestDist=99999999999999999;
			local x,y=GetPlayerMapPosition("player");
			for enderId,_ in pairs(stub.enders) do
				local ender= quest.session.stubs[enderId];
				if(ender and ender.enabled==true and ender.type=="NPC" and ender.zone==zone)then
					local xdist=x-ender.coordX;
					local ydist=y-ender.coordY;
					local dist=sqrt(xdist*xdist+ydist*ydist);
					if(dist<shortestDist)then
						closestEnder=ender;
						shortestDist=dist;
					end
					
				end
			end
			if(closestEnder)then
				return 1,closestEnder.coordX,closestEnder.coordY,1;
			else
				return 1,0,0,1
			end
		else
			local closestObj=0;
			local shortestDist=99999999999999999;
			local x,y=GetPlayerMapPosition("player");
			for i=1,#quest.objectivesInfo do
				if(quest.objectivesInfo[i].zone==zone and quest.objectivesInfo[i].level==level and not quest.objectives[i].completed)then
					local xdist=x-quest.objectivesInfo[i].x;
					local ydist=y-quest.objectivesInfo[i].y;
					local dist=sqrt(xdist*xdist+ydist*ydist);
					if(dist<shortestDist)then
						closestObj=i;
						shortestDist=dist;
					end
				end
			end
			if(closestObj>0)then
				quest.closestObjective=closestObj;
				return 1,quest.objectivesInfo[closestObj].x,quest.objectivesInfo[closestObj].y,1
			else
				return 1,0,0,1
			end
		end
		
	else
		return unpack({self.hooks.QuestPOIGetIconInfo(questId)})
	end 
end

function VerisimilarPl:QuestPOIUpdateIcons()
	self.hooks.QuestPOIUpdateIcons() 
end

function VerisimilarPl:GetQuestPOILeaderBoard(questPOIIndex,questLogIndex) --I still don't understand when this one get's called...
	if(type(VerisimilarPl.questLog[questLogIndex])=="table")then
	--if(false)then	
		
	else
		
		return unpack({self.hooks.GetQuestPOILeaderBoard(questPOIIndex,VerisimilarPl.questLog[questLogIndex])})
	end 
end

function VerisimilarPl:GetNumQuestItemDrops(questLogIndex)
	if(type(VerisimilarPl.questLog[questLogIndex])=="table")then
		if(VerisimilarPl.questLog[questLogIndex].closestObjective)then
			return 1;
		else
			return 0;
		end
	else
		
		return self.hooks.GetNumQuestItemDrops(VerisimilarPl.questLog[questLogIndex])
	end 
end

function VerisimilarPl:GetQuestLogItemDrop(i,questLogIndex)
	if(type(VerisimilarPl.questLog[questLogIndex])=="table")then
		local stub=VerisimilarPl.questLog[questLogIndex];
		if(stub.closestObjective)then
			return stub.objectivesInfo[i].text..": "..stub.objectives[i].value.."/"..stub.objectivesInfo[i].targetValue,"item",stub.objectives[stub.closestObjective].completed;
		else
			return ;
		end
	else
		
		return unpack({self.hooks.GetQuestLogItemDrop(i,VerisimilarPl.questLog[questLogIndex])})
	end 
end

function VerisimilarPl:GetQuestWorldMapAreaID(questId)
	if(type(questId)=="string")then
		return 0,0
		
	else
		return unpack({self.hooks.GetQuestWorldMapAreaID(questId)})
	end 
end

function VerisimilarPl:QuestPOI_HideButtons(parentName, buttonType, buttonIndex) --I don't know, it's definitely my error on another hook, but right now this is the easiest solution...
	local numButtons;
		
	numButtons = 20
	if ( numButtons ) then
		local poiButton;
		local buttonName = "poi"..parentName..buttonType.."_";
		for i = buttonIndex, numButtons do
			poiButton = _G[buttonName..i];
			if ( poiButton and poiButton.isSelected and poiButton.type == QUEST_POI_COMPLETE_SWAP ) then
				QuestPOI_DeselectButton(poiButton);
			end
			if(poiButton)then
				poiButton:Hide();
			end
		end
	end
end

function VerisimilarPl:GetNumAutoQuestPopUps()
	return self.hooks.GetNumAutoQuestPopUps()+#self.autoQuestPopUps;
end

function VerisimilarPl:GetAutoQuestPopUp(popUpId)
	if(popUpId>self.hooks.GetNumAutoQuestPopUps())then
		local popUp=self.autoQuestPopUps[popUpId-self.hooks.GetNumAutoQuestPopUps()];
		return self:GetQuestIDFromStub(popUp.stub),popUp.type;
		
	else
		return unpack({self.hooks.GetAutoQuestPopUp(popUpId)})
	end 
end

function VerisimilarPl:RemoveAutoQuestPopUp(questId)
	if(tonumber(questId)==nil)then
		local stub=self:GetStubFromQuestID(questId);
		for i=1,#self.autoQuestPopUps do
			if(self.autoQuestPopUps[i].stub==stub)then
				tremove(self.autoQuestPopUps,i);
				--stub.autoQuest=nil;
				return
			end
		end
		
	else
		return unpack({self.hooks.RemoveAutoQuestPopUp(questId)})
	end 
end

function VerisimilarPl:GetQuestLogIndexByID(questId)
	if(tonumber(questId)==nil)then
		local stub=self:GetStubFromQuestID(questId);
		if(stub)then
			for i=1,#self.questLog do
				if(self.questLog[i]==stub)then
					return i
				end
			end
		end
		
	else
		return unpack({self.hooks.GetQuestLogIndexByID(questId)})
	end 
end

function VerisimilarPl:ShowQuestOffer(questLogIndex)
	local stub=self.questLog[questLogIndex];
	if(type(stub)=="table")then
		stub.autoQuest=true;
		self.offeredQuest=stub;
		QuestFrame_OnEvent(nil,"QUEST_DETAIL");
		self:ShowQuestNPCModel(stub);
	else
		self.hooks.ShowQuestOffer(stub)
	end 
end

function VerisimilarPl:ShowQuestComplete(questLogIndex)
	local stub=self.questLog[questLogIndex];
	if(type(stub)=="table")then
		stub.autoQuest=true;
		self.offeredQuest=stub;
		self:ShowQuestProgress(stub);
	else
		self.hooks.ShowQuestComplete(stub)
	end 
end

function VerisimilarPl:QuestGetAutoAccept()
	if(self.offeredQuest)then
		return self.offeredQuest.autoQuest;
	else
		return self.hooks.QuestGetAutoAccept()
	end 
end

function VerisimilarPl:GetQuestLogIsAutoComplete(questIndex)
	if(questIndex==nil and self.offeredQuest)then
		return self.offeredQuest.autoQuest;
	end
	if(type(self.questLog[questIndex])=="table")then
		return self.questLog[questIndex].autoComplete or self.questLog[questIndex].autoQuest;
	elseif(type(self.questLog[questIndex])=="number")then
		return self.hooks.GetQuestLogIsAutoComplete(self.questLog[questIndex]);
	end
end