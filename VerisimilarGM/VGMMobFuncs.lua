VerisimilarGM.MobFuncs={}

function VerisimilarGM:InitializeMob(Mob)
	Mob.enabled=false;
	Mob.name=UnitName("target") or "";
	Mob.lootTable={};
	Mob.corpseList={};
end


function VerisimilarGM:AssignMobFuncs(Mob)
	
	for methodName,method in pairs(VerisimilarGM.CommonFuncs)do
		Mob[methodName]=method;
	end
	
	for methodName,method in pairs(VerisimilarGM.MobFuncs)do
		Mob[methodName]=method;
	end
	
	Mob.corpseList={};
	for _,player in pairs(Mob:GetSession().players)do
		player.elements[Mob.id]={};
	end
	if(Mob:IsEnabled())then
		Mob:Enable();
	end
end

function VerisimilarGM.MobFuncs:InitializePlayer(player)
	player.elements[self.id]={
							}
							
end

function VerisimilarGM.MobFuncs:SendPlayerData(player)
	local playerData=player.elements[self.id];
	local session=self:GetSession();
	
end

function VerisimilarGM.MobFuncs:GetStub(player)
	if(self.stub.v==self.version)then return self.stub end
	local session=self:GetSession();
	local stub={id=self.netID,
				t="M",
				v=self.version,
				n=self.name,
				};
	self.stub=stub;
	return stub;
end

function VerisimilarGM.MobFuncs:GetName()
	return self.name
end

function VerisimilarGM.MobFuncs:SetName(name)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	if(name and self.name~=name)then
		self:GenerateNewVersion()
		self.name=name;
	end
end

function VerisimilarGM.MobFuncs:GetDropChance(index)
	return self.lootTable[index].chance;
end

function VerisimilarGM.MobFuncs:SetDropChance(index,chance)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	chance=tonumber(chance);
	if(self.lootTable[index] and self.lootTable[index].chance~=chance)then
		self:GenerateNewVersion()
		self.lootTable[index].chance=chance;
	end
end

function VerisimilarGM.MobFuncs:GetDropAmount(index)
	return self.lootTable[index].amount;
end

function VerisimilarGM.MobFuncs:SetDropAmount(index,amount)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	amount=tonumber(amount);
	if(self.lootTable[index] and self.lootTable[index].amount~=amount)then
		self:GenerateNewVersion()
		self.lootTable[index].amount=amount;
	end
end

function VerisimilarGM.MobFuncs:GetItem(index)
	local session=self:GetSession();
	if(self.lootTable[index].item and session.elements[self.lootTable[index].item])then
		return session.elements[self.lootTable[index].item];
	end
end

function VerisimilarGM.MobFuncs:SetItem(index,item)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	item=type(item)=="string" and item or item.id;
	if(item and self.lootTable[index] and self.lootTable[index].item~=item)then
		self:GenerateNewVersion()
		self.lootTable[index].item=item;
	end
end

function VerisimilarGM.MobFuncs:AddDrop()
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	tinsert(self.lootTable,{item=nil,chance=100,amount=1})
end

function VerisimilarGM.MobFuncs:RemoveDrop(index)
	if(self.enabled==true and self:GetSession():IsEnabled()==true)then return end
	self:GenerateNewVersion()
	tremove(self.lootTable,index);
end

function VerisimilarGM.MobFuncs:GetNumDrops()
	return #self.lootTable;
end

function VerisimilarGM.MobFuncs:Event(player,event,parameter,arg1,arg2,arg3)
	local session=self:GetSession();
	if(event=="Kill" and strlower(self.name)==strlower(parameter))then
		player.elements[self.id][arg1]=true;
		if(self.corpseList[arg1]==nil)then
			self.corpseList[arg1]={guid=arg1};
			local loot=self.corpseList[arg1];
			VerisimilarGM:ScheduleTimer("RemoveCorpse", 300,{Mob=self,guid=arg1});
			for i=1,self:GetNumDrops()do
				if(self:GetDropChance(i)>=math.random(100))then
					loot[self:GetItem(i).netID]=math.random(self:GetDropAmount(i));
				end
			end
			if(session.channel~="WHISPER")then
				VerisimilarGM:SendSessionMessage(nil,session,self,"LOOT_LIST",loot);
			end
		end
		if(session.channel=="WHISPER")then
			VerisimilarGM:SendSessionMessage(player,session,self,"LOOT_LIST",self.corpseList[arg1]);
		end
	end
end

local lootFilter=function(player,session,Mob,message,data)
	if(player.elements[Mob.id][strsub(data,1,6)])then
		return true;
	end
end

function VerisimilarGM:RemoveCorpse(t)
	local session=t.Mob:GetSession();
	VerisimilarGM:SendSessionMessage(lootFilter,session,t.Mob,"CLEAR_LOOT",t.guid);
	t.Mob.corpseList[t.guid]=nil;
	for _,player in pairs(session.players)do
		if(player.elements[t.Mob.id][t.guid])then
			player.elements[t.Mob.id][t.guid]=nil;
		end
	end
end

function VerisimilarGM.MobFuncs:LOOT_ITEM(player,lootInfo)
	if(not lootInfo)then return end
	local session=self:GetSession();
	local itemNetId=strsub(lootInfo,1,1);
	local Mob=self;
	local guid=strsub(lootInfo,2);
	if(Mob.corpseList[guid] and Mob.corpseList[guid][itemNetId] and player.elements[Mob.id][guid])then
		local Item=session:GetElementFromNetID(itemNetId);
		if(Item and Item:GetUniqueAmount()==0 or (player.elements[Item.id] and player.elements[Item.id].amount<Item:GetUniqueAmount()))then
			Item:GiveTo(player,Mob.corpseList[guid][itemNetId]);
			Mob.corpseList[guid][itemNetId]=nil
			VerisimilarGM:SendSessionMessage(lootFilter,session,Mob,"CLEAR_LOOT",guid..itemNetId);
		else
			session:SendErrorMessage("You can't loot any more of this item",player)
		end
	end
end






