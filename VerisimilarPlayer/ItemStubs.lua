VerisimilarPl.bag={}
VerisimilarPl.bag[0]={}
VerisimilarPl.bag[1]={}
VerisimilarPl.bag[2]={}
VerisimilarPl.bag[3]={}
VerisimilarPl.bag[4]={}


function VerisimilarPl:UpdateBagInterfaceMerge()
	if(self.db.char.mergeWithBagInterface)then
		self:RawHook("GetContainerItemCooldown",true);
		self:RawHook("GetContainerItemID",true);
		self:RawHook("GetContainerItemInfo",true);
		self:RawHook("PickupContainerItem",true);
		self:RawHook("PutItemInBackpack",true);
		self:RawHook("PutItemInBag",true);
		self:RawHook("SplitContainerItem",true);
		self:RawHook("GetContainerNumFreeSlots",true);
		self:RawHook("GetContainerItemQuestInfo",true);
		self:RawHook("GetContainerItemLink",true);
		self:RawHook("GetItemInfo",true);
		self:SecureHook("UseContainerItem");
		self:RawHook(GameTooltip,"SetBagItem",true);
		self:RegisterEvent("BAG_UPDATE");
		VerisimilarPl.bag[0]={}
		VerisimilarPl.bag[1]={}
		VerisimilarPl.bag[2]={}
		VerisimilarPl.bag[3]={}
		VerisimilarPl.bag[4]={}
		for _,session in pairs(VerisimilarPl.sessions)do
			for _,stub in pairs(session.ItemStubs)do
				for i=0,4 do
					if(GetContainerNumFreeSlots(i)>0)then
						local placed=false;
						for j=1,GetContainerNumSlots(i) do
							if(GetContainerItemID(i, j)==nil)then
								VerisimilarPl.bag[i][j]=stub
								placed=true;
								break;
							end
							
						end
						if(placed)then
							break;
						end
					end
				end
			end
		end
		for frameNum=1,13 do
			local frame=_G["ContainerFrame"..frameNum]
			if(frame:IsVisible())then
				ContainerFrame_Update(frame);
			end
		end
		MainMenuBarBackpackButton_UpdateFreeSlots()
	else
		self:Unhook("GetContainerItemCooldown",true);
		self:Unhook("GetContainerItemID",true);
		self:Unhook("GetContainerItemInfo",true);
		self:Unhook("PickupContainerItem",true);
		self:Unhook("PutItemInBackpack",true);
		self:Unhook("PutItemInBag",true);
		self:Unhook("SplitContainerItem",true);
		self:Unhook("GetContainerNumFreeSlots",true);
		self:Unhook("UseContainerItem",true);
		self:Unhook("GetContainerItemQuestInfo",true);
		self:Unhook("GetContainerItemLink",true);
		self:Unhook("GetItemInfo",true);
		self:Unhook(GameTooltip,"SetBagItem",true);
		self:UnregisterEvent("BAG_UPDATE");
		for frameNum=1,13 do
			local frame=_G["ContainerFrame"..frameNum]
			if(frame:IsVisible())then
				ContainerFrame_Update(frame);
			end
		end
		MainMenuBarBackpackButton_UpdateFreeSlots()
	end
end


function VerisimilarPl:AddItemStubData(stubData,stubInfo)
	stubData.type="Item";
	stubData.name=stubInfo.n;
	stubData.icon=stubInfo.i;
	stubData.uniqueAmount=stubInfo.u;
	stubData.soulbound=stubInfo.s;
	stubData.tooltip=stubInfo.tt;
	stubData.document=stubInfo.d;
	stubData.quality=VerisimilarPl.itemQuality[stubInfo.q];
	stubData.usable=stubInfo.ub;
	stubData.range=stubInfo.r;
	stubData.ooc=stubInfo.ooc;
	stubData.useDescription=stubInfo.ud;
	stubData.flavorText=stubInfo.ft;
	if(stubInfo.qs)then
		stubData.quests={};
		for i=1,strlen(stubInfo.qs)do
			stubData.quests[strsub(stubInfo.qs,i,i)]=true;
		end
	end
