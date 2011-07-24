local mobPanel
local GetLootTable, GetLootInfo, AddLoot,RemoveLoot,SetChance,SetAmount
function VerisimilarGM:InitializeMobPanel()
	
	StaticPopupDialogs["VERISIMILAR_NEW_MOB"] = {
		text = "Enter the Mob ID. The \"ID\" is just a codeword used to refer to this mob within Verisimilar GM, not it's actual name, which you will add later. 30 characters max, no space or special characters",
		button1 = "Create",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data)
			local Mob=data:NewMob(self.editBox:GetText());
			if(Mob)then
				VerisimilarGM:AddElementToElementList(Mob);
				VerisimilarGM:UpdateElementList();
				VerisimilarGM:SetPanelToElement(Mob);
			end
		end,
		OnHide = function(self)
					self.editBox:SetText("")
				end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_SET_LOOT_DROP_CHANCE"] = {
		text = "Enter the drop chance for the selected items. It should be a number between 1 (veeery low drop chance) and 100 (always drops). Note that if an item has been designated as 'quest item', then it will only drop if the player is on the quest.",
		button1 = "Set chance",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data,data2)
			local Mob=data;
			if(Mob)then
				local indices=data2;
				for i=1,#indices do
					Mob:SetDropChance(indices[i],tonumber(self.editBox:GetText()));
				end
				VerisimilarGM:UpdateInterface();
			end
		end,
		OnHide = function(self)
					self.editBox:SetText("")
				end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_SET_LOOT_DROP_AMOUNT"] = {
		text = "Enter the drop amount for the selected items. This is the maximum number of items that will drop on each kill, not a set number.",
		button1 = "Set amount",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data,data2)
			local Mob=data;
			if(Mob)then
				local indices=data2;
				for i=1,#indices do
					Mob:SetDropAmount(indices[i],tonumber(self.editBox:GetText()));
				end
				VerisimilarGM:UpdateInterface();
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
						{text="Loot table",showOnEnabled=false,showOnDisabled=true,
							{type="EditBox", key="name",label="Name",labelPosition="LEFT",x=55,y=-15,width=200,setFunc=function(editBox,name)VerisimilarGM:GetActiveElement():SetName(name);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetName(); end,tooltip="This is the name of the mob. You must enter it's exact name in order for Verisimilar to affect it's loot table"},
							{type="Button", key="setTargetName",label="Set as my target's name",refFrame="name",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function(button)VerisimilarGM:GetActiveElement():SetName(UnitName("target") or "");mobPanel.controls.name:SetText(UnitName("target") or "") end ,tooltip="Set the name of this mob as the name of your target. This will make Verisimilar edit your target's loot table"},
							{type="Button", key="addLoot",label="Add loot",x=15,y=-65, clickFunc=AddLoot ,tooltip="Add an item to the loot table"},
							{type="List", key="lootList",x=10,y=-90,width=600,height=300,updateFunc=GetLootTable,infoFunc=GetLootInfo,columns={
																																	{label="Id",width=130},
																																	{label="Name"},
																																	{label="Chance",width=60},
																																	{label="Amount",width=60},
																																},
							},
							{type="Button", key="removeLoot",label="Remove loot",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=5,y=0, clickFunc=RemoveLoot ,tooltip="Remove the selected items from the loot table"},
							{type="Button", key="setChance",label="Set drop chance",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=SetChance ,tooltip="Set the drop chance for the selected loot"},
							{type="Button", key="setAmount",label="Set drop amount",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=SetAmount ,tooltip="Set the drop amount for the selected loot"},
						},
					};
	
	mobPanel=self:CreateElementPanel("Mob",description)
	
end

GetLootTable=function(list)
	local mob=VerisimilarGM:GetActiveElement();
	
	for i=1,mob:GetNumDrops() do
		local drop=mob:GetItem(i);
		if(drop)then
			list:Insert(i,drop:IsEnabled());
		end
	end
end

GetLootInfo=function(index)
	local mob=VerisimilarGM:GetActiveElement();
	return mob:GetItem(index).id,mob:GetItem(index).name,mob:GetDropChance(index),mob:GetDropAmount(index);
end

local function itemClicked(button,mob,item)
	mob:AddDrop();
	mob:SetItem(mob:GetNumDrops(),item);
	VerisimilarGM:UpdateInterface();
end

local menuFrame = CreateFrame("Frame", "VGMDDMobMenuFrame", UIParent, "UIDropDownMenuTemplate");
AddLoot=function(button)
	local mob=VerisimilarGM:GetActiveElement();
	local session=mob:GetSession();
	local menu={};
	local existingLoot={};
	for i=1,mob:GetNumDrops() do
		local drop=mob:GetItem(i);
		if(drop)then
			existingLoot[mob:GetItem(i).id]=true;
		end
	end
	for _,element in pairs(session.elements)do
		if(element.elType=="Item" and not existingLoot[element.id])then
			tinsert(menu,{text=element.id.." - "..element.name,notCheckable=true,func=itemClicked,arg1=mob,arg2=element});
		end
	end
	EasyMenu(menu, menuFrame, button, 0 , 0,"MENU",10);
end

RemoveLoot=function(button)
	local indices=mobPanel.controls.lootList:GetSelectedEntries();
	local mob=VerisimilarGM:GetActiveElement();
	local lootToDelete={};
	for j=1,#indices do
		lootToDelete[mob:GetItem(indices[j]).id]=true;
	end
	local i=1;
	while(i<=mob:GetNumDrops())do
		if(lootToDelete[mob:GetItem(i).id])then
			mob:RemoveDrop(i);
		else
			i=i+1;
		end
	end
	VerisimilarGM:UpdateInterface()
end

SetChance=function(button)
	local indices=mobPanel.controls.lootList:GetSelectedEntries();
	local mob=VerisimilarGM:GetActiveElement();
	local dialog=StaticPopup_Show ("VERISIMILAR_SET_LOOT_DROP_CHANCE");
	if (dialog) then
		dialog.data  = mob;
		dialog.data2=indices;
	end
end

SetAmount=function(button)
	local indices=mobPanel.controls.lootList:GetSelectedEntries();
	local mob=VerisimilarGM:GetActiveElement();
	local dialog=StaticPopup_Show ("VERISIMILAR_SET_LOOT_DROP_AMOUNT");
	if (dialog) then
		dialog.data  = mob;
		dialog.data2=indices;
	end
end

function VerisimilarGM:SetPanelToMob()
	local mob=VGMMainFrame.controlPanel.element;
	VGMMainFrame.controlPanel.title:SetText(mob.id);
	VGMMainFrame.controlPanel.panels.Mob:Show();
end