local sessionPanel;
local GetChannel,SetChannel,GetPlayerInfo,KickPlayers,GetPlayers,GetScriptsMenu,AddScript,RemoveScript,RunScriptWithParameters,SetScriptName, GetScriptName,RunScript,GetScripts,GetScriptInfo,SetScriptText, GetScriptText,SetScriptPeriod, GetScriptPeriod
function VerisimilarGM:InitializeSessionPanel()
	StaticPopupDialogs["VERISIMILAR_NEW_SESSION"] = {
		text = "Enter the session name. There is a 60 character limit. Players who wish to connect to your session will see this name.",
		button1 = "Create",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self)
			local session=VerisimilarGM:NewSession(self.editBox:GetText());
			if(session)then
				VerisimilarGM:AddElementToElementList(session);
				VerisimilarGM:SetPanelToElement(session);
				VerisimilarGM:UpdateElementList();
			end
		end,
		OnHide = function(self)
					self.editBox:SetText("")
				end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_DELETE_SESSION"] = {
		text = "Delete session %s?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function(self,data)
			VerisimilarGM:DeleteSession(data);
			VerisimilarGM:RemoveElementFromElementList(data);
			VerisimilarGM:SetPanelToElement();
			VerisimilarGM:UpdateElementList();
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_DELETE_ELEMENT"] = {
		text = "Delete %s?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function(self,data)
			data:GetSession():DeleteElement(data);
			VerisimilarGM:RemoveElementFromElementList(data);
			VerisimilarGM:SetPanelToElement();
			VerisimilarGM:UpdateElementList();
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_KICK_PLAYER"] = {
		text = "Kick selected player(s)",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function(self,data,data2)
			local players=data2;
			local session=data;
			
			for i=1,#players do
				session:KickPlayer(players[i]);
			end
		end,
		
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	StaticPopupDialogs["VERISIMILAR_RUN_SCRIPT_WITH_PARAMETERS"] = {
		text = "Run the serected scripts with the given parameters. Separate muliple paremeters using commas (,)",
		button1 = "Run",
		button2 = "Cancel",
		hasEditBox = true,
		OnAccept = function(self,data,data2)
			local indices=data2;
			local session=data;
			local input=loadstring("return "..self.editBox:GetText())
			setfenv(input,session.env)
			for i=1,#indices do
				session.scripts[indices[i]].func(input());
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
						{text="Players",showOnEnabled=true,showOnDisabled=true,
							{type="List", key="playerList",x=10,y=-25,width=300,height=300,showOfflineControls=true,updateFunc=GetPlayers,infoFunc=GetPlayerInfo,columns={
																																	{label="Name",width=50},
																																	{label="Zone"},
																																	{label="Status",width=60},
																																},
							},
							{type="Button", key="kickPlayer",label="Kick Player(s)",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=5,y=-10, clickFunc=KickPlayers ,tooltip="Removes the selected players and all their data from the session"},
							{type="CheckButton", key="local",label="Session is local",x=330,y=-25,width=100, clickFunc=function(button,state)VerisimilarGM:GetActiveElement():SetLocal(state);end,checkFunc=function() return VerisimilarGM:GetActiveElement():GetLocal();end,tooltip="As long as this option is checked, no player other than you may connect to the session. Use it when creating the session in order to prevent others from joining, and disable when ready."},
							{type="EditBox", key="password",label="Password",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=0,y=-25,width=135,setFunc=function(editBox,password)VerisimilarGM:GetActiveElement():SetPassword(password);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetPassword(); end,tooltip="Players who attempt to connect to this session will be asked to enter this password."},
						},
						{text="Configure",showOnEnabled=false,showOnDisabled=true,
							{type="Container", key="channelsContainer",label="Communication channel",x=10,y=-15,width=150,height=175, tooltip="Optimize the session for your intented group of players. Players who don't belong in the selected group (your raid or guild) won't be able to connect. 'Whisper' is the most unoptimized choice, 'xtensionxtooltip' is the most inclusive optimized choice, and you also have the option to set your own channel",
								{type="RadioButtons", key="channel",buttonLabels={"Whisper","Guild","Raid","xtensionxtooltip2","Custom"},x=15,y=-15,setFunc=SetChannel,getFunc=GetChannel},
								{type="EditBox", key="customChannel",refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=25,y=-5,width=100,setFunc=function(editBox,channel)print(VerisimilarGM:GetActiveElement().name);VerisimilarGM:GetActiveElement():SetChannel(channel);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetChannel(); end},
							},
							{type="LargeEditBox", key="welcomeMessage",label="Welcome message",x=175,y=-15,width=400,height=200,setFunc=function(editBox,message)VerisimilarGM:GetActiveElement():SetWelcomeMessage(message);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetWelcomeMessage(); end},
						},
						{text="Advanced",showOnEnabled=false,showOnDisabled=true,
							{type="LargeEditBox", key="newPlayerScript",label="New Player Script",x=25,y=-15,width=400,height=200,setFunc=function(editBox,script)VerisimilarGM:GetActiveElement():SetNewPlayerScript(script);end, getFunc=function() return VerisimilarGM:GetActiveElement():GetNewPlayerScript(); end},
						
						},
						{text="Custom Scripts",showOnEnabled=false,showOnDisabled=true,
							{type="DropDown", key="script",label="Script:",x=45,y=-5, width=200,labelPosition="LEFT", menuFunc=GetScriptsMenu, tooltip="Select one of custom scripts to edit"},
							{type="Button", key="addScript",label="Add Script",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=AddScript ,tooltip="Add a new custom script to your session"},
							{type="Button", key="removeScript",label="Remove Script",refFrame="PREVIOUS",refPoint="TOPRIGHT",x=10,y=0, clickFunc=RemoveScript ,tooltip="Remove the currently selected script from your session"},
							{type="EditBox", key="scriptName",label="Name:",x=55,y=-40,width=200,labelPosition="LEFT",setFunc=SetScriptName, getFunc=GetScriptName,tooltip="The script name, by which you can call it within your scripts"},
							{type="EditBox", key="scriptPeriod",label="Period:",x=100,y=0,width=50,labelPosition="LEFT",numeric=true,refFrame="PREVIOUS",refPoint="TOPRIGHT",setFunc=SetScriptPeriod, getFunc=GetScriptPeriod,tooltip="If you want the script to be executed periodically, enter the number of seconds between executions"},
							{type="LargeEditBox", key="scriptText",label="Script:",x=25,y=-100,width=650,height=400,setFunc=SetScriptText, getFunc=GetScriptText,},
						},
						{text="Run Scripts",showOnEnabled=true,showOnDisabled=false,
							{type="List", key="scriptList",x=10,y=-25,width=250,height=300,showOfflineControls=false,updateFunc=GetScripts,infoFunc=GetScriptInfo,columns={
																																	{label="Name",width=150},
																																	{label="Period"},
																																},
							},
							{type="Button", key="runScript",label="Run script",width=200,refFrame="PREVIOUS",refPoint="TOPRIGHT",x=20,y=0, clickFunc=RunScript ,tooltip="Execute the selected scripts"},
							{type="Button", key="runScriptWithParameters",label="Run script with parameters",width=200,refFrame="PREVIOUS",refPoint="BOTTOMLEFT",x=-0,y=-150, clickFunc=RunScriptWithParameters ,tooltip="Execute the selected scripts with parameters"},
						}
					};
	sessionPanel=self:CreateElementPanel("Session",description)
