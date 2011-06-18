local npcChatFrames={};
local npcChatFrameTabs={};
local npcChatMinimizedFrames={};

function VerisimilarGM:ShowNPCChatFrame(npc)
	local id=npc:GetSession().netID.."_"..npc.netID;
	if(npcChatFrames[id]==nil)then
		self:AddNPCChatFrame(npc);
	end
	local frame=npcChatFrames[id];
	local tab=npcChatFrameTabs[id];
	local minimized=npcChatMinimizedFrames[id];
	frame:Show();
	tab:Show();
	minimized:Hide();
end

function VerisimilarGM:HideNPCChatFrame(npc)
	local id=npc:GetSession().netID.."_"..npc.netID;
	local frame=npcChatFrames[id];
	local tab=npcChatFrameTabs[id];
	local minimized=npcChatMinimizedFrames[id];
	frame:Hide();
	tab:Hide();
	minimized:Hide();
end

function VerisimilarGM:IsNPCChatVisible(npc)
	local id=npc:GetSession().netID.."_"..npc.netID;
	if(npcChatFrames[id] and (npcChatFrames[id]:IsVisible() or npcChatMinimizedFrames[id]:IsVisible()))then
		return true
	end
end

function VerisimilarGM:AddNPCChatFrame(npc)
	local id=npc:GetSession().netID.."_"..npc.netID;
	npcChatFrames[id]=CreateFrame("ScrollingMessageFrame","VerisimilarNPCChatFrame"..strbyte(id),nil,"VerisimilarNPCFloatingChatFrameTemplate", id);
	npcChatFrameTabs[id]=CreateFrame("Button","VerisimilarNPCChatTab"..strbyte(id),nil,"VerisimilarNPCChatTabTemplate", id);
	npcChatMinimizedFrames[id]=CreateFrame("Button","VerisimilarNPCMinimizedFrame"..strbyte(id),nil,"VerisimilarNPCFloatingChatFrameMinimizedTemplate", id);
end

-- ChatFrame functions
function VerisimilarGM:ChatFrame_OnLoad(chatFrame)
	chatFrame.flashTimer = 0;
	chatFrame.tellTimer = GetTime();
	chatFrame.messageTypeList = {};
	
	chatFrame.defaultLanguage = GetDefaultLanguage(); 
end

function VerisimilarGM:ChatFrame_OnUpdate(chatFrame, elapsedSec)
	local flash = _G[chatFrame:GetName().."ButtonFrameBottomButtonFlash"];
	
	if ( not flash ) then
		return;
	end

	if ( chatFrame:AtBottom() ) then
		if ( flash:IsShown() ) then
			flash:Hide();
		end
		return;
	end

	local flashTimer = chatFrame.flashTimer + elapsedSec;
	if ( flashTimer < CHAT_BUTTON_FLASH_TIME ) then
		chatFrame.flashTimer = flashTimer;
		return;
	end

	while ( flashTimer >= CHAT_BUTTON_FLASH_TIME ) do
		flashTimer = flashTimer - CHAT_BUTTON_FLASH_TIME;
	end
	chatFrame.flashTimer = flashTimer;

	if ( flash:IsShown() ) then
		flash:Hide();
	else
		flash:Show();
	end
end

function VerisimilarGM:ChatFrame_OnMouseWheel(value)
	if ( value > 0 ) then
		SELECTED_DOCK_FRAME:ScrollUp();
	elseif ( value < 0 ) then
		SELECTED_DOCK_FRAME:ScrollDown();
	end
end

