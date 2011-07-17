VerisimilarPl.regionTypes={"Entire zone","Subzone","Circle","Rectangle"}

VerisimilarPl.eventList={"Kill","Area","Item","Script"};
VerisimilarPl.itemQuality={"Poor","Common","Uncommon","Rare","Epic","Legendary","Artifact"}
VerisimilarPl.qualityColor={Poor={r=0.6,g=0.6,b=0.6}, Common={r=1,g=1,b=1}, Uncommon={r=0.1,g=1,b=0}, Rare={r=0,g=0.4,b=0.86}, Epic={r=0.63,g=0.21,b=0.93}, Legendary={r=1,g=0.5,b=0}, Artifact={r=0.9,g=0.8,b=0.5}}
VerisimilarPl.documentMaterials={"Parchment","Bronze","Marble","Silver","Stone","Valentine"}

VerisimilarPl.forbiddenCharacters={strchar(1),strchar(2),strchar(10),"%%",strchar(124),strchar(128)}
local nf=#VerisimilarPl.forbiddenCharacters;
for i=1,nf do
	tinsert(VerisimilarPl.forbiddenCharacters,strchar(strbyte(VerisimilarPl.forbiddenCharacters[i])+127))
end
VerisimilarPl.forbiddenCharacterCodes={}
for i=1,#VerisimilarPl.forbiddenCharacters do
	tinsert(VerisimilarPl.forbiddenCharacterCodes,strchar(1)..strchar(100+i))
end

for i=129,255 do
	tinsert(VerisimilarPl.forbiddenCharacters,strchar(i))
	tinsert(VerisimilarPl.forbiddenCharacterCodes,strchar(2)..strchar(i-127))
end

VerisimilarPl.CommunicationMessages={
"QUERY_SESSIONS", --PL asks GM for his session list !!!DO NOT CHANGE ORDER!!! 
"SESSION_LIST",	--GM sends PL his session list !!!DO NOT CHANGE ORDER!!! 
"CONNECTION_REQUEST", --PL asks GM to connect to a session !!!DO NOT CHANGE ORDER!!! 
"CONNECTION_ACCEPTED", --GM informs PL that he is connected !!!DO NOT CHANGE ORDER!!! 
"CONNECTION_DENIED_WRONG_PASSWORD", --GM informs PL that his password was incorrect !!!DO NOT CHANGE ORDER!!! 
"CONNECTION_DENIED_WRONG_VERSION", --GM informs PL that they run different script versions !!!DO NOT CHANGE ORDER!!! 
"DISCONNECT", --PL informs GM that he has disconnected from the session.
"KICK", --GM informs PL that he was kicked off the session
"ENABLE", --GM sends the PL a list of elements (with their versions) to enable (one string)
"DISABLE", --GM tells the PL to disable a list of elements (if no list, then session was disabled, disable all).
"CACHED_STUBS", --PL tells the GM what elements he has cached, and their versions (On connect only) (one string, every three characters the first one is the element netid, and the other two it's version
"STUBS", --GM sends the PL the required elements
"CONCURRENT", --Pl tells the GM that they are running the same versions of elements
"PLAYER_INFO", --Pl sends GM his info (name, zone, level etc)
"TEXT_MESSAGE", --GM sends the player a text message
"ERROR_MESSAGE", --GM sends an error message to the player
"ITEM_AMOUNT", --GM sends the player the amount of an item that he has
"DESTROY_ITEM", --Pl tells GM to destroy one of his items
"GIVE_ITEM_TO_OTHER_PLAYER", --Pl tells GM to give an item to another player
"ITEM_USED", --PL tells GM that he used an item
"COOLDOWN", --GM tells PL that an item enters cooldown
"QUEST_AVAILABILITY", --GM tells the player whether a quest is available to him or not
"QUEST_ACCEPTED", --Pl tells GM that he accepted a quest
"OFFER_QUEST", --GM offers a quest to the Player (through the auto-quest system)
"RESET_QUEST", --GM tells the player to reset a quest in pre-accept state (both finished and ongoing quests)
"ABANDON_QUEST", --Player tells GM that he abandoned a quest
"TURN_IN_QUEST", --player tells GM that he wants to turn in a quest
"OBJECTIVE_UPDATED", --GM tells Pl that an objective value has changed
"QUEST_PROGRESS", --GM gives Pl notification for autoquest completion
"QUEST_COMPLETED", --GM tells player that the quest was completed
"EVENT_GAINED_ITEM", --Pl tells GM that he gained (or lost) a WoW item
"EVENT_MOB_KILLED", --Pl tells GM that he killed a mob
"EVENT_SUBZONE", --Pl tells GM that he entered a subzone
"NPC_SAY", --GM tells Pl that an npc said something
"NPC_EMOTE", --GM tells Pl that an npc emoted something
"NPC_YELL", --GM tells Pl that an npc yelled something
"NPC_DEFAULT_GOSSIP", --GM sends the Pl the default gossip for an npc
"GOSSIP_OPTION", --Pl tells the GM that he clicked a gossip option
"NPC_GOSSIP", --GM sends Pl gossip for an NPC
"NPC_EXISTENCE", --GM tells Pl whether an NPC exists for him or not
"LOOT_LIST", --GM sends the Pl a list of the loot a mob dropped
"LOOT_ITEM", --Pl tells the GM that he is looting an item
"CLEAR_LOOT", --GM tells Pl to remove a particular drop from the loot list of a mob
"PLAYER_SAYING", --Pl sends the GM something he said or emoted within hearing range of an NPC
"PLAYER_CHANGES_AREA", --Pl tells the GM that the player has left or entered an area
};

VerisimilarPl.ErrorMessages={
"Invalid target",
"You can't loot any more of this item",
}