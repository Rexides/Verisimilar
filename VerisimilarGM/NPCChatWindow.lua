local npcChatFrames={};
local sayingTypeFull={y="YELL",s="SAY",e="EMOTE",t="EMOTE",yell="YELL",say="SAY",emote="EMOTE"};
local sayingTypeText={y="%s yells: ", s="%s says: ", t="%s ", e="",YELL="%s yells: ", SAY="%s says: ", EMOTE="%s "}
local sayingTypeToNPCMethod={SAY="Say",YELL="Yell",EMOTE="Emote"};

function VerisimilarGM:ShowNPCChatFrame(npc)
	local id=npc:GetSession().netID..npc.netID;
	if(npcChatFrames[id]==nil)then
		self:AddNPCChatFrame(npc);
	end
	local frame=npcChatFrames[id];
	frame.tab.Text:SetText(npc.id.." - "..npc.name);
	frame.minimized.Text:SetText(npc.id.." - "..npc.name);
	frame:SetPoint("TOPLEFT",50,-150)
	frame.minimized:Hide();
	frame:Show();
	
	ChatEdit_SetLastActiveWindow(frame.editBox);
end

function VerisimilarGM:HideNPCChatFrame(npc)
	local id=npc:GetSession().netID..npc.netID;
	local frame=npcChatFrames[id];
	frame:Hide();
	frame.minimized:Hide();
end

function VerisimilarGM:IsNPCChatVisible(npc)
	local id=npc:GetSession().netID..npc.netID;
	if(npcChatFrames[id] and (npcChatFrames[id]:IsVisible() or npcChatFrames[id].minimized:IsVisible()))then
		return true
	end
end

function VerisimilarGM:AddNPCChatFrame(npc)
	local id=npc:GetSession().netID..npc.netID;
	npcChatFrames[id]=CreateFrame("ScrollingMessageFrame","VerisimilarNPCChatFrame"..id,nil,"VerisimilarNPCFloatingChatFrameTemplate", id);
	local frame=npcChatFrames[id];
	frame.minimized=CreateFrame("Button","VerisimilarNPCChatMinimizedFrame"..id,nil,"VerisimilarNPCFloatingChatFrameMinimizedTemplate", id);
	frame.minimized.maximized=frame;
	frame.minimized:SetPoint("BOTTOMLEFT",frame,"TOPLEFT");
	frame.minimized:Hide();
	frame:Hide();
	frame.NPC=npc;
	PanelTemplates_TabResize(frame.tab,0, 256);
end

function VerisimilarGM:MinimizeNPCChatFrame(chatFrame)
	--chatFrame.minimized:SetPoint("BOTTOMLEFT",chatFrame,"TOPLEFT");
	chatFrame:Hide();
	chatFrame.minimized:Show();
end

function VerisimilarGM:MaximizeNPCChatFrame(chatFrame)
	--chatFrame:SetPoint("TOPLEFT",chatFrame.minimized,"BOTTOMLEFT");
	if(chatFrame.minimized.alerting)then
		UIFrameFlashStop(chatFrame.minimized.glow);
		chatFrame.minimized.alerting = false;
	end
	chatFrame.minimized:Hide();
	chatFrame:Show();
	ChatEdit_SetLastActiveWindow(chatFrame.editBox);
end

function VerisimilarGM:AddPlayerSaying(npc,player,sayingType,text)
	local id=npc:GetSession().netID..npc.netID;
	if(npcChatFrames[id]==nil)then
		self:AddNPCChatFrame(npc);
	end
	local frame=npcChatFrames[id];
	local c=ChatTypeInfo[sayingTypeFull[sayingType]];
	if(sayingType=="e")then
		text=gsub(text,"[yY]our",player.name.."'s");
		text=gsub(text,"[yY]ou",player.name);
	end
	frame:AddMessage(format(sayingTypeText[sayingType],player.name)..text,c.r,c.g,c.b);
	
	if(frame.minimized:IsVisible())then
		UIFrameFlash(frame.minimized.glow, 1.0, 1.0, -1, false, 0, 0, "chat");
		frame.minimized.alerting = true;
	end
