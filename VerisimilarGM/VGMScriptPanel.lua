local dewdrop = AceLibrary("Dewdrop-2.0")

function VerisimilarGM:InitializeScriptPanel()
		
	local ScrollingTable = LibStub("ScrollingTable");
	local ScriptListDesc={};
	ScriptListDesc[1]={
				["name"] = "Name",
				["width"] = 80,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",
			}
	ScriptListDesc[2]={
				["name"] = "Runs every",
				["width"] = 80,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",
				--["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table, ...) VerisimilarGM:QuestIconCellUpdate(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table, ...);end,
			}
	ScriptListDesc[3]={
				["name"] = "Code",
				["width"] = 570,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",
			}
	VGMScriptList = ScrollingTable:CreateST(ScriptListDesc,9,36,nil,VGMMainFrameScriptsPage);
	VGMScriptList.frame:SetPoint("TOPLEFT",VGMMainFrameScriptsPage,"TOPLEFT",20,-100);
	VGMScriptList:RegisterEvents({
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, table, ...)
									if(data[realrow])then
										VerisimilarGM:ScriptClicked(data[realrow].script);
									end
								end,
			});
	VerisimilarGM:ScriptListUpdated();
	
	StaticPopupDialogs["VERISIMILAR_NEW_SCRIPT"] = {
		text = "Script id:",
		button1 = "Create",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data)
			data:NewScript(self.editBox:GetText());
			VerisimilarGM:ScriptListUpdated();
		end,
		OnHide = function(self)
					self.editBox:SetText("")
				end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_RUN_WITH_PARAMETERS"] = {
		text = "Parameters:",
		button1 = "Run",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data)
			local func=loadstring("return "..self.editBox:GetText())
			setfenv(func,data:GetSession().env)
			data:Run(func());
		end,
		OnHide = function(self)
					self.editBox:SetText("")
				end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_DELETE_SCRIPT"] = {
		text = "Delete %s?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function(self,data,data2)
			data:DeleteElement(data2);
			VerisimilarGM:ScriptListUpdated();
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
end

function VerisimilarGM:ScriptClicked(Script)
	local x,y=GetCursorPosition();
	dewdrop:Open(VGMMainFrameScriptsPage,
				'children',	function()
						local menuTable={};
						tinsert(menuTable,{	text="Enabled",
											checked=Script:IsEnabled();
											func=function()
													if(Script:IsEnabled())then 
														Script:Disable();
													else 
														Script:Enable(); 
													end 
													VGMScriptList:Refresh();
												end,
											closeWhenClicked=true
										});
						if(Script:IsEnabled() and Script:GetSession():IsEnabled())then
							tinsert(menuTable,{	text="Run script",
												func=function()	Script:Run()
																end,
												closeWhenClicked=true,
												});
							tinsert(menuTable,{	text="Run with parameters",
												func=function()	local dialog = StaticPopup_Show("VERISIMILAR_RUN_WITH_PARAMETERS")
																if (dialog) then
																	dialog.data  = Script
																end
															end,
												closeWhenClicked=true,
												});
						else
							tinsert(menuTable,{	text="Script code",
												func=function(handler)	VGMTextEntryFrame.handler=handler;
																		VGMTextEntryFrameScrollFrameCodeEditBoxCode:SetText(Script:GetScript());
																		VGMTextEntryFrameTitle:SetText("Script code");
																		VGMTextEntryFrame:Show(); 
																end,
												arg1=function(text)Script:SetScript(text);end,
												closeWhenClicked=true,
												});
							tinsert(menuTable,{	text="Repeats(secs)",
												hasArrow=true,
												hasEditBox=true,
												editBoxText=Script:GetPeriod(),
												editBoxFunc=function(secs)Script:SetPeriod(secs);end,
												});
							tinsert(menuTable,{	text="Event script code",
												func=function(handler)	VGMTextEntryFrame.handler=handler;
																		VGMTextEntryFrameScrollFrameCodeEditBoxCode:SetText(Script:GetEventScript());
																		VGMTextEntryFrameTitle:SetText("Event script code");
																		VGMTextEntryFrame:Show(); 
																end,
												arg1=function(text)Script:SetEventScript(text);end,
												closeWhenClicked=true,
												});
							tinsert(menuTable,{	text="Delete",
													func=function()
															local dialog = StaticPopup_Show("VERISIMILAR_DELETE_SCRIPT",Script.id)
															if (dialog) then
																dialog.data  = VerisimilarGM.db.char.activeSession
																dialog.data2 = Script
															end
														end,
													closeWhenClicked=true});
						end
						dewdrop:FeedTable(menuTable);

				end,
				'cursorX',x,
				'cursorY',y
				);
end

function VerisimilarGM:UpdateScriptPanel()
	VGMScriptList:Refresh();
end

function VerisimilarGM:ScriptListUpdated()
	local itemList={};
	if(not VerisimilarGM.db.char.activeSession)then
		VGMScriptList:SetData({})
		return
	end
	
	for ScriptId,Script in pairs(VerisimilarGM.db.char.activeSession.Scripts) do
		
			local entry={};
			entry.color=VerisimilarGM.ElementEntryColor;
			entry.colorargs={VerisimilarGM,Script};
			entry.script=Script;
			entry.cols={};
			entry.cols[1]={};
			entry.cols[2]={};
			entry.cols[3]={};
			entry.cols[1].value=ScriptId;
			--[[entry.cols[2].value=Quest.GetTitle;
			entry.cols[2].args={Quest};
			entry.cols[3].value=Quest.GetLevel;
			entry.cols[3].args={Quest};]]
			
			tinsert(itemList,entry);
	
	end
	VGMScriptList:SetData(itemList)
end