end

local buttonToChannel={"WHISPER","GUILD","RAID","xtensionxtooltip2"};
GetChannel=function()
	local channel=VerisimilarGM:GetActiveElement():GetChannel();
	for i=1,#buttonToChannel do
		if(channel==buttonToChannel[i])then
			sessionPanel.controls.customChannel:Hide()
			return i;
		end
	end
	sessionPanel.controls.customChannel:Show();
	return #buttonToChannel+1;
end

SetChannel=function(button,i)
	VerisimilarGM:GetActiveElement():SetChannel(buttonToChannel[i] or sessionPanel.controls.customChannel:GetText());
end

GetWelcomeMessage=function()
	return VerisimilarGM:GetActiveElement():GetWelcomeMessage();
end

SetWelcomeMessage=function(message)
	VerisimilarGM:GetActiveElement():SetWelcomeMessage(message);
end

KickPlayers=function(button)
	local players=button.elementPanel.controls.playerList:GetSelectedEntries();
	
	local dialog = StaticPopup_Show("VERISIMILAR_KICK_PLAYER");
	if (dialog) then
		dialog.data  = VerisimilarGM:GetActiveSession();
		dialog.data2 = players;
	end
end

GetPlayers=function(list,showOffline)
	local session=VerisimilarGM:GetActiveElement();
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

