
					
local MC={} --Message to code
local CM={} --Code to message

for i=1,#VerisimilarPl.CommunicationMessages do
	MC[VerisimilarPl.CommunicationMessages[i]]=strchar(i);
	CM[strchar(i)]=VerisimilarPl.CommunicationMessages[i];
end

local pendingConnectionRequests={}
local CONNECTION_RETRY_INTERVAL_SECS=10
local CONNECTION_RETRY_ATTEMPTS=3

function VerisimilarPl:OnCommReceived(prefix,messageString,channel,sender)
	local inboundQue={VerisimilarPl:Deserialize(messageString)}
	if(not inboundQue[1])then return end
	self:Print("Got messages:")
	for i=2,#inboundQue,2 do
		local header=inboundQue[i];
		local data=inboundQue[i+1];
		local message=CM[strsub(header,1,1)]
		
		if(message and self[message])then
			
			self:Print(i/2,":",message)
			if(message=="STUBS")then
				for j=1,#data do
					self:Print("name:",data[j].n or data[j].tl)
				end
			end
			
			local session=self.sessions[sender.."_"..strsub(header,2,2)]
			if(not session)then
				self[message](self,sender,data)
			else
				if(session.connected)then
					local stub=session.stubs[strsub(header,3,3)]
					if(not stub)then
						self[message](self,session,data)
					else
						self[message](self,stub,data)
					end
				end
			end
		end
	end
end

function VerisimilarPl:SendSessionMessage(session,stub, message,data)
	local header=MC[message]..session.id
	if(stub)then
		header=header..stub.id;
	end
	
	self:SendCommMessageWrapper(header,data, "WHISPER", session.gm);
end

function VerisimilarPl:SendMessage(recipient,message,data)
	local header=MC[message];
	local serialized=self:Serialize(header,data);
	if(recipient)then
		self:SendCommMessageWrapper(header,data, "WHISPER", recipient);
	else
		self:SendCommMessageWrapper(header,data, "RAID");
		self:SendCommMessageWrapper(header,data, "GUILD");
		--Also send it to xtensiontooltip here
	end
end

local outgoingQue={BULK={},NORMAL={},ALERT={}};

local outgoingQueTimer=nil;

function VerisimilarPl:SendCommMessageWrapper(header,data,channel,recipient,priority)
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

function VerisimilarPl:ProcessOutgoingQue()
	for _, priority in pairs({"ALERT","NORMAL","BULK"})do
		for recipient, data in pairs(outgoingQue[priority])do
			if(type(recipient)~="number")then
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

function VerisimilarPl:CommUpkeep(timeSince)
	
	--Connections
	for gm,sessions in pairs(pendingConnectionRequests)do
		for SessionNetID, connection in pairs(sessions)do
			connection.timeToRetry=connection.timeToRetry-timeSince;
			if(connection.timeToRetry<0)then
				if(connection.attemptsLeft>0)then
					self:SendMessage(gm,"CONNECTION_REQUEST",{id=SessionNetID,v=self.scriptVersion,p=connection.session.password});
					connection.attemptsLeft=connection.attemptsLeft-1;
				else
					self:Print(gm.." did not respond to the connection request")
					pendingConnectionRequests[gm][SessionNetID]=nil
				end
			end
		end
	end
end

local messageBuffer={}
function VerisimilarPl:ChannelMessageRecieved(event,text,sender,arg3,arg4,arg5,arg6,arg7,arg8,channel)
	local prefixLen=strlen(VerisimilarPrefix);
	if(VerisimilarPrefix==strsub(text,1,prefixLen))then
		local chunk=strsub(text,prefixLen+2);
		local chunkControlChar=strsub(text,prefixLen+1,prefixLen+1);
		local bufferID=sender.."_"..channel.."_"..strlower(chunkControlChar);
		if(not messageBuffer[bufferID])then
			messageBuffer[bufferID]="";
		end
		messageBuffer[bufferID]=messageBuffer[bufferID]..chunk;
		if(chunkControlChar=="N" or chunkControlChar=="B" or chunkControlChar=="A")then
			self:OnCommReceived(VerisimilarPrefix,self:DecodeTextFromCustomChannel(messageBuffer[bufferID]),channel,sender);
			messageBuffer[bufferID]=nil;
		end
	end
end

local forbidden=VerisimilarPl.forbiddenCharacters;
local codes=VerisimilarPl.forbiddenCharacterCodes;
local paternForbidden={["^"]=true,["$"]=true,["("]=true,[")"]=true,["%"]=true,["."]=true,["["]=true,["]"]=true,["*"]=true,["+"]=true,["-"]=true,["?"]=true}

function VerisimilarPl:DecodeTextFromCustomChannel(text)
	for i=#forbidden,1,-1 do
		local escape="";
		local firstChar=strsub(codes[i],1,1)
		local secondChar=strsub(codes[i],2,2)
		if(paternForbidden[secondChar])then
			escape="%";
		end
		
		text=gsub(text,firstChar..escape..secondChar,forbidden[i],nil,true);

	end
	return text
end

function VerisimilarPl:SendQueryPlayer(playername)
	self:SendMessage(playername,"QUERY_SESSIONS");
end

local channels={w="WHISPER",g="GUILD",r="RAID",x="xtensionxtooltip2"}
function VerisimilarPl:SESSION_LIST(gm,list)
	for i=1,#list do
		list[i].gm=gm;
		VerisimilarPl:AddSession(list[i]);
	end
