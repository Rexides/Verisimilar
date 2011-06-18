--All code here was shamelessly stolen from Cartographer Notes.
--I have no pride for self, only shame.
--I will commit sepuku once I hit level 85 in cataclysm on both my toons and maybe a goblin.

local Minimap = Minimap
local rotateMinimap = GetCVar("rotateMinimap") == "1"
local lastX, lastY  = 1/0, 1/0
local lastZoom,lastTracking,forceNextMinimapUpdate,indoors
local Tourist=LibStub("LibTourist-3.0");
VerisimilarPl.minimapPoints={};
VerisimilarPl.minimapQuestPoints={};
local pointCache={};
local questPointCache={};

local MinimapSize = { -- radius of minimap
	indoor = {
		[0] = 150,
		[1] = 120,
		[2] = 90,
		[3] = 60,
		[4] = 40,
		[5] = 25,
	},
	outdoor = {
		[0] = 233 + 1/3,
		[1] = 200,
		[2] = 166 + 2/3,
		[3] = 133 + 1/6,
		[4] = 100,
		[5] = 66 + 2/3,
	},
}

local minimapUpdateTimer

function VerisimilarPl:UpdateMinimapIconsShowStatus()
	if(self.db.char.showEvnIconsOnMinimap)then
		minimapUpdateTimer=self:ScheduleRepeatingTimer("UpdateMinimapIcons", 0.1 );
		for sessionName,session in pairs(self.sessions)do
			for stubId,stub in pairs(session.stubs)do
				if(stub.enabled and stub.type=="NPC" and stub.exists and stub.visible and (stub.environmentIcon or not VerisimilarPl.db.char.mergeWithGossipInterface))then
					VerisimilarPl:AddMinimapPoint(stub)
				end
			end
		end
	else
		self:CancelTimer(minimapUpdateTimer);
		for _,point in pairs(VerisimilarPl.minimapPoints)do
			point:Hide()
			tinsert(pointCache,point);
		end
		VerisimilarPl.minimapPoints={}
	end
end

function VerisimilarPl:AddMinimapPoint(stub)
	if(not VerisimilarPl.db.char.showEvnIconsOnMinimap)then return end
	if(VerisimilarPl.minimapPoints[stub.session.gm.."_"..stub.session.id..stub.id])then return end
	local index,point=next(pointCache);
	
	if(point==nil)then
		point=CreateFrame("Button", nil, MiniMap)
		point:EnableMouse(true)
		point:SetMovable(true)
		point:SetWidth(16)
		point:SetHeight(16)
		point:SetPoint("CENTER", MiniMap, "CENTER")
		point:SetFrameStrata(Minimap:GetFrameStrata())
		point:SetFrameLevel(Minimap:GetFrameLevel() + 2)
		point:SetScript("OnEnter", VPLMMPointOnEnter)
		point:SetScript("OnLeave", VPLMMPointOnLeave)
		point:SetScript("OnClick", VPLMMPointOnClick)

		local texture = point:CreateTexture(nil, "OVERLAY")
		point.texture = texture
		texture:SetAllPoints(point)
	else
		pointCache[index]=nil;
	end
	
	point.object=stub;
	point.texture:SetTexture("Interface\\Icons\\"..stub.icon)
	point.texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	point.x=stub.coordX
	point.y=stub.coordY
	VerisimilarPl.minimapPoints[stub.session.gm.."_"..stub.session.id..stub.id]=point;
	forceNextMinimapUpdate=true;
end

function VPLMMPointOnEnter(self)
	GameTooltip_SetDefaultAnchor( GameTooltip, self );
	GameTooltip:SetPoint("BOTTOM",self,"TOP");
	GameTooltip:ClearLines();
	GameTooltip:AddLine(self.object.name);
	if(self.object.actable==false and not self.isQuestIcon)then
		GameTooltip:AddLine("Cannot interact yet");
	end
	
	GameTooltip:Show();
end

function VPLMMPointOnLeave()
	GameTooltip:Hide();
end

function VPLMMPointOnClick(self)
	VerisimilarPl:EnvironmentClicked(self.object)