end

function VerisimilarPl:InitializeItemStub(stub)
	stub.amount=0;
	stub.cdStart=0;
	stub.cdDuration=0;
	stub.lastUsed=0;
end

function VerisimilarPl:DisableItemStub(stub)
	if(stub.amount==0)then return end
	VerisimilarPl:InventoryUpdated();
	if(self.db.char.mergeWithBagInterface)then
		for i=0,4 do
			local removed=false;
			for j=1,GetContainerNumSlots(i) do
				if(VerisimilarPl.bag[i][j]==stub)then
					VerisimilarPl.bag[i][j]=nil
					removed=true;
					for frameNum=1,13 do
						local frame=_G["ContainerFrame"..frameNum];
						if(frame:GetID()==i and frame:IsVisible())then
							ContainerFrame_Update(frame);
						end
					end
					break;
				end
				
			end
			if(removed)then
				break;
			end
		end
		MainMenuBarBackpackButton_UpdateFreeSlots();
	end
end

function VerisimilarPl:ItemStubClicked(stub)
	local curTime=GetTime();
	if(stub.cdStart>0 or (stub.lastUsed+1>curTime))then return end
	stub.lastUsed=curTime;
	if(stub.document)then
		self:OpenDocument(stub);
	end
	for _,questStub in pairs(stub.session.stubs) do
		if(questStub.type=="Quest" and questStub.enabled and not questStub.finished)then
			if(not questStub.onQuest and questStub.available and questStub.starters[stub.id])then
				self:ShowQuestDetails(questStub);
				break;
			elseif(questStub.onQuest and questStub.enders[stub.id])then
				self:ShowQuestProgress(questStub);
				break;
			end
		end
	end
	if(stub.usable)then
		if(stub.ooc and UnitAffectingCombat("player"))then
			PlaySound("igQuestFailed");
			UIErrorsFrame_OnEvent(UIErrorsFrame, "UI_ERROR_MESSAGE", ERR_NOT_IN_COMBAT);
			return
		end
		local close=CheckInteractDistance("target",3);
		local medium=CheckInteractDistance("target",1);
		if(stub.range==0 or (not UnitIsUnit("target","player") and (close or (stub.range==2 and medium) or stub.range==3)))then
			local x,y=GetPlayerMapPosition("player");
			local useInfo={c=self:EncodeCoordinates(x,y)};
			if(stub.range>0)then
				useInfo.n=UnitName("target");
				useInfo.g=strsub(UnitGUID("target"),13);
				useInfo.h=ceil(100*UnitHealth("target")/UnitHealthMax("target"));
				useInfo.s=UnitSex("target");
			end
			self:SendSessionMessage(stub.session,stub,"ITEM_USED",useInfo);
		else
			PlaySound("igQuestFailed");
			UIErrorsFrame_OnEvent(UIErrorsFrame, "UI_ERROR_MESSAGE", ERR_OUT_OF_RANGE)
		end
	end
end


local gainMessages={
					g="You gained item: ",
					lost="You lost item: ",
					l="You receive loot: ",
					};