function VerisimilarGM:ChatFrame_OpenChat(text, chatFrame)
	local editBox = VerisimilarGM:ChatEdit_ChooseBoxForSend(chatFrame);

	VerisimilarGM:ChatEdit_ActivateChat(editBox);
	editBox.setText = 1;
	editBox.text = text;

	if ( editBox:GetAttribute("chatType") == editBox:GetAttribute("stickyType") ) then
		if ( (editBox:GetAttribute("stickyType") == "PARTY") and (GetNumPartyMembers() == 0) or
		(editBox:GetAttribute("stickyType") == "RAID") and (GetNumRaidMembers() == 0) or
		(editBox:GetAttribute("stickyType") == "BATTLEGROUND") and (GetNumRaidMembers() == 0) ) then
			editBox:SetAttribute("chatType", "SAY");
		end
	end
	
	VerisimilarGM:ChatEdit_UpdateHeader(editBox);
	return editBox;
end

function VerisimilarGM:ChatFrame_ScrollToBottom()
	SELECTED_DOCK_FRAME:ScrollToBottom();
end

function VerisimilarGM:ChatFrame_ScrollUp()
	SELECTED_DOCK_FRAME:ScrollUp();
end

function VerisimilarGM:ChatFrame_ScrollDown()
	SELECTED_DOCK_FRAME:ScrollDown();
end

--used for chatframe and combat log
function VerisimilarGM:MessageFrameScrollButton_OnLoad(scrollButton)
	scrollButton.clickDelay = MESSAGE_SCROLLBUTTON_INITIAL_DELAY;
	scrollButton:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonUp", "RightButtonDown");
end

--Controls scrolling for chatframe and combat log
function VerisimilarGM:MessageFrameScrollButton_OnUpdate(scrollButton, elapsed)
	if (scrollButton:GetButtonState() == "PUSHED") then
		scrollButton.clickDelay = scrollButton.clickDelay - elapsed;
		if ( scrollButton.clickDelay < 0 ) then
			local name = scrollButton:GetName();
			if ( name == scrollButton:GetParent():GetName().."DownButton" ) then
				scrollButton:GetParent():GetParent():ScrollDown();
			elseif ( name == scrollButton:GetParent():GetName().."UpButton" ) then
				scrollButton:GetParent():GetParent():ScrollUp();
			end
			scrollButton.clickDelay = MESSAGE_SCROLLBUTTON_SCROLL_DELAY;
		end
	end
end

function VerisimilarGM:ChatFrame_ChatPageUp()
	SELECTED_CHAT_FRAME:PageUp();
end

function VerisimilarGM:ChatFrame_ChatPageDown()
	SELECTED_CHAT_FRAME:PageDown();
end

-- ChatEdit functions

function VerisimilarGM:ChatEdit_OnLoad(editBox)
	editBox:SetFrameLevel(editBox.chatFrame:GetFrameLevel()+1);
	editBox:SetAttribute("chatType", "SAY");
	editBox:SetAttribute("stickyType", "SAY");
	editBox.chatLanguage = GetDefaultLanguage();
		
	editBox.addSpaceToAutoComplete = true;
	
	if ( CHAT_OPTIONS.ONE_EDIT_AT_A_TIME == "many" ) then
		editBox:Show();
	end
end

function VerisimilarGM:ChatEdit_OnUpdate(editBox, elapsedSec)
	if ( editBox.setText == 1) then
		editBox:SetText(editBox.text);
		editBox.setText = 0;
		VerisimilarGM:ChatEdit_ParseText(editBox, 0, true);
	end
end

function VerisimilarGM:ChatEdit_OnShow(editBox)
	VerisimilarGM:ChatEdit_ResetChatType(editBox);
end

function  VerisimilarGM:ChatEdit_ResetChatType(editBox)
	editBox.tabCompleteIndex = 1;
	editBox.tabCompleteText = nil;
	ChatEdit_UpdateHeader(editBox);
	ChatEdit_OnInputLanguageChanged(editBox);
	--[[if ( CHAT_OPTIONS.ONE_EDIT_AT_A_TIME == "old") then
		self:SetFocus();
	end]]
end

function  VerisimilarGM:ChatEdit_OnHide(editBox)
	if ( ACTIVE_CHAT_EDIT_BOX == editBox ) then
		 VerisimilarGM:ChatEdit_DeactivateChat(editBox);
	end
