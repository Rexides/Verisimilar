--Get perfix on function names means that it was called in response to a network message
--Send perfix means that it was called by the local user or the local addon


local SessionsPerNetID={};
local ElementsPerSessionPerNetID={};

local MC={} --Message to code
local CM={} --Code to message

for i=1,#VerisimilarPl.CommunicationMessages do
	MC[VerisimilarPl.CommunicationMessages[i] ]=strchar(i);
	CM[strchar(i)]=VerisimilarPl.CommunicationMessages[i];
end


function VerisimilarGM:OnCommReceived(prefix,messageString,channel,sender)
	local inboundQue={VerisimilarPl:Deserialize(messageString)}
	if(not inboundQue[1])then return end
	for i=2,#inboundQue,2 do
		local header=inboundQue[i];
		local data=inboundQue[i+1];
		local message=CM[strsub(header,1,1)]
		local session=SessionsPerNetID[strsub(header,2,2)]

		if(message)then
			if(not VerisimilarPl[message])then
				VerisimilarPl:PrintDebug("GM got message: ",i/2,message,data);
			end
			if(not session)then
				if(self[message])then
					self[message](self,sender,data)
				end
			else
				if(session.players[sender])then
					local element=ElementsPerSessionPerNetID[session.netID][strsub(header,3,3)];
					if(not element)then
						if(session[message])then
							session[message](session,session.players[sender],data);
						end
					else
						if(element[message] and element:IsEnabled() and element:GetSession():IsEnabled())then
							element[message](element,session.players[sender],data);
						end
					end
				end
			end
		end
	end
end


function VerisimilarGM:SendSessionMessage(player,session,element,message,data,priority)
	
	local header=MC[message]..session.netID;

	if(element)then
		if(not element:IsEnabled() or not session:IsEnabled())then
			return;
		end
		header=header..element.netID;
	end
	
	if(type(player)=="table")then
		if(player.connected)then
			self:SendCommMessageWrapper(header,data, "WHISPER", player.name,priority);
		end
	elseif(session.channel=="WHISPER")then
		local filterFunc=nil;
		if(type(player)=="function")then
			filterFunc=player;
		end
		for _,player in pairs(session.players) do
			if(player.connected and (filterFunc==nil or (filterFunc and filterFunc(player,session,element,message,data))))then
				self:SendCommMessageWrapper(header,data, "WHISPER", player.name,priority);
			end
		end
	else
		self:SendCommMessageWrapper(header,data,session.channel,nil,priority);
	end
end


function VerisimilarGM:SendMessage(recipient,message,data,priority)
	if(recipient)then
		self:SendCommMessageWrapper(MC[message],data, "WHISPER", recipient,priority);
	else
		self:SendCommMessageWrapper(MC[message],data, "RAID",nil,priority);
		self:SendCommMessageWrapper(MC[message],data, "GUILD",nil,priority);
		self:SendCommMessageWrapper(MC[message],data, "xtensionxtooltip2",nil,priority);
	end
end

local outgoingQue={BULK={},NORMAL={},ALERT={}};

local outgoingQueTimer=nil;
function VerisimilarGM:SendCommMessageWrapper(header,data,channel,recipient,priority)
	if(channel=="xtensionxtooltip2" and VerisimilarPl.db.char.xtensionxtooltip2==false)then return end
	priority=priority or "NORMAL";
	if(data==nil)then data=false end
	if(channel~="WHISPER" and channel~="GUILD" and channel~="RAID")then channel=GetChannelName(channel) end
	if(channel=="WHISPER")then channel=recipient end
	
	if(outgoingQue[priority][channel]==nil)then outgoingQue[priority][channel]={} end
		
	tinsert(outgoingQue[priority][channel],header);
	tinsert(outgoingQue[priority][channel],data);
	
	if(outgoingQueTimer==nil)then
		outgoingQueTimer=self:ScheduleTimer("ProcessOutgoingQue",0.1);
	end
end

function VerisimilarGM:ProcessOutgoingQue()
	for _, priority in pairs({"ALERT","NORMAL","BULK"})do
		for recipient, data in pairs(outgoingQue[priority])do
			if(type(recipient)~="number")then --channel=="WHISPER" or channel=="GUILD" or channel=="RAID")then
				if(recipient=="GUILD" or recipient=="RAID")then
					self:SendCommMessage(VerisimilarPrefix, self:Serialize(unpack(data)),recipient,nil,priority);
				else
					self:SendCommMessage(VerisimilarPrefix, self:Serialize(unpack(data)),"WHISPER",recipient,priority);
				end
			else
				data=self:EncodeTextForCustomChannel(self:Serialize(unpack(data)));
				local chunkSize=255-(strlen(VerisimilarPrefix)+1);
				local nChunks=ceil(strlen(data)/chunkSize);
				for i=1,nChunks do
					local controlChar=strlower(strsub(priority,1,1));
					if(i==nChunks)then
						controlChar=strupper(controlChar);
					end
					local message=VerisimilarPrefix..controlChar..strsub(data,(i-1)*chunkSize+1,i*chunkSize);
					ChatThrottleLib:SendChatMessage(priority, VerisimilarPrefix, message, "CHANNEL", nil, recipient,nil);
				end
			end
		end
		outgoingQue[priority]={}
	end
	outgoingQueTimer=nil;
