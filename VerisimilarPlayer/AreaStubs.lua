
function VerisimilarPl:AddAreaStubData(stubData,stubInfo)
	stubData.type="Area";
	stubData.name=stubInfo.n;
	stubData.zone=stubInfo.z;
	stubData.level=stubInfo.l;
	stubData.regions={};
	for i=1,#stubInfo.r do
		local x,y=self:DecodeCoordinates(stubInfo.r[i].c);
		local width,height=self:DecodeCoordinates(stubInfo.r[i].d);
		stubData.regions[i]={type=stubInfo.r[i].t,subzone=stubInfo.r[i].s,x=x,y=y,width=width,height=height}
	end
end

function VerisimilarPl:InitializeAreaStub(stub)
	stub.inside=false;
	VerisimilarPl:CheckArea(stub)
end

function VerisimilarPl:DisableAreaStub(stub)

end

local function checkCircle(region,x,y)
	local dx=region.x-x;
	local dy=region.y-y;
	return dx*dx+dy*dy<region.width*region.width;
end

local function checkRect(region,x,y)
	local dx=abs(region.x-x);
	local dy=abs(region.y-y);
	return dx<region.width and dy<region.height
end

function VerisimilarPl:CheckArea(stub)
	local x=self.lastPlayerPositionX;
	local y=self.lastPlayerPositionY;
	local zone=self.currentZone;
	local level=self.currentLevel;
	local subzone=GetSubZoneText();
	local inside=false;
	if(zone==stub.zone and level==stub.level)then
		for i=1,#stub.regions do
			inside=(stub.regions[i].type==1 and true) or (stub.regions[i].type==2 and stub.regions[i].subzone==subzone) or (stub.regions[i].type==3 and checkCircle(stub.regions[i],x,y)) or (stub.regions[i].type==4 and checkRect(stub.regions[i],x,y)) or false;
			if(inside)then break; end
		end
	end
	if(inside~=stub.inside)then
		stub.inside=inside;
		self:SendSessionMessage(stub.session,stub,"PLAYER_CHANGES_AREA",stub.inside);
	end
end