end

function VerisimilarGM:ChatEdit_OnEditFocusGained(editBox)
	VerisimilarGM:ChatEdit_ActivateChat(editBox);
end

function VerisimilarGM:ChatEdit_OnEditFocusLost(editBox)
	VerisimilarGM:AutoCompleteEditBox_OnEditFocusLost(editBox);
	VerisimilarGM:ChatEdit_DeactivateChat(editBox);
end

function VerisimilarGM:ChatEdit_ActivateChat(editBox)
	if ( ACTIVE_CHAT_EDIT_BOX and ACTIVE_CHAT_EDIT_BOX ~= editBox ) then
		ChatEdit_DeactivateChat(ACTIVE_CHAT_EDIT_BOX);
	end
	ACTIVE_CHAT_EDIT_BOX = editBox;
	
	VerisimilarGM:ChatEdit_SetLastActiveWindow(editBox);
	
	--Stop any sort of fading
	UIFrameFadeRemoveFrame(editBox);
	
	editBox:Show();
	editBox:SetFocus();
	editBox:SetFrameStrata("DIALOG");
	editBox:Raise();
	
	editBox.header:Show();
	editBox.focusLeft:Show();
	editBox.focusRight:Show();
	editBox.focusMid:Show();
	editBox:SetAlpha(1.0);
	
	VerisimilarGM:ChatEdit_UpdateHeader(editBox);
	
end

local function ChatEdit_SetDeactivated(editBox)
	editBox:SetFrameStrata("LOW");
	if ( GetCVar("chatStyle") == "classic") then
		editBox:Hide();
	else
		editBox:SetText("");
		editBox.header:Hide();
		editBox:SetAlpha(0.35);
		editBox:ClearFocus();
		
		editBox.focusLeft:Hide();
		editBox.focusRight:Hide();
		editBox.focusMid:Hide();
		ChatEdit_ResetChatTypeToSticky(editBox);
		ChatEdit_ResetChatType(editBox);
	end
end

function VerisimilarGM:ChatEdit_DeactivateChat(editBox)
	if ( ACTIVE_CHAT_EDIT_BOX == editBox ) then
		ACTIVE_CHAT_EDIT_BOX = nil;
	end
	
	VerisimilarGM:ChatEdit_SetDeactivated(editBox);
end

function VerisimilarGM:ChatEdit_UpdateHeader(editBox)
	local type = editBox:GetAttribute("chatType");
	if ( not type ) then
		return;
	end

	local info = ChatTypeInfo[type];
	local header = _G[editBox:GetName().."Header"];
	if ( not header ) then
		return;
	end

	if ( type == "EMOTE" ) then
		header:SetFormattedText(CHAT_EMOTE_SEND, UnitName("player")); --<----FIX THIS FOR NPC NAME
	else
		header:SetText(_G["CHAT_"..type.."_SEND"]);
	end

	header:SetTextColor(info.r, info.g, info.b);

	editBox:SetTextInsets(15 + header:GetWidth(), 13, 0, 0);
	editBox:SetTextColor(info.r, info.g, info.b);
	
	editBox.focusLeft:SetVertexColor(info.r, info.g, info.b);
	editBox.focusRight:SetVertexColor(info.r, info.g, info.b);
	editBox.focusMid:SetVertexColor(info.r, info.g, info.b);
end

function VerisimilarGM:ChatEdit_SendText(editBox, addHistory)
	VerisimilarGM:ChatEdit_ParseText(editBox, 1);

	local type = editBox:GetAttribute("chatType");
	local text = editBox:GetText();
	if ( strfind(text, "%s*[^%s]+") ) then
		--SEND CODE GOES HERE
		if ( addHistory ) then
			ChatEdit_AddHistory(editBox);
		end
	end
end

