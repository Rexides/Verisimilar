currentDropList={}
LootCloseButton:HookScript("OnClick", function(self, button)VerisimilarForceCloseLoot=true; LootFrame:Hide(); end); --Yeah, it's weird, I know, but trust me, it's needed.

function VerisimilarPl:UpdateLootInterfaceMerge()
	if(VerisimilarPl.db.char.mergeWithLootInterface)then
		self:RawHook("GetNumLootItems",true);
		self:RawHook("LootSlot",true);
		self:RawHook("LootSlotIsItem",true);
		self:RawHook("LootSlotIsCoin",true);
		self:RawHook("GetLootSlotLink",true);
		self:RawHook("GetLootSlotInfo",true);
		self:Hook("LootFrame_Show",	"LootFrame_Update",true);
		self:Hook("LootFrame_Update",true);
		self:RawHook(LootFrame,"Hide","LootFrame_OnHide",true);
		self:RawHook(GameTooltip,"SetLootItem",true);
	else
		self:Unhook("GetNumLootItems",true);
		self:Unhook("LootSlot",true);
		self:Unhook("LootSlotIsItem",true);
		self:Unhook("LootSlotIsCoin",true);
		self:Unhook("GetLootSlotLink",true);
		self:Unhook("GetLootSlotInfo",true);
		self:Unhook("LootFrame_Show",true);
		self:Unhook("LootFrame_Update",true);
		self:Unhook("LootFrame_OnEvent",true);
		self:Unhook(LootFrame,"Hide",true);
		self:Unhook(GameTooltip,"SetLootItem",true);
	end
	
end

function VerisimilarPl:AddMobStubData(stubData,stubInfo)
	stubData.type="Mob";
	stubData.name=stubInfo.n;
end

function VerisimilarPl:InitializeMobStub(stub)
	stub.corpseList={};
	stub.taggedList={};
end

function VerisimilarPl:DisableMobStub(stub)

end

function VerisimilarPl:CheckLootableMobKill(session,mobName,guid)
		
			for _,stub in pairs(session.stubs)do
				if(stub.enabled and stub.type=="Mob" and strlower(mobName)==strlower(stub.name))then
					stub.taggedList[guid]=true;
					return true
				end
			end
		
end

function VerisimilarPl:LootTarget()
	local name=UnitName("target")
	if(not name)then return end
	name=strlower(name)
	local guid=strsub(UnitGUID("target"),13)
	for _,session in pairs(VerisimilarPl.sessions)do
		if(session.connected)then
			for _,mob in pairs(session.stubs)do
				if(mob.enabled and mob.type=="Mob" and name==strlower(mob.name) and mob.corpseList[guid])then
					if(CheckInteractDistance("target",3))then
						if(VerisimilarPl.db.char.mergeWithLootInterface)then
							LootFrame.page=1
							LootFrame_Show(LootFrame);
						end
					end
					return
				end
			end
		end
	end
	
end

function VerisimilarPl:LOOT_LIST(stub,loot)
	local session=stub.session;
	stub.corpseList[loot.guid]=loot;
end

function VerisimilarPl:CLEAR_LOOT(stub,lootInfo)
	local guid=strsub(lootInfo,1,6);
	local itemId=strsub(lootInfo,7,7);
	if(itemId=="")then
		VerisimilarPl:RemoveDrop(stub,guid)
			
	else
		item=session.stubs[itemId]
		if(item and item.enabled and item.type=="Item")then
			VerisimilarPl:RemoveDrop(stub,guid,item)
		end
	end
end

function VerisimilarPl:RemoveDrop(mob,guid,item)
	--self:PrintDebug("1",mob.id,guid,item).id)
	local session=mob.session;
	
	if(item==nil)then
		mob.corpseList[guid]=nil
		if(currentDropList.guid==guid)then
			HideUIPanel(LootFrame)
		end
	else
		local itemId=item.id;
		mob.corpseList[guid][itemId]=nil
		if(currentDropList.guid==guid)then
			--self:Print("2",mob.id,guid,item.id)
			for i=1,#currentDropList do
				if(currentDropList[i].item.id==itemId)then
					currentDropList[i].removed=true;
					if(VerisimilarPl.db.char.mergeWithLootInterface)then
						--self:Print("3",mob.id,guid,item.id)
						LootFrame_OnEvent(LootFrame, "LOOT_SLOT_CLEARED", i+self.hooks.GetNumLootItems())
					end
					break
				end
			end
		end
		local hide=true
		for i=1,#currentDropList do
			if(currentDropList[i].removed==nil)then
				hide=false;
				break
			end
		end
		if(hide and self.hooks.GetNumLootItems()==0)then HideUIPanel(LootFrame) end
	end
end

