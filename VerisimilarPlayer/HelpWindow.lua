local helpTopics;

function helptest()
	VerisimilarPl:ShowHelpWindow(VerisimilarPl.helpTopics);
end

function VerisimilarPl:ShowHelpWindow(topics)
	helpTopics = topics;
	if(helpTopics.selection == 1)then
		helpTopics.selection = helpTopics[1];
	end
	VHelpFrame.textPanel.scroll.text:SetText(helpTopics.selection.text);
	VHelpFrameTitleText:SetText(topics.title);
	VerisimilarPl:UpdateTopicList();
	VHelpFrame:Show();
end

function VerisimilarPl:UpdateTopicList()
	local offset = FauxScrollFrame_GetOffset(VHelpFrame.topicList.list);
	local buttons = VHelpFrame.topicList.buttons;
	local entry;

	local numEntries = #helpTopics;
	for i=1,#helpTopics do
		if(not helpTopics[i].collapsed)then
			numEntries=numEntries+#helpTopics[i];
		end
	end

	local numButtons = #buttons;

	FauxScrollFrame_Update(VHelpFrame.topicList.list, numEntries, numButtons, buttons[1]:GetHeight());

	OptionsList_ClearSelection(VHelpFrame.topicList, VHelpFrame.topicList.buttons);

	local j=1;
	local chapter=1;
	local paragraph=0;
	while (offset>0)do
		if(not helpTopics[chapter].collapsed and paragraph<=#helpTopics[chapter])then
			paragraph = paragraph+1;
		else
			chapter = chapter+1;
			paragraph=0;
		end
		offset = offset-1;
	end
	for i = 1, #buttons do
		entry = helpTopics[chapter] and (paragraph and helpTopics[chapter][paragraph] or helpTopics[chapter]);
		if ( not entry ) then
			buttons[i]:Hide();
		else
			self:UpdateTopicListButton(buttons[i], entry);

			if ( helpTopics.selection ) and ( helpTopics.selection == entry ) then
				OptionsList_SelectButton(VHelpFrame.topicList, buttons[i]);
			end
			if(not helpTopics[chapter].collapsed and paragraph<#helpTopics[chapter])then
				paragraph = paragraph+1;
			else
				chapter = chapter+1;
				paragraph=0;
			end
		end

	end

	if ( selection ) then
		VHelpFrame.topicList.selection = selection;
	end
	VerisimilarPl:ManageNavButtons();
end

function VerisimilarPl:GetActiveTopic()

end

function VerisimilarPl:UpdateTopicListButton(button, entry)
	button:Show();
	button.entry = entry;
	local filter=VHelpFrame.topicFilter:GetText();
	if (#entry==0) then
		if(filter~="" and strfind(strlower(entry.text),strlower(filter)))then
			button:SetNormalFontObject(GameFontGreenSmall);
		else
			button:SetNormalFontObject(GameFontNormalSmall);
		end
		button:SetHighlightFontObject(GameFontHighlightSmall);
		button.text:SetPoint("LEFT", 16, 2);
	else
		if(filter~="" and strfind(strlower(entry.text),strlower(filter)))then
			button:SetNormalFontObject(GameFontGreen);
		else
			button:SetNormalFontObject(GameFontNormal);
		end
		button:SetHighlightFontObject(GameFontHighlight);
		button.text:SetPoint("LEFT", 8, 2);
	end
	button.text:SetText(entry.title);

	if (#entry>0) then
		if (entry.collapsed) then
			button.toggle:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP");
			button.toggle:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN");
		else
			button.toggle:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-UP");
			button.toggle:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-DOWN");
		end
		button.toggle:Show();
	else
		button.toggle:Hide();
	end
end

function VerisimilarPl:ToggleTopicListEntry(entry)
	entry.collapsed=not entry.collapsed;
	VerisimilarPl:UpdateTopicList();
end

function VerisimilarPl:TopicFilterTextChanged(editbox)
	VerisimilarPl:UpdateTopicList();
end

function VerisimilarPl:ManageNavButtons()
	if(helpTopics[#helpTopics][#helpTopics[#helpTopics]] == helpTopics.selection)then
		VHelpFrame.nextButton:Disable();
	else
		VHelpFrame.nextButton:Enable();
	end
	if(helpTopics[1] == helpTopics.selection or helpTopics.selection == nil)then
		VHelpFrame.prevButton:Disable();
	else
		VHelpFrame.prevButton:Enable();
	end
end

function VerisimilarPl:TopicClicked(panelButton,mouseButton)
	VHelpFrame.textPanel.scroll.text:SetText(panelButton.entry.text);
	helpTopics.selection = panelButton.entry;
	OptionsList_ClearSelection(VHelpFrame.topicList, VHelpFrame.topicList.buttons);
	OptionsList_SelectButton(VHelpFrame.topicList, panelButton);
	VerisimilarPl:ManageNavButtons();
end

function VerisimilarPl:PreviousHelpTopic()
	local previous;
	local found;
	for i=1, #helpTopics do
		if(helpTopics[i] == helpTopics.selection or found)then
			break;
		end
		previous = helpTopics[i];
		for j=1, #helpTopics[i] do
			if(helpTopics[i][j] == helpTopics.selection)then
				found = true; 
				break;
			end
			previous = helpTopics[i][j];
		end
	end
	helpTopics.selection = previous;
	VHelpFrame.textPanel.scroll.text:SetText(previous.text);
	self:UpdateTopicList();
	
end

function VerisimilarPl:NextHelpTopic()
	local previous;
	local found;
	for i=1, #helpTopics do
		if(previous == helpTopics.selection)then
			if (not found)then
				found = helpTopics[i];
			end
			break;
		end
		previous = helpTopics[i];
		for j=1, #helpTopics[i] do
			if(previous == helpTopics.selection)then
				found = helpTopics[i][j]; 
				break;
			end
			previous = helpTopics[i][j];
		end
	end
	helpTopics.selection = found;
	VHelpFrame.textPanel.scroll.text:SetText(found.text);
	self:UpdateTopicList();
end