function VerisimilarPl:ITEM_AMOUNT(stub,amountInfo)
	local gainType=strsub(amountInfo,1,1);
	local amount=tonumber(strsub(amountInfo,2));
	self:Print("Item amount",stub.name,amount);
	local difference=amount-stub.amount;
	stub.amount=amount;
	
	VerisimilarPl:InventoryUpdated();
	
	if(difference~=0 and gainType~="n")then
		local amountString="";
		if(gainType=="g" and difference<0)then
			gainType="lost";
			difference=-difference;
		end
		if(difference>1)then
			amountString="x"..difference;
		end
		PlaySound("ITEMGENERICSOUND");
		local qColor=VerisimilarPl.qualityColor[stub.quality];
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME,"CHAT_MSG_LOOT",gainMessages[gainType].."|cff"..string.format("%.2x%.2x%.2x",qColor.r*255,qColor.g*255,qColor.b*255).."["..stub.name.."]|r"..amountString,"","","","","",0,0,"",0,stub.id,"",0);
	end
	if(self.db.char.mergeWithBagInterface)then
		local bagNum=nil;
		local slotNum=nil;
		for i=0,4 do
			for slot,item in pairs(VerisimilarPl.bag[i]) do
				if(item==stub)then
					bagNum=i;
					slotNum=slot;
					break
				end
			end
		end
		if(stub.amount>0)then
			if(not bagNum)then
				for i=0,4 do
					if(GetContainerNumFreeSlots(i)>0)then
						local placed=false;
						for j=1,GetContainerNumSlots(i) do
							if(GetContainerItemID(i, j)==nil)then
								VerisimilarPl.bag[i][j]=stub;
								placed=true;
								bagNum=i;
								break;
							end
							
						end
						if(placed)then
							break;
						end
					end
				end
			end
			
			
			if(difference>0 and gainType~="n" and gainType~="lost")then
				if(bagNum==0)then
					ItemAnim_OnEvent(MainMenuBarBackpackButtonItemAnim,"ITEM_PUSH",0,"Interface\\Icons\\"..stub.icon)
				else
					ItemAnim_OnEvent(_G["CharacterBag"..(bagNum-1).."SlotItemAnim"],"ITEM_PUSH",bagNum+19,"Interface\\Icons\\"..stub.icon)
				end
			end
		elseif(bagNum)then
			VerisimilarPl.bag[bagNum][slotNum]=nil;
		end
		
		if(bagNum)then
			for frameNum=1,13 do
				local frame=_G["ContainerFrame"..frameNum]
				if(frame:GetID()==bagNum and frame:IsVisible())then
					ContainerFrame_Update(frame)
				end
			end
			
		end
		MainMenuBarBackpackButton_UpdateFreeSlots();
	end
end

function VerisimilarPl:COOLDOWN(stub,cdTime)
	if(type(cdTime)~="number" or cdTime<0)then return end
	local curTime=GetTime();
	if(stub.cdStart+stub.cdDuration<curTime+cdTime)then
		stub.cdStart=curTime;
		stub.cdDuration=cdTime;
		VerisimilarPl:CancelTimer(stub.cdHandle, true)
		stub.cdHandle=VerisimilarPl:ScheduleTimer("ClearCooldown", stub.cdDuration, stub);
		VerisimilarPl:InventoryUpdated()
		WatchFrame_Update();
		
		if(self.db.char.mergeWithBagInterface)then
			for i=0,4 do
				for _,item in pairs(VerisimilarPl.bag[i]) do
					if(item==stub)then
						for frameNum=1,13 do
							local frame=_G["ContainerFrame"..frameNum]
							if(frame:GetID()==i and frame:IsVisible())then
								ContainerFrame_UpdateCooldowns(frame);
							end
						end
						break
					end
				end
			end
		end
	end
end

function  VerisimilarPl:ClearCooldown(stub)
	if(stub)then
		stub.cdStart=0
		stub.cdDuration=0
		VerisimilarPl:InventoryUpdated()
	end
end

function VerisimilarPl:DestroyItem(stub,amount)
	if(stub)then
		self:SendSessionMessage(stub.session,stub,"DESTROY_ITEM",tonumber(amount));
	end
end

function VerisimilarPl:GiveItemTo(stub, playerName, amount)
	if(stub)then
		self:Print("Destroy item func")
		self:SendSessionMessage(stub.session,stub,"GIVE_ITEM_TO_OTHER_PLAYER",{p=playerName,a=tonumber(amount)});
	end
end

