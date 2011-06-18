local dewdrop = AceLibrary("Dewdrop-2.0")

function VerisimilarGM:InitializePlayerPanel()
		
	local ScrollingTable = LibStub("ScrollingTable");
	local playerListDesc={};
	playerListDesc[1]={
				["name"] = "Player",
				["width"] = 100,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",
			}
	playerListDesc[2]={
				["name"] = "Gender",
				["width"] =80,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	playerListDesc[3]={
				["name"] = "Class",
				["width"] =100,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	playerListDesc[4]={
				["name"] = "Level",
				["width"] =80,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	playerListDesc[5]={
				["name"] = "Race",
				["width"] =100,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	playerListDesc[6]={
				["name"] = "Zone",
				["width"] =270,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	VGMPlayerList = ScrollingTable:CreateST(playerListDesc,20,nil,nil,VGMMainFramePlayersPage);
	VGMPlayerList.frame:SetPoint("TOPLEFT",VGMMainFramePlayersPage,"TOPLEFT",20,-120);
	VGMPlayerList:RegisterEvents({
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, table, ...)
										if(data[realrow]==nil)then return end
										VerisimilarGM:PlayerClicked(data[realrow].player,data[realrow].session);
										
								end,
			});
	
	StaticPopupDialogs["VERISIMILAR_KICK_PLAYER"] = {
		text = "Kick %s?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function(self,data,data2)
			data:KickPlayer(data2);
			VerisimilarGM:PlayerListUpdated();
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
end

function VerisimilarGM:PlayerClicked(player,session)
	local x,y=GetCursorPosition();
	dewdrop:Open(VGMMainFramePlayersPage,
				'children',	function()
						local menuTable={};
						if(player.connected)then
							tinsert(menuTable,{	text="Send Message",
												hasArrow=true,
												hasEditBox=true,
												editBoxText="",
												editBoxFunc=function(text)session:SendTextMessage(text,player);end,
												closeWhenClicked=true
											});
						end
						tinsert(menuTable,{	text="Active Quests",
											hasArrow=true,
											subMenu={},
										});
						for questId,questVariables in pairs(player.elements)do
							if(questVariables.onQuest==true)then
								local questsMenu=menuTable[#menuTable].subMenu;
								local Quest=session.Quests[questId];
								if(type(questVariables)=="table")then
									tinsert(questsMenu,{	text=Quest.title,
															hasArrow=true,
															closeWhenClicked=true,
															subMenu={}
														});
									local objectiveMenu=questsMenu[#questsMenu].subMenu;
									for i=1,#Quest.objectives do
										
										local objective=Quest.objectives[i];
										tinsert(objectiveMenu,{	text=objective.text..": "..questVariables.objectives[i].currentValue.."/"..objective.targetValue,
																hasArrow=true,
																closeWhenClicked=true,
																subMenu={}
															});
										for i=1,#objective.filter do
											local eventMenu=objectiveMenu[#objectiveMenu].subMenu
											local parameter=objective.filter[i]
											tinsert(eventMenu,{	text=objective.event.." - "..parameter,
																--closeWhenClicked=true,
																func=Quest.EvaluateObjectives,
																arg1=Quest,
																arg2=player,
																arg3=objective.event,
																arg4=parameter,
															});
										end
									end
									tinsert(objectiveMenu,{	text="Remove",
															func=Quest.Reset,
															arg1=Quest,
															arg2=player,
															closeWhenClicked=true
											});
								end
							end
						end
						tinsert(menuTable,{	text="Completed Quests",
											hasArrow=true,
											subMenu={},
										});
						for questId,questVariables in pairs(player.elements)do
							if(questVariables.finished==true)then
								local Quest=session.Quests[questId];
								tinsert(menuTable[#menuTable].subMenu,{	text=Quest.title,
																		hasArrow=true,
																		closeWhenClicked=true,
																		subMenu={	[1]={	text="Reset",
																							func=Quest.Reset,
																							arg1=Quest,
																							arg2=player,
																						},
																				}
																	});
							end
						end
						tinsert(menuTable,{	text="Kick",
											func=function()
													local dialog = StaticPopup_Show("VERISIMILAR_KICK_PLAYER",player.name)
													if (dialog) then
														dialog.data  = VerisimilarGM.db.char.activeSession
														dialog.data2 = player
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

function VerisimilarGM:UpdatePlayersPanel()
	VGMPlayerList:Refresh();
end

function VerisimilarGM:PlayerListUpdated()
	local itemList={};
	if(not VerisimilarGM.db.char.activeSession)then return end
	local playerList=VerisimilarGM.db.char.activeSession.players;
	if(playerList==nil)then return end
	for playerName,player in pairs(playerList) do
		local entry={};
		entry.color=VerisimilarGM.ElementEntryColor;
		entry.colorargs={VerisimilarGM,player};
		entry.session=VerisimilarGM.db.char.activeSession
		entry.player=player
		entry.cols={};
		entry.cols[1]={};
		entry.cols[2]={};
		entry.cols[3]={};
		entry.cols[4]={};
		entry.cols[5]={};
		entry.cols[6]={};
		entry.cols[1].value=VerisimilarGM.GetValue;
		entry.cols[1].args={VerisimilarGM,player,"name"};
		entry.cols[2].value=VerisimilarGM.GetValue;
		entry.cols[2].args={VerisimilarGM,player,"gender"};
		entry.cols[3].value=VerisimilarGM.GetValue;
		entry.cols[3].args={VerisimilarGM,player,"class"};
		entry.cols[4].value=VerisimilarGM.GetValue;
		entry.cols[4].args={VerisimilarGM,player,"level"};
		entry.cols[5].value=VerisimilarGM.GetValue;
		entry.cols[5].args={VerisimilarGM,player,"race"};
		entry.cols[6].value=VerisimilarGM.GetValue;
		entry.cols[6].args={VerisimilarGM,player,"zone"};
		tinsert(itemList,entry);
	end
	VGMPlayerList:SetData(itemList)
end

function VerisimilarGM:GetValue(object,field)
	return object[field];
end