end

local forbidden=VerisimilarPl.forbiddenCharacters;
local codes=VerisimilarPl.forbiddenCharacterCodes;

function VerisimilarGM:EncodeTextForCustomChannel(text)
	for i=1,#forbidden do
		text=gsub(text,forbidden[i],codes[i],nil,true);
	end
	
	return text;
end

local channels={WHISPER="w",GUILD="g",RAID="r",xtensionxtooltip2="x"}
function VerisimilarGM:QUERY_SESSIONS(querier)
	local sessionList=self.db.global.sessions;
	local list={};

	for sessionName,session in pairs(sessionList) do
		if(not session:GetLocal())then
			if(session:GetChannel()~="GUILD" and session:GetChannel()~="RAID" and session:GetChannel()~="xtensionxtooltip2")then
				tinsert(list,{n=sessionName,id=session.netID});
			end
		end
	end
	if(#list<1)then return end
	self:SendMessage(querier,"SESSION_LIST",list,"BULK");
end

function VerisimilarGM:SendSessionLists()
	local sessionList=self.db.global.sessions;
	local glist={};
	local rlist={};
	local xlist={};

	for sessionName,session in pairs(sessionList) do
		if(not session:GetLocal())then
			if(session:GetChannel()=="GUILD")then
				tinsert(glist,{n=sessionName,id=session.netID,c=channels[session:GetChannel()] or session:GetChannel()});
			elseif(session:GetChannel()=="RAID")then
				tinsert(rlist,{n=sessionName,id=session.netID,c=channels[session:GetChannel()] or session:GetChannel()});
			elseif(session:GetChannel()=="xtensionxtooltip2")then
				tinsert(xlist,{n=sessionName,id=session.netID,c=channels[session:GetChannel()] or session:GetChannel()});
			end
		end
	end
	
	if(#glist>0)then
		self:SendCommMessageWrapper(MC["SESSION_LIST"],glist, "GUILD",nil,"BULK");
	end
	if(#rlist>0)then
		self:SendCommMessageWrapper(MC["SESSION_LIST"],rlist, "RAID",nil,"BULK");
	end
	if(#xlist>0)then
		self:SendCommMessageWrapper(MC["SESSION_LIST"],xlist, "xtensionxtooltip2",nil,"BULK");
	end
end

function VerisimilarGM:CONNECTION_REQUEST(playerName,connectionInfo)
	local session=SessionsPerNetID[connectionInfo.id];
	if(session and (not session:GetLocal() or (session:GetLocal() and playerName==UnitName("player"))))then
		if(session.version==connectionInfo.v)then
			if(session.password=="" or (session.password~="" and session.password==connectionInfo.p))then
				self:SendMessage(playerName,"CONNECTION_ACCEPTED",{id=session.netID,c=channels[session:GetChannel()] or session:GetChannel()})
				session:AddPlayer(playerName);
				self:PlayerListUpdated()
			else
				self:SendMessage(playerName,"CONNECTION_DENIED_WRONG_PASSWORD",session.netID)
			end
		else
			self:SendMessage(playerName,"CONNECTION_DENIED_WRONG_VERSION",session.netID)
		end
	end
end


function VerisimilarGM:GetEvent(message,channel,sender)
	local session=VerisimilarGM.db.global.sessions[message.sessionName];
	if(session and session.players[sender])then
		session:Event(session.players[sender],message.event,message.parameter,message.arg1,message.arg2,message.arg3);
	end
end


function VerisimilarGM:RegisterSessionNetID(session)
	SessionsPerNetID[session.netID]=session
	ElementsPerSessionPerNetID[session.netID]={}
end

function VerisimilarGM:UnregisterSessionNetID(session)
	SessionsPerNetID[session.netID]=nil
	ElementsPerSessionPerNetID[session.netID]=nil
end

function VerisimilarGM:RegisterElementNetID(element,session)
	ElementsPerSessionPerNetID[session.netID][element.netID]=element
end

function VerisimilarGM:UnregisterElementNetID(element,session)
	ElementsPerSessionPerNetID[session.netID][element.netID]=nil
end


function VerisimilarGM:GenerateSessionNetID(session)
	local sessionList=VerisimilarGM.db.global.sessions;
	local id
	repeat
		id=strchar(random(255));
	until(SessionsPerNetID[id]==nil)
	session.netID=id;
	VerisimilarGM:RegisterSessionNetID(session)
end

function VerisimilarGM:GenerateElementNetID(element,session)
	local id
	repeat
		id=strchar(random(255));
	until(ElementsPerSessionPerNetID[session.netID][id]==nil)
	element.netID=id;
	VerisimilarGM:RegisterElementNetID(element,session)
end


function VerisimilarGM:PrintSessionNetID()
	local sessionList=VerisimilarGM.db.global.sessions;
	for _,s in pairs(sessionList)do
		self:Print(s.name,s.netID)
	end
end

function VerisimilarGM:PrintElementNetID(sessionName)
	local session=VerisimilarGM.db.global.sessions[sessionName];
	for __,el in pairs(session.elements)do
		self:Print(el.id,el.netID)
	end
end














