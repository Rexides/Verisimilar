local dewdrop = AceLibrary("Dewdrop-2.0")

function VerisimilarPl:InitializeInterface()
	VerisimilarMinimapButton.openDefault=self.db.char.MMBOpenDefault;
	VerisimilarPl:ScheduleRepeatingTimer("UpdateInterface", 3);
	VerisimilarPl:InitializeSessionPanel();
	VerisimilarPl:InitializeEnvironmentPanel();
	VerisimilarPl:InitializeQuestPanel();
	VerisimilarPl:InitializeInventoryPanel();
	VerisimilarPl:TabButtonHandler("Session");
end


function VerisimilarPl:ToggleMainWindow()
	if VPlMainFrame:IsShown() then
		VPlMainFrame:Hide();
		dewdrop:Close()
	else
		VPlMainFrame:Show();
	end
end

function VerisimilarPl:UpdateInterface()
	if(VPlMainFrameSessionPage:IsVisible())then
		VerisimilarPl:RefreshSessionList();
	elseif(VPlMainFrameEnvironmentPage:IsVisible())then
		VerisimilarPl:RefreshEnviromentList();
	elseif(VPlMainFrameQuestPage:IsVisible())then
		VerisimilarPl:RefreshQuestList();
	elseif(VPlMainFrameInventoryPage:IsVisible())then
		--VerisimilarPl:InventoryUpdated();
	end
end

function VerisimilarPl:TabButtonHandler(tab)
	PanelTemplates_SetNumTabs(VPlMainFrame, 5); --I have NO idea... It won't work otherwise. For some reason the .numTabs is lost on the way.
	if(tab=="Session")then
		PanelTemplates_SetTab(VPlMainFrame, 1);  
		VPlMainFrameSessionPage:Show();  
		VPlMainFrameEnvironmentPage:Hide();  
		VPlMainFrameInventoryPage:Hide(); 
		VPlMainFrameQuestPage:Hide(); 
		VPlMainFrameUnused2Page:Hide(); 
	elseif(tab=="Environment")then
		PanelTemplates_SetTab(VPlMainFrame, 2);
		VPlMainFrameSessionPage:Hide(); 
		VPlMainFrameEnvironmentPage:Show();  
		VPlMainFrameInventoryPage:Hide(); 
		VPlMainFrameQuestPage:Hide(); 
		VPlMainFrameUnused2Page:Hide(); 
	elseif(tab=="Inventory")then
		PanelTemplates_SetTab(VPlMainFrame, 3);  
		VPlMainFrameSessionPage:Hide(); 
		VPlMainFrameEnvironmentPage:Hide(); 
		VPlMainFrameInventoryPage:Show();
		VPlMainFrameQuestPage:Hide(); 
		VPlMainFrameUnused2Page:Hide(); 
	elseif(tab=="Quests")then
		PanelTemplates_SetTab(VPlMainFrame, 4);
		VPlMainFrameSessionPage:Hide(); 
		VPlMainFrameEnvironmentPage:Hide(); 
		VPlMainFrameInventoryPage:Hide(); 
		VPlMainFrameQuestPage:Show();
		VPlMainFrameUnused2Page:Hide(); 
	elseif(tab=="Unused2")then
		PanelTemplates_SetTab(VPlMainFrame, 5);
		VPlMainFrameSessionPage:Hide(); 
		VPlMainFrameEnvironmentPage:Hide(); 
		VPlMainFrameInventoryPage:Hide(); 
		VPlMainFrameQuestPage:Hide();
		VPlMainFrameUnused2Page:Show();
	end
	VerisimilarPl:UpdateInterface();
end