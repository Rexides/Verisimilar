function VerisimilarPl:InitializeEnvironmentPanel()
	local ScrollingTable = LibStub("ScrollingTable");
	local environmentListDesc={};
	environmentListDesc[1]={
				["name"] = "Icon",
				["width"] = 36,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",
				["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table, ...) VerisimilarPl:EnvironmentIconCellUpdate(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table, ...);end,

			}
	environmentListDesc[2]={
				["name"] = "Name",
				["width"] = 80,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",
			}
	environmentListDesc[3]={
				["name"] = "Distance",
				["width"] = 80,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	environmentListDesc[4]={
				["name"] = "Act",
				["width"] = 40,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	environmentListDesc[5]={
				["name"] = "Padding",
				["width"] = 94,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	VPlEnvironmentList = ScrollingTable:CreateST(environmentListDesc,9,36,nil,VPlMainFrameEnvironmentPage);
	VPlEnvironmentList.frame:SetPoint("TOPLEFT",VPlMainFrameEnvironmentPage,"TOPLEFT",20,-100);
	VPlEnvironmentList:RegisterEvents({
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, table, ...)
									if(data[realrow])then
										VerisimilarPl:EnvironmentClicked(data[realrow].stub);
									end
									
								end,
			});
end

function VerisimilarPl:EnvironmentIconCellUpdate(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table, ...)
	if fShow then
			local rowdata = data[realrow];
			local celldata = rowdata.cols[column];
			
			cellFrame:SetNormalTexture("Interface\\Icons\\"..celldata.value);
			
			if table.fSelect then 
				if table.selected == realrow then 
					SetHighLightColor(rowFrame, celldata.highlight or cols[column].highlight or rowdata.highlight or table:GetDefaultHighlight());
				else
					SetHighLightColor(rowFrame, table:GetDefaultHighlightBlank());
				end
			end
	else	
			cellFrame.text:SetText("");
	end
end

function VerisimilarPl:EnvironmentClicked(stub)
	if(stub.actable)then
		local session=self.sessions[stub.sessionName];
		if(stub.type=="NPC")then
			if(not VerisimilarPl.db.char.mergeWithGossipInterface)then
				if(stub.gossipTable==nil)then
					VerisimilarPl:NPCStubClicked(stub);
				else
					
					local dewdrop = AceLibrary("Dewdrop-2.0")
					local x,y=GetCursorPosition();
					dewdrop:Open(VPlMainFrameEnvironmentPage,
								'children',	function()
										local menuTable={};
										for i=1,#stub.gossipTable.quests do
											tinsert(menuTable,{	text="(Q)"..stub.gossipTable.quests[i].title,
																func=function()
																		if(not session.stubs[stub.gossipTable.quests[i].id])then
																			VerisimilarPl:SendQuestDetailsQuery({session=session,stub=stub,id=stub.gossipTable.quests[i].id});
																		else
																			VerisimilarPl:SendQuestProgressQuery({session=session,stub=stub,id=stub.gossipTable.quests[i].id});
																		end
																	end,
																closeWhenClicked=true
															});
										end
										for i=1,#stub.gossipTable.options do
											tinsert(menuTable,{	text=stub.gossipTable.options[i].text,
																func=function()
																		VerisimilarPl:SendGossipOption({session=session,stub=stub,choice=stub.gossipTable.options[i].choice})
																	end,
																closeWhenClicked=true
															});
										end
										tinsert(menuTable,{	text="End gossip",
																func=function()
																		stub.gossipTable=nil;
																	end,
																closeWhenClicked=true
															});
										dewdrop:FeedTable(menuTable);

								end,
								'cursorX',x,
								'cursorY',y
								);
				end
			else
				VerisimilarPl:NPCStubClicked(stub);
			end
		end
	end
end

function VerisimilarPl:RefreshEnviromentList()
	VPlEnvironmentList:Refresh();
end

function VerisimilarPl:EnviromentListUpdated()
	local itemList={};
	local sessionList=self.sessions;
	
	for sessionName,session in pairs(sessionList) do
		if(session.connected)then
			for _,stub in pairs(session.stubs)do
				
				if(stub.visible and (stub.environmentIcon or not VerisimilarPl.db.char.mergeWithGossipInterface))then
					local entry={};
					local arguments={VerisimilarPl,stub};
					entry.stub=stub;
					entry.cols={};
					entry.cols[1]={};
					entry.cols[2]={};
					entry.cols[3]={};
					entry.cols[4]={};
					entry.cols[5]={};
					entry.cols[1].value=stub.icon;
					entry.cols[2].value=stub.name;
					entry.cols[3].value=VerisimilarPl.GetDistanceAndOrientation;
					entry.cols[3].args=arguments;					
					entry.cols[4].value=VerisimilarPl.IsActable;
					entry.cols[4].args=arguments;
					
					tinsert(itemList,entry);
				end
			end
		end
	end
	VPlEnvironmentList:SetData(itemList)
end

function VerisimilarPl:GetDistanceAndOrientation(stub)
	local distance=VerisimilarPl:Distance(VerisimilarPl.lastPlayerPositionX,VerisimilarPl.lastPlayerPositionY,stub.coordX,stub.coordY);
	local orientation;
	distance=floor(distance);
	if(VerisimilarPl.lastPlayerPositionX<stub.coordX)then
		orientation="E";
	else
		orientation="W";
	end
	if(VerisimilarPl.lastPlayerPositionY<stub.coordY)then
		orientation=" S"..orientation;
	else
		orientation=" N"..orientation;
	end
	
	return distance..orientation;
end

function VerisimilarPl:IsActable(stub)
	if(stub.actable)then 
		return "Yes" 
	else
		return "No" 
	end
end