function VerisimilarGM:ChatEdit_OnEnterPressed(editBox)
	if(VerisimilarGM:AutoCompleteEditBox_OnEnterPressed(editBox)) then
		return;
	end
	VerisimilarGM:ChatEdit_SendText(editBox, 1);

	local type = editBox:GetAttribute("chatType");
	if ( ChatTypeInfo[type].sticky == 1 ) then
		editBox:SetAttribute("stickyType", type);
	end
	
	VerisimilarGM:ChatEdit_OnEscapePressed(editBox);
end

function VerisimilarGM:ChatEdit_OnEscapePressed(editBox)
	ChatEdit_ResetChatTypeToSticky(editBox);
	VerisimilarGM:ChatEdit_DeactivateChat(editBox);
end

function VerisimilarGM:ChatEdit_OnSpacePressed(editBox)
	VerisimilarGM:ChatEdit_ParseText(editBox, 0);
end

function VerisimilarGM:ChatEdit_OnTextChanged(editBox, userInput)
	VerisimilarGM:ChatEdit_ParseText(editBox, 0);
	
end

function VerisimilarGM:ChatEdit_OnTextSet(editBox)
	VerisimilarGM:ChatEdit_ParseText(editBox, 0);
end

local function processChatType(editBox, msg, index, send)
	editBox.autoCompleteParams = AUTOCOMPLETE_LIST[index];
-- this is a special function for "ChatEdit_HandleChatType"
	if ( ChatTypeInfo[index] ) then
		editBox:SetAttribute("chatType", index);
		editBox:SetText(msg);
		ChatEdit_UpdateHeader(editBox);
		return true;
	end
	return false;
end

function VerisimilarGM:ChatEdit_HandleChatType(editBox, msg, command, send)
	
		-- first check the hash table
		if ( hash_ChatTypeInfoList[command] ) then
			return processChatType(editBox, msg, hash_ChatTypeInfoList[command], send);
		end
		for index, value in pairs(ChatTypeInfo) do
			local i = 1;
			local cmdString = _G["SLASH_"..index..i];
			while ( cmdString ) do
				cmdString = strupper(cmdString);
				if ( cmdString == command ) then
					hash_ChatTypeInfoList[command] = index;	-- add to hash table
					return processChatType(editBox, msg, index, send);
				end
				i = i + 1;
				cmdString = _G["SLASH_"..index..i];
			end
		end
	return false;
end

