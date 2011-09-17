local helpTopics;

function helptest()
	VerisimilarPl:ShowHelpWindow(VerisimilarPl.helpTopics);
end

function VerisimilarPl:ShowHelpWindow(topics)
	helpTopics = topics;
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
		if(helpTopics[i].expanded)then
			numEntries=numEntries+#helpTopics[i];
		end
	end

	local numButtons = #buttons;

	FauxScrollFrame_Update(VHelpFrame.topicList.list, numEntries, numButtons, buttons[1]:GetHeight());

	--if ( selection ) then
		OptionsList_ClearSelection(VHelpFrame.topicList, VHelpFrame.topicList.buttons);
	--end

	local j=1;
	local chapter=1;
	local paragraph=0;
	while (offset>0)do
		if(helpTopics[chapter].expanded and paragraph<=#helpTopics[chapter])then
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

			if ( selection ) and ( selection == entry ) and ( not VHelpFrame.topicList.selection ) then
				OptionsList_SelectButton(VHelpFrame.topicList, buttons[i]);
			end
			if(helpTopics[chapter].expanded and paragraph<#helpTopics[chapter])then
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
end

function VerisimilarPl:GetActiveTopic()

end

function VerisimilarPl:UpdateTopicListButton(button, entry)
	button:Show();
	button.entry = entry;
	local filter=VHelpFrame.topicFilter:GetText();
	if (#entry==0) then
		--if(filter~="" and self:FilterElement(entry.entry,filter))then
		--	button:SetNormalFontObject(GameFontGreenSmall);
		--else
			button:SetNormalFontObject(GameFontNormalSmall);
		--end
		button:SetHighlightFontObject(GameFontHighlightSmall);
		button.text:SetPoint("LEFT", 16, 2);
	else
		button:SetNormalFontObject(GameFontNormal);
		button:SetHighlightFontObject(GameFontHighlight);
		button.text:SetPoint("LEFT", 8, 2);
	end
	button.text:SetText(entry.title);

	if (#entry>0) then
		if (not entry.expanded) then
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
	entry.expanded=not entry.expanded;
	VerisimilarPl:UpdateTopicList()
end

function VerisimilarPl:TopicFilterTextChanged(editbox)

end

function VerisimilarPl:TopicClicked(panelButton,mouseButton)
	VHelpFrame.textPanel.text:SetText(panelButton.entry.text)
end
