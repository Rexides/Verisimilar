local menuFrame = CreateFrame("Frame", "VGMDDMenuFrame", UIParent, "UIDropDownMenuTemplate")
function VerisimilarGM:InitializeInterface()
	VGMMainFrameTitleText:SetText("Verisimilar GM Panel");
	
	
	
	
	self:CreateMenuBar({
						[1]={
								text="New",
								clickHandler="MenuButtonNew"
							},
						[2]={
								text="Edit",
								clickHandler="MenuButtonEdit"
							},
						[3]={
								text="Help",
							},
						});

	self:InitializeSessionPanel();
	--self:InitializePlayerPanel();
	self:InitializeNPCPanel();
	self:InitializeQuestPanel();
	--self:InitializeScriptPanel();
	self:InitializeItemPanel();
	self:InitializeMobPanel();
	self:InitializeAreaPanel();
	self:InitializeIconFilter();
	--self:ScheduleRepeatingTimer("UpdateInterface", 3);
	
	for _,session in pairs(VerisimilarGM.db.global.sessions)do
		self:AddElementToElementList(session);
		for ___,element in pairs(session.elements)do
			self:AddElementToElementList(element);
		end
	end
	self:UpdateElementList()
	self:SetPanelToElement();
end

function VerisimilarGM:CreateMenuBar(menuDesc)
	VGMMainFrame.menuBar={};
	local lastButton=nil;
	for i=1,#menuDesc do
		VGMMainFrame.menuBar[menuDesc[i].text]=CreateFrame("Button","VGMMainFrameMenuBar"..menuDesc[i].text,VGMMainFrame,"VGMMenuBarButtonTemplate");
		local button=VGMMainFrame.menuBar[menuDesc[i].text];
		button:SetText(menuDesc[i].text);
		button:SetWidth(button:GetTextWidth()+20);
		button.clickHandler=menuDesc[i].clickHandler;
		button.clickArg=menuDesc[i].clickArg;
		if(lastButton==nil)then
			button:SetPoint("TOPLEFT",5,-23);
		else
			button:SetPoint("TOPLEFT",lastButton,"TOPRIGHT",5,0);
		end
		lastButton=button;
	end
end

