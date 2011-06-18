VerisimilarGM.ItemFuncs={}

function VerisimilarGM:InitializeItem(Item)
	Item.enabled=false;
	Item.name=Item.id;
	Item.icon="Ability_Ambush";
	Item.useScriptText="function(Item,player,x,y,targetName,targetGuid,targetHealth,targetSex)\n\nend";
	Item.quality="Common";
	Item.uniqueAmount=0;
	Item.tooltip={};
	for i=1,6 do
		tinsert(Item.tooltip,{lText="",lr=1,lg=1,lb=1,rText="",rr=1,rg=1,rb=1})
	end
	Item.document={material=1};
	Item.soulbound=false;
	Item.quests={};
	Item.usable=false;
	Item.range=0;
	Item.useDescription="";
	Item.flavorText="";
end


function VerisimilarGM:AssignItemFuncs(Item)
	
	for methodName,method in pairs(VerisimilarGM.CommonFuncs)do
		Item[methodName]=method;
	end
	
	for methodName,method in pairs(VerisimilarGM.ItemFuncs)do
		Item[methodName]=method;
	end
	
	Item:SetUseScript(Item:GetUseScript());
	if(Item:IsEnabled())then
		Item:Enable();
	end
	local session=Item:GetSession();
	for questId,_ in pairs(Item.quests)do
		if(not session.elements[questId])then
			Item.starters[questId]=nil;
		end
	end
end

function VerisimilarGM.ItemFuncs:InitializePlayer(player)
	player.elements[self.id]={
							amount=0,
							onCooldown=false,
							}
end

function VerisimilarGM.ItemFuncs:SendPlayerData(player)
	local playerData=player.elements[self.id];
	if(playerData.amount>0)then
		VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"ITEM_AMOUNT","n"..playerData.amount);
	end
end

