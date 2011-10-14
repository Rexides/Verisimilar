function VerisimilarPl:InitializeSessionPanel()
	local ScrollingTable = LibStub("ScrollingTable");
	local sessionListDesc={};
	sessionListDesc[1]={
				["name"] = "Session",
				["width"] = 80,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",
			}
	sessionListDesc[2]={
				["name"] = "Game Master",
				["width"] = 80,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",
			}
	sessionListDesc[3]={
				["name"] = "Send sayings",
				["width"] = 80,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",
			}
	sessionListDesc[4]={
				["name"] = "Connected",
				["width"] = 90,
				["align"] = "RIGHT",
				["defaultsort"] = "dsc",
			}
	VPlSessionList = ScrollingTable:CreateST(sessionListDesc,20,nil,nil,VPlMainFrameSessionPage);
	VPlSessionList.frame:SetPoint("TOPLEFT",VPlMainFrameSessionPage,"TOPLEFT",20,-120);
	VPlSessionList:RegisterEvents({
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, table, ...)
									if(data[realrow])then
										self:SessionClicked(data[realrow].session);
									end
								end,
				["OnEnter"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, table, ...)
									if(data[realrow])then
										GameTooltip:ClearLines();
										GameTooltip:SetOwner(rowFrame, "ANCHOR_BOTTOMRIGHT");
										GameTooltip:AddLine(data[realrow].session.name,nil,nil,nil,1);
										GameTooltip:Show();
									end
								end,
				["OnLeave"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, table, ...)
									if(data[realrow])then
										GameTooltip:Hide();
										GameTooltip:ClearLines();
									end
								end,
			});
	
	StaticPopupDialogs["VERISIMILAR_QUERY_PLAYER"] = {
		text = "Query player for sessions",
		button1 = "Query",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self)
			VerisimilarPl:SendQueryPlayer(self.editBox:GetText());
		end,
		OnHide = function(self)
					self.editBox:SetText("")
				end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_REMOVE_SESSION"] = {
		text = "Remove %s from the list?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function(self,data,data2)
			VerisimilarPl:RemoveSession(data);
			if(VerisimilarPl.db.char.savedSessionInfo[data.gm.."_"..id])then
				VerisimilarPl.db.char.savedSessionInfo[data.gm.."_"..id]=nil
			end
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
end

function VerisimilarPl:SessionClicked(session)
	local dewdrop = AceLibrary("Dewdrop-2.0");
	local x,y=GetCursorPosition();
	dewdrop:Open(VPlMainFrame,
				'children',	function()
						if(session.connected)then
							dewdrop:AddLine(
								'text', "Disconnect",
								'func',VerisimilarPl.SendDisconnectMessage,
								'arg1',VerisimilarPl,
								'arg2',session,
								'closeWhenClicked',true
							);
							dewdrop:AddLine(
								'text', "Send Sayings",
								'func',function()
											if(session.sendSay)then
												session.sendSay=false;
											else
												session.sendSay=true;
											end
											VerisimilarPl:UpdateInterface()
										end,
								'checked',session.sendSay
							);
						else
							dewdrop:AddLine(
								'text', "Connect",
								'func',VerisimilarPl.SendConnectRequest,
								'arg1',VerisimilarPl,
								'arg2',session,
								'closeWhenClicked',true
							);
							dewdrop:AddLine('text',"Password",
											'hasArrow',true,
											'hasEditBox',true,
											'editBoxText',session.password,
											'editBoxFunc',function(password)session.password=password;end
											);
							dewdrop:AddLine(
								'text', "Remove",
								'func',function()
											local dialog = StaticPopup_Show("VERISIMILAR_REMOVE_SESSION",session.name)
											if (dialog) then
												dialog.data  = session
												dialog.data2 = savedSessionIndex
											end
										end,
								'closeWhenClicked',true
							);
						end
						
						dewdrop:AddLine(
								'text', "Save",
								'func',function()
											local sessionID=session.gm.."_"..session.id;
											if(VerisimilarPl.db.char.savedSessionInfo[sessionID])then
												VerisimilarPl.db.char.savedSessionInfo[sessionID]=nil
											else
												VerisimilarPl.db.char.savedSessionInfo[sessionID]={n=session.name,gm=session.gm,id=session.id,password=session.password};
											end
										end,
								'checked',VerisimilarPl.db.char.savedSessionInfo[session.gm.."_"..session.id]~=nil
							);
					end,
				'cursorX',x,
				'cursorY',y
				);
end

function VerisimilarPl:RefreshSessionList()
	VPlSessionList:Refresh()
end

local function sendSayings(session)
	if(session.sendSay)then
		return "Yes";
	else
		return "No";
	end
end

local function isConnected(session)
	if(session.connected)then
		return "Yes";
	else
		return "No";
	end
end

function VerisimilarPl:SessionListUpdated()
	local itemList={};
	local sessionList=self.sessions;
	
	for sessionName,session in pairs(sessionList) do
		local entry={};
		local argument={session}
		entry.session=session
		entry.cols={};
		entry.cols[1]={};
		entry.cols[2]={};
		entry.cols[3]={};
		entry.cols[4]={};
		entry.cols[1].value=session.name;
		entry.cols[2].value=session.gm;
		entry.cols[3].value=sendSayings;
		entry.cols[3].args=argument;
		entry.cols[4].value=isConnected;
		entry.cols[4].args=argument;
		tinsert(itemList,entry);
	end
	VPlSessionList:SetData(itemList)
end