function VerisimilarGM:AddElementToElementList(element)
	if(element.elType=="Session")then
		local i=1;
		while(i<=#VGMMainFrame.elementList.entries and (VGMMainFrame.elementList.entries[i].hasChildren==false or (VGMMainFrame.elementList.entries[i].hasChildren and VGMMainFrame.elementList.entries[i].element.name<element.name)))do
			i=i+1;
		end
		tinsert(VGMMainFrame.elementList.entries,i,{name=element.name,element=element,hasChildren=true,collapsed=true});
	else
		for j=1,#VGMMainFrame.elementList.entries do
			if(element:GetSession()==VGMMainFrame.elementList.entries[j].element)then
				local i=j+1;
				while(i<=#VGMMainFrame.elementList.entries and VGMMainFrame.elementList.entries[i].hasChildren==false and VGMMainFrame.elementList.entries[i].element.id<element.id)do
					i=i+1;
				end
				tinsert(VGMMainFrame.elementList.entries,i,{name=element.id,element=element,hasChildren=false});
				return;
			end
		end
	end
end

function VerisimilarGM:RemoveElementFromElementList(element)
	if(element.elType=="Session")then
		for j=1,#VGMMainFrame.elementList.entries do
			if(element==VGMMainFrame.elementList.entries[j].element)then
				tremove(VGMMainFrame.elementList.entries,j);
				while(j<=#VGMMainFrame.elementList.entries and VGMMainFrame.elementList.entries[j].hasChildren==false)do
					tremove(VGMMainFrame.elementList.entries,j);
				end
				return;
			end
		end
	else
		for j=1,#VGMMainFrame.elementList.entries do
			if(element:GetSession()==VGMMainFrame.elementList.entries[j].element)then
				local i=j+1;
				while(i<=#VGMMainFrame.elementList.entries and VGMMainFrame.elementList.entries[i].element~=element)do
					i=i+1;
				end
				tremove(VGMMainFrame.elementList.entries,i);
				return;
			end
		end
	end
end

function VerisimilarGM:UpdateInterface()
	for _,panel in pairs(VGMMainFrame.controlPanel.panels)do
		if(panel:IsVisible())then
			for _,control in pairs(panel.controls)do
				if(control:IsVisible())then
					control:UpdateData();
				end
			end
		end
	end
end

function VerisimilarGM:UpdateElementList()
	local offset = FauxScrollFrame_GetOffset(VGMMainFrame.elementList.list);
	local buttons = VGMMainFrame.elementList.buttons;
	local entry;

	local numEntries = 0;
	local doCount=false;
	for i=1,#VGMMainFrame.elementList.entries do
		if(VGMMainFrame.elementList.entries[i].hasChildren)then
			doCount=not VGMMainFrame.elementList.entries[i].collapsed;
			numEntries=numEntries+1;
		else
			if(doCount)then
				numEntries=numEntries+1;
			end
		end
	end
	local numButtons = #buttons;

	FauxScrollFrame_Update(VGMMainFrame.elementList.list, numEntries, numButtons, buttons[1]:GetHeight());

	local selection 
	local activeElement=self:GetActiveElement();
	for i=1,#VGMMainFrame.elementList.entries do
		if(VGMMainFrame.elementList.entries[i].element==activeElement)then
			selection=VGMMainFrame.elementList.entries[i];
			break;
		end
	end
	--if ( selection ) then
		OptionsList_ClearSelection(VGMMainFrame.elementList, VGMMainFrame.elementList.buttons);
	--end
	
	j=1;
	for i = 1, #buttons do
		entry = VGMMainFrame.elementList.entries[j + offset]
		if ( not entry ) then
			buttons[i]:Hide();
		else
			self:UpdateElementListButton(buttons[i], entry);
			
			if ( selection ) and ( selection == entry ) and ( not VGMMainFrame.elementList.selection ) then
				OptionsList_SelectButton(VGMMainFrame.elementList, buttons[i]);
			end
			j=j+1;
			if(entry.hasChildren and entry.collapsed)then
				while(j + offset<=#VGMMainFrame.elementList.entries and VGMMainFrame.elementList.entries[j + offset].hasChildren==false)do
					j=j+1;
				end
			end
		end
	end

	if ( selection ) then
		VGMMainFrame.elementList.selection = selection;
	end
end

function VerisimilarGM:UpdateElementListButton(button,entry)
	button:Show();
	button.element = entry;
	local filter=VGMMainFrame.elementFilter:GetText();
	if (not entry.hasChildren) then
		if(filter~="" and self:FilterElement(entry.element,filter))then
			button:SetNormalFontObject(GameFontGreenSmall);
		else
			if(entry.element:IsEnabled())then
				button:SetNormalFontObject(GameFontNormalSmall);
			else
				button:SetNormalFontObject(GameFontDisableSmall);
			end
		end
		button:SetHighlightFontObject(GameFontHighlightSmall);
		button.text:SetPoint("LEFT", 16, 2);
	else
		if(entry.element:IsEnabled())then
			button:SetNormalFontObject(GameFontNormal);
		else
			button:SetNormalFontObject(GameFontDisable);
		end
		button:SetHighlightFontObject(GameFontHighlight);
		button.text:SetPoint("LEFT", 8, 2);
	end
	button.text:SetText(entry.name);
	
	if (entry.hasChildren) then
		if (entry.collapsed) then
			button.toggle:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP");
			button.toggle:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN");
		else
			button.toggle:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-UP");
			button.toggle:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-DOWN");		
		end
		button.toggle:Show();
	else
		button.toggle:Hide();
	end

end

function VerisimilarGM:ToggleElementListEntry(entry)
	entry.collapsed=not entry.collapsed;
	self:UpdateElementList();
end

function VerisimilarGM:ToggleMainWindow()
	if VGMMainFrame:IsShown() then
		VGMMainFrame:Hide();
	else
		VGMMainFrame:Show();
	end
end

function VerisimilarGM:LogEvent(event)
	--VGMMainFrameEventLogPageScrollFrameEditBox:Insert(event.."\n");
end

function VerisimilarGM:ProccessCommand(commandText)
	if(self.activeElement)then
		local func,message=loadstring("return "..commandText);
		assert(func~=nil,message);
		setfenv(func,self.activeElement.session.env);
		local result=func();
		if(result)then
			self:LogEvent(commandText..":"..tostring(result))
		end
	end
end

function VerisimilarGM.CountPlayers(session)
	local plcount=0;
	for _,player in pairs(session.players)do
		if(player.connected)then
			plcount=plcount+1;
		end
	end
	return plcount;
end

local rightClickMenu={	{text="Enabled",func=function(button,element)
												if(element:IsEnabled()) then
													element:Disable();
												else 
													element:Enable() 
												end 
												VerisimilarGM:UpdateElementList();
												if(element==VerisimilarGM:GetActiveElement())then
													VerisimilarGM:SetPanelToElement(element);
												end
											end},
						{text="Copy",notCheckable=true,func=	function(button,element)
																	VerisimilarGM.copiedElement=VerisimilarGM:RecursiveCopy(element);
																end},
						{text="Delete",notCheckable=true,func=	function(button,element)
																	VerisimilarGM:DeleteElementPrompt(element); 
																end},
					};
					
function VerisimilarGM:ElementClicked(elementButton,mouseButton)
	local element=elementButton.element.element;
	if(mouseButton=="LeftButton")then
		PlaySound("igMainMenuOptionCheckBoxOn");
		local parent=elementButton:GetParent();
		
		OptionsList_ClearSelection(parent, parent.buttons);
		OptionsList_SelectButton(parent, elementButton);
		VerisimilarGM:SetPanelToElement(element)
	elseif(mouseButton=="RightButton")then
		local x, y = GetCursorPosition();
		rightClickMenu[1].checked=element:IsEnabled();
		rightClickMenu[1].arg1=element;
		rightClickMenu[2].arg1=element;
		rightClickMenu[3].arg1=element;
		EasyMenu(rightClickMenu, menuFrame, UIParent , x , y,nil,10);
	end
end

function VerisimilarGM:ElementFilterTextChanged(editBox)
	self:UpdateElementList()
end

function VerisimilarGM:FilterElement(element,filter)
	local filter=strlower(filter)
	if(strfind(strlower(element.id),filter) or strfind(strlower(element.elType),filter))then
		return true;
	end
	if(	(element.elType=="Quest" and strfind(strlower(element:GetTitle()),filter) or strfind(strlower(element:GetCategory()),filter)) or
		(element.elType=="NPC" and strfind(strlower(element:GetName()),filter)) or
		(element.elType=="Item" and strfind(strlower(element:GetName()),filter)) or
		(element.elType=="Mob" and strfind(strlower(element:GetName()),filter)))then
		return true;
	end
	return false;
end

function VerisimilarGM:RecursiveCopy(t)
	local newT={};
	for key,value in pairs(t)do
		if(type(value)=="table")then
			newT[key]=self:RecursiveCopy(value);
		elseif(type(value)~="function")then
			newT[key]=value;
		end
	end
	
	return newT;
end

function VerisimilarGM:ShowElementTooltip(button,element)
	GameTooltip:ClearLines();
	GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT");
	GameTooltip:AddLine(element.id,nil,nil,nil,1);
	GameTooltip:AddLine(element.title or element.name or "",nil,nil,nil,1);
	GameTooltip:Show();
end

function VerisimilarGM:HideElementPanels()
	for _,panel in pairs(VGMMainFrame.controlPanel.panels)do
		panel:Hide(); --We hide them first to save any changes to the previous active element
	end
end
function VerisimilarGM:SetPanelToElement(element)
	self:HideElementPanels()
	VGMMainFrame.controlPanel.element=element;
	if(element==nil)then
		VGMMainFrame.controlPanel:Hide();
		VerisimilarGM:UpdateElementList();
		return;
	else
		VGMMainFrame.controlPanel:Show();
	end
	VGMMainFrame.controlPanel.checkEnabled:SetChecked(element:IsEnabled());
	VGMMainFrame.controlPanel.checkDisabled:SetChecked(not element:IsEnabled());
	VerisimilarGM:UpdateElementList();
	
	if(element.elType=="Session" or element.elType==nil)then
		self:SetPanelToSession();
	elseif(element.elType=="Quest")then
		self:SetPanelToQuest();
	elseif(element.elType=="NPC")then
		self:SetPanelToNPC();
	elseif(element.elType=="Item")then
		self:SetPanelToItem();
	elseif(element.elType=="Mob")then
		self:SetPanelToMob();
	elseif(element.elType=="Area")then
		self:SetPanelToArea();
	end
	self:UpdateInterface();
end


function VerisimilarGM:MenuButtonClicked(button)
	if(type(button.clickHandler)=="function")then
		button.clickHandler(self,button);
	elseif(type(button.clickHandler)=="string")then
		self[button.clickHandler](self,button);
	elseif(type(button.clickHandler)=="table")then
		EasyMenu(button.clickHandler, menuFrame, button, 0 , 0,nil,10);
	end
end

local mbNewTable={
					{text="Session",tooltipTitle="New Session",tooltipText="Sessions are the \"containers\" for your quests, npcs, items etc. Players will connect to a session in order to experience your creations.",
						notCheckable=true,func=function()StaticPopup_Show ("VERISIMILAR_NEW_SESSION");end,},
					{text="Elements",hasArrow=true,notCheckable=true,menuList={
																				{text="Quest",notCheckable=true,func=	function()
																															local dialog=StaticPopup_Show ("VERISIMILAR_NEW_QUEST");
																															if (dialog) then
																																dialog.data  = VerisimilarGM:GetActiveSession();
																																local elType="quest"
																																local id=elType.."1";
																																local i=1;
																																while(VerisimilarGM:GetActiveSession().elements[id])do
																																	i=i+1;
																																	id=elType..i;
																																end
																																dialog.editBox:SetText(id);
																															end
																															
																														end,},
																				{text="NPC",notCheckable=true,func=		function()
																															local dialog=StaticPopup_Show ("VERISIMILAR_NEW_NPC");
																															if (dialog) then
																																dialog.data  = VerisimilarGM:GetActiveSession();
																																local elType="npc"
																																local id=elType.."1";
																																local i=1;
																																while(VerisimilarGM:GetActiveSession().elements[id])do
																																	i=i+1;
																																	id=elType..i;
																																end
																																dialog.editBox:SetText(id);
																															end
																															
																														end,},
																				{text="Item",notCheckable=true,func=	function()
																															local dialog=StaticPopup_Show ("VERISIMILAR_NEW_ITEM");
																															if (dialog) then
																																dialog.data  = VerisimilarGM:GetActiveSession();
																																local elType="item"
																																local id=elType.."1";
																																local i=1;
																																while(VerisimilarGM:GetActiveSession().elements[id])do
																																	i=i+1;
																																	id=elType..i;
																																end
																																dialog.editBox:SetText(id);
																															end
																															
																														end,},
																				{text="Mob",notCheckable=true,func=		function()
																															local dialog=StaticPopup_Show ("VERISIMILAR_NEW_MOB");
																															if (dialog) then
																																dialog.data  = VerisimilarGM:GetActiveSession();
																																local elType="mob"
																																local id=elType.."1";
																																local i=1;
																																while(VerisimilarGM:GetActiveSession().elements[id])do
																																	i=i+1;
																																	id=elType..i;
																																end
																																dialog.editBox:SetText(id);
																															end
																															
																														end,},
																				{text="Area",notCheckable=true,func=	function()
																															local dialog=StaticPopup_Show ("VERISIMILAR_NEW_AREA");
																															if (dialog) then
																																dialog.data  = VerisimilarGM:GetActiveSession();
																																local elType="area"
																																local id=elType.."1";
																																local i=1;
																																while(VerisimilarGM:GetActiveSession().elements[id])do
																																	i=i+1;
																																	id=elType..i;
																																end
																																dialog.editBox:SetText(id);
																															end
																															
																														end,},
																				
																			},
												
					},
										
				}
function VerisimilarGM:MenuButtonNew(button)
	if(self:GetActiveSession())then
		mbNewTable[2].disabled=false;
		mbNewTable[2].hasArrow=true;
	else
		mbNewTable[2].disabled=true;
		mbNewTable[2].hasArrow=false;
	end
	EasyMenu(mbNewTable, menuFrame, button, 0 , 0,nil,10);
end

local mbEditTable={
					{text="Copy",notCheckable=true,func=	function()
																VerisimilarGM.copiedElement=VerisimilarGM:RecursiveCopy(VerisimilarGM:GetActiveElement());
															end,},
					{text="Paste",notCheckable=true,func=	function()
																VerisimilarGM:PasteElementPrompt(VerisimilarGM.copiedElement);
															end,},
					{text="Delete",notCheckable=true,func=	function()
																VerisimilarGM:DeleteElementPrompt(VerisimilarGM:GetActiveElement());
															end,},
				}
function VerisimilarGM:MenuButtonEdit(button)
	if(self:GetActiveElement())then
		if(self.GetActiveElement().elType=="Session")then
			mbEditTable[1].disabled=true;
		else
			mbEditTable[1].disabled=false;
		end
		if(self.copiedElement==nil)then
			mbEditTable[2].disabled=true;
		else
			mbEditTable[2].disabled=false;
		end
		mbEditTable[3].disabled=false;
	else
		mbEditTable[1].disabled=true;
		mbEditTable[2].disabled=true;
		mbEditTable[3].disabled=true;
	end
	EasyMenu(mbEditTable, menuFrame, button, 0 , 0,nil,10);
end

function VerisimilarGM:GetActiveSession()
	if(VGMMainFrame.controlPanel.element)then
		local element=VGMMainFrame.controlPanel.element;
		if(element.elType=="Session")then
			return element;
		else
			return element:GetSession();
		end
	end
end

function VerisimilarGM:GetActiveElement()
	if(VGMMainFrame.controlPanel.element)then
		return VGMMainFrame.controlPanel.element;
	end
end

function VerisimilarGM:DeleteElementPrompt(element)
	if(element.elType=="Session")then
		local dialog = StaticPopup_Show("VERISIMILAR_DELETE_SESSION",element.name)
		if (dialog) then
			dialog.data  = element;
		end;
	else
		local dialog = StaticPopup_Show("VERISIMILAR_DELETE_ELEMENT",element.id)
		if (dialog) then
			dialog.data  = element;
		end;
	end
end

function VerisimilarGM:PasteElementPrompt(element)
	if(element.elType=="Session")then
		return;
	else
		local dialog=StaticPopup_Show ("VERISIMILAR_PASTE_ELEMENT");
		if (dialog) then
			dialog.data=VerisimilarGM:GetActiveSession();
			dialog.data2=element;
			local newID=element.id;
			local id=newID.."2";
			local i=2;
			while(VerisimilarGM:GetActiveSession().elements[id])do
				i=i+1;
				id=newID..i;
			end
			dialog.editBox:SetText(id);
		end
	end
end

VerisimilarGM.zoneMapInfo={};
VERISIMILAR_NUM_OVERLAYS=0;
function VerisimilarGM:CreateZoneMapInfo()
	local infoTable=VerisimilarGM.zoneMapInfo;
	local info={};
	local oldFilename="";
	for id=4,1000 do
		SetMapByID(id);
		info.filename=GetMapInfo();
		if(oldFilename~=info.filename)then
			info.id=id;
			info.numLevels=GetNumDungeonMapLevels();
			info.overlays={};
			local textureCount = 0;
			for i=1, GetNumMapOverlays() do
				local textureName, textureWidth, textureHeight, offsetX, offsetY = GetMapOverlayInfo(i);
				if ( textureName and textureName ~= "" ) then
					local numTexturesWide = ceil(textureWidth/256);
					local numTexturesTall = ceil(textureHeight/256);
					local neededTextures = textureCount + (numTexturesWide * numTexturesTall);
					if ( neededTextures > VERISIMILAR_NUM_OVERLAYS ) then
						VERISIMILAR_NUM_OVERLAYS = neededTextures;
					end
					local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight;
					for j=1, numTexturesTall do
						if ( j < numTexturesTall ) then
							texturePixelHeight = 256;
							textureFileHeight = 256;
						else
							texturePixelHeight = mod(textureHeight, 256);
							if ( texturePixelHeight == 0 ) then
								texturePixelHeight = 256;
							end
							textureFileHeight = 16;
							while(textureFileHeight < texturePixelHeight) do
								textureFileHeight = textureFileHeight * 2;
							end
						end
						for k=1, numTexturesWide do
							textureCount = textureCount + 1;
							if ( k < numTexturesWide ) then
								texturePixelWidth = 256;
								textureFileWidth = 256;
							else
								texturePixelWidth = mod(textureWidth, 256);
								if ( texturePixelWidth == 0 ) then
									texturePixelWidth = 256;
								end
								textureFileWidth = 16;
								while(textureFileWidth < texturePixelWidth) do
									textureFileWidth = textureFileWidth * 2;
								end
							end
							tinsert(info.overlays,{	name=textureName..(((j - 1) * numTexturesWide) + k),
													width=texturePixelWidth,
													height=texturePixelHeight,
													texCoordX=texturePixelWidth/textureFileWidth,
													texCoordY= texturePixelHeight/textureFileHeight,
													x=offsetX + (256 * (k-1)),
													y=-(offsetY + (256 * (j - 1)))
												});
						end
					end
				end
			end
			infoTable[id]=info;
			oldFilename=info.filename;
			info={};
		end
	end
	
	SetMapToCurrentZone()
end