end

function VerisimilarPl:SendConnectRequest(session)
	if(session.connected)then
		return
	end
	if(pendingConnectionRequests[session.gm]==nil)then
		pendingConnectionRequests[session.gm]={}
	end
	pendingConnectionRequests[session.gm][session.id]={session=session,timeToRetry=CONNECTION_RETRY_INTERVAL_SECS,attemptsLeft=CONNECTION_RETRY_ATTEMPTS-1};
	self:SendMessage(session.gm,"CONNECTION_REQUEST",{id=session.id,v=self.scriptVersion,p=session.password});
	
end

function VerisimilarPl:CONNECTION_ACCEPTED(gm,sessionInfo)
	if(pendingConnectionRequests[gm] and pendingConnectionRequests[gm][sessionInfo.id])then
		local session=pendingConnectionRequests[gm][sessionInfo.id].session
		self:Print("Connected to session "..session.name);
		session.channel=channels[sessionInfo.c] or sessionInfo.c;
		self:ConnectToSession(session);
		pendingConnectionRequests[gm][sessionInfo.id]=nil
		self:SendCachedStubsInfo(session);
	end
end

function VerisimilarPl:CONNECTION_DENIED_WRONG_PASSWORD(gm,sessionNetID)
	if(pendingConnectionRequests[gm] and pendingConnectionRequests[gm][sessionNetID])then
		local session=pendingConnectionRequests[gm][sessionNetID].session
		self:Print("Connection to session "..session.name.." failed: Wrong password");
		pendingConnectionRequests[gm][sessionNetID]=nil
	end
end

function VerisimilarPl:CONNECTION_DENIED_WRONG_VERSION(gm,sessionNetID)
	if(pendingConnectionRequests[gm] and pendingConnectionRequests[gm][sessionNetID])then
		local session=pendingConnectionRequests[gm][sessionNetID].session
		self:Print("Connection to session "..session.name.." failed: Incompatible versions");
		pendingConnectionRequests[gm][sessionNetID]=nil
	end
end

function VerisimilarPl:SendCachedStubsInfo(session)
	
	local localID=session.gm.."_"..session.id;
	if(session.stubData==nil)then
		if(self.db.factionrealm.sessionStubsChache[localID]==nil)then
			self.db.factionrealm.sessionStubsChache[localID]={};
		end
		session.stubData=self.db.factionrealm.sessionStubsChache[localID];
	end
	local stubVersionList="";
	for id,stubData in pairs(session.stubData)do
		stubVersionList=stubVersionList..id..stubData.version;
	end
	self:SendSessionMessage(session,nil,"CACHED_STUBS",stubVersionList)
end

		
function VerisimilarPl:SendDisconnectMessage(session)
	self:Print("Disconnected from session "..session.name);
	self:DisconnectFromSession(session);
	self:SendSessionMessage(session,nil,"DISCONNECT");
end

function VerisimilarPl:ENABLE(session,enabledList)
	for i=1,#enabledList,3 do
		self:EnableStub(session,strsub(enabledList,i,i),strsub(enabledList,i+1,i+2));
	end
	
	self:CheckConcurrentness(session);
end

function VerisimilarPl:DISABLE(session,disbledList)
	if(disbledList)then
		for i=1,#disbledList do
			self:DisableStub(session.stubs[strsub(disbledList,i,i)]);
		end
	else
		if(session.stubs)then
			for _,stub in pairs(session.stubs)do
				self:DisableStub(stub);
			end
		end
	end
end

function VerisimilarPl:STUBS(session,stubList)
	for i=1,#stubList do
		self:AddStubData(session, stubList[i]);
	end
	
	self:CheckConcurrentness(session);
end

function VerisimilarPl:CheckConcurrentness(session)
	local sessionConcurrent=true;
	for id,stub in pairs(session.stubs) do
		local stubData=session.stubData[id];
		
		if(stubData and stub.enabled==true and stubData.version==stub.GMVersion)then
			setmetatable(stub,{__index=stubData}); --stub.data=stubData;
			stub.concurrent=true;
			self:InitializeStub(stub);
		else
			stub.concurrent=false;
			sessionConcurrent=false;
		end
	end
	if(sessionConcurrent)then
		self:SendSessionMessage(session,nil,"CONCURRENT");
	end
end



function VerisimilarPl:GetSaying(message,channel,sender)
	local session=self.sessions[message.sessionName];
	if(session and session.gm==sender)then
		VerisimilarPl:NPCSaying(session,message);
	end
end

function VerisimilarPl:TEXT_MESSAGE(session,text)
	self:Print("Message from session ",session.name,":")
	self:Print(self:SubSpecialChars(text));
end

function VerisimilarPl:KICK(session)
	self:Print("Kicked from ",session.name);
	self:DisconnectFromSession(session)
end

local CEM={} --Code to Error message
for i=1,#VerisimilarPl.ErrorMessages do
	CEM[strchar(i)]=VerisimilarPl.ErrorMessages[i];
end

function VerisimilarPl:ERROR_MESSAGE(session,text)
		if(not text)then return end
		
		if(CEM[text])then
			text=CEM[text];
		end
		UIErrorsFrame_OnEvent(UIErrorsFrame, "UI_ERROR_MESSAGE", text);
end
