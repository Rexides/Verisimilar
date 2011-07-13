local areaPanel,regionMarker
local UpdateRegionMarker,SetRegionMarker,GetRegionMenu,AddRegion,RemoveRegion,RegionClick,GetRegionTypeMenu,SetRegionCoords,GetRegionX,GetRegionY,SetCenterAsPlayer,SetRegionWidth, GetRegionWidth, SetWidthToPlayer,SetRegionHeight,GetRegionHeight,SetHeightToPlayer,SetSubzone,GetSubzone,SetSubzoneToPlayer,SetRegionThreshold, GetRegionThreshold,SetThresholdToPlayer
function VerisimilarGM:InitializeAreaPanel()
	
	StaticPopupDialogs["VERISIMILAR_NEW_AREA"] = {
		text = "Enter the Area ID. The \"ID\" is just a codeword used to refer to this area within Verisimilar GM, not the area's actual name. 30 characters max, no space or special characters",
		button1 = "Create",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data)
			local Area=data:NewArea(self.editBox:GetText());
			if(Area)then
				VerisimilarGM:AddElementToElementList(Area);
				VerisimilarGM:UpdateElementList();
				VerisimilarGM:SetPanelToElement(Area);
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
						
						},
						{text="Regions",showOnEnabled=false,showOnDisabled=true,
							{type="DropDown", key="region",label="Region:",x=30,y=-5, width=100,labelPosition="LEFT", menuFunc=GetRegionMenu, tooltip="Select one of the regions to edit. Regions are smaller parts of the area that are described by simple shapes, or by a subzone."},
							{type="Button", key="addRegion",label="Add Region",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=0,y=0, clickFunc=AddRegion ,tooltip="Add a new region to this area. Regions are smaller parts of the area that are described by simple shapes, or by a subzone."},
							{type="Button", key="removeRegion",label="Remove Region",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=RemoveRegion ,tooltip="Remove the currently selected region from the area"},
						
							{type="DropDown", key="regionType",label="Region type:",x=55,y=-40, width=120,labelPosition="LEFT", menuFunc=GetRegionTypeMenu, tooltip="The type of the region changes it's shape."},
							
							{type="EditBox", key="regionX",label="X:",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=20,y=0,width=130,labelPosition="LEFT",setFunc=SetRegionCoords, getFunc=GetRegionX,tooltip="The x coordinate of the region's center point"},
							{type="EditBox", key="regionY",label="Y:",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=30,y=0,width=130,labelPosition="LEFT",setFunc=SetRegionCoords, getFunc=GetRegionY,tooltip="The y coordinate of the region's center point"},
							{type="Button", key="setCenterAsPlayer",label="Set as my position",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=SetCenterAsPlayer ,tooltip="Set the region's center as your current position"},
							{type="EditBox", key="regionWidth",label="Width:",refFrame="regionType",refPoint="BOTTOMLEFT",x=0,y=-10,width=130,labelPosition="LEFT",setFunc=SetRegionWidth, getFunc=GetRegionWidth,tooltip="The region's radius (if circle) or width (if rectangle)"},
							{type="Button", key="increaseWidth",label="+",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function() local area=VerisimilarGM:GetActiveElement();local distance=tonumber(areaPanel.controls.regionWidth:GetText())*1.1;area:SetWidth(areaPanel.controls.region.selection,distance);areaPanel.controls.regionWidth:SetText(distance);UpdateRegionMarker() end},
							{type="Button", key="decreaseWidth",label="-",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=5,y=0, clickFunc=function() local area=VerisimilarGM:GetActiveElement();local distance=tonumber(areaPanel.controls.regionWidth:GetText())*0.9;area:SetWidth(areaPanel.controls.region.selection,distance);areaPanel.controls.regionWidth:SetText(distance);UpdateRegionMarker() end},
							{type="Button", key="setWidthToPlayer",label="Set to my position",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=SetWidthToPlayer ,tooltip="Set the circle's radius or rectangle's width to your current position"},
							{type="EditBox", key="regionHeight",label="Height:",refFrame="regionWidth",refPoint="BOTTOMLEFT",x=0,y=-5,width=130,labelPosition="LEFT",setFunc=SetRegionHeight, getFunc=GetRegionHeight,tooltip="The region's radius (if circle) or width (if rectangle)"},
							{type="Button", key="increaseHeight",label="+",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function() local area=VerisimilarGM:GetActiveElement();local distance=tonumber(areaPanel.controls.regionHeight:GetText())*1.1;area:SetHeight(areaPanel.controls.region.selection,distance);areaPanel.controls.regionHeight:SetText(distance);UpdateRegionMarker() end},
							{type="Button", key="decreaseHeight",label="-",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=5,y=0, clickFunc=function() local area=VerisimilarGM:GetActiveElement();local distance=tonumber(areaPanel.controls.regionHeight:GetText())*0.9;area:SetHeight(areaPanel.controls.region.selection,distance);areaPanel.controls.regionHeight:SetText(distance);UpdateRegionMarker() end},
							{type="Button", key="setHeightToPlayer",label="Set to my position",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=SetHeightToPlayer ,tooltip="Set the rectangle's height to your current position"},
							{type="EditBox", key="regionThreshold",label="Threshold:",refFrame="setWidthToPlayer",refPoint="TOPRIGHT",x=80,y=0,width=150,setFunc=SetRegionThreshold, getFunc=GetRegionThreshold,tooltip="The additional distance the player has to cover before entering or leaving the area"},
							{type="Button", key="increaseThreshold",label="+",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function() local area=VerisimilarGM:GetActiveElement();local threshold=tonumber(areaPanel.controls.regionThreshold:GetText())*1.1;area:SetThreshold(threshold);areaPanel.controls.regionThreshold:SetText(threshold);UpdateRegionMarker() end},
							{type="Button", key="decreaseThreshold",label="-",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=5,y=0, clickFunc=function() local area=VerisimilarGM:GetActiveElement();local threshold=tonumber(areaPanel.controls.regionThreshold:GetText())*0.9;area:SetThreshold(threshold);areaPanel.controls.regionThreshold:SetText(threshold);UpdateRegionMarker() end},
							{type="Button", key="setThresholdToPlayer",label="Set to my position",refFrame="regionThreshold",refPoint="BOTTOMLEFT",x=0,y=-5, clickFunc=SetThresholdToPlayer ,tooltip="Set the threshold as the distance from the side closest to the player, up to his position"},
							{type="EditBox", key="subzone",label="Subzone:",refFrame="regionType",refPoint="BOTTOMLEFT",x=0,y=-10,width=180,labelPosition="LEFT",setFunc=SetSubzone, getFunc=GetSubzone,tooltip="The subzone's name"},
							{type="Button", key="setSubzoneToPlayer",label="Set to my subzone",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=SetSubzoneToPlayer ,tooltip="Set to your current subzone"},
							{type="Area", key="regionPicker",x=0,y=-145,clickFunc=RegionClick,setFunc=function(areaControl,zone,level) VerisimilarGM:GetActiveElement():SetZone(zone,level) end, getFunc=function(areaControl) return VerisimilarGM:GetActiveElement():GetZone() end,},
						},
						{text="Scripts",showOnEnabled=false,showOnDisabled=true,
							{type="LargeEditBox", key="enteringScript",label="Entering Script:",x=10,y=-15,width=650,height=340,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetAreaScript(text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetAreaScript(); end,},
						}
					};
	
	areaPanel=self:CreateElementPanel("Area",description)
	
	regionMarker=CreateFrame("Frame",nil,areaPanel.controls.regionPicker);
	regionMarker:SetWidth(20);
	regionMarker:SetHeight(20);
	regionMarker:SetFrameLevel(areaPanel.controls.regionPicker.Map:GetFrameLevel()+1);
	regionMarker.texture=regionMarker:CreateTexture();
	regionMarker.texture:SetPoint("CENTER",regionMarker,"CENTER");
	