function  VerisimilarPl:GetContainerItemCooldown(bagID, slot)
	if((bagID>-1 and bagID<5) and type(VerisimilarPl.bag[bagID][slot])=="table")then
		return VerisimilarPl.bag[bagID][slot].cdStart,VerisimilarPl.bag[bagID][slot].cdDuration,1
	else
		return unpack({self.hooks.GetContainerItemCooldown(bagID, slot)})
	end
end

function  VerisimilarPl:GetContainerItemID(bagID, slot)
	if((bagID>-1 and bagID<5) and type(VerisimilarPl.bag[bagID][slot])=="table")then
		return VerisimilarPl.bag[bagID][slot].id
	else
		return self.hooks.GetContainerItemID(bagID, slot)
	end
end

function  VerisimilarPl:GetContainerItemQuestInfo(bagID, slot)
	if((bagID>-1 and bagID<5) and type(VerisimilarPl.bag[bagID][slot])=="table")then
		local stub=VerisimilarPl.bag[bagID][slot];
		for _,questStub in pairs(stub.session.stubs) do
			if(questStub.type=="Quest" and questStub.enabled and not questStub.finished and questStub.available and questStub.starters[stub.id])then
				local onQuest=nil;
				if(questStub.onQuest)then
					onQuest=1;
				end
				return true,questStub.id,onQuest;
			end
		end
		return nil
	else
		return self.hooks.GetContainerItemQuestInfo(bagID, slot)
	end
end

function VerisimilarPl:GetItemStubQuality(stub)
	for i=1,#VerisimilarPl.itemQuality do
		if(VerisimilarPl.itemQuality[i]==stub.quality)then
			return i-1;
		end
	end
end

function VerisimilarPl:GetContainerItemInfo(bagID, slot)
	if((bagID>-1 and bagID<5) and type(VerisimilarPl.bag[bagID][slot])=="table")then
		local stub=VerisimilarPl.bag[bagID][slot];
		local quality=VerisimilarPl:GetItemStubQuality(stub);
		
		local readable
		if(stub.document~=nil)then
			readable=1;
		end
		return "Interface\\Icons\\"..stub.icon, stub.amount, nil, quality,readable;
	else
		return unpack({self.hooks.GetContainerItemInfo(bagID, slot)})
	end
end

function  VerisimilarPl:test()
	local link=GetContainerItemLink(4,14)
	self:Print(gsub(link,"(.)","%1 "))
end

local bagNum,slotNum
local WoWBagsItemMenu=function()
	local menuTable={};
	local stub=VerisimilarPl.bag[bagNum][slotNum]
	if(not stub)then return end
	tinsert(menuTable,{	text="Place at",
							isTitle=true
						});
	for i=0,4 do
		tinsert(menuTable,{	text=GetBagName(i),
							hasArrow=true,
							subMenu={}
						});
		for j=1,GetContainerNumSlots(i) do
			local id=GetContainerItemID(i, j);
			local text;
			if(type(id)=="number")then
				text=GetItemInfo(id);
			elseif(type(id)=="string")then
				text=VerisimilarPl.bag[i][j].name;
			else
				text="Empty slot";
			end
			tinsert(menuTable[#menuTable].subMenu,{	text=text,
													func=function()
															if(type(id)=="number")then
																VerisimilarPl.bag[bagNum][slotNum]=nil;
																VerisimilarPl.hooks.PickupContainerItem(i, j);
																VerisimilarPl.hooks.PickupContainerItem(bagNum, slotNum);
															elseif(type(id)=="string")then
																VerisimilarPl.bag[bagNum][slotNum]=VerisimilarPl.bag[i][j];
																for frameNum=1,13 do
																	local frame=_G["ContainerFrame"..frameNum]
																	if(frame:GetID()==bagNum and frame:IsVisible())then
																		ContainerFrame_Update(frame);
																	end
																end
															end
															VerisimilarPl.bag[i][j]=stub;
															
															for frameNum=1,13 do
																local frame=_G["ContainerFrame"..frameNum];
																if(frame:GetID()==i and frame:IsVisible())then
																	ContainerFrame_Update(frame);
																end
															
															end
														end,
													closeWhenClicked=true,
								});
		end
		
	end
	if(not stub.soulbound and UnitName("target")~=UnitName("player") and UnitIsPlayer("target") and UnitIsFriend("player","target") and CheckInteractDistance("target",2))then
		tinsert(menuTable,{	text="Give to "..UnitName("target"),
							hasArrow=true,
							hasEditBox=true,
							editBoxText=stub.amount,
							editBoxFunc=VerisimilarPl.GiveItemTo,
							editBoxArg1=VerisimilarPl,
							editBoxArg2=stub,
							editBoxArg3=UnitName("target"),
							closeWhenClicked=true
							});
	end
	tinsert(menuTable,{	text="Destroy",
						hasArrow=true,
						hasEditBox=true,
						editBoxText=stub.amount,
						editBoxFunc=function(stub,amount)
										local dialog = StaticPopup_Show("VERISIMILAR_DESTROY_ITEM",stub.name)
										if (dialog) then
											dialog.data  = stub
											dialog.data2 = amount
										end
										AceLibrary("Dewdrop-2.0"):Close()
									end,
						editBoxArg1=stub,
						closeWhenClicked=true
						});
	AceLibrary("Dewdrop-2.0"):FeedTable(menuTable);

