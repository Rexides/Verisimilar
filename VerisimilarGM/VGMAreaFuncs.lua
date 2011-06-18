VerisimilarGM.AreaFuncs={}

function VerisimilarGM:InitializeArea(Area)
	Area.enabled=false;
	Area.zone=GetCurrentMapAreaID();
	Area.level=GetCurrentMapDungeonLevel();
	Area.regions={};
	Area.areaScriptText="function(Area,player,entering)\n    if(entering)then\n\n    else\n\n    end\nend";
end


function VerisimilarGM:AssignAreaFuncs(Area)
	
	for methodName,method in pairs(VerisimilarGM.CommonFuncs)do
		Area[methodName]=method;
	end
	
	for methodName,method in pairs(VerisimilarGM.AreaFuncs)do
		Area[methodName]=method;
	end
	
	for _,player in pairs(Area:GetSession().players)do
		player.elements[Area.id]={};
	end
	Area:SetAreaScript(Area:GetAreaScript());
	if(Area:IsEnabled())then
		Area:Enable();
	end
end

function VerisimilarGM.AreaFuncs:InitializePlayer(player)
	player.elements[self.id]={
								inside=false,
							}
							
end

function VerisimilarGM.AreaFuncs:SendPlayerData(player)
	local playerData=player.elements[self.id];
	local session=self:GetSession();
	
end

function VerisimilarGM.AreaFuncs:GetStub(player)
	if(self.stub.v==self.version)then return self.stub end
	local session=self:GetSession();
	local stub={id=self.netID,
				t="A",
				v=self.version,
				z=self.zone,
				l=self.level,
				r={},
				};
	for i=1,#self.regions do
		stub.r[i]={t=self.regions[i].type}
		stub.r[i].s=stub.r[i].t==2 and self.regions[i].subzone or nil;
		stub.r[i].c=(stub.r[i].t==3 or stub.r[i].t==4) and VerisimilarPl:EncodeCoordinates(self.regions[i].centerX,self.regions[i].centerY) or nil;
		stub.r[i].d=(stub.r[i].t==3 or stub.r[i].t==4) and VerisimilarPl:EncodeCoordinates(self.regions[i].width, stub.r[i].t==4 and self.regions[i].height) or nil;
	end
	self.stub=stub;
	return stub;
end

function VerisimilarGM.AreaFuncs:GetZone()
	return self.zone, self.level;
end

function VerisimilarGM.AreaFuncs:SetZone(zone,level)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	zone=tonumber(zone);
	level=tonumber(level) or 0;
	if(zone and (self.zone~=zone or self.level~=level))then
		self:GenerateNewVersion();
		self.zone=zone;
		self.level=level;
	end
end

function VerisimilarGM.AreaFuncs:AddRegion()
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion();
	tinsert(self.regions,{type=1,centerX=0.5,centerY=0.5,width=0.2,height=0.2,subzone=""})
end

function VerisimilarGM.AreaFuncs:RemoveRegion(index)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(self.regions[index])then
		self:GenerateNewVersion();
		tremove(self.regions,index);
	end
end

function VerisimilarGM.AreaFuncs:GetNumRegions()
	return #self.regions;
end

function VerisimilarGM.AreaFuncs:GetType(index)
	if(self.regions[index])then
		return VerisimilarPl.regionTypes[self.regions[index].type];
	end
end

function VerisimilarGM.AreaFuncs:SetType(index,regionType)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(type(regionType)~="number" and type(regionType)~="string")then return end
	if(type(regionType)=="string")then
		for i=1,#VerisimilarPl.regionTypes do
			if(strlower(regionType)==strlower(VerisimilarPl.regionTypes[i]))then
				regionType=i;
				break;
			end
		end
	end
	if(VerisimilarPl.regionTypes[regionType] and self.regions[index] and self.regions[index].type~=regionType)then
		self:GenerateNewVersion();
		self.regions[index].type=regionType;
	end
end

function VerisimilarGM.AreaFuncs:GetAreaInfo(index)
	if(self.regions[index])then
		return self.regions[index].centerX,self.regions[index].centerY,self.regions[index].width,self.regions[index].height;
	end
end

function VerisimilarGM.AreaFuncs:SetCenter(index,x,y)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	x=tonumber(x);
	y=tonumber(y);
	if(x and y and self.regions[index] and (self.regions[index].centerX~=x or self.regions[index].centerY~=y))then
		self:GenerateNewVersion();
		self.regions[index].centerX=x;
		self.regions[index].centerY=y;
	end
end

function VerisimilarGM.AreaFuncs:SetWidth(index,width)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	width=tonumber(width);
	if(width and self.regions[index] and self.regions[index].width~=width)then
		self:GenerateNewVersion();
		self.regions[index].width=width;
	end
end

function VerisimilarGM.AreaFuncs:SetHeight(index,height)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	height=tonumber(height);
	if(height and self.regions[index] and self.regions[index].height~=height)then
		self:GenerateNewVersion();
		self.regions[index].height=height;
	end
end

function VerisimilarGM.AreaFuncs:GetSubzone(index)
	if(self.regions[index])then
		return self.regions[index].subzone;
	end
end

function VerisimilarGM.AreaFuncs:SetSubzone(index,subzone)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(type(subzone)~="string")then return end
	if(self.regions[index] and self.regions[index].subzone~=subzone)then
		self:GenerateNewVersion();
		self.regions[index].subzone=subzone;
	end
end

function VerisimilarGM.SessionFuncs:GetAreaScript()
	return self.newPlayerScriptText;
end


function VerisimilarGM.SessionFuncs:SetAreaScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.areaScriptText=scriptText;
	self.areaScript=func();
	setfenv(self.newPlayerScript,self:GetSession().env);
end

function VerisimilarGM.AreaFuncs:PLAYER_CHANGES_AREA(player,entering)
	player.elements[self.id].inside=entering;
	self:areaScript(player,entering);
end