end

function VerisimilarPl:RemoveMinimapPoint(stub)
	point=VerisimilarPl.minimapPoints[stub.session.gm.."_"..stub.session.id..stub.id];
	if(not point) then return end
	VerisimilarPl.minimapPoints[stub.session.gm.."_"..stub.session.id..stub.id]=nil;
	point:Hide();
	tinsert(pointCache,point);
	forceNextMinimapUpdate=true;
end

function VerisimilarPl:UpdateMinimapQuestPoints()
	local numPoints=#self.minimapQuestPoints
	for i=1,numPoints do
		tinsert(questPointCache,self.minimapQuestPoints[i]);
		self.minimapQuestPoints[i]=nil;
	end
	for _, session in pairs(self.sessions)do
		for _,stub in pairs(session.stubs)do
			if(stub.enabled and stub.type=="NPC" and stub.zone==self.currentZone)then
				local index,point=next(questPointCache);
	
				if(point==nil)then
					point=CreateFrame("Frame", nil, MiniMap)
					--point:EnableMouse(true)
					point:SetMovable(true)
					point:SetWidth(16)
					point:SetHeight(16)
					point:SetPoint("CENTER", MiniMap, "CENTER")
					point:SetFrameStrata(Minimap:GetFrameStrata())
					point:SetFrameLevel(Minimap:GetFrameLevel() + 3)
					point:SetScript("OnEnter", VPLMMPointOnEnter)
					point:SetScript("OnLeave", VPLMMPointOnLeave)
					point.isQuestIcon=true;
					local texture = point:CreateTexture(nil, "OVERLAY")
					point.texture = texture
					texture:SetAllPoints(point)
				else
					questPointCache[index]=nil;
				end
				point.object=stub;
				point.x=stub.coordX
				point.y=stub.coordY
				self.minimapQuestPoints[stub.session.gm.."_"..stub.session.id..stub.id]=point;
				forceNextMinimapUpdate=true;
			end
		end
	end
	self:UpdateMinimapQuestIcons()
end

function VerisimilarPl:UpdateMinimapQuestIcons()
	for _, point in pairs(self.minimapQuestPoints)do
		point.available=false;
		point.completed=false;
		point:Hide();
	end
	for _,session in pairs(self.sessions)do
		for __,stub in pairs(session.stubs)do
			if(stub.enabled and stub.type=="Quest" and not stub.finished)then
				for enderId,_ in pairs(stub.enders)do
				local npcStub=session.stubs[enderId];
					if(npcStub and npcStub.enabled and npcStub.exists and npcStub.zone==self.currentZone)then
						local point=self.minimapQuestPoints[npcStub.session.gm.."_"..npcStub.session.id..npcStub.id];
						if(point and stub.onQuest and stub.completed)then
							point.completed=true;
						end
					end
				end
				for starterId,_ in pairs(stub.starters)do
					local npcStub=session.stubs[starterId]
					if(npcStub and npcStub.enabled and npcStub.exists and npcStub.zone==self.currentZone)then
						local point=self.minimapQuestPoints[npcStub.session.gm.."_"..npcStub.session.id..npcStub.id];
						if(point and not stub.onQuest and stub.available)then
							point.available=true;
						end
					end					
				end
			end
		end
	end
	
	for _, point in pairs(self.minimapQuestPoints)do
		if(point.completed)then
			point.texture:SetTexture("Interface\\MINIMAP\\OBJECTICONS")
			point.texture:SetTexCoord(0.26,0.37,0.26,0.5);
			point:Show();
		elseif(point.available)then
			point.texture:SetTexture("Interface\\MINIMAP\\OBJECTICONS")
			point.texture:SetTexCoord(0.13,0.25,0.26,0.5);
			point:Show();
		end
	end
	self:UpdateMinimapIcons(true)
end

