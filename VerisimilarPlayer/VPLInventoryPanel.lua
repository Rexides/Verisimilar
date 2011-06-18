function VerisimilarPl:InitializeInventoryPanel()
	for i=1,8 do
		for y=1,9 do
			local id=(i-1)*9+y
			local invButton=CreateFrame("Button", "VPLInvButton"..id, VPlMainFrameInventoryPage, "VPLInventoryPopupButtonTemplate");
			invButton:SetPoint("TOPLEFT", VPlMainFrameInventoryPage, "TOPLEFT", (y-1)*40+15, (1-i)*40-110);
			invButton.id=id;
		end
	end
	StaticPopupDialogs["VERISIMILAR_DESTROY_ITEM"] = {
		text = "Do you want to destroy %s?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function(self,data,data2)
			VerisimilarPl:DestroyItem(data,data2)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		showAlert = true,
	}
end

function VerisimilarPl:InventoryUpdated()
	local sessionList=VerisimilarPl.sessions;
	local items={};
	for sessionName,session in pairs(sessionList)do
		for id,stub in pairs(session.stubs)do
			if(stub.type=="Item" and stub.enabled and stub.amount>0)then
				tinsert(items,stub);
			end
		end
	end
	
	local offset=FauxScrollFrame_GetOffset(VPlMainFrameInventoryPageScrollFrame);
	local index=((offset) * 9);
	for i=1,72 do
		
		local button=getglobal("VPLInvButton"..i);
		local count=getglobal("VPLInvButton"..i.."Count");
		local cd=getglobal("VPLInvButton"..i.."Cooldown");
		if(items[i+index]~=nil)then
			
			SetItemButtonTexture(button,"Interface\\Icons\\"..items[i+index].icon);
			button.stub=items[i+index];
			if(button.stub.amount>1)then
				count:SetText(button.stub.amount);
				count:Show()
			else
				count:Hide();
			end
			CooldownFrame_SetTimer(cd, button.stub.cdStart, button.stub.cdDuration, 1)
			if ( button.stub.cdDuration > 0) then
				SetItemButtonTextureVertexColor(button, 0.4, 0.4, 0.4);
			else
				SetItemButtonTextureVertexColor(button, 1, 1, 1);
			end
		else
			SetItemButtonTexture(button,nil);
			button.stub=nil;
			count:Hide();
			cd:Hide();
		end
	end
	
	FauxScrollFrame_Update(VGMIconChooserScrollFrame, ceil(#items / 9) , 4, 36 );
end

function VerisimilarPl:ShowItemTooltip(stub,button,anchor)
	if(button)then
		local x;
		x = button:GetRight();
		if(anchor)then
			GameTooltip:SetOwner(button, anchor);
		else
			if ( x >= ( GetScreenWidth() / 2 ) ) then
				GameTooltip:SetOwner(button, "ANCHOR_LEFT");
			else
				GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
			end
		end
	end
	GameTooltip:ClearLines();
	local color=VerisimilarPl.qualityColor[stub.quality]
	GameTooltip:AddLine(stub.name,color.r,color.g,color.b);
	if(stub.soulbound)then
		GameTooltip:AddLine("Soulbound",1,1,1);
	end
	if(stub.quests)then
		GameTooltip:AddLine("<Quest Item>",1,1,1);
	end
	
	if(stub.uniqueAmount>0)then
		local unique="Unique";
		if(stub.uniqueAmount>1)then
			unique=unique.."("..stub.uniqueAmount..")";
			GameTooltip:AddLine(unique,1,1,1);
		end
	end
	for _,questStub in pairs(stub.session.stubs) do
		if(questStub.type=="Quest" and questStub.enabled and not questStub.finished and questStub.available and questStub.starters[stub.id])then
			GameTooltip:AddLine("This item begins a quest",1,1,1);
		end
	end
	if(stub.tooltip~=nil)then
		for i=1,#stub.tooltip do
			local line=stub.tooltip[i];
			if(line.rt~=nil)then
				GameTooltip:AddDoubleLine(line.lt or "",line.rt ,line.lr or 1,line.lg or 1,line.lb or 1,line.rr,line.rg,line.rb);
			else
				GameTooltip:AddLine(line.lt,line.lr,line.lg,line.lb,true);
			end
		end
	end
	if(stub.useDescription and stub.useDescription~="")then
		GameTooltip:AddLine("Use: "..stub.useDescription,0.1,1,0);
	end
	if(stub.flavorText and stub.flavorText~="")then
		GameTooltip:AddLine('"'..stub.flavorText..'"',1,0.7,0.1);
	end
	if(stub.document)then
		GameTooltip:AddLine("<Right Click to Read>",0.1,1,0);
	end
	GameTooltip:Show()
end

function VerisimilarPl:OpenDocument(stub)
	VPLItemTextFrameTitleText:SetText(stub.name);
	VPLItemTextFrameScrollFrame:Hide();
	VPLItemTextFrameCurrentPage:Hide();
	VPLItemTextFrameStatusBar:Hide();
	VPLItemTextFramePrevPageButton:Hide();
	VPLItemTextFrameNextPageButton:Hide();
	local material = VerisimilarPl.documentMaterials[stub.document.material]
	local textColor = GetMaterialTextColors(material);
	VPLItemTextFramePageText:SetTextColor(textColor[1], textColor[2], textColor[3]);
	VPLItemTextFrame.stub=stub;
	VerisimilarPl:OpenPage(1)
	VPLItemTextFrame:Show()
end

function VerisimilarPl:OpenPage(pageNum)
	VPLItemTextFramePageText:SetText("\n"..VPLItemTextFrame.stub.document[pageNum].."\n\n");
	VPLItemTextFrameScrollFrameScrollBar:SetValue(0);
	VPLItemTextFrameScrollFrame:Show();	
	VPLItemTextFrame.currentPage=pageNum;
	local page = pageNum;
	local next = VPLItemTextFrame.stub.document[page+1]~=nil
	local material = VerisimilarPl.documentMaterials[VPLItemTextFrame.stub.document.material]; 
	if ( material == "Parchment" ) then
		VPLItemTextFrameMaterialTopLeft:Hide();
		VPLItemTextFrameMaterialTopRight:Hide();
		VPLItemTextFrameMaterialBotLeft:Hide();
		VPLItemTextFrameMaterialBotRight:Hide();
	else
		VPLItemTextFrameMaterialTopLeft:Show();
		VPLItemTextFrameMaterialTopRight:Show();
		VPLItemTextFrameMaterialBotLeft:Show();
		VPLItemTextFrameMaterialBotRight:Show();
		VPLItemTextFrameMaterialTopLeft:SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-TopLeft");
		VPLItemTextFrameMaterialTopRight:SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-TopRight");
		VPLItemTextFrameMaterialBotLeft:SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-BotLeft");
		VPLItemTextFrameMaterialBotRight:SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-BotRight");
	end
	if ( (page > 1) or next ) then
		VPLItemTextFrameCurrentPage:SetText(page);
		VPLItemTextFrameCurrentPage:Show();
		if ( page > 1 ) then
			VPLItemTextFramePrevPageButton:Show();
		else
			VPLItemTextFramePrevPageButton:Hide();
		end
		if ( next ) then
			VPLItemTextFrameNextPageButton:Show();
		else
			VPLItemTextFrameNextPageButton:Hide();
		end
	end	
	VPLItemTextFrameStatusBar:Hide();
	ShowUIPanel(VPLItemTextFrame);
end

local stub
local ItemMenu=function()
	local menuTable={};
	if(not stub)then return end
	if(not stub.soulbound and UnitName("target")~=UnitName("player") and UnitIsPlayer("target") and UnitIsFriend("player","target") and CheckInteractDistance("target",2))then
		tinsert(menuTable,{	text="Give to "..UnitName("target"),
							hasArrow=true,
							hasEditBox=true,
							editBoxText=stub.amount,
							editBoxFunc=VerisimilarPl.GiveItemTo,
							editBoxArg1=VerisimilarPl,
							editBoxArg2=stub,
							editBoxArg3=UnitName("target"),
							closeWhenClicked=true
							});
	end
	tinsert(menuTable,{	text="Destroy",
						hasArrow=true,
						hasEditBox=true,
						editBoxText=stub.amount,
						editBoxFunc=function(stub,amount)
										local dialog = StaticPopup_Show("VERISIMILAR_DESTROY_ITEM",stub.name)
										if (dialog) then
											dialog.data  = stub
											dialog.data2 = amount
										end
									end,
						editBoxArg1=stub,
						closeWhenClicked=true
					});
	AceLibrary("Dewdrop-2.0"):FeedTable(menuTable);
end
function VerisimilarPl:ItemContextMenu(clickedItem)
	stub=clickedItem;
	local x,y=GetCursorPosition();
	AceLibrary("Dewdrop-2.0"):Open(UIParent,'children',ItemMenu,'cursorX',x,'cursorY',y);
end