end

function  VerisimilarPl:PickupContainerItem(bagID, slot)
	if((bagID>-1 and bagID<5) and type(VerisimilarPl.bag[bagID][slot])=="table")then
		local stub=VerisimilarPl.bag[bagID][slot]
		if(CursorHasItem())then
			for i=0,4 do
				local finished=false;
				for j=1,GetContainerNumSlots(i) do
					_,__,locked=GetContainerItemInfo(i,j);
					if(locked)then
						VerisimilarPl.bag[i][j]=stub
						finished=true;
						break;
					end
				end
				if(finished)then
					break;
				end
			end
			VerisimilarPl.bag[bagID][slot]=nil
			self.hooks.PickupContainerItem(bagID, slot)
		else
			bagNum=bagID;
			slotNum=slot;
			local x,y=GetCursorPosition();
			AceLibrary("Dewdrop-2.0"):Open(UIParent,'children',WoWBagsItemMenu,'cursorX',x,'cursorY',y);
		end
	else
		self.hooks.PickupContainerItem(bagID, slot)
	end
end

function  VerisimilarPl:GetContainerItemLink(bagID, slot)
	if((bagID>-1 and bagID<5) and type(self.bag[bagID][slot])=="table")then
		local stub=self.bag[bagID][slot]
		return self:GetItemStubLink(stub);
	else
		return self.hooks.GetContainerItemLink(bagID, slot)
	end
end

function VerisimilarPl:GetItemStubLink(stub)
	local color=self.qualityColor[stub.quality];
	return "|cff"..format("%.2x%.2x%.2x",color.r*255,color.g*255,color.b*255).."|Hitem:"..stub.session.gm.."_"..stub.session.id..stub.id..":0:0:0:0:0:0:0:80:0|h["..stub.name.."]|h|r";
end

function  VerisimilarPl:GetItemInfo(itemInfo)
	local sessionList=self.sessions;
	if(self.hooks.GetItemInfo(itemInfo))then
		return unpack({self.hooks.GetItemInfo(itemInfo)})
	else
		local stub;
		local itemId=strmatch( itemInfo, "|Hitem:(.+):0:0:0:0:0:0:0:80:0|h" );
		if(not itemId)then
			itemId=itemInfo;
		end
		session=sessionList[strsub(itemId,1,-2)];
		if(session)then
			stub=session.stubs[strsub(itemId,-1,-1)];
		else
			for _,session in pairs(sessionList)do
				for __,s in pairs(session.stubs)do
					if(s.type=="Item" and s.enabled and s.amount>0 and s.name==itemInfo)then
						stub=s;
						break;
					end
				end
			end
		end
		if(stub)then
			return stub.name,self:GetItemStubLink(stub),self:GetItemStubQuality(stub),1,0,"Miscellaneous","Other",999,"","Interface\\Icons\\"..stub.icon,0;
		end
	end