function VerisimilarPl:MINIMAP_UPDATE_ZOOM()
	forceNextMinimapUpdate = true
	local zoom = Minimap:GetZoom()
	if GetCVar("minimapZoom") == GetCVar("minimapInsideZoom") then
		Minimap:SetZoom(zoom < 2 and zoom + 1 or zoom - 1)
	end
	indoors = GetCVar("minimapZoom")+0 == Minimap:GetZoom() and "outdoor" or "indoor"
	Minimap:SetZoom(zoom)
	--self:MINIMAP_ZONE_CHANGED()
end

local pointTable={"minimapPoints","minimapQuestPoints"};
local function CheckToUpdateMinimapIcons(x, y, force) 

	local xscale,yscale=Tourist:GetZoneYardSize(VerisimilarPl.currentZone);
	if(xscale==nil)then return end
	forceNextMinimapUpdate = false
	lastX, lastY = x, y
	local radius = MinimapSize[indoors][lastZoom]
	local radius_2 = radius*radius
	
	for __, pTable in pairs(pointTable)do
		for _, point in pairs(VerisimilarPl[pTable]) do
			local idX, idY = point.x*xscale,point.y*yscale;
			local diffX, diffY = (x - idX), (y - idY)
			local distance_2 = diffX*diffX + diffY*diffY
			if distance_2 > radius_2-1000 or (point.isQuestIcon and not point.completed and not point.available) then
				point:Hide();
			else
				point:Show();
			end
		
		end
	end
	
end


function VerisimilarPl:UpdateMinimapIcons(forceNextMinimapUpdate)

	local x_, y_ = GetPlayerMapPosition("player");
	local xscale,yscale=Tourist:GetZoneYardSize(VerisimilarPl.currentZone)
	if not xscale then
		return
	end
	local x, y = x_*xscale, y_*yscale;
	
	local zoom = Minimap:GetZoom()
	local diffZoom = zoom ~= lastZoom
	local GetMinimapShape = GetMinimapShape
	local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"

	
	if diffZoom or x ~= lastX or y ~= lastY or facing ~= lastFacing or forceNextMinimapUpdate then
		lastZoom = zoom
		local Minimap_Width = Minimap:GetWidth()/2
		lastX, lastY = x, y
		CheckToUpdateMinimapIcons(x, y, diffZoom or forceNextMinimapUpdate)
		local radius = MinimapSize[indoors][lastZoom]

		for __, pTable in pairs(pointTable)do
			for id, poi in pairs(VerisimilarPl[pTable]) do
				if(poi:IsVisible())then
					local px, py = xscale*poi.x,yscale*poi.y
					local dx, dy = px - x, py - y
					if rotateMinimap then
						local sin = math.sin(facing)
						local cos = math.cos(facing)
						dx, dy = dx*cos - dy*sin, dx*sin + dy*cos
					end
					local diffX = dx / radius
					local diffY = dy / radius
					
					
					poi:SetPoint("CENTER", Minimap, "CENTER", diffX * Minimap_Width, -diffY * Minimap_Width)
				end
			end
		end
	end
end

--[[local isvalidframe = function(frame)
	if frame:GetName() then
		return
	end
	overlayRegion = select(2, frame:GetRegions())
	return overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == "Interface\\Tooltips\\Nameplate-Border"
end
local numkids=0
local checkPlates=false;
local count=0
function VerisimilarPl:CheckNameplates()
	if(not checkPlates)then
		checkPlates=true;
		SetCVar("nameplateShowEnemies", 1);
		SetCVar("nameplateShowFriends", 1);
		return
	end
	count=count+1;
    --if WorldFrame:GetNumChildren() ~= numkids then
		numkids = WorldFrame:GetNumChildren()
		local text=""
		for i = 1, select("#", WorldFrame:GetChildren()) do
			local frame = select(i, WorldFrame:GetChildren())
			if isvalidframe(frame) then
				local glowRegion, overlayRegion, castbarOverlay, shieldedRegion, spellIconRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()
				text=text..nameTextRegion:GetText()..":"..frame:GetLeft().."\n"
			end
		end
		VPLNamePlateTestBox:SetText(select("#", WorldFrame:GetChildren()));
	--end
	checkPlates=false;
	SetCVar("nameplateShowEnemies", 0);
	SetCVar("nameplateShowFriends", 0);
	return
end]]