end

function VerisimilarGM:ChatEdit_OnEditFocusGained(editBox)
	if ( ACTIVE_CHAT_EDIT_BOX and ACTIVE_CHAT_EDIT_BOX ~= editBox and not editBox.Verisimilar) then
		ChatEdit_DeactivateChat(ACTIVE_CHAT_EDIT_BOX);
	end
	ACTIVE_CHAT_EDIT_BOX = editBox;
	editBox.chatType="SAY";
	self:ChatEdit_UpdateHeader(editBox);
end

function VerisimilarGM:ChatEdit_OnEditFocusLost(editBox)
	editBox:SetText("");
	editBox.chatType=nil;
	self:ChatEdit_UpdateHeader(editBox);
	ChatEdit_SetLastActiveWindow(editBox);
end

function VerisimilarGM:ChatEdit_OnEnterPressed(editBox)
	local text=editBox:GetText();
	local type=strmatch(text, "^/([^%s]+)$");
	if(type)then
		type=strlower(type);
		if(sayingTypeFull[type])then
			editBox.chatType=sayingTypeFull[type];
			self:ChatEdit_UpdateHeader(editBox);
		else
			self:Print("No chat commands are supported for NPC chat other than /say, /yell and /emote (/s /y /e)");
		end
	else
		local chatFrame=editBox.chatFrame;
		chatFrame.NPC[sayingTypeToNPCMethod[editBox.chatType]](chatFrame.NPC,text);
		if(text~="")then
			local c=ChatTypeInfo[editBox.chatType];
			chatFrame:AddMessage(format(sayingTypeText[editBox.chatType],chatFrame.NPC.name)..text,c.r,c.g,c.b);
		end
		editBox:ClearFocus();
		editBox.chatType=nil;
		self:ChatEdit_UpdateHeader(editBox);
	end
	editBox:SetText("");
	
end

function VerisimilarGM:ChatEdit_OnTextChanged(editBox, userInput)
	local text=editBox:GetText();
	local type=strmatch(text, "^/([^%s]+)%s+$");
	if(type)then
		type=strlower(type);
		if(sayingTypeFull[type])then
			editBox.chatType=sayingTypeFull[type];
			self:ChatEdit_UpdateHeader(editBox)
		else
			self:Print("No chat commands are supported for NPC chat other than /say, /yell and /emote (/s /y /e)");
		end
		editBox:SetText("");
	end
end

function VerisimilarGM:ChatEdit_UpdateHeader(editBox)
	
	local chatFrame=editBox.chatFrame;
	
	local header = _G[editBox:GetName().."Header"];
	if ( not header ) then
		return;
	end
	
	local type = editBox.chatType;
	if ( not type ) then
		header:SetText("");
		editBox:SetTextInsets(15 + header:GetWidth(), 13, 0, 0);

		editBox.focusLeft:Hide();
		editBox.focusRight:Hide();
		editBox.focusMid:Hide();
		return;
	end
	
	local info = ChatTypeInfo[type];
	header:SetFormattedText(_G["CHAT_"..type.."_SEND"], chatFrame.NPC.name);
	
	header:SetTextColor(info.r, info.g, info.b);

	editBox:SetTextInsets(15 + header:GetWidth(), 13, 0, 0);
	editBox:SetTextColor(info.r, info.g, info.b);
	
	editBox.header:Show();
	editBox.focusLeft:Show();
	editBox.focusRight:Show();
	editBox.focusMid:Show();
	editBox.focusLeft:SetVertexColor(info.r, info.g, info.b);
	editBox.focusRight:SetVertexColor(info.r, info.g, info.b);
	editBox.focusMid:SetVertexColor(info.r, info.g, info.b);
end
