local questPanel,poi;
local GetPlayerQuestInfo, OfferQuest, ResetQuest,CompleteQuest, setObjectiveValue, GetQuestGiverInfo, SetStarter, RemoveStarter,SetObjText, GetObjText, SetEnder, RemoveEnder,SetPOIasPlayer,RemovePOI,PoiClick,GetNextQuestMenu,SetPoiCoords, GetPoiX,GetPoiY,SetObjTarget,setSmartObjFilter, GetObjTarget,SetObjFilter, GetObjFilter,SetReward,RemoveReward,AddObjective,GetQuestObjTypeMenu,RemoveObjective,SetAmount,SetChoice,GetRewards, GetRewardInfo, GetQuestObjectivesMenu, GetQuests, GetQuestChainInfo,SetPrevious,RemovePrevious, GetSpecialItemMenu, SetTargetNPC, GetPlayers, GetGuestGivers;
function VerisimilarGM:InitializeQuestPanel()
		
	StaticPopupDialogs["VERISIMILAR_NEW_QUEST"] = {
		text = "Enter the Quest ID. The \"ID\" is just a codeword used to refer to this quest within Verisimilar GM, not the quest title visible to the players, which you will add later. 30 characters max, no space or special characters",
		button1 = "Create",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data)
			local Quest=data:NewQuest(self.editBox:GetText());
			if(Quest)then
				VerisimilarGM:AddElementToElementList(Quest);
				VerisimilarGM:UpdateElementList();
				VerisimilarGM:SetPanelToElement(Quest);
			end
		end,
		OnHide = function(self)
					self.editBox:SetText("")
				end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_SET_QUEST_OBJECTIVE_VALUE"] = {
		text = "Enter the objective number and the new value separated by commas (for example, type '3,1' if you want to set the third objective to the value of 1. Don't type the quotes.)",
		button1 = "Set value",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data,data2)
			local Quest=data;
			if(Quest)then
				local players=data2;
				obj,value=strsplit(",",self.editBox:GetText());
				for i=1,#players do
					Quest:SetObjectiveValue(players[i],tonumber(obj),tonumber(value));
					Quest:CheckCompletion(players[i]);
				end
				VerisimilarGM:UpdateInterface();
			end
		end,
		OnHide = function(self)
					self.editBox:SetText("")
				end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_SET_QUEST_REWARD_AMOUNT"] = {
		text = "Enter the reward amount",
		button1 = "Set amount",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data,data2)
			local quest=data;
			if(quest)then
				local elements=data2;
				for i=1,#elements do
					for j=1,quest:GetNumQuestRewards()do
						if(elements[i]==quest:GetQuestReward(j))then
							quest:SetQuestRewardAmount(j,tonumber(self.editBox:GetText()) or 1);
							break;
						end
					end
				end
				VerisimilarGM:UpdateInterface();
			end
		end,
		OnHide = function(self)
					self.editBox:SetText("")
				end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	local description={
						{text="Assign",showOnEnabled=true,showOnDisabled=true,
							{type="List", key="playerList",x=10,y=-25,width=300,height=300,showOfflineControls=true,updateFunc=GetPlayers,infoFunc=GetPlayerQuestInfo,columns={
																																	{label="Name",width=50},
																																	{label="Quest Status"},
																																	{label="Obj1",width=40},
																																	{label="Obj2",width=40},
																																	{label="Obj3",width=40},
																																},
							},
							{type="Button", key="offerQuest",label="Give Quest",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=5,y=-10, clickFunc=OfferQuest ,tooltip="Give the quest to the selected players"},
							{type="Button", key="resetQuest",label="Reset Quest",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=ResetQuest ,tooltip="Reset the current quest for the selected players, removing it from their quest logs and making it available again if they have completed it"},
							{type="Button", key="completeQuest",label="Complete Quest",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=CompleteQuest ,tooltip="If the selected player are on the quest and have completed it's objectives, they will be presented with the quest completion screen"},
							{type="Button", key="setObjective",label="Set Objective Value",refFrame="offerQuest",refPoint="BOTTOMLEFT",x=0,y=-10, clickFunc=setObjectiveValue ,tooltip="Set a new value for an objective for the selected players"},
							
							
						},
						{text="General",showOnEnabled=false,showOnDisabled=true,
							{type="EditBox", key="title",label="Title",labelPosition="LEFT",x=55,y=-15,width=300,setFunc=function(editBox,title)VerisimilarGM:GetActiveElement():SetTitle(title);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTitle(); end,tooltip="The title of the quest"},
							{type="EditBox", key="level",label="Level",labelPosition="LEFT",x=0,y=-15,refFrame="PREVIOUS",refPoint="BOTTOMLEFT",width=30,numeric=true,setFunc=function(editBox,level)VerisimilarGM:GetActiveElement():SetLevel(level);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetLevel(); end,tooltip="The level of the quest will not prevent anyone from accepting it, it's merely an indicator of it's difficulty"},
							{type="EditBox", key="category",label="Category",labelPosition="LEFT",x=0,y=-15,refFrame="PREVIOUS",refPoint="BOTTOMLEFT",width=135,setFunc=function(editBox,category)VerisimilarGM:GetActiveElement():SetCategory(category);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetCategory(); end,tooltip="The category of the quest, as it will appear in the quest log"},
							{type="List", key="giverList",x=10,y=-130,width=600,height=300,updateFunc=GetGuestGivers,infoFunc=GetQuestGiverInfo,columns={
																																	{label="Id",width=130},
																																	{label="Name"},
																																	{label="Status",width=90},
																																},
							},
							{type="Button", key="setStarter",label="Set Starter",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=5,y=0, clickFunc=SetStarter ,tooltip="Set the selected elements to start this quest/act as questgivers"},
							{type="Button", key="removeStarter",label="Remove Starter",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=RemoveStarter ,tooltip="Remove the questgiver status from the selected elements"},
							{type="Button", key="setEnder",label="Set Ender",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=SetEnder ,tooltip="Set the selected elements to allow a player to turn in the quest when completed"},
							{type="Button", key="removeEnder",label="Remove Ender",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=RemoveEnder ,tooltip="The selected elements will no longer allow players to turn in quests"},
							{type="DropDown", key="specialItem",label="Special item:",x=300,y=-60, width=200, menuFunc=GetSpecialItemMenu, tooltip="This item will be given to the player when he accepts the quest. It will appear as a button in the quest watch frame"},
						},
						
						{text="Description",showOnEnabled=false,showOnDisabled=true,
							{type="LargeEditBox", key="description",label="Quest description",x=15,y=-15,width=300,height=400,setFunc=function(editBox,description)VerisimilarGM:GetActiveElement():SetQuestDescription(description);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetQuestDescription(); end,tooltip="This is the 'In-character' description of the quest, as narrated by the quest giver"},
							{type="LargeEditBox", key="objSummary",label="Objectives summary",x=330,y=-15,width=300,height=200,setFunc=function(editBox,summary)VerisimilarGM:GetActiveElement():SetObjectivesSummary(summary);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetObjectivesSummary(); end,tooltip="This is a short summary of the quest objectives"},
						},
						{text="Completion",showOnEnabled=false,showOnDisabled=true,
							{type="LargeEditBox", key="progressText",label="Progress text",x=15,y=-15,width=300,height=100,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetProgressText(text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetProgressText(); end,tooltip="This text will appear if the player tries to turn in the quest before completing the objectives"},
							{type="LargeEditBox", key="returnToText",label="Return-to text",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-15,width=300,height=50,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetReturnToText(text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetReturnToText(); end,tooltip="This text appears in the quest watch window when the player has completed the objectives, and informs him about where to turn-in the quest"},
							{type="LargeEditBox", key="completionText",label="Completion text",x=330,y=-15,width=300,height=200,setFunc=function(text)VerisimilarGM:GetActiveElement():SetCompletionText(editBox,text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetCompletionText(); end,tooltip="This text will appear when the player is given the option to complete the quest"},
							{type="CheckButton", key="autoComplete",label="Quest is auto-completable",refFrame="returnToText",refPoint="BOTTOMLEFT",x=0,y=-15,width=100, clickFunc=function(button,state)VerisimilarGM:GetActiveElement():SetAutoComplete(state);end,checkFunc=function() return VerisimilarGM:GetActiveElement():IsAutoComplete();end,tooltip="The option to complete the quest will automatically appear as soon as the player completes the quest objectives"},
							{type="List", key="rewardList",x=20,y=-250,width=580,height=250,updateFunc=GetRewards,infoFunc=GetRewardInfo,columns={
																																	{label="Id",width=130},
																																	{label="Name"},
																																	{label="Reward",width=80},
																																	{label="Amount",width=55},
																																},
							},
							{type="Button", key="setReward",label="Set Reward",width=120,refFrame="PREVIOUS",refPoint="TOPRIGHT",x=-10,y=-20, clickFunc=SetReward ,tooltip="Set the selected items to be rewarded upon completion of the quest"},
							{type="Button", key="setChoice",label="Set Choice",width=120,refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-10, clickFunc=SetChoice ,tooltip="Set the selected items to be presented to the player as a choice upon completion of the quest"},
							{type="Button", key="setAmount",label="Set Amount",width=120,refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-10, clickFunc=SetAmount ,tooltip="Set the amount of the selected rewards"},
							{type="Button", key="removeReward",label="Remove Reward",width=120,refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-10, clickFunc=RemoveReward ,tooltip="Remove the selected items from being rewards for this quest"},
						},
						{text="Objectives",showOnEnabled=false,showOnDisabled=true,
							{type="DropDown", key="objective",label="Objective:",x=45,y=-5, width=200,labelPosition="LEFT", menuFunc=GetQuestObjectivesMenu, tooltip="Select one of the quest objectives to edit"},
							{type="Button", key="addObjective",label="Add Objective",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=AddObjective ,tooltip="Add a new objective to this quest"},
							{type="Button", key="removeObjective",label="Remove Objective",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=RemoveObjective ,tooltip="Remove the currently selected objective from the quest"},
							{type="EditBox", key="objText",label="Text:",x=55,y=-40,width=200,labelPosition="LEFT",setFunc=SetObjText, getFunc=GetObjText,tooltip="The objective text, for example 'Scourge slain'"},
							{type="EditBox", key="objTarget",label="Target value:",x=100,y=0,width=30,labelPosition="LEFT",numeric=true,refFrame="PREVIOUS",refPoint="TOPRIGHT",setFunc=SetObjTarget, getFunc=GetObjTarget,tooltip="The target value that the player has to reach to complete the objective, for example the number of enemies he needs to kill or items to gather"},
							{type="DropDown", key="objType",label="Type:",x=0,y=-10, width=100, labelPosition="LEFT",refFrame="objText",refPoint="BOTTOMLEFT", menuFunc=GetQuestObjTypeMenu, tooltip="Select type of the objective. Kill requires the player to kill creatures, Item is about gathering items, and Script is for use within scripts"},
							{type="EditBox", key="objFilter",label="",x=70,y=0,width=200,labelPosition="LEFT",refFrame="PREVIOUS",refPoint="TOPRIGHT",setFunc=SetObjFilter, getFunc=GetObjFilter,tooltip=""},
							{type="Button", key="smartObjFilter",label="",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0,width=160, clickFunc=setSmartObjFilter ,tooltip=""},
							{type="EditBox", key="poiX",label="X:",coordinates=true,x=25,y=-110,width=60,labelPosition="LEFT",setFunc=SetPoiCoords, getFunc=GetPoiX,tooltip="The X coordinates for the objective mark on the map"},
							{type="EditBox", key="poiY",label="Y:",coordinates=true,refFrame="PREVIOUS",refPoint="TOPRIGHT",x=25,y=0,width=60,labelPosition="LEFT",setFunc=SetPoiCoords, getFunc=GetPoiY,tooltip="The Y coordinates for the objective mark on the map"},
							{type="Button", key="setPOIasPlayer",label="Set as my position",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=SetPOIasPlayer ,tooltip="Set the objective's map and coordinates as your current position"},
							{type="Button", key="removePOI",label="Remove objective area",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=RemovePOI ,tooltip="Set this objective to not correspond to any area in the world"},
							{type="Area", key="poiPicker",x=0,y=-140,clickFunc=PoiClick,setFunc=function(areaControl,zone,level) VerisimilarGM:GetActiveElement():SetObjectivePOIZone(questPanel.controls.objective.selection,zone,level) end, getFunc=function(areaControl) return VerisimilarGM:GetActiveElement():GetObjectivePOIZone(questPanel.controls.objective.selection) end,},
						},
						{text="Quest Chain",showOnEnabled=false,showOnDisabled=true,
							{type="DropDown", key="nextQuest",label="Next quest:",x=25,y=-25, width=200, menuFunc=GetNextQuestMenu, tooltip="Upon completion, the player will be offered this quest if it's available to him"},
							{type="List", key="questList",x=10,y=-130,width=600,height=300,updateFunc=GetQuests,infoFunc=GetQuestChainInfo,columns={
																																	{label="Id",width=130},
																																	{label="Title"},
																																	{label="Previous",width=90},
																																},
							},
							{type="Button", key="setPrevious",label="Set Previous",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=5,y=0, clickFunc=SetPrevious ,tooltip="Set the selected quests as previous to this one. A player must complete all previous quests before this quests will become available to him. If you want this quest to automatically be offered to the player upon completion of all previous quests, you will have to set his quext as 'next' in each of it's previous quests"},
							{type="Button", key="removePrevious",label="Remove Previous",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=RemovePrevious ,tooltip="Remove selected quests from being previous to this one"},
						},
						{text="NPC Model",showOnEnabled=false,showOnDisabled=true,
							{type="Button", key="setTargetNPC",label="Set as the target NPC",x=15,y=-15, clickFunc=SetTargetNPC ,tooltip="Target an NPC, and click this button to set the GUID and NPC's name"},
							{type="EditBox", key="npcGUID",label="NPC GUID:",numeric=true,labelPosition="LEFT",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=60,y=-15,width=135,setFunc=function(editBox,guid)VerisimilarGM:GetActiveElement():SetNPCModelGUID(guid);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetNPCModelGUID(); end,tooltip="The GUID that describes the NPC. You can find this through sites like WoWHead.com, or just click the above button to set it automatically"},
							{type="EditBox", key="npcName",label="NPC Name:",labelPosition="LEFT",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-15,width=135,setFunc=function(editBox,name)VerisimilarGM:GetActiveElement():SetNPCModelName(name);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetNPCModelName(); end,tooltip="The name of the NPC"},
							{type="LargeEditBox", key="npcDescription",label="NPC description",labelPosition="LEFT",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=-60,y=-30,width=300,height=200,setFunc=function(editBox,description)VerisimilarGM:GetActiveElement():SetNPCModelText(description);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetNPCModelText(); end,tooltip="This description appears below the NPC model"},
						},
						{text="Scripts 1",showOnEnabled=false,showOnDisabled=true,
							{type="LargeEditBox", key="acceptScript",label="Accept Script:",x=10,y=-15,width=650,height=160,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetAcceptScript(text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetAcceptScript(); end,},
							{type="LargeEditBox", key="objectiveScript",label="Objectives Script:",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-15,width=650,height=160,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetObjectivesScript(text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetObjectivesScript(); end,},
							{type="LargeEditBox", key="availabilityScript",label="Availability Script:",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-15,width=650,height=160,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetAvailabilityScript(text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetAvailabilityScript(); end,},
						},
						{text="Scripts 2",showOnEnabled=false,showOnDisabled=true,
							{type="LargeEditBox", key="completionScript",label="Completion Script:",x=10,y=-15,width=650,height=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetCompletionScript(text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetCompletionScript(); end,},
							{type="LargeEditBox", key="abandonScript",label="Abandon Script:",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-15,width=650,height=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetAbandonScript(text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetAbandonScript(); end,},
						},
					}
	
	questPanel=self:CreateElementPanel("Quest",description)
	
	poi=CreateFrame("Frame",nil,questPanel.controls.poiPicker);
	poi:SetWidth(20);
	poi:SetHeight(20);
	poi:SetFrameLevel(questPanel.controls.poiPicker.Map:GetFrameLevel()+1);
	poi.texture=poi:CreateTexture();
	poi.texture:SetAllPoints(poi);
	poi.texture:SetTexture("Interface\\WorldMap\\UI-QuestPoi-NumberIcons");
	poi.texture:SetTexCoord(0.52,0.60,0.39,0.48);
end

GetPlayers=function(list,showOffline)
	local quest=VerisimilarGM:GetActiveElement();
	local session=quest:GetSession();
	local totalentries, onlineentries=0,0
	
	for _,player in pairs(session.players)do
		totalentries=totalentries+1;
		if(player.connected)then
			onlineentries=onlineentries+1;
		end
		if(player.connected or showOffline)then
			list:Insert(player,player.connected);
		end
	end
	return totalentries, onlineentries;
end

local obj={};
GetPlayerQuestInfo=function(player)
	local quest=VerisimilarGM:GetActiveElement();
	local questInfo=player.elements[quest.id]

	local status=(questInfo.finished and "Finished") or (questInfo.onQuest and "On Quest") or (questInfo.available and "Available") or "Unavailable";
	for i=1,3 do
		obj[i]=questInfo.onQuest and (questInfo.objectives[i] and questInfo.objectives[i].currentValue.."/"..quest:GetObjectiveTargetValue(i));
	end
	return player.name,status,obj[1],obj[2],obj[3];
end


GetGuestGivers=function(list)
	local quest=VerisimilarGM:GetActiveElement();
	local session=quest:GetSession();

	for _,element in pairs(session.elements)do
		if(element.elType=="NPC" or element.elType=="Item" or element.elType=="Area")then 
			list:Insert(element,element:IsEnabled());
		end
	end
end

GetQuestGiverInfo=function(element)
	local quest=VerisimilarGM:GetActiveElement();
	local isStarter=quest:IsStarter(element);
	local isEnder=quest:IsEnder(element);
	local status=(isStarter and isEnder and "Starter & Ender") or (isStarter and "Starter") or (isEnder and "Ender") or "";
	return element.id,element.name,status;
end

OfferQuest=function(button)
	local players=questPanel.controls.playerList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#players do
		quest:Offer(players[i]);
	end
	VerisimilarGM:UpdateInterface()
end

ResetQuest=function(button)
	local players=questPanel.controls.playerList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#players do
		quest:Reset(players[i]);
	end
	VerisimilarGM:UpdateInterface()
end

CompleteQuest=function(button)
	local players=questPanel.controls.playerList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#players do
		quest:ShowProgress(players[i]);
	end
end

setObjectiveValue=function(button)
	local players=questPanel.controls.playerList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	local dialog=StaticPopup_Show ("VERISIMILAR_SET_QUEST_OBJECTIVE_VALUE");
	if (dialog) then
		dialog.data  = quest;
		dialog.data2=players;
	end
end

SetStarter=function(button)
	local elements=questPanel.controls.giverList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#elements do
		quest:AddStarter(elements[i]);
	end
	VerisimilarGM:UpdateInterface()
end

RemoveStarter=function(button)
	local elements=questPanel.controls.giverList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#elements do
		quest:RemoveStarter(elements[i]);
	end
	VerisimilarGM:UpdateInterface()
end

SetEnder=function(button)
	local elements=questPanel.controls.giverList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#elements do
		quest:AddEnder(elements[i]);
	end
	VerisimilarGM:UpdateInterface()
end

RemoveEnder=function(button)
	local elements=questPanel.controls.giverList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#elements do
		quest:RemoveEnder(elements[i]);
	end
	VerisimilarGM:UpdateInterface()
end

local function SpecialItemClicked(button,quest,item)
	quest:SetSpecialItem(item);
	VerisimilarGM:UpdateInterface();
end

GetSpecialItemMenu=function()
	local quest=VerisimilarGM:GetActiveElement();
	local session=quest:GetSession();
	local menu={};
	local item=quest:GetSpecialItem();
	for _,element in pairs(session.elements)do
		if(element.elType=="Item")then
			tinsert(menu,{text=element.id.." - "..element.name,checked=element==item,func=SpecialItemClicked,arg1=quest,arg2=element});
		end
	end
	tinsert(menu,{text="None",checked=item==nil,func=SpecialItemClicked,arg1=quest,arg2=nil})
	return menu;
end

GetRewards=function(list)
	local quest=VerisimilarGM:GetActiveElement();
	local session=quest:GetSession();

	for _,element in pairs(session.elements)do
		if(element.elType=="Item")then 
			list:Insert(element,element:IsEnabled());
		end
	end
end


GetRewardInfo=function(element)
	local quest=VerisimilarGM:GetActiveElement();
	local status,amount="No","";
	for i=1,quest:GetNumQuestRewards()do
		if(element==quest:GetQuestReward(i))then
			if(quest:GetQuestRewardChoosability(i))then
				status="Choice";
			else
				status="Yes";
			end
			amount=quest:GetQuestRewardAmount(i);
		end
	end
	return element.id,element.name,status,amount;
end

SetReward=function(button)
	local elements=questPanel.controls.rewardList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#elements do
		local exists=false
		for j=1,quest:GetNumQuestRewards()do
			if(elements[i]==quest:GetQuestReward(j))then
				quest:SetQuestRewardChoosability(j,false);
				exists=true;
			end
		end
		if(not exists)then
			quest:AddQuestReward()
			quest:SetQuestReward(quest:GetNumQuestRewards(),elements[i])
			quest:SetQuestRewardChoosability(quest:GetNumQuestRewards(),false);
			quest:SetQuestRewardAmount(quest:GetNumQuestRewards(),1);
		end
	end
	VerisimilarGM:UpdateInterface()
end

SetChoice=function(button)
	local elements=questPanel.controls.rewardList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#elements do
		local exists=false
		for j=1,quest:GetNumQuestRewards()do
			if(elements[i]==quest:GetQuestReward(j))then
				quest:SetQuestRewardChoosability(j,true);
				exists=true;
			end
		end
		if(not exists)then
			quest:AddQuestReward()
			quest:SetQuestReward(quest:GetNumQuestRewards(),elements[i])
			quest:SetQuestRewardChoosability(quest:GetNumQuestRewards(),true);
			quest:SetQuestRewardAmount(quest:GetNumQuestRewards(),1);
		end
	end
	VerisimilarGM:UpdateInterface()
end

SetAmount=function(button)
	local elements=questPanel.controls.rewardList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	local dialog=StaticPopup_Show ("VERISIMILAR_SET_QUEST_REWARD_AMOUNT");
	if (dialog) then
		dialog.data  = quest;
		dialog.data2=elements;
	end
end

RemoveReward=function(button)
	local elements=questPanel.controls.rewardList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#elements do
		for j=1,quest:GetNumQuestRewards()do
			if(elements[i]==quest:GetQuestReward(j))then
				quest:RemoveQuestReward(j);
				break;
			end
		end
	end
	VerisimilarGM:UpdateInterface()
end

local function NextQuestClicked(button,quest,nextQuest)
	quest:SetNextQuest(nextQuest);
	VerisimilarGM:UpdateInterface();
end

GetNextQuestMenu=function()
	local quest=VerisimilarGM:GetActiveElement();
	local session=quest:GetSession();
	local menu={};
	local nextQuest=quest:GetNextQuest();
	for _,element in pairs(session.elements)do
		if(element.elType=="Quest" and element~=quest)then
			tinsert(menu,{text=element.id.." - "..element:GetTitle(),checked=element==nextQuest,func=NextQuestClicked,arg1=quest,arg2=element});
		end
	end
	tinsert(menu,{text="None",checked=nextQuest==nil,func=NextQuestClicked,arg1=quest,arg2=nil})
	return menu;
end

GetQuests=function(list)
	local quest=VerisimilarGM:GetActiveElement();
	local session=quest:GetSession();

	for _,element in pairs(session.elements)do
		if(element.elType=="Quest" and element~=quest)then 
			list:Insert(element,element:IsEnabled());
		end
	end
end

GetQuestChainInfo=function(element)
	local quest=VerisimilarGM:GetActiveElement();
	return element.id,element.title,(quest:IsPreviousQuest(element) and "Yes") or "No";
end

SetPrevious=function(button)
	local elements=questPanel.controls.questList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#elements do
		quest:AddPreviousQuest(elements[i]);
	end
	VerisimilarGM:UpdateInterface()
end

RemovePrevious=function(button)
	local elements=questPanel.controls.questList:GetSelectedEntries();
	local quest=VerisimilarGM:GetActiveElement();
	for i=1,#elements do
		quest:RemovePreviousQuest(elements[i]);
	end
	VerisimilarGM:UpdateInterface()
end

SetTargetNPC=function(button)
	local controls=questPanel.controls;
	local npcGUID=UnitGUID("target");
	if(npcGUID and strsub(npcGUID,5,5)=="3")then
		controls.npcGUID:SetText(tonumber(strsub(npcGUID,7,10),16));
		controls.npcGUID:setFunc(controls.npcGUID:GetText());
		controls.npcName:SetText(UnitName("target"));
		controls.npcName:setFunc(controls.npcName:GetText());
	else
		controls.npcGUID:SetText("");
		controls.npcGUID:setFunc();
		controls.npcName:SetText("");
		controls.npcName:setFunc("");
	end
end

local function ObjectiveClicked(button,objectiveNum)
	local controls=questPanel.controls;
	local quest=VerisimilarGM:GetActiveElement();

	controls.objText:Hide();
	controls.objTarget:Hide();
	controls.objType:Hide();
	controls.objFilter:Hide();
	controls.smartObjFilter:Hide();
	controls.poiPicker:Hide();
	controls.poiX:Hide();
	controls.poiY:Hide();
	controls.setPOIasPlayer:Hide();
	controls.removePOI:Hide();
	controls.objective.selection=objectiveNum;

	if(objectiveNum)then
		controls.objText:Show();
		controls.objTarget:Show();
		controls.objType:Show();
		controls.objFilter:Show();
		controls.smartObjFilter:Show();
		controls.poiX:Show();
		controls.poiY:Show();
		controls.setPOIasPlayer:Show();
		controls.removePOI:Show();
		controls.poiPicker:Show();
	end
	VerisimilarGM:UpdateInterface();
end

GetQuestObjectivesMenu=function(ddList)
	local quest=VerisimilarGM:GetActiveElement();
	local menu={};
	for i=1,#quest.objectives do
		tinsert(menu,{text=""..i.." - "..quest:GetObjectiveText(i),checked=ddList.selection==i,func=ObjectiveClicked,arg1=i});
	end
	menu.func=ObjectiveClicked;
	return menu;
end

AddObjective=function(button)
	local quest=VerisimilarGM:GetActiveElement();
	quest:AddObjective();
	ObjectiveClicked(nil,#quest.objectives)
	VerisimilarGM:UpdateInterface()
end


RemoveObjective=function(button)
	local objDD=questPanel.controls.objective;
	local quest=VerisimilarGM:GetActiveElement();
	if(objDD.selection)then
		quest:RemoveObjective(objDD.selection);
	end
	ObjectiveClicked(nil,((#quest.objectives>0) and 1) or nil)
	VerisimilarGM:UpdateInterface()
end

SetObjText=function(editBox,text)
	local objDD=questPanel.controls.objective;
	local quest=VerisimilarGM:GetActiveElement();
	if(objDD.selection)then
		quest:SetObjectiveText(objDD.selection,text)
	end
end

GetObjText=function(editBox)
	local objDD=questPanel.controls.objective;
	local quest=VerisimilarGM:GetActiveElement();
	if(objDD.selection)then
		return quest:GetObjectiveText(objDD.selection)
	end
end

SetObjTarget=function(editBox,target)
	local objDD=questPanel.controls.objective;
	local quest=VerisimilarGM:GetActiveElement();
	if(objDD.selection)then
		quest:SetObjectiveTargetValue(objDD.selection,target)
	end
end

GetObjTarget=function(editBox)
	local objDD=questPanel.controls.objective;
	local quest=VerisimilarGM:GetActiveElement();
	if(objDD.selection)then
		return quest:GetObjectiveTargetValue(objDD.selection)
	end
end

local labels={Kill="Mob name:",Item="Item ID:",Area="Area ID:",Script="Event string:"}
local tooltips={Kill="Enter the name of the mob the player must kill to complete this objective.",Item="Select the item the player needs to find to complete this objective",Area="Select the area the player needs to enter to complete this objective",Script="Enter a unique string for this objective"}
local buttonLabels={Kill="Set as my target",Item="Select from a list",Area="Select from a list",Script="Generate unique string"}
local buttonTooltips={Kill="Target a mob, and then click this button to set it as the quest objective",Item="Select an item from the drop down list that will be this quest objective",Area="Select an area from the drop down list that will be this quest objective",Script="Generate a unique string to be used as an event within scripts for this objective"}
local function ObjTypeClicked(button,objType)
	local controls=questPanel.controls;
	local quest=VerisimilarGM:GetActiveElement();
	
	controls.objType.selection=objType;
	
	controls.objFilter.label:SetText(labels[objType] or "");
	controls.objFilter.tooltip=tooltips[objType] or "";
	controls.smartObjFilter:SetText(buttonLabels[objType] or "");
	controls.smartObjFilter.tooltip=buttonTooltips[objType] or "";
	quest:RegisterEvent(controls.objective.selection,objType)
	
	VerisimilarGM:UpdateInterface();
end

GetQuestObjTypeMenu=function(ddList)
	local quest=VerisimilarGM:GetActiveElement();
	local menu={};
	local event=quest:GetObjectiveEvent(questPanel.controls.objective.selection)

	for i=1,#VerisimilarPl.eventList do
		tinsert(menu,{text=VerisimilarPl.eventList[i],checked=event==VerisimilarPl.eventList[i],func=ObjTypeClicked,arg1=VerisimilarPl.eventList[i]});
	end
	menu.func=ObjTypeClicked;
	return menu;
end

SetObjFilter=function(editBox,filter)
	local objDD=questPanel.controls.objective;
	local quest=VerisimilarGM:GetActiveElement();
	if(objDD.selection)then
		quest:SetEventFilter(objDD.selection,filter)
	end
end

GetObjFilter=function(editBox)
	local objDD=questPanel.controls.objective;
	local quest=VerisimilarGM:GetActiveElement();
	if(objDD.selection)then
		return quest:GetEventFilter(objDD.selection)
	end
end

local function ObjItemClicked(button,itemID)
	local controls=questPanel.controls;
	local quest=VerisimilarGM:GetActiveElement();
	
	controls.objFilter:SetText(itemID);
	quest:SetEventFilter(controls.objective.selection,itemID)
	
end

local dummyDD=CreateFrame("Frame","VerisimilarGMDummyDropDown",nil,"UIDropDownMenuTemplate")
setSmartObjFilter=function(button)
	local objDD=questPanel.controls.objective;
	local filter=questPanel.controls.objFilter;
	local quest=VerisimilarGM:GetActiveElement();
	local objType=quest:GetObjectiveEvent(objDD.selection);
	if(objType=="Kill")then
		local targetName=UnitName("target") or "";
		filter:SetText(targetName);
		quest:SetEventFilter(objDD.selection,targetName)
	elseif(objType=="Item")then
		local session=quest:GetSession();
		local menu={};
				
		for id, element in pairs(session.elements)do
			if(element.elType=="Item")then
				tinsert(menu,{text=id.." - "..element:GetName(),func=ObjItemClicked,arg1=id});
			end
		end
		EasyMenu(menu, dummyDD, button, 0, 0, nil, 10);
	elseif(objType=="Area")then
		local session=quest:GetSession();
		local menu={};
				
		for id, element in pairs(session.elements)do
			if(element.elType=="Area")then
				tinsert(menu,{text=id,func=ObjItemClicked,arg1=id});
			end
		end
		EasyMenu(menu, dummyDD, button, 0, 0, nil, 10);
	elseif(objType=="Script")then
		local unique="Quest_"..quest.id.."_Obj_"..objDD.selection.."_Event";
		filter:SetText(unique);
		quest:SetEventFilter(objDD.selection,unique)
	end
end

local function SetPoiSign(x,y)
	if(x==0 and y==0)then
		poi:Hide();
	else
		local map=questPanel.controls.poiPicker.Map;
		local scale=map:GetEffectiveScale();
		poi:SetPoint("CENTER", map, "TOPLEFT",x*map:GetWidth()*scale,-y*map:GetHeight()*scale);
		poi:Show();
	end	
end

SetPoiCoords=function(editBox)
	local controls=questPanel.controls;
	local quest=VerisimilarGM:GetActiveElement();
	local x=tonumber(controls.poiX:GetText());
	local y=tonumber(controls.poiY:GetText());
	if(controls.objective.selection)then
		quest:SetObjectivePOICoordinates(controls.objective.selection,x,y)
	end
	SetPoiSign(x,y);
end

GetPoiX=function(editBox)
	local objDD=questPanel.controls.objective;
	local quest=VerisimilarGM:GetActiveElement();
	if(objDD.selection)then
		local x,y=quest:GetObjectivePOICoordinates(objDD.selection)
		SetPoiSign(x,y) --Yeah, kind of a hack, but it works
		return x
	end
end

GetPoiY=function(editBox)
	local objDD=questPanel.controls.objective;
	local quest=VerisimilarGM:GetActiveElement();
	if(objDD.selection)then
		local _,y=quest:GetObjectivePOICoordinates(objDD.selection)
		return y;
	end
end

PoiClick=function(area,x,y)
	local controls=questPanel.controls;
	local quest=VerisimilarGM:GetActiveElement();
	
	controls.poiX:SetText(x);
	controls.poiY:SetText(y);
	if(controls.objective.selection)then
		quest:SetObjectivePOICoordinates(controls.objective.selection,x,y);
	end
	
	SetPoiSign(x,y);
end

SetPOIasPlayer=function(button)
	local controls=questPanel.controls;
	SetMapToCurrentZone();
	local zoneId=GetCurrentMapAreaID();
	local level=GetCurrentMapDungeonLevel();
	local x,y=GetPlayerMapPosition("player");
	controls.poiX:SetText(x);
	controls.poiY:SetText(y);
	SetPoiSign(x,y);
	VerisimilarGM:GetActiveElement():SetObjectivePOICoordinates(controls.objective.selection,x,y);
	VerisimilarGM:GetActiveElement():SetObjectivePOIZone(controls.objective.selection,zoneId,level);
	VerisimilarGM:UpdateInterface();
end

RemovePOI=function(button)
	local controls=questPanel.controls;
	controls.poiX:SetText(0);
	controls.poiY:SetText(0);
	VerisimilarGM:GetActiveElement():SetObjectivePOICoordinates(controls.objective.selection,0,0);
	VerisimilarGM:GetActiveElement():SetObjectivePOIZone(controls.objective.selection,0,0);
	poi:Hide();
	VerisimilarGM:UpdateInterface();
end

function VerisimilarGM:SetPanelToQuest()
	local quest=VGMMainFrame.controlPanel.element;
	VGMMainFrame.controlPanel.title:SetText(quest.id);
	VGMMainFrame.controlPanel.panels.Quest:Show();
end