function VerisimilarPl:LootFrame_Update()
	
	local guid=strsub(UnitGUID("target") or "",13);
	local name=UnitName("target")
	if(guid~="")then
		currentDropList={name=name,guid=guid}
	else
		guid=currentDropList.guid
		name=currentDropList.name
		currentDropList={name=name,guid=guid}
	end
	if(guid=="")then
		return
	end
	for _,session in pairs(VerisimilarPl.sessions)do
		for _,mob in pairs(session.stubs)do
			if(mob.enabled and mob.type=="Mob" and strlower(name)==strlower(mob.name) and mob.corpseList[guid] and mob.taggedList[guid])then
				currentDropList.mobName=mob.name;
				for id,amount in pairs(mob.corpseList[guid]) do
					local item=session.stubs[id];
					if(item and item.enabled)then
						local add=true
						if(item.quests)then
							add=false;
							for questId,_ in pairs(item.quests)do
								local quest=session.stubs[questId];
								if(quest and quest.enabled and quest.type=="Quest" and quest.onQuest and not quest.finished)then
									add=true;
									break;
								end
							end
						end
						if(add)then
							tinsert(currentDropList,{item=item,amount=amount});
						end
					end
				end
			end
		end
		
	end
	LootFrame.numLootItems=self.hooks.GetNumLootItems()+#currentDropList --When updating after looting a WoW item, it seems that this vaslue updates somewhere secret. I just update it here as well for good measure because it breaks otherwise.
end

function VerisimilarPl:GetNumLootItems()
	return self.hooks.GetNumLootItems()+#currentDropList
end

function VerisimilarPl:LootSlot(slotId)
	if(slotId>self.hooks.GetNumLootItems())then
		for _,session in pairs(self.sessions)do
			if(session.connected)then
				for __,mob in pairs(session.stubs)do
					if(mob.enabled and mob.type=="Mob" and mob.name==currentDropList.mobName)then
						for id,amount in pairs(mob.corpseList[currentDropList.guid]) do
							if(id==currentDropList[slotId-self.hooks.GetNumLootItems()].item.id)then
								self:SendSessionMessage(session,mob,"LOOT_ITEM",currentDropList[slotId-self.hooks.GetNumLootItems()].item.id..currentDropList.guid);
								return
							end
						end
					end
				end
			end
		end
	else
		self.hooks.LootSlot(slotId)	
	end
end

function VerisimilarPl:LootSlotIsItem(slotId)
	if(slotId>self.hooks.GetNumLootItems())then
		return true
	else
		return self.hooks.LootSlotIsItem(slotId)
	end
end

function VerisimilarPl:LootSlotIsCoin(slotId)
	if(slotId>self.hooks.GetNumLootItems())then
		return false
	else
		return self.hooks.LootSlotIsCoin(slotId)
	end
end

function VerisimilarPl:GetLootSlotLink(slotId)
	if(slotId>self.hooks.GetNumLootItems())then
		return currentDropList[slotId-self.hooks.GetNumLootItems()].item.name
	else
		return self.hooks.GetLootSlotLink(slotId)
	end
end

function VerisimilarPl:GetLootSlotInfo(slotId)
	if(slotId>self.hooks.GetNumLootItems())then
		local item=currentDropList[slotId-self.hooks.GetNumLootItems()].item;
		local quality;
		for i=1,#VerisimilarPl.itemQuality do
			if(item.quality==VerisimilarPl.itemQuality[i])then
				quality=i-1
				break
			end
		end
		return "Interface\\Icons\\"..item.icon,item.name,currentDropList[slotId-self.hooks.GetNumLootItems()].amount,quality;
	else
		return unpack({self.hooks.GetLootSlotInfo(slotId)});	
	end
end

function VerisimilarPl:SetLootItem(tooltip,slotId)
	if(slotId>self.hooks.GetNumLootItems())then
		local buttonNumber=slotId;
		if(VerisimilarPl:GetNumLootItems()>4)then
			buttonNumber=((slotId-1)%3)+1;
		end
		VerisimilarPl:ShowItemTooltip(currentDropList[slotId-self.hooks.GetNumLootItems()].item,_G["LootButton"..buttonNumber],"ANCHOR_RIGHT")
	else
		self.hooks[GameTooltip].SetLootItem(tooltip,slotId)
	end 
end

function VerisimilarPl:LootFrame_OnHide()
	local hide=true
	for i=1,#currentDropList do
		if(currentDropList[i].removed==nil)then
			hide=false;
			break
		end
	end
	if(not VerisimilarForceCloseLoot and not hide)then
		LootFrame_Update()
	else
		currentDropList={}
		self.hooks[LootFrame].Hide(LootFrame)
		VerisimilarForceCloseLoot=false;
	end 
end

--[[function printCurrentList()
	for i=1,#currentDropList do
		VerisimilarPl:Print(i,"- item:",currentDropList[i].id)
	end
end]]