GetPlayerInfo=function(player)
	return player.name,player.zone,(player.connected and "Connected") or "Disconnected";
end

local function ScriptClicked(button,scriptNum)
	local controls=sessionPanel.controls;
	local session=VerisimilarGM:GetActiveElement();

	controls.scriptName:Hide();
	controls.scriptPeriod:Hide();
	controls.scriptText:Hide();
	
	controls.script.selection=scriptNum;

	if(scriptNum)then
		controls.scriptName:Show();
		controls.scriptPeriod:Show();
		controls.scriptText:Show();
	end
	VerisimilarGM:UpdateInterface();
end

GetScriptsMenu=function(ddList)
	local session=VerisimilarGM:GetActiveElement();
	local menu={};
	for i=1,session:GetNumScripts() do
		tinsert(menu,{text=""..i.." - "..session:GetScriptName(i),checked=ddList.selection==i,func=ScriptClicked,arg1=i});
	end
	menu.func=ScriptClicked;
	return menu;
end

AddScript=function(button)
	local session=VerisimilarGM:GetActiveElement();
	session:AddScript();
	ScriptClicked(nil,session:GetNumScripts())
	VerisimilarGM:UpdateInterface()
end

RemoveScript=function(button)
	local scriptDD=sessionPanel.controls.script;
	local session=VerisimilarGM:GetActiveElement();
	if(scriptDD.selection)then
		session:RemoveScript(scriptDD.selection);
	end
	ScriptClicked(nil,((#session:GetNumScripts()>0) and 1) or nil)
	VerisimilarGM:UpdateInterface()
end

SetScriptName=function(editBox,text)
	local scriptDD=sessionPanel.controls.script;
	local script=VerisimilarGM:GetActiveElement();
	if(scriptDD.selection)then
		script:SetScriptName(scriptDD.selection,text)
	end
end

GetScriptName=function(editBox)
	local scriptDD=sessionPanel.controls.script;
	local script=VerisimilarGM:GetActiveElement();
	if(scriptDD.selection)then
		return script:GetScriptName(scriptDD.selection)
	end
end

SetScriptPeriod=function(editBox,period)
	local scriptDD=sessionPanel.controls.script;
	local script=VerisimilarGM:GetActiveElement();
	if(scriptDD.selection)then
		script:SetScriptPeriod(scriptDD.selection,period)
	end
end

GetScriptPeriod=function(editBox)
	local scriptDD=sessionPanel.controls.script;
	local script=VerisimilarGM:GetActiveElement();
	if(scriptDD.selection)then
		return script:GetScriptPeriod(scriptDD.selection)
	end
end

SetScriptText=function(editBox,text)
	local scriptDD=sessionPanel.controls.script;
	local script=VerisimilarGM:GetActiveElement();
	if(scriptDD.selection)then
		script:SetScriptText(scriptDD.selection,text)
	end
end

GetScriptText=function(editBox)
	local scriptDD=sessionPanel.controls.script;
	local script=VerisimilarGM:GetActiveElement();
	if(scriptDD.selection)then
		return script:GetScriptText(scriptDD.selection)
	end
end

GetScripts=function(list)
	local session=VerisimilarGM:GetActiveElement();
		
	for i=1,session:GetNumScripts() do
		list:Insert(i,true);
	end
end

GetScriptInfo=function(index)
	local session=VerisimilarGM:GetActiveElement();
	return session:GetScriptName(index),session:GetScriptPeriod(index);
end

RunScript=function(button)
	local indices=sessionPanel.controls.scriptList:GetSelectedEntries();
	local session=VerisimilarGM:GetActiveElement();
	
	for i=1,#indices do
		session.scripts[indices[i]].func();
	end
end

RunScriptWithParameters=function(button)
	local indices=sessionPanel.controls.scriptList:GetSelectedEntries();
	
	local dialog = StaticPopup_Show("VERISIMILAR_RUN_SCRIPT_WITH_PARAMETERS");
	if (dialog) then
		dialog.data  = VerisimilarGM:GetActiveSession();
		dialog.data2 = indices;
	end
end

function VerisimilarGM:SetPanelToSession()
	local session=VGMMainFrame.controlPanel.element;
	VGMMainFrame.controlPanel.title:SetText(session.name);
	VGMMainFrame.controlPanel.panels.Session:Show();
end