end

UpdateRegionMarker=function()
	local controls=areaPanel.controls
	local map=controls.regionPicker.Map;
	local xScale=2.0*map:GetWidth()*map:GetEffectiveScale();
	local yScale=2.0*map:GetHeight()*map:GetEffectiveScale();
	
	local width=abs(tonumber(controls.regionWidth:GetText()) or 0);
	local height=abs(controls.regionType.selection==4 and (tonumber(controls.regionHeight:GetText()) or 0) or width);
	regionMarker.texture:SetSize(width*xScale,height*yScale);
	regionMarker.texture:SetVertexColor(1,0.7,0.1,0.5);
end

local function SetRegionMarker(x,y)
	local map=areaPanel.controls.regionPicker.Map;
	local scale=map:GetEffectiveScale();
	regionMarker:SetPoint("CENTER", map, "TOPLEFT",x*map:GetWidth()*scale,-y*map:GetHeight()*scale);
	UpdateRegionMarker();
	--regionMarker:Show();	
end

local function RegionClicked(button,regionNum)
	local controls=areaPanel.controls;
	local area=VerisimilarGM:GetActiveElement();

	controls.regionType:Hide();
	controls.regionPicker:Hide();
	controls.region.selection=regionNum;
	
	controls.regionX:Hide();
	controls.regionY:Hide();
	controls.setCenterAsPlayer:Hide();
	controls.regionWidth:Hide();
	controls.increaseWidth:Hide();
	controls.decreaseWidth:Hide();
	controls.setWidthToPlayer:Hide();
	controls.regionHeight:Hide();
	controls.increaseHeight:Hide();
	controls.decreaseHeight:Hide();
	controls.setHeightToPlayer:Hide();
	controls.regionThreshold:Hide();
	controls.increaseThreshold:Hide();
	controls.decreaseThreshold:Hide();
	controls.setThresholdToPlayer:Hide();
	controls.subzone:Hide();
	controls.setSubzoneToPlayer:Hide();

	if(regionNum)then
		controls.regionType:Show();
		controls.regionPicker:Show();
	end
	VerisimilarGM:UpdateInterface();
