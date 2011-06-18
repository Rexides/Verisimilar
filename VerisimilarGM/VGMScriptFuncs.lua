VerisimilarGM.ScriptFuncs={}

function VerisimilarGM:InitializeScript(Script)
	Script.enabled=false
	Script.scriptText="function()\n \nend"
	Script.script=nil
	Script.eventScriptText="function(player,event,parameter,arg1,arg2,arg3)\n \nend"
	Script.eventScript=nil
	Script.period=0
end


function VerisimilarGM:AssignScriptFuncs(Script)

	for methodName,method in pairs(VerisimilarGM.CommonFuncs)do
		Script[methodName]=method;
	end
	
	for methodName,method in pairs(VerisimilarGM.ScriptFuncs)do
		Script[methodName]=method;
	end
	
	Script:SetScript(Script:GetScript());
	if(Script:IsEnabled())then
		Script:Enable();
	end
end

function VerisimilarGM.ScriptFuncs:Enable()
	self.enabled=true;
	--self:SendStub();
	if(self.period>0)then
		self.timer=VerisimilarGM:ScheduleRepeatingTimer("PeriodicScriptExecution",self.period,self)
	end
end

function VerisimilarGM:PeriodicScriptExecution(Script)
	Script:Run()
end

function VerisimilarGM.ScriptFuncs:Disable()
	self.enabled=false;
	--self:ClearStub()
	if(self.timer)then
		VerisimilarGM:CancelTimer(self.timer)
		self.timer=nil
	end
end

function VerisimilarGM.ScriptFuncs:GetScript()
	return self.scriptText;
end

function VerisimilarGM.ScriptFuncs:GetPeriod()
	return self.period;
end

function VerisimilarGM.ScriptFuncs:SetPeriod(secsString)
	self.period=tonumber(secsString) or 0;
end


function VerisimilarGM.ScriptFuncs:SetScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.scriptText=scriptText;
	self.script=func();
	setfenv(self.script,self:GetSession().env);
end

function VerisimilarGM.ScriptFuncs:Run(...)
	if(self:IsEnabled() and self:GetSession():IsEnabled())then
		return self.script(...);
	end
end

function VerisimilarGM.ScriptFuncs:RunDelayed(delay,...)
	if(self:IsEnabled() and self:GetSession():IsEnabled())then
		if(delay==nil)then delay=0 end
		args=...
		VerisimilarGM:ScheduleTimer(function()
										self.script(args);
									end, delay);
	end
end

function VerisimilarGM.ScriptFuncs:GetEventScript()
	return self.eventScriptText;
end

function VerisimilarGM.ScriptFuncs:SetEventScript(scriptText)
	local func,message=loadstring("return "..scriptText);
	assert(func~=nil,message);
	self.eventScriptText=scriptText;
	self.eventScript=func();
	setfenv(self.eventScript,self:GetSession().env);
end

function VerisimilarGM.ScriptFuncs:Event(player,event,parameter,arg1,arg2,arg3)
	if(self.eventScript)then
		self.eventScript(player,event,parameter,arg1,arg2,arg3);
	end
end

