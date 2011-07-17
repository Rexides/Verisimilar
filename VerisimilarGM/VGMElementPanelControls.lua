local controlConstructors={}
local controlMethods={Container={},List={},EditBox={},LargeEditBox={},RadioButtons={},Button={},CheckButton={},DropDown={},Area={},Icon={}};

function VerisimilarGM:CreateElementPanel(elementType,description)
	local panel=CreateFrame("Frame","VGM"..elementType.."MainPanel",VGMMainFrame.controlPanel,"VGMMainElementPanelTemplate");
	panel.tabs={};
	panel.pages={};
	panel.controls={};
	for i=1,#description do
		panel.tabs[i]=CreateFrame("Button",panel:GetName().."Tab"..i,panel,"VGMPanelTabTemplate",i);
		getglobal(panel.tabs[i]:GetName().."Text"):SetText(description[i].text);
		panel.tabs[i].showOnEnabled=description[i].showOnEnabled;
		panel.tabs[i].showOnDisabled=description[i].showOnDisabled;
		
		panel.pages[i]=CreateFrame("Frame",panel:GetName().."Page"..i,panel,"VGMControlPageTemplate",i);
		panel.pages[i].elementPanel=panel;
		self:PopulatePageOrContainer(panel.pages[i],description[i]);
		
	end
	PanelTemplates_SetNumTabs(panel, #panel.tabs)
	
	VGMMainFrame.controlPanel.panels[elementType]=panel;
	return panel;
end

function controlMethods.Container:UpdateData()
	for _,subControl in pairs(container.controls)do
		subControl:UpdateData();
	end
end

local function updateControlNull()end

function VerisimilarGM:PopulatePageOrContainer(page,description)
	page.lastControl=page;
	for i=1,#description do
		controlConstructors[description[i].type](page,description[i]);
	end
end

controlConstructors.Container=function(page,description)
	page.elementPanel.controls[description.key]=CreateFrame("Frame",page:GetName().."Container"..description.key,page,"VGMControlContainerTemplate");
	local control=page.elementPanel.controls[description.key];
	control.elementPanel=page.elementPanel;
	control.key=description.key;
	local refFrame=description.refFrame or page;
	local refPoint=description.refPoint or "TOPLEFT";
	if(refFrame=="PREVIOUS" or refFrame=="PREV")then
		refFrame=page.lastControl;
	end	
	if(type(refFrame)=="string")then
		refFrame=page.elementPanel.controls[refFrame];
	end
	control:SetPoint("TOPLEFT",refFrame,refPoint,description.x,description.y);
	control:SetWidth(description.width or 200);
	control:SetHeight(description.height or 300);
	control.tooltip=description.tooltip;
	control.label:SetText(description.label or "");
	control.controls={};
	VerisimilarGM:PopulatePageOrContainer(control,description);
	
	for methodName,method in pairs(controlMethods.Container)do
		control[methodName]=method;
	end
	page.lastControl=control;
end

function controlMethods.Container:UpdateData()
	for _,subControl in pairs(self.controls)do
		subControl:UpdateData();
	end
end

controlConstructors.EditBox=function(page,description)
	page.elementPanel.controls[description.key]=CreateFrame("EditBox",page:GetName().."Editbox"..description.key,page,"VGMEditBoxControlTemplate");
	local control=page.elementPanel.controls[description.key];
	control.elementPanel=page.elementPanel;
	control.key=description.key;
	local refFrame=description.refFrame or page;
	local refPoint=description.refPoint or "TOPLEFT";
	if(refFrame=="PREVIOUS" or refFrame=="PREV")then
		refFrame=page.lastControl;
	end	
	if(type(refFrame)=="string")then
		refFrame=page.elementPanel.controls[refFrame];
	end
	control:SetPoint("TOPLEFT",refFrame,refPoint,description.x,description.y);
	control:SetWidth(description.width or 135);
	control.label:SetText(description.label or "");
	control.tooltip=description.tooltip;
	control.setFunc=description.setFunc;
	control.getFunc=description.getFunc;
	control:SetNumeric(description.numeric);
	if(description.coordinates)then
		control.oldGetText=control.GetText;
		control.oldSetText=control.SetText;
		control.GetText=function(editBox)
							return (tonumber(editBox:oldGetText()) or 0)/100;
						end;
		control.SetText=function(editBox,text)
							editBox:oldSetText(floor((tonumber(text) or 0)*100000)/1000);
						end
	end
	if(description.labelPosition=="LEFT")then
		control.label:ClearAllPoints();
		control.label:SetPoint("RIGHT",control,"LEFT",-10,0);
	elseif(description.labelPosition=="RIGHT")then
		control.label:ClearAllPoints();
		control.label:SetPoint("LEFT",control,"RIGHT");
	elseif(description.labelPosition=="BOTTOM")then
		control.label:ClearAllPoints();
		control.label:SetPoint("TOPLEFT",control,"BOTTOMLEFT");
	end
	
	for methodName,method in pairs(controlMethods.EditBox)do
		control[methodName]=method;
	end
	page.lastControl=control;
	control:Show();
end

controlMethods.EditBox.UpdateData=updateControlNull;

controlConstructors.LargeEditBox=function(page,description)
	page.elementPanel.controls[description.key]=CreateFrame("Frame",page:GetName().."LargeEditbox"..description.key,page,"VGMLargeEditBoxTemplate");
	local control=page.elementPanel.controls[description.key];
	control.elementPanel=page.elementPanel;
	control.key=description.key;
	local refFrame=description.refFrame or page;
	local refPoint=description.refPoint or "TOPLEFT";
	if(refFrame=="PREVIOUS" or refFrame=="PREV")then
		refFrame=page.lastControl;
	end	
	if(type(refFrame)=="string")then
		refFrame=page.elementPanel.controls[refFrame];
	end
	control:SetPoint("TOPLEFT",refFrame,refPoint,description.x,description.y);
	control:SetWidth(description.width or 135);
	control:SetHeight(description.height or 400);
	control.textButton.tooltip=description.tooltip;
	control.label:SetText(description.label or "");
	
	control.scrollFrame.editBox:SetWidth(control:GetWidth()-40);
	control.scrollFrame.editBox:SetHeight(control:GetHeight());
	control.scrollFrame.editBox:SetScript("OnTabPressed", function(editBox)
																editBox:Insert("    ");
															end);
	
	
	control.scrollFrame.editBox.setFunc=description.setFunc;
	control.scrollFrame.editBox.getFunc=description.getFunc;
	
	for methodName,method in pairs(controlMethods.LargeEditBox)do
		control[methodName]=method;
	end
	page.lastControl=control;
	control:Show();
end

controlMethods.LargeEditBox.UpdateData=updateControlNull;

controlConstructors.RadioButtons=function(page,description)
	local refFrame=description.refFrame or page;
	local refPoint=description.refPoint or "TOPLEFT";
	local x=description.x or 0;
	local y=description.y or 0;
	if(refFrame=="PREVIOUS" or refFrame=="PREV")then
		refFrame=page.lastControl;
	end	
	if(type(refFrame)=="string")then
		refFrame=page.elementPanel.controls[refFrame];
	end
	local peerList={};
	for i=1,#description.buttonLabels do
		page.elementPanel.controls[description.key..i]=CreateFrame("CheckButton",page:GetName().."RadioButton"..description.key..i,page,"VGMRadioButtonTemplate",i);
		local control=page.elementPanel.controls[description.key..i];
		control.key=description.key..i;
		control.elementPanel=page.elementPanel;
		control:SetPoint("TOPLEFT",refFrame,refPoint,x,y);
		getglobal(control:GetName().."Text"):SetText(description.buttonLabels[i]);
		control.tooltip=description.tooltip;
		control.setFunc=description.setFunc;
		control.getFunc=description.getFunc;
		
		refFrame=control;
		refPoint="BOTTOMLEFT";
		x=0;
		y=-10;
		tinsert(peerList,control);
		control.peers=peerList;
		for methodName,method in pairs(controlMethods.RadioButtons)do
			control[methodName]=method;
		end
		page.lastControl=control;
		control:Show();
	end
end

controlMethods.RadioButtons.UpdateData=updateControlNull;

controlConstructors.List=function(page,description)
	page.elementPanel.controls[description.key]=CreateFrame("Frame",page:GetName().."List"..description.key,page,"VGMListTemplate");
	local control=page.elementPanel.controls[description.key];
	control.key=description.key;
	control.elementPanel=page.elementPanel;
	local refFrame=description.refFrame or page;
	local refPoint=description.refPoint or "TOPLEFT";
	local x=description.x or 0;
	local y=description.y or 0;
	if(refFrame=="PREVIOUS" or refFrame=="PREV")then
		refFrame=page.lastControl;
	end	
	if(type(refFrame)=="string")then
		refFrame=page.elementPanel.controls[refFrame];
	end
	control:SetPoint("TOPLEFT",refFrame,refPoint,x,y);
	control:SetWidth(description.width or 175);
	control:SetHeight(description.height or 400);
	control.tooltip=description.tooltip;
	control.container.update=function() control:Refresh() end;
	control.entries={};
	control.lookup={};
													
	control.entryType=strlower(description.entryType or "");
	control.infoFunc=description.infoFunc;
	control.updateFunc=description.updateFunc;
	if(description.showOfflineControls)then
		control.showOffline:Show();
		control.playerCount:Show();
		control.countLabel:Show();
	else
		control.showOffline:Hide();
		control.playerCount:Hide();
		control.countLabel:Hide();
	end
	control.columns={};
	HybridScrollFrame_CreateButtons(control.container,"VGMListButtonTemplate",3,-3);
	for i=1,#control.container.buttons do
		control.container.buttons[i]:SetWidth(control:GetWidth())
	end
	local numVariableWidthColumns=0;
	local unallocatedWidth=control.container:GetWidth()-6+2*(#description.columns-1);
	for i=1,#description.columns do
		local width=description.columns[i].width;
		if(width)then
			unallocatedWidth=unallocatedWidth-width;
		else
			numVariableWidthColumns=numVariableWidthColumns+1;
		end
	end
	for i=1,#description.columns do
		local column=CreateFrame("Button",control:GetName().."Column"..i,control,"VGMListColumnTemplate",i);
		if(i==1)then
			column:SetPoint("BOTTOMLEFT",control.container,"TOPLEFT",3,-3);
		else
			column:SetPoint("LEFT",control.columns[i-1],"RIGHT",-2,0);
		end
		column:SetText(description.columns[i].label);
		local width=description.columns[i].width;
		if(not width)then
			width=floor(unallocatedWidth/numVariableWidthColumns);
			unallocatedWidth=unallocatedWidth-width;
			numVariableWidthColumns=numVariableWidthColumns-1;
			description.columns[i].width=width;
		end
		WhoFrameColumn_SetWidth(column, width);
		for j=1,#control.container.buttons do
			local button=control.container.buttons[j];
			local fontString=button:CreateFontString(button:GetName().."String"..i,"ARTWORK","GameFontHighlightSmall",i);
			if(i==1)then
				fontString:SetPoint("LEFT",button,"LEFT");
				button.labels={};
			else
				fontString:SetPoint("LEFT",control.container.buttons[j].labels[i-1],"RIGHT");
			end
			fontString:SetWidth(width-2);
			button.labels[i]=fontString;
		end
		column:Show();
		control.columns[i]=column;
	end
	control.sortBy=1;
	for methodName,method in pairs(controlMethods.List)do
		control[methodName]=method;
	end
	page.lastControl=control;
	control:Show();
end


function controlMethods.List:UpdateData()
	local session=VerisimilarGM:GetActiveSession();
	local addDisconnected=(not strfind(self.entryType,"players") and true) or self.showOffline:GetChecked();
	local nameLookup={};
	local collection;
	for i=1,#self.entries do
		self.entries[i].delete=true;
	end
	local totalentries, onlineentries =self.updateFunc(self,self.showOffline:GetChecked());
	local i=1
	while(self.entries[i])do
		if(self.entries[i].delete)then
			self.lookup[self.entries[i].entry]=nil;
			tremove(self.entries,i);
		else
			i=i+1;
		end
	end
	
	if(totalentries and onlineentries)then
		self.playerCount:SetText(onlineentries.."/"..totalentries);
	end
	--self.container.range=#self.entries;
	HybridScrollFrame_Update (self.container, #self.entries*self.container.buttonHeight, self.container:GetHeight())
	self:Sort();
end

function controlMethods.List:Insert(entry,enabled)
	if(self.lookup[entry])then
		self.lookup[entry].delete=false;
	else
		local info={entry=entry,enabled=enabled};
		self.lookup[entry]=info;
		tinsert(self.entries,info);
	end
end

function controlMethods.List:Refresh()
	local scrollFrame = self.container;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local button, index
	for i = 1, numButtons do
		button = buttons[i];		
		index = offset + i;
		local entryInfo=self.entries[index];
		if(entryInfo)then
			button.entryInfo=entryInfo;
			local tempInfo={self.infoFunc(entryInfo.entry)};
			for j=1,#button.labels do
				local buttonString=button.labels[j];
				buttonString:SetText(tempInfo[j]);
				if ( entryInfo.enabled) then
					buttonString:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
				else
					buttonString:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
				end
			end
			button:Show();
			if ( mod(index, 2) == 0 ) then
				button.stripe:SetTexCoord(0.36230469, 0.38183594, 0.95898438, 0.99804688);
			else
				button.stripe:SetTexCoord(0.51660156, 0.53613281, 0.88281250, 0.92187500);
			end
			if(entryInfo.selected)then
				button:LockHighlight();
			else
				button:UnlockHighlight();
			end
		else
			button:Hide();
		end
	end
end

function controlMethods.List:Sort()
	local columnNum=self.sortBy;
	local order=self.columns[columnNum].sortOrder;
	sort(self.entries,function(a,b) local comp=strlower(select(columnNum,self.infoFunc(a.entry)))<strlower(select(columnNum,self.infoFunc(b.entry))); return (not order and comp) or (order and not comp); end);
	self:Refresh();
end

function controlMethods.List:ButtonClick(button,mouseButton)
	if(mouseButton=="LeftButton")then
		if(IsShiftKeyDown())then
			local lastIndex,currentIndex;
			for i=1,#self.entries do
				self.entries[i].selected=false;
				if(self.entries[i]==button.entryInfo)then
					currentIndex=i;
				elseif(self.entries[i]==self.lastSelected)then
					lastIndex=i;
				end
			end
			
			lastIndex=lastIndex or currentIndex;
			for i=min(currentIndex,lastIndex),max(currentIndex,lastIndex) do
				self.entries[i].selected=true;
			end
		elseif(IsControlKeyDown())then
			button.entryInfo.selected=not button.entryInfo.selected;
		else
			for i=1,#self.entries do
				self.entries[i].selected=false;
			end
			button.entryInfo.selected=true;
		end
		self.lastSelected=button.entryInfo;
		self:UpdateData();
	end
end

function controlMethods.List:GetSelectedEntries()
	local selectedList={}
	for i=1,#self.entries do
		if(self.entries[i].selected)then
			tinsert(selectedList,self.entries[i].entry);
		end
	end
	return selectedList;
end

controlConstructors.Button=function(page,description)
	page.elementPanel.controls[description.key]=CreateFrame("Button",page:GetName().."Button"..description.key,page,"VGMButtonControlTemplate");
	local control=page.elementPanel.controls[description.key];
	control.key=description.key;
	control.elementPanel=page.elementPanel;
	local refFrame=description.refFrame or page;
	local refPoint=description.refPoint or "TOPLEFT";
	if(refFrame=="PREVIOUS" or refFrame=="PREV")then
		refFrame=page.lastControl;
	end	
	if(type(refFrame)=="string")then
		refFrame=page.elementPanel.controls[refFrame];
	end
	control.ButtonClick=description.clickFunc or updateControlNull;
	control:SetText(description.label or "");
	control:SetPoint("TOPLEFT",refFrame,refPoint,description.x,description.y);
	control:SetWidth(description.width or control:GetTextWidth()+20);
	control.tooltip=description.tooltip;
	for methodName,method in pairs(controlMethods.Button)do
		control[methodName]=method;
	end
	page.lastControl=control;
	control:Show();
end

controlMethods.Button.UpdateData=updateControlNull;

controlConstructors.CheckButton=function(page,description)
	page.elementPanel.controls[description.key]=CreateFrame("CheckButton",page:GetName().."CheckButton"..description.key,page,"VGMCheckButtonControlTemplate");
	local control=page.elementPanel.controls[description.key];
	control.key=description.key;
	control.elementPanel=page.elementPanel;
	local refFrame=description.refFrame or page;
	local refPoint=description.refPoint or "TOPLEFT";
	if(refFrame=="PREVIOUS" or refFrame=="PREV")then
		refFrame=page.lastControl;
	end	
	if(type(refFrame)=="string")then
		refFrame=page.elementPanel.controls[refFrame];
	end
	control.tooltip=description.tooltip;
	control.GetCheckedStatus=description.checkFunc or updateControlNull;
	control.ButtonClick=description.clickFunc or updateControlNull;
	control.label:SetText(description.label or "");
	control:SetPoint("TOPLEFT",refFrame,refPoint,description.x,description.y);
	
	for methodName,method in pairs(controlMethods.CheckButton)do
		control[methodName]=method;
	end
	page.lastControl=control;
	control:Show();
end

controlMethods.CheckButton.UpdateData=updateControlNull;

controlConstructors.DropDown=function(page,description)
	page.elementPanel.controls[description.key]=CreateFrame("Frame",page:GetName().."DropDown"..description.key,page,"VGMDropDownControlTemplate");
	local control=page.elementPanel.controls[description.key];
	control.key=description.key;
	control.elementPanel=page.elementPanel;
	local refFrame=description.refFrame or page;
	local refPoint=description.refPoint or "TOPLEFT";
	if(refFrame=="PREVIOUS" or refFrame=="PREV")then
		refFrame=page.lastControl;
	end	
	if(type(refFrame)=="string")then
		refFrame=page.elementPanel.controls[refFrame];
	end
	control.tooltip=description.tooltip;
	control.label:SetText(description.label or "");
	if(description.labelPosition=="LEFT")then
		control.label:ClearAllPoints();
		control.label:SetPoint("RIGHT",control,"LEFT",15,3);
	end
	control:SetPoint("TOPLEFT",refFrame,refPoint,description.x,description.y);
	UIDropDownMenu_SetWidth(control,description.width or 100);
	control.menuFunc=description.menuFunc or updateControlNull;
	for methodName,method in pairs(controlMethods.DropDown)do
		control[methodName]=method;
	end
	page.lastControl=control;
	control:Show();
end

controlMethods.DropDown.UpdateData=function(ddList)
	local menu=ddList:menuFunc();
	local hasText=false;
	for i=1,#menu do
		if(menu[i].checked)then
			UIDropDownMenu_SetText(ddList, menu[i].text);
			hasText=true;
			break
		end
	end
	if(not hasText)then
		UIDropDownMenu_SetText(ddList, "No selection")
	end
end

controlMethods.DropDown.ButtonClick=function(ddList)
	local menu=ddList:menuFunc();
	EasyMenu(menu, ddList, ddList, 0, 0, nil, 10);
end

controlConstructors.Area=function(page,description)
	page.elementPanel.controls[description.key]=CreateFrame("Frame",page:GetName().."Area"..description.key,page,"VGMAreaControlTemplate");
	local control=page.elementPanel.controls[description.key];
	control.key=description.key;
	control.elementPanel=page.elementPanel;
	local refFrame=description.refFrame or page;
	local refPoint=description.refPoint or "TOPLEFT";
	if(refFrame=="PREVIOUS" or refFrame=="PREV")then
		refFrame=page.lastControl;
	end	
	if(type(refFrame)=="string")then
		refFrame=page.elementPanel.controls[refFrame];
	end
	control.tooltip=description.tooltip;
	
	control:SetPoint("TOPLEFT",refFrame,refPoint,description.x,description.y);
	
	control.tiles={};
	control.overlays={};
	local s=control:GetName().."MapDetailTile";
	for i=1,12 do
		control.tiles[i]=getglobal(s..i);
	end
	for i=1,VERISIMILAR_NUM_OVERLAYS do
		control.overlays[i]=control.Map:CreateTexture(control:GetName().."Overlay"..i, "ARTWORK");
	end
	control.Map:SetScale(WORLDMAP_WINDOWED_SIZE);
	control.getFunc=description.getFunc or updateControlNull;
	control.setFunc=description.setFunc or updateControlNull;
	control.clickFunc=description.clickFunc or updateControlNull;
	local setMapLevel=function(frame,area,level)
		control.level=level;
		control:setFunc(area,level);
		control:UpdateData();
	end
	getglobal(control.levelDD:GetName().."Button"):SetScript("OnClick",	function()
																				if(not control.area)then return end
																				local map=VerisimilarGM.zoneMapInfo[control.area];
																				local dungeonLevel=control.level;
																				local menu={};
																				for i=1,map.numLevels do
																					tinsert(menu,{text=_G["DUNGEON_FLOOR_" .. strupper(map.filename) .. i],checked=i==dungeonLevel,func=setMapLevel,arg1=control.area,arg2=i});
																				end
																				EasyMenu(menu, control.levelDD, control.levelDD, 0 , 0);
																				PlaySound("igMainMenuOptionCheckBoxOn");
																			end
	);
	UIDropDownMenu_SetWidth(control.levelDD,160);
	local ScrollingTable = LibStub("ScrollingTable");
	local listDesc={[1]={
				["name"] = "Map name",
				["width"] = 95,
				["align"] = "LEFT",
				["defaultsort"] = "dsc",
			}};
	control.mapList = ScrollingTable:CreateST(listDesc,21,nil,nil,control);
	control.mapList.frame:SetPoint("TOPLEFT",control.filter,"BOTTOMLEFT",-5,-20);
	control.mapList:RegisterEvents({
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, table, ...)
									if(data[realrow])then
										local map=data[realrow].Map
										
										control:setFunc(map.id,map.numLevels and 1 or 0);
										control:UpdateData();
									end
								end,
			});
	
	local itemList={};
	for id,info in pairs(VerisimilarGM.zoneMapInfo) do
		local entry={};
		entry.Map=info;
		entry.cols={{value=info.filename}};
		tinsert(itemList,entry);
	end
	control.mapList:SetData(itemList)
	control.mapList:EnableSelection(true)
	local mapFilter=function(list,row)
		if(strfind(strlower(row.Map.filename),strlower(control.filter:GetText())))then
			return true
		end
		return false;
	end
	control.mapList:SetFilter(mapFilter);
	control.mapList=control.mapList;
	
	for methodName,method in pairs(controlMethods.Area)do
		control[methodName]=method;
	end
	page.lastControl=control;
	control:Show();
end

controlMethods.Area.UpdateData=function(self)
	local mapId,dungeonLevel=self:getFunc();
	local map=VerisimilarGM.zoneMapInfo[mapId];
	
	if(not map)then 
		self.area=0;
		self.level=0;
		self.levelDD:Hide();
		for i=1, #self.tiles do
			self.tiles[i]:SetTexture();
		end
		for i=1, #self.overlays do
			self.overlays[i]:Hide();
		end
	else
		self.area=map.id;
		self.level=dungeonLevel;
		local completeMapFileName;
		if ( map.numLevels > 0 ) then
			completeMapFileName = map.filename..dungeonLevel.."_";
			self.levelDD:Show();
			UIDropDownMenu_SetText(self.levelDD, _G["DUNGEON_FLOOR_" .. strupper(map.filename) .. dungeonLevel])
		else
			completeMapFileName = map.filename;
			self.levelDD:Hide();
		end
		
		for i=1, #self.tiles do
			local texName = "Interface\\WorldMap\\"..map.filename.."\\"..completeMapFileName..i;
			self.tiles[i]:SetTexture(texName);
		end
		
		for i=1,#map.overlays do
			local texture=self.overlays[i];
			texture:SetWidth(map.overlays[i].width);
			texture:SetHeight(map.overlays[i].height);
			texture:SetTexCoord(0, map.overlays[i].texCoordX, 0,map.overlays[i].texCoordY);
			texture:SetPoint("TOPLEFT", map.overlays[i].x, map.overlays[i].y);
			texture:SetTexture(map.overlays[i].name);
			texture:Show();
		end
		
		for i=#map.overlays+1, #self.overlays do
			self.overlays[i]:Hide();
		end
	end
end

controlMethods.Area.MapClicked=function(self)
	local cursorX, cursorY = GetCursorPosition();
	
	local mapScale=self.Map:GetEffectiveScale();
	local x = (cursorX-self.Map:GetLeft()*mapScale)
	local y = (cursorY-self.Map:GetBottom()*mapScale)
	
	self:clickFunc(x/self.Map:GetWidth()/mapScale,1-y/self.Map:GetHeight()/mapScale)
end

controlConstructors.Icon=function(page,description)
	page.elementPanel.controls[description.key]=CreateFrame("Button",page:GetName().."Icon"..description.key,page,"VGMIconControlTemplate");
	local control=page.elementPanel.controls[description.key];
	control.key=description.key;
	control.elementPanel=page.elementPanel;
	local refFrame=description.refFrame or page;
	local refPoint=description.refPoint or "TOPLEFT";
	if(refFrame=="PREVIOUS" or refFrame=="PREV")then
		refFrame=page.lastControl;
	end	
	if(type(refFrame)=="string")then
		refFrame=page.elementPanel.controls[refFrame];
	end
	control.tooltip=description.tooltip;
	control.getFunc=description.getFunc or updateControlNull;
	control.setFunc=description.setFunc or updateControlNull;
	control.label:SetText(description.label or "");
	control:SetPoint("TOPLEFT",refFrame,refPoint,description.x,description.y);
	
	for methodName,method in pairs(controlMethods.CheckButton)do
		control[methodName]=method;
	end
	page.lastControl=control;
	control:Show();
end

controlMethods.CheckButton.UpdateData=updateControlNull;
	
function VerisimilarGM:HandleTabVisibility(panel)
	local element=VGMMainFrame.controlPanel.element;
	local enabled=element:IsEnabled();
	panel:Show()
	if(element.elType~="Session")then
		enabled=enabled and element:GetSession():IsEnabled();
	end
	local anchorFrame=panel;
	local anchorPoint="TOPLEFT";
	local anchorX=5;
	local anchorY=-3;
	for i=1,#panel.tabs do
		if((enabled and panel.tabs[i].showOnEnabled) or (not enabled and panel.tabs[i].showOnDisabled))then
			panel.tabs[i]:ClearAllPoints();
			panel.tabs[i]:SetPoint("BOTTOMLEFT",anchorFrame,anchorPoint,anchorX,anchorY);
			panel.tabs[i]:Show();
			anchorFrame=panel.tabs[i];
			anchorPoint="BOTTOMRIGHT";
			anchorX=-15;
			anchorY=0;
		else
			panel.tabs[i]:Hide();
		end
	end
	local noShownPanel=true;
	for i=1,#panel.tabs do
		if(panel.tabs[i]:IsShown())then
			self:TabClickHandler(panel.tabs[i]);
			noShownPanel=false;
			break;
		end
	end
	if(noShownPanel)then
		panel:Hide()
	end
end

function VerisimilarGM:TabClickHandler(tab)
	PanelTemplates_Tab_OnClick(tab, tab:GetParent());
	PanelTemplates_UpdateTabs(tab:GetParent());
	local selected=tab:GetParent().selectedTab;
	local tabs=tab:GetParent().tabs;
	local pages=tab:GetParent().pages;
	for i=1,#tabs do
		if(i==selected)then
			tabs[i].spacer1:Show();
			tabs[i].spacer2:Show();
			_G[tabs[i]:GetName().."Text"]:SetPoint("CENTER", tabs[i], "CENTER", 0, 0); --No clue, used to work before I tinkered too much
			pages[i]:Show();
		else
			tabs[i].spacer1:Hide();
			tabs[i].spacer2:Hide();
			_G[tabs[i]:GetName().."Text"]:SetPoint("CENTER", tabs[i], "CENTER", 0, -4); --No clue, used to work before I tinkered too much
			pages[i]:Hide();
		end
	end
end