function VerisimilarGM.ItemFuncs:GetStub()
	if(self.stub.v==self.version)then return self.stub end
	local stub={id=self.netID,
				t="I",
				v=self.version,
				n=self.name,
				i=self.icon,
				u=self.uniqueAmount,
				s=self.soulbound,
				ub=self.usable,
				};
	if(self.usable)then
		stub.r=self.range;
		stub.ooc=self.ooc;
		stub.ud=self.useDescription;
	end
	local questsString="";
	for elementId,_ in pairs(self.quests)do
		local quest=self:GetSession().elements[elementId]
		if(quest)then
			questsString=questsString..quest.netID;
		end
	end
	if(strlen(questsString)>0)then
		stub.qs=questsString;
	end
	if(self.flavorText~="")then
		stub.ft=self.flavorText;
	end
	for i=1,#VerisimilarPl.itemQuality do
		if(self.quality==VerisimilarPl.itemQuality[i])then
			stub.q=i;
			break;
		end
	end
	if(self:GetNumTooltipLines()>0)then
		stub.tt={}
		for i=1,self:GetNumTooltipLines() do
			local line={}
			if(self:GetTooltipLeftText(i)~="")then
				line.lt=self:GetTooltipLeftText(i);
				line.lr, line.lg, line.lb = self:GetTooltipLeftColor(i);
			end
			if(self:GetTooltipRightText(i)~="")then
				line.rt=self:GetTooltipRightText(i);
				line.rr, line.rg, line.rb = self:GetTooltipRightColor(i);
			end
			if(line.lt or line.rt)then
				tinsert(stub.tt,line)
			end
		end
		if(#stub.tt==0)then
			stub.tt=nil;
		end
	end
	
	if(#self.document>0)then
		stub.d={material=self.document.material}
		for i=1,#self.document do
			stub.d[i]=self.document[i];
		end
	end
	self.stub=stub;
	return stub;
end

function VerisimilarGM.ItemFuncs:GetName()
	return self.name
end

function VerisimilarGM.ItemFuncs:SetName(name)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(name and self.name~=name)then
		self:GenerateNewVersion()
		self.name=name;
	end
end

function VerisimilarGM.ItemFuncs:GetIcon()
	return self.icon;
end

function VerisimilarGM.ItemFuncs:SetIcon(icon)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(self.icon~=icon)then
		self:GenerateNewVersion()
		self.icon=icon;
	end
end

function VerisimilarGM.ItemFuncs:GetQuality()
	return self.quality;
end

function VerisimilarGM.ItemFuncs:SetQuality(quality)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	quality=VerisimilarPl.itemQuality[quality] and VerisimilarPl.itemQuality[quality] or quality;
	if(quality and self.quality~=quality)then
		self:GenerateNewVersion()
		self.quality=quality;
	end
end

function VerisimilarGM.ItemFuncs:IsSoulbound()
	return self.soulbound;
end

function VerisimilarGM.ItemFuncs:SetSoulbound(state)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	state=state and true or false;
	if(self.soulbound~=state)then
		self:GenerateNewVersion()
		self.soulbound=state;
	end
end

function VerisimilarGM.ItemFuncs:GetUniqueAmount()
	return self.uniqueAmount;
end

function VerisimilarGM.ItemFuncs:SetUniqueAmount(amount)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	amount=tonumber(amount) or 0;
	if(self.uniqueAmount~=amount)then
		self:GenerateNewVersion()
		self.uniqueAmount=amount;
	end
end

function VerisimilarGM.ItemFuncs:GetNumTooltipLines()
	return #self.tooltip
end

--[[function VerisimilarGM.ItemFuncs:AddTooltipLine()
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	tinsert(self.tooltip,{lText="",lr=1,lg=1,lb=1,rText="",rr=1,rg=1,rb=1})
end]]

function VerisimilarGM.ItemFuncs:SetTooltipLeftText(i,text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(text and self.tooltip[i] and self.lText~=text)then
		self:GenerateNewVersion()
		self.tooltip[i].lText=text;
	end
end

function VerisimilarGM.ItemFuncs:GetTooltipLeftText(i)
	return self.tooltip[i] and self.tooltip[i].lText;
end

function VerisimilarGM.ItemFuncs:SetTooltipLeftColor(i,r,g,b)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	r=tonumber(r);
	g=tonumber(g);
	b=tonumber(b);
	if(r and g and b and self.tooltip[i] and (self.tooltip[i].lr~=r or self.tooltip[i].lg~=g or self.tooltip[i].lb~=b))then
		self:GenerateNewVersion()
		self.tooltip[i].lr=r;
		self.tooltip[i].lg=g;
		self.tooltip[i].lb=b;
	end
end

function VerisimilarGM.ItemFuncs:GetTooltipLeftColor(i)
	if(self.tooltip[i])then
		return self.tooltip[i].lr,self.tooltip[i].lg,self.tooltip[i].lb;
	end
end

function VerisimilarGM.ItemFuncs:SetTooltipRightText(i,text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(text and self.tooltip[i] and self.rText~=text)then
		self:GenerateNewVersion()
		self.tooltip[i].rText=text;
	end
end

function VerisimilarGM.ItemFuncs:GetTooltipRightText(i)
	return self.tooltip[i] and self.tooltip[i].rText;
end

function VerisimilarGM.ItemFuncs:SetTooltipRightColor(i,r,g,b)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	r=tonumber(r);
	g=tonumber(g);
	b=tonumber(b);
	if(r and g and b and self.tooltip[i] and (self.tooltip[i].rr~=r or self.tooltip[i].rg~=g or self.tooltip[i].rb~=b))then
		self:GenerateNewVersion()
		self.tooltip[i].rr=r;
		self.tooltip[i].rg=g;
		self.tooltip[i].rb=b;
	end
end

function VerisimilarGM.ItemFuncs:GetTooltipRightColor(i)
	if(self.tooltip[i])then
		return self.tooltip[i].rr,self.tooltip[i].rg,self.tooltip[i].rb;
	end
end

--[[function VerisimilarGM.ItemFuncs:RemoveTooltipLine(i)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	tremove(self.tooltip,i)
end]]

function VerisimilarGM.ItemFuncs:HasQuest(elementId)
	local session=self:GetSession();
	if(elementId==nil)then return false; end
	if(type(elementId)=="table")then
		elementId=elementId.id;
	end
	return self.quests[elementId] or false;
end

function VerisimilarGM.ItemFuncs:AddQuest(quest)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	quest=type(quest)=="string" and quest or quest.id;
	if(not self.quests[quest])then
		self:GenerateNewVersion()
		self.quests[quest]=true;
	end
end

function VerisimilarGM.ItemFuncs:RemoveQuest(quest)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	quest=type(quest)=="string" and quest or quest.id;
	if(self.quests[quest])then
		self:GenerateNewVersion()
		self.quests[quest]=nil;
	end
end

function VerisimilarGM.ItemFuncs:IsUsable()
	return self.usable;
end

function VerisimilarGM.ItemFuncs:SetUsable(state)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	state=state and true or false;
	if(self.usable~=state)then
		self:GenerateNewVersion()
		self.usable=state;
	end
end

function VerisimilarGM.ItemFuncs:GetUseScript()
	return self.useScriptText;
end

function VerisimilarGM.ItemFuncs:SetUseScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.useScriptText=scriptText;
	self.useScript=func();
	setfenv(self.useScript,self:GetSession().env);
end

function VerisimilarGM.ItemFuncs:GetUseDescription()
	return self.useDescription;
end

function VerisimilarGM.ItemFuncs:SetUseDescription(description)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(description and self.useDescription~=description)then
		self:GenerateNewVersion();
		self.useDescription=description;
	end
end

function VerisimilarGM.ItemFuncs:IsOutOfCombatOnly()
	return self.ooc;
end

function VerisimilarGM.ItemFuncs:SetOutOfCombatOnly(state)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	state=state and true or false;
	if(self.ooc~=state)then
		self:GenerateNewVersion()
		self.ooc=state;
	end
end

function VerisimilarGM.ItemFuncs:GetRange()
	return self.range;
end

function VerisimilarGM.ItemFuncs:SetRange(range)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	range=tonumber(range);
	if(range and range>=0 and range<=3 and self.range~=range)then
		self:GenerateNewVersion()
		self.range=range;
	end
end

function VerisimilarGM.ItemFuncs:GetFlavorText()
	return self.flavorText;
end

function VerisimilarGM.ItemFuncs:SetFlavorText(text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(text and self.flavorText~=text)then
		self:GenerateNewVersion();
		self.flavorText=text;
	end
end

function VerisimilarGM.ItemFuncs:GetDocumentMaterial()
	return VerisimilarPl.documentMaterials[self.document.material],self.document.material;
end

function VerisimilarGM.ItemFuncs:SetDocumentMaterial(material)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(type(material)=="string")then
		material=nil;
		for i=1,#VerisimilarPl.documentMaterials do
			if(VerisimilarPl.documentMaterials[i]==material)then
				material=i;
				break
			end
		end
	end
	if(material and material>0 and material<=#VerisimilarPl.documentMaterials and self.document.material~=material)then
		self:GenerateNewVersion()
		self.document.material=material;
	end
end

function VerisimilarGM.ItemFuncs:AddPage()
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	tinsert(self.document,"")
end

function VerisimilarGM.ItemFuncs:RemovePage(pageNum)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	tremove(self.document,pageNum)
end

function VerisimilarGM.ItemFuncs:SetPageText(pageNum,text)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(pageNum and text and self.document[pageNum] and self.document[pageNum]~=text)then
		self:GenerateNewVersion()
		self.document[pageNum]=text
	end
end

function VerisimilarGM.ItemFuncs:GetPageText(pageNum)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	return self.document[pageNum];
end

function VerisimilarGM.ItemFuncs:GiveTo(player,amount,gainType)
	if(gainType==nil)then
		gainType="normal";
	end
	amount=tonumber(amount);
	if(amount==nil or amount==0)then return end
	local itemData=player.elements[self.id];
	if(not itemData)then return end
	amount=amount+itemData.amount;
	if(amount<0)then
		amount=0;
	end
	if(amount>self:GetUniqueAmount() and self:GetUniqueAmount()>0)then
		amount=self:GetUniqueAmount();
	end
	if(amount==nil)then return end
	itemData.amount=amount;
	local gType=nil;
	if(strlower(gainType)=="normal")then
		gType="n";
	elseif(strlower(gainType)=="loot")then
		gType="l";
	elseif(strlower(gainType)=="gain")then
		gType="g";
	end
	VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"ITEM_AMOUNT",gType..itemData.amount);
	self:GetSession():Event(player,"Item",self.id,amount);
end

function VerisimilarGM.ItemFuncs:Cooldown(player,cdTime)
	if(player.elements[self.id].onCooldown~=false)then
		if(VerisimilarGM:TimeLeft(player.elements[self.id].onCooldown)<cdTime)then
			VerisimilarGM:CancelTimer(player.elements[self.id].onCooldown, true)
		else
			return
		end
	end
	player.elements[self.id].onCooldown=VerisimilarGM:ScheduleTimer("ClearCooldown", cdTime, player.elements[self.id]);
	VerisimilarGM:SendSessionMessage(player,self:GetSession(),self,"COOLDOWN",cdTime);
end

function  VerisimilarGM:ClearCooldown(item)
	if(item)then
		item.onCooldown=false;
	end
end

function VerisimilarGM.ItemFuncs:ITEM_USED(player,useInfo)
	if(useInfo and player.elements[self.id].onCooldown==false)then
		local x,y=VerisimilarPl:DecodeCoordinates(useInfo.c)
		self:useScript(player,x,y,useInfo.n,useInfo.g,useInfo.h,useInfo.s);
		VerisimilarGM:LogEvent("Player "..player.name.." used item "..self.id)
	end
end

function VerisimilarGM.ItemFuncs:DESTROY_ITEM(player,amount)
	if(type(amount)=="number" and amount>0)then
		self:GiveTo(player,-amount);
		VerisimilarGM:LogEvent("Player "..player.name.." destroyed item "..self.id.."x"..amount);
	end
end

function VerisimilarGM.ItemFuncs:GIVE_ITEM_TO_OTHER_PLAYER(player,giveInfo)
	if(giveInfo)then
		local receiver=session.players[giveInfo.p];
		if(not self:IsSoulbound() and receiver)then
			if(type(giveInfo.a)=="number" and giveInfo.a>0)then
				if(player.elements[self.id].amount<giveInfo.a)then
					giveInfo.a=player.elements[self.id].amount;
				end
				self:GiveTo(player,-giveInfo.a,"gain");
				self:GiveTo(receiver,giveInfo.a,"gain");
			end
			VerisimilarGM:LogEvent("Player "..player.name.." gave item "..self.id.."x"..giveInfo.a.." to "..receiver.name)
		end
	end
end

function VerisimilarGM.ItemFuncs:Event(player,event,parameter,arg1,arg2,arg3)

end



