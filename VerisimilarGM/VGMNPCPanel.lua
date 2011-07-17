local npcPanel,npcSign
local AreaClick,SetCoords,GetX,GetY,SetPositionasPlayer,UpdateNPCSign,GetNPCGossipMenu,AddGossip,RemoveGossip,GetPlayers,GetPlayerNPCInfo,CanInteract,CanNotInteract,ShowGossip
function VerisimilarGM:InitializeNPCPanel()
		
	StaticPopupDialogs["VERISIMILAR_NEW_NPC"] = {
		text = "Enter the NPC ID. The \"ID\" is just a codeword used to refer to this NPC within Verisimilar GM, not his actual name, which you will add later. 30 characters max, no space or special characters",
		button1 = "Create",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data)
			local NPC=data:NewNPC(self.editBox:GetText());
			if(NPC)then
				VerisimilarGM:AddElementToElementList(NPC);
				VerisimilarGM:UpdateElementList();
				VerisimilarGM:SetPanelToElement(NPC);
			end
		end,
		OnHide = function(self)
					self.editBox:SetText("")
				end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	local distanceToGM=function(npc)
		local x1,y1=GetPlayerMapPosition("player");
		local x2,y2=npc:GetCoords();
		local x=(x1-x2);
		local y=(y1-y2);
		return sqrt(x*x+y*y);
	end
	local description={
						{text="Interact",showOnEnabled=true,showOnDisabled=true,
							{type="Button", key="showChatWindow",label="Chat Window",x=35,y=-35, clickFunc=function(button)VerisimilarGM:ShowNPCChatFrame(VerisimilarGM:GetActiveElement()) end ,tooltip="This will give you a special chat window that will allow you to talk as this NPC to nearby players"},
							{type="List", key="playerList",x=10,y=-80,width=300,height=200,showOfflineControls=true,updateFunc=GetPlayers,infoFunc=GetPlayerNPCInfo,columns={
																																	{label="Name",width=50},
																																	{label="Can interact with NPC"},
																																	
																																},
							},
							{type="Button", key="canInteract",label="Can interact with NPC",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=5,y=-10, clickFunc=CanInteract ,tooltip="The selected players will be able to interact (see, talk with and read gossip) with the NPC"},
							{type="Button", key="canNotInteract",label="Can NOT interact with NPC",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=CanNotInteract ,tooltip="The selected players will NOT be able to interact (see, talk with and read gossip) with the NPC"},
							{type="Button", key="showGossip",label="Show Gossip",refFrame="canInteract",refPoint="BOTTOMLEFT",x=0,y=-15, clickFunc=ShowGossip ,tooltip="Show this NPC's gossip to the selected players"},
						},
						{text="General",showOnEnabled=false,showOnDisabled=true,
							{type="EditBox", key="name",label="Name",labelPosition="LEFT",x=55,y=-15,width=300,setFunc=function(editBox,name)VerisimilarGM:GetActiveElement():SetName(name);end, getFunc=function(editBox) return VerisimilarGM:GetActiveElement():GetName(); end,tooltip="The name of this NPC. If you are editing a real NPC, this must be his exact name."},
							{type="Button", key="setTargetName",label="Set as my target's name",refFrame="name",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function(button)VerisimilarGM:GetActiveElement():SetName(UnitName("target") or "");npcPanel.controls.name:SetText(UnitName("target") or "") end ,tooltip="Set the name of this NPC as the name of your target. This will make Verisimilar edit your target's quests and gossip options too."},
							--{type="Icon", key="icon",label="Icon",x=0,y=-15,refFrame="name",refPoint="BOTTOMLEFT",setFunc=function(iconButton,icon)VerisimilarGM:GetActiveElement():SetIcon(icon);end, getFunc=function(iconButton) return VerisimilarGM:GetActiveElement():GetIcon(); end,tooltip="If you are creating an NPC that doesn't exist on the game world, or if a player chooses not to merge WoW NPCs with Verisimilar NPCs, you can select an icon that will represent him on the minimap"},
							--{type="CheckButton", key="hasEnviromentalIcon",label="Show icon on minimap",refFrame="icon",refPoint="BOTTOMLEFT",x=5,y=-15,width=100, clickFunc=function(button,state)VerisimilarGM:GetActiveElement():SetEnvironmentIcon(state);end,checkFunc=function() return VerisimilarGM:GetActiveElement():HasEnvironmentIcon();end,tooltip="If selected, then this NPC's icon will appear on the minimap to represent his position. Deselect it if you are editing an existing WoW NPC"},
							{type="CheckButton", key="captureSayings",label="Can listen to players",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-15,width=100, clickFunc=function(button,state)VerisimilarGM:GetActiveElement():SetCaptureSayings(state);end,checkFunc=function() return VerisimilarGM:GetActiveElement():IsCapturingSayings();end,tooltip="Allows the NPC to 'listen' when nearby players talk, allowing you to have a conversation with them through this NPC. Requires that the player must also enable the 'send sayings' option for this session"},
							{type="Container", key="talkability",label="Talks when targeted",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-15,width=160,height=130, tooltip="If the WoW NPC you are editing cannot be interracted with (using the right mouse button), then select this option to allow players to interact with him by targeting, and at what range (you will need at least medium range for most hostile NPCs)",
								{type="RadioButtons", key="isTargetTalkable",buttonLabels={"No","Close (<10 yards)","Medium (<28 yards)","Far (>28 yards)"},x=15,y=-15,setFunc=function(button,i)VerisimilarGM:GetActiveElement():SetTargetTalkable(i-1);end,getFunc=function() return VerisimilarGM:GetActiveElement():IsTargetTalkable()+1;end},
							},
						},
						{text="Location",showOnEnabled=false,showOnDisabled=true,
							--{type="EditBox", key="visibleDistance",label="Visible distance",coordinates=true,x=100,y=0,width=60,labelPosition="LEFT",setFunc=function(editBox,distance)VerisimilarGM:GetActiveElement():SetVisibleDistance(distance);UpdateNPCSign() end, getFunc=function()return VerisimilarGM:GetActiveElement():GetVisibleDistance(); end,tooltip="If this NPC is represented by a minimap icon, then this is the distance that he will be visible. These are not yards, but a fraction of the map, and will vary according to it's size."},
							--{type="Button", key="increaseVisibleDistance",label="+",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=tonumber(npcPanel.controls.visibleDistance:GetText())*1.1;npc:SetVisibleDistance(distance);npcPanel.controls.visibleDistance:SetText(distance);UpdateNPCSign() end},
							--{type="Button", key="decreaseVisibleDistance",label="-",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=5,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=tonumber(npcPanel.controls.visibleDistance:GetText())*0.9;npc:SetVisibleDistance(distance);npcPanel.controls.visibleDistance:SetText(distance);UpdateNPCSign() end},
							--{type="Button", key="setVisibleDistanceFromPlayer",label="Set up to my position",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=distanceToGM(npc);npc:SetVisibleDistance(distance);npcPanel.controls.visibleDistance:SetText(distance);UpdateNPCSign() end ,tooltip="Set the visible distance to be up to your current position"},
							
							--{type="EditBox", key="actDistance",label="Act distance",coordinates=true,refFrame="visibleDistance",refPoint="BOTTOMLEFT",x=0,y=-5,width=60,labelPosition="LEFT",setFunc=function(editBox,distance)VerisimilarGM:GetActiveElement():SetActDistance(distance);UpdateNPCSign() end, getFunc=function()return VerisimilarGM:GetActiveElement():GetActDistance(); end,tooltip="If this NPC is represented by a minimap icon, then this is the distance that the player will be able to interact with him (right click on the icon to talk). These are not yards, but a fraction of the map, and will vary according to it's size."},
							--{type="Button", key="increaseActDistance",label="+",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=tonumber(npcPanel.controls.actDistance:GetText())*1.1;npc:SetActDistance(distance);npcPanel.controls.actDistance:SetText(distance);UpdateNPCSign() end},
							--{type="Button", key="decreaseActDistance",label="-",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=5,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=tonumber(npcPanel.controls.actDistance:GetText())*0.9;npc:SetActDistance(distance);npcPanel.controls.actDistance:SetText(distance);UpdateNPCSign() end},
							--{type="Button", key="setActDistanceFromPlayer",label="Set up to my position",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=distanceToGM(npc);npc:SetActDistance(distance);npcPanel.controls.actDistance:SetText(distance);UpdateNPCSign() end ,tooltip="Set the act distance to be up to your current position"},
							
							{type="EditBox", key="sayDistance",coordinates=true,label="Say distance",x=100,y=-15,width=60,labelPosition="LEFT",setFunc=function(editBox,distance)VerisimilarGM:GetActiveElement():SetSayDistance(distance);UpdateNPCSign() end, getFunc=function()return VerisimilarGM:GetActiveElement():GetSayDistance(); end,tooltip="This is the distance that a player will hear the NPC speaking or emoting. These are not yards, but a fraction of the map, and will vary according to it's size."},
							{type="Button", key="increaseSayDistance",label="+",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=tonumber(npcPanel.controls.sayDistance:GetText())*1.1;npc:SetSayDistance(distance);npcPanel.controls.sayDistance:SetText(distance);UpdateNPCSign() end},
							{type="Button", key="decreaseSayDistance",label="-",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=5,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=tonumber(npcPanel.controls.sayDistance:GetText())*0.9;npc:SetSayDistance(distance);npcPanel.controls.sayDistance:SetText(distance);UpdateNPCSign() end},
							{type="Button", key="setSayDistanceFromPlayer",label="Set up to my position",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=distanceToGM(npc);npc:SetSayDistance(distance);npcPanel.controls.sayDistance:SetText(distance);UpdateNPCSign() end ,tooltip="Set the say distance to be up to your current position"},
							
							{type="EditBox", key="yellDistance",label="Yell distance",coordinates=true,refFrame="sayDistance",refPoint="BOTTOMLEFT",x=0,y=-5,width=60,labelPosition="LEFT",setFunc=function(editBox,distance)VerisimilarGM:GetActiveElement():SetYellDistance(distance);UpdateNPCSign() end, getFunc=function()return VerisimilarGM:GetActiveElement():GetYellDistance(); end,tooltip="This is the distance that a player will hear the NPC yelling. These are not yards, but a fraction of the map, and will vary according to it's size."},
							{type="Button", key="increaseYellDistance",label="+",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=tonumber(npcPanel.controls.yellDistance:GetText())*1.1;npc:SetYellDistance(distance);npcPanel.controls.yellDistance:SetText(distance);UpdateNPCSign() end},
							{type="Button", key="decreaseYellDistance",label="-",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=5,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=tonumber(npcPanel.controls.yellDistance:GetText())*0.9;npc:SetYellDistance(distance);npcPanel.controls.yellDistance:SetText(distance);UpdateNPCSign() end},
							{type="Button", key="setYellDistanceFromPlayer",label="Set up to my position",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=function() local npc=VerisimilarGM:GetActiveElement();local distance=distanceToGM(npc);npc:SetYellDistance(distance);npcPanel.controls.yellDistance:SetText(distance);UpdateNPCSign() end ,tooltip="Set the say distance to be up to your current position"},
							
							{type="EditBox", key="coordX",coordinates=true,label="X:",x=25,y=-120,width=60,labelPosition="LEFT",setFunc=SetCoords, getFunc=GetX,tooltip="The X coordinates for the position of the NPC on the map"},
							{type="EditBox", key="coordY",label="Y:",coordinates=true,refFrame="PREVIOUS",refPoint="TOPRIGHT",x=25,y=0,width=60,labelPosition="LEFT",setFunc=SetCoords, getFunc=GetY,tooltip="The Y coordinates for the position of the NPC on the map"},
							{type="Button", key="setPositionasPlayer",label="Set as my position",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=SetPositionasPlayer ,tooltip="Set the NPC's map and coordinates as your current position"},
							{type="Area", key="area",x=0,y=-150,clickFunc=AreaClick,setFunc=function(areaControl,zone,level) VerisimilarGM:GetActiveElement():SetZone(zone,level) end, getFunc=function(areaControl) return VerisimilarGM:GetActiveElement():GetZone() end,},
						},
						{text="Gossip",showOnEnabled=false,showOnDisabled=true,
							{type="DropDown", key="gossip",label="Gossip:",x=45,y=-5, width=200,labelPosition="LEFT", menuFunc=GetNPCGossipMenu, tooltip="Select one of this NPC's gossip options to edit"},
							{type="Button", key="addGossip",label="Add gossip option",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=AddGossip ,tooltip="Add a new gossip option to this NPC"},
							{type="Button", key="removeGossip",label="Remove gossip option",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=RemoveGossip ,tooltip="Remove the currently selected gossip option from this NPC"},
							{type="EditBox", key="gossipOption",label="Option text:",refFrame="gossip",refPoint="BOTTOMLEFT",x=0,y=-25,width=300,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetOptionText(npcPanel.controls.gossip.selection,text); end, getFunc=function()return VerisimilarGM:GetActiveElement():GetOptionText(npcPanel.controls.gossip.selection); end,tooltip="The gossip option text. This is the button that appears in the gossip window, that players can click.\nIf you are editing gossip option #0, this option will take the player back to the main gossip"},
							{type="LargeEditBox", key="gossipText",label="Gossip text:",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-15,width=300,height=400,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetOptionGossip(npcPanel.controls.gossip.selection,text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetOptionGossip(npcPanel.controls.gossip.selection); end,tooltip="The gossip text that appears when the player clicks the above option.\nFor gossip option #0, this text appears as soon as you interact with the NPC, along with his original gossip text"},
						},
						{text="Scripts",showOnEnabled=false,showOnDisabled=true,
							{type="LargeEditBox", key="gossipScript",label="Gossip Script:",x=10,y=-15,width=650,height=340,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetGossipScript(text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetGossipScript(); end,},
							{type="LargeEditBox", key="existenceScript",label="Existence Script:",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-15,width=650,height=160,setFunc=function(editBox,text)VerisimilarGM:GetActiveElement():SetExistenceScript(text);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetExistenceScript(); end,},
						},
					}
	
	npcPanel=self:CreateElementPanel("NPC",description)
	npcSign=CreateFrame("Frame",nil,npcPanel.controls.area);
	npcSign:SetWidth(16);
	npcSign:SetHeight(16);
	npcSign:SetFrameLevel(npcPanel.controls.area.Map:GetFrameLevel()+1);
	npcSign.MainTexture=npcSign:CreateTexture();
	npcSign.MainTexture:SetAllPoints(npcSign);
	npcSign.MainTexture:SetTexture("Interface\\WorldMap\\WorldMapPartyIcon");
	
	--[[npcSign.VisibleTexture=npcSign:CreateTexture();
	npcSign.VisibleTexture:SetPoint("CENTER",npcSign,"CENTER");
	npcSign.VisibleTexture:SetTexture("Interface\\AddOns\\VerisimilarPlayer\\Images\\Interface\\white_circle");
	npcSign.VisibleTexture:SetVertexColor(1,1,0)]]
	
	--[[npcSign.ActTexture=npcSign:CreateTexture();
	npcSign.ActTexture:SetPoint("CENTER",npcSign,"CENTER");
	npcSign.ActTexture:SetTexture("Interface\\AddOns\\VerisimilarPlayer\\Images\\Interface\\white_circle");
	npcSign.ActTexture:SetVertexColor(0,1,0)]]
	
	npcSign.SayTexture=npcSign:CreateTexture();
	npcSign.SayTexture:SetPoint("CENTER",npcSign,"CENTER");
	npcSign.SayTexture:SetTexture("Interface\\AddOns\\VerisimilarPlayer\\Images\\Interface\\white_ring");
	npcSign.SayTexture:SetVertexColor(1,1,1)
	
	npcSign.YellTexture=npcSign:CreateTexture();
	npcSign.YellTexture:SetPoint("CENTER",npcSign,"CENTER");
	npcSign.YellTexture:SetTexture("Interface\\AddOns\\VerisimilarPlayer\\Images\\Interface\\white_ring");
	npcSign.YellTexture:SetVertexColor(1,0,0)
end


GetPlayers=function(list,showOffline)
	local npc=VerisimilarGM:GetActiveElement();
	local session=npc:GetSession();
	local totalentries, onlineentries=0,0
	
	for _,player in pairs(session.players)do
		totalentries=totalentries+1;
		if(player.connected)then
			onlineentries=onlineentries+1;
		end
		if(player.connected or showOffline)then
			list:Insert(player,player.connected);
		end
	end
	return totalentries, onlineentries;
end

GetPlayerNPCInfo=function(player)
	local npc=VerisimilarGM:GetActiveElement();
	local npcInfo=player.elements[npc.id]

	return player.name,npcInfo.exists and "Yes" or "No";
end

CanInteract=function(button)
	local npc=VerisimilarGM:GetActiveElement();
	local players=npcPanel.controls.playerList:GetSelectedEntries();
	for i=1,#players do
		npc:SetExistenceForPlayer(players[i],true);
	end
	VerisimilarGM:UpdateInterface()
end

CanNotInteract=function(button)
	local npc=VerisimilarGM:GetActiveElement();
	local players=npcPanel.controls.playerList:GetSelectedEntries();
	for i=1,#players do
		npc:SetExistenceForPlayer(players[i],false);
	end
	VerisimilarGM:UpdateInterface()
end

ShowGossip=function(button)
	local npc=VerisimilarGM:GetActiveElement();
	local players=npcPanel.controls.playerList:GetSelectedEntries();
	for i=1,#players do
		npc:SendGossip(players[i],0);
	end
	VerisimilarGM:UpdateInterface()
end



local function SetNPCSign(x,y)
	if(x==0 and y==0)then
		npcSign:Hide();
	else
		local map=npcPanel.controls.area.Map;
		local scale=map:GetEffectiveScale();
		npcSign:SetPoint("CENTER", map, "TOPLEFT",x*map:GetWidth()*scale,-y*map:GetHeight()*scale);
		UpdateNPCSign();
		npcSign:Show();
	end	
end

UpdateNPCSign=function()
	local controls=npcPanel.controls
	local map=controls.area.Map;
	local xScale=2.2*map:GetWidth()*map:GetEffectiveScale();
	local yScale=2.2*map:GetHeight()*map:GetEffectiveScale();
	
	--local visibleSize=tonumber(controls.visibleDistance:GetText())
	--VisibleTexture:SetSize(visibleSize*xScale,visibleSize*yScale);
	
	--local actSize=tonumber(controls.actDistance:GetText())
	--npcSign.ActTexture:SetSize(actSize*xScale,actSize*yScale);
	
	local saySize=tonumber(controls.sayDistance:GetText())
	npcSign.SayTexture:SetSize(saySize*xScale,saySize*yScale);
	
	local yellSize=tonumber(controls.yellDistance:GetText())
	npcSign.YellTexture:SetSize(yellSize*xScale,yellSize*yScale);
end

SetCoords=function(editBox)
	local controls=npcPanel.controls;
	local npc=VerisimilarGM:GetActiveElement();
	local x=tonumber(controls.coordX:GetText());
	local y=tonumber(controls.coordY:GetText());
	npc:SetCoords(x,y)
	SetNPCSign(x,y);
end

GetX=function(editBox)
	local objDD=npcPanel.controls.objective;
	local npc=VerisimilarGM:GetActiveElement();
	local x,y=npc:GetCoords()
	SetNPCSign(x,y) --Yeah, kind of a hack, but it works
	return x
end

GetY=function(editBox)
	local objDD=npcPanel.controls.objective;
	local npc=VerisimilarGM:GetActiveElement();
	local _,y=npc:GetCoords()
	return y;
end

SetPositionasPlayer=function(button)
	local controls=npcPanel.controls;
	SetMapToCurrentZone();
	local zoneId=GetCurrentMapAreaID();
	local level=GetCurrentMapDungeonLevel();
	local x,y=GetPlayerMapPosition("player");
	controls.coordX:SetText(x);
	controls.coordY:SetText(y);
	SetNPCSign(x,y);
	VerisimilarGM:GetActiveElement():SetCoords(x,y);
	VerisimilarGM:GetActiveElement():SetZone(zoneId,level);
	VerisimilarGM:UpdateInterface();
end

AreaClick=function(area,x,y)
	local controls=npcPanel.controls;
	local npc=VerisimilarGM:GetActiveElement();
	
	controls.coordX:SetText(x);
	controls.coordY:SetText(y);
	npc:SetCoords(x,y);
	
	SetNPCSign(x,y)
end

local function GossipClicked(button,gossipNum)
	local controls=npcPanel.controls;
	local npc=VerisimilarGM:GetActiveElement();
	controls.gossipOption:Hide();
	controls.gossipText:Hide();
	controls.gossip.selection=gossipNum;
	if(gossipNum==0)then
		controls.removeGossip:Disable();
	else
		controls.removeGossip:Enable();
	end
	
	controls.gossipOption:Show();
	controls.gossipText:Show();
	VerisimilarGM:UpdateInterface();
end

GetNPCGossipMenu=function(ddList)
	local npc=VerisimilarGM:GetActiveElement();
	local menu={};
	for i=0,#npc.gossipOptions do
		tinsert(menu,{text=i,checked=ddList.selection==i,func=GossipClicked,arg1=i});
	end
	menu.func=GossipClicked;
	return menu;
end

AddGossip=function(button)
	local npc=VerisimilarGM:GetActiveElement();
	npc:AddOption();
	GossipClicked(nil,#npc.gossipOptions)
	VerisimilarGM:UpdateInterface()
end


RemoveGossip=function(button)
	local gossipDD=npcPanel.controls.gossip;
	local npc=VerisimilarGM:GetActiveElement();
	npc:RemoveOption(gossipDD.selection);
	GossipClicked(nil,0)
	VerisimilarGM:UpdateInterface()
end




function VerisimilarGM:SetPanelToNPC()
	local npc=VGMMainFrame.controlPanel.element;
	VGMMainFrame.controlPanel.title:SetText(npc.id);
	VGMMainFrame.controlPanel.panels.NPC:Show();
end