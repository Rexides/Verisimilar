local GetQualityMenu,GetQuests,GetQuestInfo,SetQuest,RemoveQuest,GetPlayers,GetPlayerItemInfo,GiveItem,GetTTColorMenu,GetDocumentPageMenu,AddPage,RemovePage,GetMaterialMenu,SetUsable
local colors={
				white={r=1,g=1,b=1},
				green={r=0,g=1,b=0},
				red={r=1,g=0,b=0},
				gold={r=1,g=0.7,b=0.1},
			}

function VerisimilarGM:InitializeItemPanel()
		
	StaticPopupDialogs["VERISIMILAR_NEW_ITEM"] = {
		text = "Enter the Item ID. The \"ID\" is just a codeword used to refer to this item within Verisimilar GM, not the item name visible to the players, which you will add later. 30 characters max, no space or special characters",
		button1 = "Create",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data)
			local Item=data:NewItem(self.editBox:GetText());
			if(Item)then
				VerisimilarGM:AddElementToElementList(Item);
				VerisimilarGM:UpdateElementList();
				VerisimilarGM:SetPanelToElement(Item);
			end
		end,
		OnHide = function(self)
					self.editBox:SetText("")
				end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_GIVE_ITEM"] = {
		text = "Enter the amount to give to the selected players. Negative numbers will take away that many items from the selected character's bags.",
		button1 = "Give",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data,data2)
			local Item=data;
			if(Item)then
				local players=data2;
				obj,value=strsplit(",",self.editBox:GetText());
				for i=1,#players do
					Item:GiveTo(players[i],tonumber(self.editBox:GetText()),"gain");
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
							{type="List", key="playerList",x=10,y=-25,width=300,height=300,showOfflineControls=true,updateFunc=GetPlayers,infoFunc=GetPlayerItemInfo,columns={
																																	{label="Name",width=100},
																																	{label="Amount"},
																																	
																																},
							},
							{type="Button", key="giveItem",label="Give Item",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=5,y=-10, clickFunc=GiveItem ,tooltip="Give or take an amount of this item to the selected players"},
						},
						{text="General",showOnEnabled=false,showOnDisabled=true,
							{type="EditBox", key="name",label="Name",labelPosition="LEFT",x=100,y=-15,width=300,setFunc=function(editBox,name)VerisimilarGM:GetActiveElement():SetName(name);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetName(); end,tooltip="The name of the item"},
							{type="Icon", key="icon",label="Icon",x=0,y=-15,refFrame="PREVIOUS",refPoint="BOTTOMLEFT",setFunc=function(iconButton,icon)VerisimilarGM:GetActiveElement():SetIcon(icon);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetIcon(); end,tooltip="The item's icon"},
							{type="DropDown", key="quality",label="Quality",labelPosition="LEFT",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=-15,y=-15, width=100, menuFunc=GetQualityMenu, tooltip="The item's quality"},
							{type="CheckButton", key="soulbound",label="Soulbound",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-15,width=100, clickFunc=function(button,state)VerisimilarGM:GetActiveElement():SetSoulbound(state);end,checkFunc=function() return VerisimilarGM:GetActiveElement():IsSoulbound();end,tooltip="Soulbound items can't be traded between players"},
							{type="EditBox", key="unique",label="Unique Amount",labelPosition="LEFT",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=15,y=-15,width=50,numeric=true,setFunc=function(editBox,amount)VerisimilarGM:GetActiveElement():SetUniqueAmount(amount);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetUniqueAmount(); end,tooltip="The maximum number of this item that a player can have. 0 means that there isn't a limit"},
							{type="List", key="questList",x=20,y=-250,width=580,height=250,updateFunc=GetQuests,infoFunc=GetQuestInfo,columns={
																																	{label="Id",width=130},
																																	{label="Title"},
																																	{label="Belongs to quest",width=110},
																																},
							
							},
							{type="Button", key="setQuest",label="Assign as quest item",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=5,y=0, clickFunc=SetQuest ,tooltip="The item will become 'quest item' to the selected quests, and only drop from mobs if the player is on one of those quests"},
							{type="Button", key="removeQuest",label="Remove quest item assignment",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=RemoveQuest ,tooltip="The item will no longer drop in response to the player being on the seelcted quests. If the item does not belong to any quest, it will drop normally"},
							{type="LargeEditBox", key="flavor",label="Flavor text",x=350,y=-80,width=200,height=100,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetFlavorText(text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetFlavorText(); end,tooltip="This is the 'flavor text' that appears at the end of the item's tooltip in gold color"},
						},
						{text="Tooltip",showOnEnabled=false,showOnDisabled=true,
							{type="EditBox", key="leftToolTipText1",label="Line 1 left text:",labelPosition="LEFT",x=95,y=-5,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipLeftText(1,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipLeftText(1); end,tooltip="This text will appear on the left side of this line"},
							{type="EditBox", key="rightToolTipText1",label="Line 1 right text:",labelPosition="LEFT",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=110,y=0,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipRightText(1,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipRightText(1); end,tooltip="This text will appear on the right side of this line"},
							{type="DropDown", key="leftToolTipColor1",label="Line 1 left text color:",labelPosition="LEFT",refFrame="leftToolTipText1",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The left text color"},
							{type="DropDown", key="rightToolTipColor1",label="Line 1 right text color:",labelPosition="LEFT",refFrame="rightToolTipText1",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The right text color"},
							
							{type="EditBox", key="leftToolTipText2",label="Line 2 left text:",labelPosition="LEFT",refFrame="leftToolTipText1",refPoint="BOTTOMLEFT",x=0,y=-60,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipLeftText(2,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipLeftText(2); end,tooltip="This text will appear on the left side of this line"},
							{type="EditBox", key="rightToolTipText2",label="Line 2 right text:",labelPosition="LEFT",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=110,y=0,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipRightText(2,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipRightText(2); end,tooltip="This text will appear on the right side of this line"},
							{type="DropDown", key="leftToolTipColor2",label="Line 2 left text color:",labelPosition="LEFT",refFrame="leftToolTipText2",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The left text color"},
							{type="DropDown", key="rightToolTipColor2",label="Line 2 right text color:",labelPosition="LEFT",refFrame="rightToolTipText2",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The right text color"},
							
							{type="EditBox", key="leftToolTipText3",label="Line 3 left text:",labelPosition="LEFT",refFrame="leftToolTipText2",refPoint="BOTTOMLEFT",x=0,y=-60,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipLeftText(3,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipLeftText(3); end,tooltip="This text will appear on the left side of this line"},
							{type="EditBox", key="rightToolTipText3",label="Line 3 right text:",labelPosition="LEFT",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=110,y=0,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipRightText(3,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipRightText(3); end,tooltip="This text will appear on the right side of this line"},
							{type="DropDown", key="leftToolTipColor3",label="Line 3 left text color:",labelPosition="LEFT",refFrame="leftToolTipText3",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The left text color"},
							{type="DropDown", key="rightToolTipColor3",label="Line 3 right text color:",labelPosition="LEFT",refFrame="rightToolTipText3",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The right text color"},
							
							{type="EditBox", key="leftToolTipText4",label="Line 4 left text:",labelPosition="LEFT",refFrame="leftToolTipText3",refPoint="BOTTOMLEFT",x=0,y=-60,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipLeftText(4,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipLeftText(4); end,tooltip="This text will appear on the left side of this line"},
							{type="EditBox", key="rightToolTipText4",label="Line 4 right text:",labelPosition="LEFT",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=110,y=0,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipRightText(4,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipRightText(4); end,tooltip="This text will appear on the right side of this line"},
							{type="DropDown", key="leftToolTipColor4",label="Line 4 left text color:",labelPosition="LEFT",refFrame="leftToolTipText4",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The left text color"},
							{type="DropDown", key="rightToolTipColor4",label="Line 4 right text color:",labelPosition="LEFT",refFrame="rightToolTipText4",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The right text color"},
							
							{type="EditBox", key="leftToolTipText5",label="Line 5 left text:",labelPosition="LEFT",refFrame="leftToolTipText4",refPoint="BOTTOMLEFT",x=0,y=-60,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipLeftText(5,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipLeftText(5); end,tooltip="This text will appear on the left side of this line"},
							{type="EditBox", key="rightToolTipText5",label="Line 5 right text:",labelPosition="LEFT",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=110,y=0,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipRightText(5,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipRightText(5); end,tooltip="This text will appear on the right side of this line"},
							{type="DropDown", key="leftToolTipColor5",label="Line 5 left text color:",labelPosition="LEFT",refFrame="leftToolTipText5",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The left text color"},
							{type="DropDown", key="rightToolTipColor5",label="Line 5 right text color:",labelPosition="LEFT",refFrame="rightToolTipText5",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The right text color"},
							
							{type="EditBox", key="leftToolTipText6",label="Line 6 left text:",labelPosition="LEFT",refFrame="leftToolTipText5",refPoint="BOTTOMLEFT",x=0,y=-60,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipLeftText(6,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipLeftText(6); end,tooltip="This text will appear on the left side of this line"},
							{type="EditBox", key="rightToolTipText6",label="Line 6 right text:",labelPosition="LEFT",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=110,y=0,width=250,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetTooltipRightText(6,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetTooltipRightText(6); end,tooltip="This text will appear on the right side of this line"},
							{type="DropDown", key="leftToolTipColor6",label="Line 6 left text color:",labelPosition="LEFT",refFrame="leftToolTipText6",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The left text color"},
							{type="DropDown", key="rightToolTipColor6",label="Line 6 right text color:",labelPosition="LEFT",refFrame="rightToolTipText6",refPoint="BOTTOMLEFT",x=5,y=-10, width=100, menuFunc=GetTTColorMenu, tooltip="The right text color"},
						},
						{text="Document",showOnEnabled=false,showOnDisabled=true,
							{type="DropDown", key="page",label="Page:",x=45,y=-5, width=100,labelPosition="LEFT", menuFunc=GetDocumentPageMenu, tooltip="Select one of the pages of this document"},
							{type="Button", key="addPage",label="Add Page",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=AddPage ,tooltip="Add a new page to this document"},
							{type="Button", key="removePage",label="Remove Page",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=RemovePage ,tooltip="Remove the currently selected page from the document"},
							{type="DropDown", key="material",label="Document material:",labelPosition="LEFT",refFrame="page",refPoint="BOTTOMLEFT",x=50,y=-10, width=150, menuFunc=GetMaterialMenu, tooltip="The material of the document. This is the background for the text"},
							{type="LargeEditBox", key="pageText",label="Page text",x=100,y=-100,width=300,height=400,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetPageText(itemPanel.controls.page.selection,text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetPageText(itemPanel.controls.page.selection) or ""; end,tooltip="This is a short summary of the quest objectives"},
						},
						{text="Use",showOnEnabled=false,showOnDisabled=true,
							{type="CheckButton", key="usable",label="Can be used",x=50,y=-15,width=100, clickFunc=SetUsable,checkFunc=function() return VerisimilarGM:GetActiveElement():IsUsable();end,tooltip="Selecting this will make the item usable. You don't need to enable this if the item is a document or starts a quest."},
							{type="Container", key="target",label="Use range",x=20,y=-60,width=160,height=130, tooltip="If the item has a target, select the maximum range that it can be used. If it doesn't require a target, select 'no target'",
								{type="RadioButtons", key="range",buttonLabels={"No Target","Close (<10 yards)","Medium (<28 yards)","Far (>28 yards)"},x=15,y=-15,setFunc=function(button,i)VerisimilarGM:GetActiveElement():SetRange(i-1);end,getFunc=function() return VerisimilarGM:GetActiveElement():GetRange()+1;end},
							},
							{type="CheckButton", key="oocOnly",label="Only when out of combat",x=200,y=-60,width=100, clickFunc=function(button,state) VerisimilarGM:GetActiveElement():SetOutOfCombatOnly(state);end,checkFunc=function() return VerisimilarGM:GetActiveElement():IsOutOfCombatOnly();end,tooltip="Selecting this if you don't want the player to be able to use this item while in combat"},
							{type="LargeEditBox", key="useDescription",label="Use description",x=200,y=-110,width=200,height=80,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetUseDescription(text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetUseDescription(); end,tooltip="This is the  'Use:' text that appears in green color in the item's tooltip"},
							{type="LargeEditBox", key="useScript",label="Use script",x=20,y=-220,width=600,height=300,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetUseScript(text);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetUseScript(); end,tooltip="This is the script that runs when the player uses the item."},
						},
					}
	itemPanel=self:CreateElementPanel("Item",description)
end

GetPlayers=function(list,showOffline)
	local item=VerisimilarGM:GetActiveElement();
	local session=item:GetSession();
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

GetPlayerItemInfo=function(player)
	local item=VerisimilarGM:GetActiveElement();
	local itemInfo=player.elements[item.id]
	return player.name,itemInfo.amount;
end

GiveItem=function(button)
	local players=itemPanel.controls.playerList:GetSelectedEntries();
	local item=VerisimilarGM:GetActiveElement();
	local dialog=StaticPopup_Show ("VERISIMILAR_GIVE_ITEM");
	if (dialog) then
		dialog.data  = item;
		dialog.data2=players;
	end
end

local function QualityClicked(button,item,quality)
	item:SetQuality(quality);
	VerisimilarGM:UpdateInterface();
end

GetQualityMenu=function()
	local item=VerisimilarGM:GetActiveElement();
	local session=item:GetSession();
	local menu={};
	local quality=item:GetQuality();
	for i=1,#VerisimilarPl.itemQuality do
		tinsert(menu,{text=VerisimilarPl.itemQuality[i],checked=VerisimilarPl.itemQuality[i]==quality,func=QualityClicked,arg1=item,arg2=VerisimilarPl.itemQuality[i]});
	end
	return menu;
end

GetQuests=function(list)
	local item=VerisimilarGM:GetActiveElement();
	local session=item:GetSession();

	for _,element in pairs(session.elements)do
		if(element.elType=="Quest")then 
			list:Insert(element,element:IsEnabled());
		end
	end
end

GetQuestInfo=function(element)
	local item=VerisimilarGM:GetActiveElement();
	return element.id,element.title,item:HasQuest(element) and "Yes" or "No";
end

SetQuest=function(button)
	local elements=itemPanel.controls.questList:GetSelectedEntries();
	local item=VerisimilarGM:GetActiveElement();
	for i=1,#elements do
		item:AddQuest(elements[i]);
	end
	VerisimilarGM:UpdateInterface()
end

RemoveQuest=function(button)
	local elements=itemPanel.controls.questList:GetSelectedEntries();
	local item=VerisimilarGM:GetActiveElement();
	for i=1,#elements do
		item:RemoveQuest(elements[i]);
	end
	VerisimilarGM:UpdateInterface()
end

local function ColorClicked(button,item,info)
	if(info.side=="left")then
		item:SetTooltipLeftColor(info.line,info.color.r,info.color.g,info.color.b);
	else
		item:SetTooltipRightColor(info.line,info.color.r,info.color.g,info.color.b);
	end
	VerisimilarGM:UpdateInterface();
end

local colors={
				White={r=1,g=1,b=1},
				Green={r=0,g=1,b=0},
				Red={r=1,g=0,b=0},
				Gold={r=1,g=0.7,b=0.1},
			}
GetTTColorMenu=function(dropDown)
	local item=VerisimilarGM:GetActiveElement();
	local session=item:GetSession();
	local menu={};
	local line=tonumber(strsub(dropDown.key,-1,-1))
	local textSide=strsub(dropDown.key,1,1)=="l" and "left" or "right";
	local r,g,b;
	if(textSide=="left")then
		r,g,b=item:GetTooltipLeftColor(line);
	else
		r,g,b=item:GetTooltipRightColor(line);
	end
	local selectedColor;
	for color,values in pairs(colors)do
		tinsert(menu,{text=color,checked=(values.r==r and values.g==g and values.b==b),func=ColorClicked,arg1=item,arg2={side=textSide,line=line,color=values}});
	end
	return menu;
end

local function PageClicked(button,pageNum)
	local controls=itemPanel.controls;
	local item=VerisimilarGM:GetActiveElement();

	controls.material:Hide();
	controls.pageText:Hide();
	controls.page.selection=pageNum;

	if(pageNum)then
		controls.material:Show();
		controls.pageText:Show();
	end
	VerisimilarGM:UpdateInterface();
end

GetDocumentPageMenu=function(ddList)
	local item=VerisimilarGM:GetActiveElement();
	local menu={};
	for i=1,#item.document do
		tinsert(menu,{text=i,checked=ddList.selection==i,func=PageClicked,arg1=i});
	end
	menu.func=PageClicked;
	return menu;
end

AddPage=function(button)
	local item=VerisimilarGM:GetActiveElement();
	item:AddPage();
	PageClicked(nil,#item.document)
	VerisimilarGM:UpdateInterface()
end

RemovePage=function(button)
	local pageDD=itemPanel.controls.page;
	local item=VerisimilarGM:GetActiveElement();
	if(pageDD.selection)then
		item:RemovePage(pageDD.selection);
	end
	PageClicked(nil,((#item.document>0) and 1) or nil)
	VerisimilarGM:UpdateInterface()
end

local function MaterialClicked(button,item,material)
	item:SetDocumentMaterial(material);
	VerisimilarGM:UpdateInterface();
end

GetMaterialMenu=function()
	local item=VerisimilarGM:GetActiveElement();
	local session=item:GetSession();
	local material=item:GetDocumentMaterial();
	local menu={}
	for i=1,#VerisimilarPl.documentMaterials do
		tinsert(menu,{text=VerisimilarPl.documentMaterials[i],checked=VerisimilarPl.documentMaterials[i]==material,func=MaterialClicked,arg1=item,arg2=i});
	end
	return menu;
end

SetUsable=function(button, state)
	local controls=itemPanel.controls;
	local item=VerisimilarGM:GetActiveElement();
	item:SetUsable(state);
	controls.target:Hide();
	controls.oocOnly:Hide();
	controls.useDescription:Hide();
	controls.useScript:Hide();

	if(state)then
		controls.target:Show();
		controls.oocOnly:Show();
		controls.useDescription:Show();
		controls.useScript:Show();
	end
end

function VerisimilarGM:SetPanelToItem()
	local item=VGMMainFrame.controlPanel.element;
	VGMMainFrame.controlPanel.title:SetText(item.id);
	VGMMainFrame.controlPanel.panels.Item:Show();
end