end

GetRegionMenu=function(ddList)
	local area=VerisimilarGM:GetActiveElement();
	local menu={};
	for i=1,#area.regions do
		tinsert(menu,{text=i,checked=ddList.selection==i,func=RegionClicked,arg1=i});
	end
	menu.func=RegionClicked;
	return menu;
end

AddRegion=function(button)
	local area=VerisimilarGM:GetActiveElement();
	area:AddRegion();
	RegionClicked(nil,#area.regions)
	VerisimilarGM:UpdateInterface()
end

RemoveRegion=function(button)
	local regionDD=areaPanel.controls.region;
	local area=VerisimilarGM:GetActiveElement();
	if(regionDD.selection)then
		area:RemoveRegion(regionDD.selection);
	end
	RegionClicked(nil,((#area.regions>0) and 1) or nil)
	VerisimilarGM:UpdateInterface()
end

local function RegionTypeClicked(button,typeNum)
	local controls=areaPanel.controls;
	local area=VerisimilarGM:GetActiveElement();
	
	area:SetType(controls.region.selection,typeNum)
	controls.regionX:Hide();
	controls.regionY:Hide();
	controls.setCenterAsPlayer:Hide();
	controls.regionWidth:Hide();
	controls.increaseWidth:Hide();
	controls.decreaseWidth:Hide();
	controls.setWidthToPlayer:Hide();
	controls.regionHeight:Hide();
	controls.increaseHeight:Hide();
	controls.decreaseHeight:Hide();
	controls.setHeightToPlayer:Hide();
	controls.regionThreshold:Hide();
	controls.increaseThreshold:Hide();
	controls.decreaseThreshold:Hide();
	controls.setThresholdToPlayer:Hide();
	controls.subzone:Hide();
	controls.setSubzoneToPlayer:Hide();
	controls.regionType.selection=typeNum;
	
	regionMarker:Hide()
	
	if(typeNum==3)then
		controls.regionX:Show();
		controls.regionY:Show();
		controls.setCenterAsPlayer:Show();
		controls.regionWidth:Show();
		controls.increaseWidth:Show();
		controls.decreaseWidth:Show();
		controls.setWidthToPlayer:Show();
		controls.regionThreshold:Show();
		controls.increaseThreshold:Show();
		controls.decreaseThreshold:Show();
		controls.setThresholdToPlayer:Show();
		regionMarker.texture:SetTexture("Interface\\AddOns\\VerisimilarPlayer\\Images\\Interface\\white_circle");
		UpdateRegionMarker();
		regionMarker:Show()
	elseif(typeNum==4)then
		controls.regionX:Show();
		controls.regionY:Show();
		controls.setCenterAsPlayer:Show();
		controls.regionWidth:Show();
		controls.increaseWidth:Show();
		controls.decreaseWidth:Show();
		controls.setWidthToPlayer:Show();
		controls.regionHeight:Show();
		controls.increaseHeight:Show();
		controls.decreaseHeight:Show();
		controls.setHeightToPlayer:Show();
		controls.regionThreshold:Show();
		controls.increaseThreshold:Show();
		controls.decreaseThreshold:Show();
		controls.setThresholdToPlayer:Show();
		regionMarker.texture:SetTexture(1,1,1);
		UpdateRegionMarker();
		regionMarker:Show()
	elseif(typeNum==2)then
		controls.subzone:Show();
		controls.setSubzoneToPlayer:Show();
	end
	VerisimilarGM:UpdateInterface();
end

GetRegionTypeMenu=function(ddList)
	local area=VerisimilarGM:GetActiveElement();
	local regionDD=areaPanel.controls.region;
	local menu={};
	local regionType=area:GetType(regionDD.selection)
	for i=1,#VerisimilarPl.regionTypes do
		tinsert(menu,{text=VerisimilarPl.regionTypes[i],checked=regionType==VerisimilarPl.regionTypes[i],func=RegionTypeClicked,arg1=i});
	end
	return menu;
end

RegionClick=function(area,x,y)
	local controls=areaPanel.controls;
	local area=VerisimilarGM:GetActiveElement();
	
	controls.regionX:SetText(x);
	controls.regionY:SetText(y);
	area:SetCenter(controls.region.selection,x,y);
	
	SetRegionMarker(x,y)

end

SetRegionCoords=function(editBox,text)
	local controls=areaPanel.controls;
	local area=VerisimilarGM:GetActiveElement();
	local x=tonumber(controls.regionX:GetText());
	local y=tonumber(controls.regionY:GetText());
	if(controls.region.selection)then
		area:SetCenter(controls.region.selection,x,y)
	end
	SetRegionMarker(x,y);
end

GetRegionX=function(editBox)
	local regionDD=areaPanel.controls.region;
	local area=VerisimilarGM:GetActiveElement();
	if(regionDD.selection)then
		local x,y=area:GetAreaInfo(regionDD.selection)
		SetRegionMarker(x,y) --Yeah, kind of a hack, but it works
		return x
	end
end

GetRegionY=function(editBox)
	local regionDD=areaPanel.controls.region;
	local area=VerisimilarGM:GetActiveElement();
	if(regionDD.selection)then
		local x,y=area:GetAreaInfo(regionDD.selection)
		return y
	end
end

SetCenterAsPlayer=function(button)
	local controls=areaPanel.controls;
	SetMapToCurrentZone();
	local zoneId=GetCurrentMapAreaID();
	local level=GetCurrentMapDungeonLevel();
	local x,y=GetPlayerMapPosition("player");
	controls.regionX:SetText(x);
	controls.regionY:SetText(y);
	SetRegionMarker(x,y);
	VerisimilarGM:GetActiveElement():SetCenter(controls.region.selection,x,y);
	VerisimilarGM:GetActiveElement():SetZone(zoneId,level);
	VerisimilarGM:UpdateInterface();
end

SetRegionWidth=function(editBox,text)
	local controls=areaPanel.controls;
	local area=VerisimilarGM:GetActiveElement();
	if(controls.region.selection)then
		area:SetWidth(controls.region.selection,controls.regionWidth:GetText())
	end
	SetRegionMarker(x,y);
end

GetRegionWidth=function(editBox)
	local regionDD=areaPanel.controls.region;
	local area=VerisimilarGM:GetActiveElement();
	if(regionDD.selection)then
		local x,y,width=area:GetAreaInfo(regionDD.selection)
		return width
	end
end

SetWidthToPlayer=function(button)
	local controls=areaPanel.controls;
	SetMapToCurrentZone();
	local zoneId=GetCurrentMapAreaID();
	local level=GetCurrentMapDungeonLevel();
	local x,y=GetPlayerMapPosition("player");
	local dx=abs(controls.regionX:GetText()-x);
	local dy=abs(controls.regionY:GetText()-y);
	local width=controls.regionType.selection==4 and dx or sqrt(dx*dx+dy*dy);
	controls.regionWidth:SetText(width);
	VerisimilarGM:GetActiveElement():SetWidth(controls.region.selection,width);
	VerisimilarGM:GetActiveElement():SetZone(zoneId,level);
	UpdateRegionMarker();
	VerisimilarGM:UpdateInterface();
end

SetRegionHeight=function(editBox,text)
	local controls=areaPanel.controls;
	local area=VerisimilarGM:GetActiveElement();
	if(controls.region.selection)then
		area:SetHeight(controls.region.selection,controls.regionHeight:GetText())
	end
	SetRegionMarker(x,y);
end


GetRegionHeight=function(editBox)
	local regionDD=areaPanel.controls.region;
	local area=VerisimilarGM:GetActiveElement();
	if(regionDD.selection)then
		local x,y,width,height=area:GetAreaInfo(regionDD.selection)
		return height
	end
end

SetHeightToPlayer=function(button)
	local controls=areaPanel.controls;
	SetMapToCurrentZone();
	local zoneId=GetCurrentMapAreaID();
	local level=GetCurrentMapDungeonLevel();
	local x,y=GetPlayerMapPosition("player");
	local dy=abs(controls.regionY:GetText()-y);
	controls.regionHeight:SetText(dy);
	VerisimilarGM:GetActiveElement():SetHeight(controls.region.selection,dy);
	VerisimilarGM:GetActiveElement():SetZone(zoneId,level);
	UpdateRegionMarker();
	VerisimilarGM:UpdateInterface();
end

SetRegionThreshold=function(editBox,text)
	local controls=areaPanel.controls;
	local area=VerisimilarGM:GetActiveElement();
	area:SetThreshold(controls.regionThreshold:GetText())
end

GetRegionThreshold=function(editBox)
	local regionDD=areaPanel.controls.region;
	local area=VerisimilarGM:GetActiveElement();
	if(regionDD.selection)then
		local x,y,width,height,threshold=area:GetAreaInfo(regionDD.selection)
		return threshold;
	end
end

SetThresholdToPlayer=function(button)
	local regionDD=areaPanel.controls.region;
	local area=VerisimilarGM:GetActiveElement();
	local x,y=GetPlayerMapPosition("player");
	local cx,cy,width,height,threshold=area:GetAreaInfo(regionDD.selection)
	
	local areaType=area:GetType(regionDD.selection);
	local threshold;
	if(areaType=="Circle")then
		local dx=x-cx;
		local dy=y-cy;
		threshold=abs(sqrt(dx*dx+dy*dy)-width);
	elseif(areaType=="Rectangle")then
		local leftDist=abs(cx-width-x);
		local rightDist=abs(cx+width-x);
		local topDist=abs(cy+height-y);
		local bottomDist=abs(cy-height-y);
		local horizLess=leftDist<rightDist and leftDist or rightDist;
		local vertLess=topDist<bottomDist and topDist or bottomDist;
		threshold=horizLess<vertLess and horizLess or vertLess;
	end
	areaPanel.controls.regionThreshold:SetText(threshold);
	VerisimilarGM:GetActiveElement():SetThreshold(threshold);
end

SetSubzone=function(editBox,text)
	local controls=areaPanel.controls;
	local area=VerisimilarGM:GetActiveElement();
	if(controls.region.selection)then
		area:SetSubzone(controls.region.selection,text)
	end
end

GetSubzone=function(editBox)
	local regionDD=areaPanel.controls.region;
	local area=VerisimilarGM:GetActiveElement();
	if(regionDD.selection)then
		return area:GetSubzone(regionDD.selection)
	end
end

SetSubzoneToPlayer=function(button)
	local controls=areaPanel.controls;
	SetMapToCurrentZone();
	local zoneId=GetCurrentMapAreaID();
	local level=GetCurrentMapDungeonLevel();
	local subzone=GetSubZoneText();
	controls.subzone:SetText(subzone);
	VerisimilarGM:GetActiveElement():SetSubzone(controls.region.selection,subzone);
	VerisimilarGM:GetActiveElement():SetZone(zoneId,level);
	VerisimilarGM:UpdateInterface();
end

function VerisimilarGM:SetPanelToArea()
	local area=VGMMainFrame.controlPanel.element;
	VGMMainFrame.controlPanel.title:SetText(area.id);
	VGMMainFrame.controlPanel.panels.Area:Show();
end