end



function  VerisimilarPl:PutItemInBackpack()
	
	self.hooks.PutItemInBackpack()
end

function  VerisimilarPl:PutItemInBag(inventoryId)

	self.hooks.PutItemInBag(inventoryId)
end

function  VerisimilarPl:SplitContainerItem(bagID,slot,amount)
	
	self.hooks.SplitContainerItem(bagID,slot,amount)
end

function  VerisimilarPl:UseContainerItem(bagID, slot, onSelf)
	if((bagID>-1 and bagID<5) and type(VerisimilarPl.bag[bagID][slot])=="table")then
		local stub=VerisimilarPl.bag[bagID][slot]
		VerisimilarPl:ItemStubClicked(stub)
	end
end

function  VerisimilarPl:GetContainerNumFreeSlots(bagID)
	local numFreeSlots,bagType=self.hooks.GetContainerNumFreeSlots(bagID)
	for i=1, GetContainerNumSlots(bagID) do
		if((bagID>-1 and bagID<5) and type(VerisimilarPl.bag[bagID][i])=="table")then
			numFreeSlots=numFreeSlots-1
		end
	end
	return numFreeSlots,bagType;
end

function VerisimilarPl:SetBagItem(tooltip,bag, slot)
	if((bag>-1 and bag<5) and type(VerisimilarPl.bag[bag][slot])=="table")then
		local stub=VerisimilarPl.bag[bag][slot]
		VerisimilarPl:ShowItemTooltip(stub)

	else
		return unpack({self.hooks[GameTooltip].SetBagItem(tooltip,bag, slot)})
	end 
end

function VerisimilarPl:BAG_UPDATE(event,bagID)
	for slot=1, GetContainerNumSlots(bagID) do
		if(self.hooks.GetContainerItemInfo(bagID, slot) and VerisimilarPl.bag[bagID] and VerisimilarPl.bag[bagID][slot])then
			local stub=VerisimilarPl.bag[bagID][slot];
			for i=0,4 do
				if(GetContainerNumFreeSlots(i)>0)then
					local placed=false;
					for j=1,GetContainerNumSlots(i) do
						if(GetContainerItemID(i, j)==nil)then
							VerisimilarPl.bag[i][j]=stub
							placed=true;
							
							for frameNum=1,13 do
								local frame=_G["ContainerFrame"..frameNum];
								if(frame:GetID()==i and frame:IsVisible())then
									ContainerFrame_Update(frame);
								end
							end
							
							if(i==0)then
								ItemAnim_OnEvent(MainMenuBarBackpackButtonItemAnim,"ITEM_PUSH",0,"Interface\\Icons\\"..stub.icon)
							else
								ItemAnim_OnEvent(_G["CharacterBag"..(i-1).."SlotItemAnim"],"ITEM_PUSH",i+19,"Interface\\Icons\\"..stub.icon)
							end
							break;
						end
						
					end
					if(placed)then
						break;
					end
				end
			end
			VerisimilarPl.bag[bagID][slot]=nil
			for frameNum=1,13 do
				local frame=_G["ContainerFrame"..frameNum]
				if(frame:GetID()==bagID and frame:IsVisible())then
					ContainerFrame_Update(frame)
				end
			
			end
		end
	end
	MainMenuBarBackpackButton_UpdateFreeSlots()
end

function VerisimilarPl:IsItemStubInRange(stub)
	local range=stub.range;
	if(range==0)then
		return 1;
	elseif(range==5)then
		if(UnitExists("target"))then
			return 1;
		end
	else
		return CheckInteractDistance("target", range);
	end
end