function VerisimilarGM:ChatEdit_ParseText(editBox, send, parseIfNoSpaces)

	local text = editBox:GetText();
	if ( strlen(text) <= 0 ) then
		return;
	end

	if ( strsub(text, 1, 1) ~= "/" ) then
		return;
	end

	--Do not bother parsing if there is no space in the message and we aren't sending.
	if ( send ~= 1 and not parseIfNoSpaces and not strfind(text, "%s") ) then
		return;
	end
	
	-- If the string is in the format "/cmd blah", command will be "/cmd"
	local command = strmatch(text, "^(/[^%s]+)") or "";
	local msg = "";


	if ( command ~= text ) then
		msg = strsub(text, strlen(command) + 2);
	end

	command = strupper(command);

	-- Check and see if we've got secure commands to run before we look for chat types or slash commands.	
	-- This hash table is prepopulated, unlike the other ones, since nobody can add secure commands. (See line 1205 or thereabouts)
	-- We don't want this code to run unless send is 1, but we need ChatEdit_HandleChatType to run when send is 1 as well, which is why we
	-- didn't just move ChatEdit_HandleChatType inside the send == 0 conditional, which could have also solved the problem with insecure
	-- code having the ability to affect secure commands.
	
	if ( send == 1 and hash_SecureCmdList[command] ) then
		hash_SecureCmdList[command](strtrim(msg));
		editBox:AddHistoryLine(text);
		VerisimilarGM:ChatEdit_OnEscapePressed(editBox);
		return;
	end

	-- Handle chat types. No need for a securecall here, since we should be done with anything secure.
	if ( VerisimilarGM:ChatEdit_HandleChatType(editBox, msg, command, send) ) then
		return;
	end

	if ( send == 0 ) then
		return;
	end

	-- Check the hash tables for slash commands and emotes to see if we've run this before. 
	if ( hash_SlashCmdList[command] ) then
		-- if the code in here changes - change the corresponding code below
		hash_SlashCmdList[command](strtrim(msg), editBox);
		editBox:AddHistoryLine(text);
		VerisimilarGM:ChatEdit_OnEscapePressed(editBox);
		return;
	elseif ( hash_EmoteTokenList[command] ) then
		-- if the code in here changes - change the corresponding code below
		--HERE WE SEND EPOTES
		editBox:AddHistoryLine(text);
		VerisimilarGM:ChatEdit_OnEscapePressed(editBox);
		return;
	end

	-- If we didn't have the command in the hash tables, look for it the slow way...
	for index, value in pairs(SlashCmdList) do
		local i = 1;
		local cmdString = _G["SLASH_"..index..i];
		while ( cmdString ) do
			cmdString = strupper(cmdString);
			if ( cmdString == command ) then
				-- if the code in here changes - change the corresponding code above
				hash_SlashCmdList[command] = value;	-- add to hash
				value(strtrim(msg), editBox);
				editBox:AddHistoryLine(text);
				VerisimilarGM:ChatEdit_OnEscapePressed(editBox);
				return;
			end
			i = i + 1;
			cmdString = _G["SLASH_"..index..i];
		end
	end

	local i = 1;
	local j = 1;
	local cmdString = _G["EMOTE"..i.."_CMD"..j];
	while ( i <= MAXEMOTEINDEX ) do
		if ( cmdString and strupper(cmdString) == command ) then
			local token = _G["EMOTE"..i.."_TOKEN"];
			-- if the code in here changes - change the corresponding code above
			if ( token ) then
				hash_EmoteTokenList[command] = token;	-- add to hash
				--HERE SEND THE EMOTE
			end
			editBox:AddHistoryLine(text);
			VerisimilarGM:ChatEdit_OnEscapePressed(editBox);
			return;
		end
		j = j + 1;
		cmdString = _G["EMOTE"..i.."_CMD"..j];
		if ( not cmdString ) then
			i = i + 1;
			j = 1;
			cmdString = _G["EMOTE"..i.."_CMD"..j];
		end
	end

	-- Unrecognized chat command, show simple help text
	if ( editBox.chatFrame ) then
		local info = ChatTypeInfo["SYSTEM"];
		editBox.chatFrame:AddMessage(HELP_TEXT_SIMPLE, info.r, info.g, info.b, info.id);
	end
	
	-- Reset the chat type and clear the edit box's contents
	VerisimilarGM:ChatEdit_OnEscapePressed(editBox);
	return;
end

-- Chat menu functions
function VerisimilarGM:ChatMenu_SetChatType(chatFrame, type)
	local editBox = ChatFrame_OpenChat("");
	editBox:SetAttribute("chatType", type);
	VerisimilarGM:ChatEdit_UpdateHeader(editBox);
end

function VerisimilarGM:FCF_MaximizeFrame(chatFrame)

end

function VerisimilarGM:SetChatWindowShown(frameId)

end

function VerisimilarGM:FCF_StopAlertFlash(chatFrame)

end

function VerisimilarGM:FloatingChatFrame_OnLoad(chatFrame)

end

function VerisimilarGM:FCF_MinimizeFrame(chatFrame, buttonSide)

end

function VerisimilarGM:FCF_SavePositionAndDimensions(chatFrame)

end

function VerisimilarGM:FCFClickAnywhereButton_OnLoad(self)

end

function VerisimilarGM:FCFClickAnywhereButton_OnEvent(self, event, ...)

end

function VerisimilarGM:ChatEdit_SetLastActiveWindow(editBox)

end
