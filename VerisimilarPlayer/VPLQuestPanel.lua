function VerisimilarPl:InitializeQuestPanel()
	local ScrollingTable = LibStub("ScrollingTable");
	local environmentListDesc={};
	environmentListDesc[1]={
				["name"] = "Title",
				["width"] = 80,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",

			}
	environmentListDesc[2]={
				["name"] = "Category",
				["width"] = 80,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",
			}
	environmentListDesc[3]={
				["name"] = "Completed",
				["width"] = 80,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	environmentListDesc[4]={
				["name"] = "-",
				["width"] = 40,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	environmentListDesc[5]={
				["name"] = "Padding",
				["width"] = 50,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	VPlQuestList = ScrollingTable:CreateST(environmentListDesc,9,36,nil,VPlMainFrameQuestPage);
	VPlQuestList.frame:SetPoint("TOPLEFT",VPlMainFrameQuestPage,"TOPLEFT",20,-100);
	VPlQuestList:RegisterEvents({
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, table, ...)
									if(data[realrow])then
										VerisimilarPl:QuestClicked(data[realrow].stub);
									end
									
								end,
			});
	
	StaticPopupDialogs["VERISIMILAR_ABANDON_QUEST"] = {
		text = "Abandon %s?",
		button1 = "Abandon",
		button2 = "Cancel",
		OnAccept = function(self,data)
			VerisimilarPl:AbandonQuestStub(data)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_DISABLE_QUEST_MERGE"] = {
		text = "You are trying to use a WoW quest item from the watch frame. In order to do this, you must disable Verisimilar merging with the Quest interface.",
		button1 = "Disable",
		button2 = "Cancel",
		button3 = "Disable for 5 secs",
		OnAccept = function(self,data)
			VerisimilarPl.db.char.mergeWithQuestInterface=false
			VerisimilarPl:UpdateQuestInterfaceMerge();
		end,
		OnAlt = function(self,data)
			VerisimilarPl:Unhook("UseQuestLogSpecialItem",true);
			VerisimilarPl:ScheduleTimer(function() VerisimilarPl:RawHook("UseQuestLogSpecialItem",true); end, 5 );
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
end



function VerisimilarPl:QuestClicked(stub)
	local dewdrop = AceLibrary("Dewdrop-2.0")
	local x,y=GetCursorPosition();
	dewdrop:Open(VPlMainFrameQuestPage,
				'children',	function()
						local menuTable={};
						tinsert(menuTable,{	text="Details",
											func=function()
													VerisimilarPl:Print("Quest Title:",stub.title);
													VerisimilarPl:Print("Quest Objectives:");
													VerisimilarPl:Print(stub.objectivesSummary);
													for i=1,#stub.objectives do
														VerisimilarPl:Print(stub.objectivesInfo[i].text..": "..stub.objectives[i].value.."/"..stub.objectivesInfo[i].targetValue);
													end
													VerisimilarPl:Print("Quest Description:");
													VerisimilarPl:Print(stub.questDescription);
												end,
											closeWhenClicked=true
										});
						tinsert(menuTable,{	text="Abandon",
											func=function()
													local dialog = StaticPopup_Show("VERISIMILAR_ABANDON_QUEST",stub.title)
														if (dialog) then
															dialog.data  = stub
														end
												end,
											closeWhenClicked=true
										});
						
						dewdrop:FeedTable(menuTable);

				end,
				'cursorX',x,
				'cursorY',y
				);
end

function VerisimilarPl:RefreshQuestList()
	VPlQuestList:Refresh()
end

function VerisimilarPl:QuestListUpdated()
	local itemList={};
	local sessionList=self.sessions;
	
	for sessionName,session in pairs(sessionList) do
		if(session.connected)then
			--[[for _,stub in pairs(session.QuestStubs)do
				
				if(stub.type=="Quest")then
					local entry={};
					entry.stub=stub;
					entry.cols={};
					entry.cols[1]={};
					entry.cols[2]={};
					entry.cols[3]={};
					entry.cols[4]={};
					entry.cols[5]={};
					entry.cols[1].value=stub.title;
					entry.cols[2].value=stub.category;
					entry.cols[3].value=VerisimilarPl.IsCustomQuestComplete;
					entry.cols[3].args={VerisimilarPl,stub};					
					
					tinsert(itemList,entry);
				end
			end]]
		end
	end
	VPlQuestList:SetData(itemList)
end

function VerisimilarPl:IsCustomQuestComplete(stub)
	if(stub.completed)then 
		return "Yes" 
	else
		return "No" 
	end
end