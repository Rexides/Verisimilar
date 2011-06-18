VerisimilarDemoSession = {
					["Scripts"] = {
						["completeListening"] = {
							["scriptText"] = "function(player)\n listening:Event(player,\"Script\",\"Q_listening_Obj1\")\n\n\nend",
							["enabled"] = true,
							["elType"] = "Script",
							["id"] = "completeListening",
							["period"] = 0,
							["sessionName"] = "Demo Session",
						},
					},
					["enabled"] = true,
					["Mobs"] = {
						["murloc"] = {
							["corpseList"] = {
							},
							["enabled"] = true,
							["elType"] = "Mob",
							["id"] = "murloc",
							["sessionName"] = "Demo Session",
							["name"] = "Murloc",
							["lootTable"] = {
								{
									["chance"] = 10,
									["quest"] = "murlocks",
									["item"] = "ringDummy",
									["amount"] = 1,
								}, -- [1]
							},
						},
						["cutpurse"] = {
							["corpseList"] = {
								
							},
							["enabled"] = true,
							["elType"] = "Mob",
							["sessionName"] = "Demo Session",
							["id"] = "cutpurse",
							["name"] = "Defias Cutpurse",
							["lootTable"] = {
								{
									["chance"] = 33,
									["item"] = "dustQuest",
									["amount"] = 1,
								}, -- [1]
							},
						},
						["murlock2"] = {
							["corpseList"] = {
							},
							["enabled"] = true,
							["elType"] = "Mob",
							["id"] = "murlock2",
							["sessionName"] = "Demo Session",
							["name"] = "Murloc Streamrunner",
							["lootTable"] = {
								{
									["chance"] = 10,
									["quest"] = "murlocks",
									["item"] = "ringDummy",
									["amount"] = 1,
								}, -- [1]
							},
						},
					},
					["Objects"] = {
					},
					["version"] = 1,
					["Quests"] = {
						["masterPlan"] = {
							["nextQuest"] = "preparations",
							["level"] = 8,
							["questDescription"] = "We are ready to begin our plan now! Our agents are already hard at work trying to make it happen, but I will need your help with three tasks.\n\nFirst, we will need to find out the corrupt guards that the dock master mentioned. Then we need to create a diversion so we will draw their attention away from self operation. Finally, we need to make sure that all the defias operatives are inside their hideout when we strike, so they won't have a chance to escape.\n\nRenzik will brief you for each task.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "The Master Plan",
							["enderId"] = "Mathias",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["objectivesSummary"] = "Complete the tasks assigned by Renzik.",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["elType"] = "Quest",
							["previousQuest"] = "murlocks",
							["starterId"] = "Mathias",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
								{
									["targetValue"] = 1,
									["poiy"] = 0.7090309262275696,
									["filter"] = {
										"Q_masterPlan_CorruptGuards", -- [1]
									},
									["text"] = "Corrupt guards exposed",
									["event"] = "Script",
									["poix"] = 0.7842601537704468,
								}, -- [1]
								{
									["targetValue"] = 1,
									["poiy"] = 0.7090309262275696,
									["filter"] = {
										"Q_masterPlan_Operatives", -- [1]
									},
									["text"] = "Operatives recalled",
									["event"] = "Script",
									["poix"] = 0.7842601537704468,
								}, -- [2]
								{
									["targetValue"] = 1,
									["poiy"] = 0.7090309262275696,
									["filter"] = {
										"Q_masterPlan_Diversion", -- [1]
									},
									["text"] = "Diversion created",
									["event"] = "Script",
									["poix"] = 0.7842601537704468,
								}, -- [3]
							},
							["progressText"] = "How is your progress, %fn? The operation will be a failure if not everything is ready.",
							["acceptScriptText"] = "function(Quest,player)\n\n Session:SendSessionMessage(\"self is an example of a 'meta-quest', with objectives that are quests of their own. Just like the Pa'Troll daily in Northrend\",player)\nif(player.quests.corruptGuards==true)then\n    Quest:Event(player,\"Script\",\"Q_masterPlan_CorruptGuards\")\nend\nif(player.quests.operatives==true)then\n    Quest:Event(player,\"Script\",\"Q_masterPlan_Operatives\")\nend\nif(player.quests.diversion==true)then\n    Quest:Event(player,\"Script\",\"Q_masterPlan_Diversion\")\nend\nend",
							["category"] = "Stormwind City",
							["id"] = "masterPlan",
							["returnToText"] = "Return to Mathias Shaw",
							["questRewards"] = {
							},
							["completionText"] = "I knew we could count on you!",
							["filter"] = {
							},
						},
						["box1"] = {
							["nextQuest"] = "box2",
							["level"] = 6,
							["questDescription"] = "In the possession of the slain bandit, you found self box. It's contents is a strange, shimmering dust. It's unclear how such a substance came to the possession of a lowly thug. Maybe you should report self to Rowe?",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "A Suspicious Box",
							["enderId"] = "Rowe",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["elType"] = "Quest",
							["starterId"] = "dustQuest",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
								{
									["targetValue"] = 1,
									["poiy"] = 0.5400059819221497,
									["filter"] = {
										"dustQuest", -- [1]
									},
									["text"] = "Suspicious Box",
									["event"] = "Item",
									["poix"] = 0.4133787453174591,
								}, -- [1]
							},
							["progressText"] = "What's self you have there?",
							["acceptScriptText"] = "function(Quest,player)\n\nend",
							["category"] = "Stormwind City",
							["completionText"] = "A defias had self with him?",
							["id"] = "box1",
							["returnToText"] = "Return to Squire Rowe.",
							["objectivesSummary"] = "Show the suspicious box to Squire Rowe.",
							["filter"] = {
							},
							["questRewards"] = {
							},
						},
						["exposition"] = {
							["nextQuest"] = "recorder",
							["level"] = 8,
							["questDescription"] = "We have long suspecetd that the Defias were running a smuggling operation inside Stormwind, but we had never managed to get hold of the goods.\n\nUntil now.\n\nself is very worrying however. Refined dream dust? Normally I would run self operation slowly and carefully, but with self thing inside the city, many lives are at stake. We have to act fast.\n\nIf you want to help us, and help Stormwind, talk to Renzik over here, he will brief you on what we need you to do next.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "The Smuggling Ring",
							["enderId"] = "Renzik",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["objectivesSummary"] = "Talk to Renzik \"The Shiv\"",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["elType"] = "Quest",
							["previousQuest"] = "box3",
							["starterId"] = "Mathias",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
							},
							["progressText"] = "self is a bug",
							["acceptScriptText"] = "function(Quest,player)\nSession:SendSessionMessage(\"In order to talk to Renzik, as he is a non-interactable NPC, you just need to target him. If he is already targeted, you can click on his portrait on the target frame\",player)\nend",
							["category"] = "Stormwind City",
							["id"] = "exposition",
							["returnToText"] = "Talk to Renzik \"The Shiv\"",
							["questRewards"] = {
							},
							["completionText"] = "Alright, %r, listen carefully.",
							["filter"] = {
							},
						},
						["operatives"] = {
							["level"] = 8,
							["questDescription"] = "It would be safe to assume that the Brotherhood has a number of operatives inside Stormwind at any time, pushing goods or spying on us. If we raid the warehouses right now, all these people will go into hiding and we will never catch them.\n\nTake self note. It's the passphrases we got from the recorder. Visit the three warehouses around the city, and after giving the correct passphrase, tell the supervisor that things are getting hot and all operatives should lay low for a while. self will gather them all nicely for our raid.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "The Warehouse Rock",
							["enderId"] = "Renzik",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (type(player.quests[masterPlan.id])~=\"table\"))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["specialItemId"] = "passphrases",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nmasterPlan:Event(player,\"Script\",\"Q_masterPlan_Operatives\")\nend",
							["elType"] = "Quest",
							["starterId"] = "Renzik",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
								{
									["targetValue"] = 1,
									["poiy"] = 0.43178126215935,
									["filter"] = {
										"Q_operatives_harbor", -- [1]
									},
									["poix"] = 0.45033469796181,
									["text"] = "Harbor warehouse operatives recalled",
									["event"] = "Script",
									["zone"] = "Stormwind City",
								}, -- [1]
								{
									["targetValue"] = 1,
									["poiy"] = 0.75984060764313,
									["filter"] = {
										"Q_operatives_mageQuarter", -- [1]
									},
									["poix"] = 0.48894780874252,
									["text"] = "Mage Quarter warehouse operatives recalled",
									["event"] = "Script",
									["zone"] = "Stormwind City",
								}, -- [2]
								{
									["targetValue"] = 1,
									["poiy"] = 0.5444996356964111,
									["filter"] = {
										"Q_operatives_oldTown", -- [1]
									},
									["poix"] = 0.728776216506958,
									["text"] = "Old Town warehouse operatives recalled",
									["event"] = "Script",
									["zone"] = "Stormwind City",
								}, -- [3]
							},
							["progressText"] = "I hope you didn't lose your note.",
							["acceptScriptText"] = "function(Quest,player)\nSession:SendSessionMessage(\"Since Verisimilar cannot affect the 3D world, the doors to the warehouses are represented as icons in your minimap and the environment panel of Verisimilar. When you get close enough, click on the icon to initiate gossip\",player)\nend",
							["category"] = "Stormwind City",
							["completionText"] = "Hopefully they did not discover your true motives.",
							["id"] = "operatives",
							["returnToText"] = "Return to Renzik",
							["questRewards"] = {
							},
							["filter"] = {
							},
							["objectivesSummary"] = "Tell the supervisor of each warehouse to recall his operatives",
						},
						["listening"] = {
							["nextQuest"] = "murlocks",
							["level"] = 8,
							["questDescription"] = "Alright then, let's listen to what our mechanical spy has to say...",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "Our Mechanical Spy",
							["enderId"] = "Mathias",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["objectivesSummary"] = "Listen to the recorded conversation, and then talk to Mathias Shaw.",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["elType"] = "Quest",
							["previousQuest"] = "recorder",
							["starterId"] = "Renzik",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
								{
									["targetValue"] = 1,
									["poiy"] = 0.7096961140632629,
									["filter"] = {
										"Q_listening_Obj1", -- [1]
									},
									["text"] = "Recorded conversation listened",
									["event"] = "Script",
									["poix"] = 0.7840691208839417,
								}, -- [1]
							},
							["progressText"] = "Shh, let us listen.",
							["acceptScriptText"] = "function(Quest,player)\nRenzik:Emote(\"presses a button on the recorder device, and it starts playing.\",1)\nrecorderNPC:Say(\"Hey, you, are you our new delivery boy?\",5)\nRenzik:Say(\"That's the dock master, I could recognize his raspy voice through a million recordings.\",9)\nrecorderNPC:Say(\"Yes sir.\",15)\nrecorderNPC:Say(\"Here are the packages. You need to take each to our three warehouses in Stormwind.\",18)\nrecorderNPC:Say(\"The first one is at the north part of the Old Town, it has a metal grate for a door. The passphrase is 'Wolves dine at midnight'\",25)\nrecorderNPC:Say(\"The next one is at the north part of the Mage Quarter. The passphrase is 'Ducks run everywhere'.\",33);\nMathias:Emote(\"seems very absorbed by the recording.\",40);\nrecorderNPC:Say(\"And you will find the last one by taking the right road when you enter the harbor. The passphrase is 'Mice roar in the park'.\",45);\nrecorderNPC:Say(\"Got it\",53);\nrecorderNPC:Say(\"Also, take self ring. If you run into trouble, flash it at a guard. If he is one of those who are on our payroll, he will assist you\",58);\nMathias:Emote(\"gasps upon hearing self.\",63)\nrecorderNPC:Say(\"And one last thing, don't venture too close to Crystal Lake, our last runner was killed by murlocks, and all the stuff was looted. Good luck.\",69);\nMathias:Say(\"I think we heard enough...\",77);\ncompleteListening:RunDelayed(79,player);\n\nend",
							["category"] = "Stormwind City",
							["id"] = "listening",
							["returnToText"] = "Talk to Mathias Shaw.",
							["questRewards"] = {
							},
							["completionText"] = "We know enough now...",
							["filter"] = {
							},
						},
						["preparations"] = {
							["nextQuest"] = "docks",
							["level"] = 8,
							["questDescription"] = "The time has come, %fn. Everything is in place, we have to make our move.\n\nThe three guard officers, Brady, Jaxon and Pomeroy patrol around Stormwind. Find them and tell them to prepare their men for the raids on the warehouses. When you have done so, inform their captain, Melris Malagan, at the Trade District. He will brief you on your part in all self.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "Preparing for the Raids",
							["enderId"] = "Malagan",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["objectivesSummary"] = "Inform the three guard officers about the raids, and then report to Melris Malagan in the Trade District.",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["elType"] = "Quest",
							["previousQuest"] = "masterPlan",
							["starterId"] = "Mathias",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
								{
									["targetValue"] = 1,
									["poiy"] = 0.7259379625320435,
									["filter"] = {
										"Q_preparations_brady", -- [1]
									},
									["text"] = "Officer Brady informed",
									["event"] = "Script",
									["poix"] = 0.6364160180091858,
								}, -- [1]
								{
									["targetValue"] = 1,
									["poiy"] = 0.7259379625320435,
									["filter"] = {
										"Q_preparations_jaxon", -- [1]
									},
									["text"] = "Officer Jaxon informed",
									["event"] = "Script",
									["poix"] = 0.6364160180091858,
								}, -- [2]
								{
									["targetValue"] = 1,
									["poiy"] = 0.7259379625320435,
									["filter"] = {
										"Q_preparations_pomeroy", -- [1]
									},
									["text"] = "Officer Pomeroy informed",
									["event"] = "Script",
									["poix"] = 0.6364160180091858,
								}, -- [3]
							},
							["progressText"] = "Have you talked to my officers yet, %fn?",
							["acceptScriptText"] = "function(Quest,player)\n\nend",
							["category"] = "Stormwind City",
							["id"] = "preparations",
							["returnToText"] = "Report to Melris Malagan in the Trade District.",
							["questRewards"] = {
							},
							["completionText"] = "Very well, I will signal for the attack soon, then.",
							["filter"] = {
							},
						},
						["introQuest"] = {
							["nextQuest"] = "killCutpurses",
							["level"] = 5,
							["questDescription"] = "Walking through the streets of Stormwind City, you take notice of a post on an announcement board which asks for people who are not afraid to get their hands bloody. \n\nAnd it doesn't sound like illegal work either, as the person to contact for details is Squire Rowe, and not some shady character. Maybe you should check it out?",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "From an Announcement Board in Stormwind",
							["enderId"] = "Rowe",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["abaddonScriptText"] = "function(Quest,player)\n   Session:SendSessionMessage(\"You abandoned the intro quest! How could you? If you want to get back on the questline, disconnect from the session and reconnect\",player)\nend",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["elType"] = "Quest",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
							},
							["progressText"] = "If you can read self, it's a bug.",
							["acceptScriptText"] = "function(Quest,player)\n\nend",
							["category"] = "Stormwind City",
							["id"] = "introQuest",
							["returnToText"] = "Talk to Squire Rowe at the gates of Stormwind City about the job.",
							["questRewards"] = {
							},
							["completionText"] = "So, are you interested to hear about the job?",
							["filter"] = {
							},
							["objectivesSummary"] = "Talk to Squire Rowe at the gates of Stormwind City about the job.",
						},
						["diversion"] = {
							["level"] = 8,
							["questDescription"] = "When we mobilize the guard, we don't want to upset the smugglers. We have to make them think that we are preparing to strike elsewhere.\n\nThe Defias have evicted the Brackwells from their farm and are using it as a... We are not even sure what they do there, it's just a farm really. But it gives us a good opportunity for diversion.\n\nThe leader of the squatters is called Morgan the Collector. Go there and tell him that he has until tomorrow to leave the farm, or else they will all be arrested when the guards arive.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "Divert self!",
							["enderId"] = "Renzik",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (type(player.quests[masterPlan.id])~=\"table\"))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nmasterPlan:Event(player,\"Script\",\"Q_masterPlan_Diversion\")\nend",
							["elType"] = "Quest",
							["starterId"] = "Renzik",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
								{
									["targetValue"] = 1,
									["poiy"] = 0.8027786016464233,
									["filter"] = {
										"Q_diversion_Obj1", -- [1]
									},
									["poix"] = 0.7075038552284241,
									["text"] = "Morgan the Collector informed",
									["event"] = "Script",
									["zone"] = "Elwynn Forest",
								}, -- [1]
							},
							["progressText"] = "Have you gone there yet?",
							["acceptScriptText"] = "function(Quest,player)\nSession:SendSessionMessage(\"Just like Renzik, you can speak with Morgan even though he is a hostile mob by simply selecting him or clicking on his portrait in the target frame\",player)\nend",
							["category"] = "Elwynn Forest",
							["id"] = "diversion",
							["returnToText"] = "Return to Renzik",
							["questRewards"] = {
							},
							["completionText"] = "Good, self will throw them off our true plans.",
							["filter"] = {
							},
							["objectivesSummary"] = "Tell Morgan the Collector about the upcomming attack at the farm",
						},
						["killCutpurses"] = {
							["level"] = 6,
							["questDescription"] = "It's that time of the year again, %fn. The ambuses of the Defias bandits upon helpless travelers have increased, and the City has tasked me with finding people to scare them away.\n\nThe pay is not big, in fact it might be days before your payment will be authorized, but it will be an easy job for a %c like yourself because these particular bandits haven't faced anyone with even a hint of combat skill.\n\nJust venture into the forest south-east of here, and kill a few of them, it will send the rest a message.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "Pruning the Forest",
							["enderId"] = "Rowe",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["objectivesSummary"] = "Kill 10 Defias Cutpurses, and report back to Squire Rowe.",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["elType"] = "Quest",
							["previousQuest"] = "introQuest",
							["starterId"] = "Rowe",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
								{
									["targetValue"] = 10,
									["poiy"] = 0.5425429940223694,
									["filter"] = {
										"Defias Cutpurse", -- [1]
									},
									["zone"] = "Elwynn Forest",
									["text"] = "Defias Cutpurses killed",
									["event"] = "Kill",
									["poix"] = 0.4101032316684723,
								}, -- [1]
							},
							["progressText"] = "Don't tell me that those cutpurses scare you?",
							["acceptScriptText"] = "function(Quest,player)\n\nend",
							["category"] = "Elwynn Forest",
							["id"] = "killCutpurses",
							["returnToText"] = "Return to Squire Rowe",
							["questRewards"] = {
							},
							["completionText"] = "I hope it wasn't too dangerous, I know the pay isn't worth that much... Speaking of which, I will write you down on my report so you will get your compensation in a few days.",
							["filter"] = {
							},
						},
						["docks"] = {
							["nextQuest"] = "reward",
							["level"] = 15,
							["questDescription"] = "Our simultaneous attack on all three warehouses will begin soon. Your task is to take care of the remaining pocket of the smuggling ring: Jerod's Landing. We don't want them to have the chance to escape once they learn of the raids here, so you need to move now.\n\nWhen your mission is over, report back to Master Mathias Shaw",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "Assault the Docks",
							["enderId"] = "Mathias",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["objectivesSummary"] = "Kill the Defias Dockmaster and his three dockworkers at Jerod's Landing, and then report back to Mathias Shaw.",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["elType"] = "Quest",
							["previousQuest"] = "preparations",
							["starterId"] = "Malagan",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
								{
									["targetValue"] = 1,
									["poiy"] = 0.8659248352050781,
									["filter"] = {
										"Defias Dockmaster", -- [1]
									},
									["poix"] = 0.4821344017982483,
									["text"] = "Defias Dockmaster slain",
									["event"] = "Kill",
									["zone"] = "Elwynn Forest",
								}, -- [1]
								{
									["targetValue"] = 3,
									["poiy"] = 0.8659248352050781,
									["filter"] = {
										"Defias Dockworker", -- [1]
									},
									["poix"] = 0.4821344017982483,
									["text"] = "Defias Dockworker slain",
									["event"] = "Kill",
									["zone"] = "Elwynn Forest",
								}, -- [2]
							},
							["progressText"] = "Why are you here, %fn?",
							["acceptScriptText"] = "function(Quest,player)\n\nend",
							["category"] = "Elwynn Forest",
							["id"] = "docks",
							["returnToText"] = "Return to Mathias Shaw",
							["questRewards"] = {
							},
							["completionText"] = "Excellent work, %fn! The raids were a success too. Those defias were cought with their pants down so to speak, and we managed to confiscate their entire stash!\n\nAnd it's all thanks to you.",
							["filter"] = {
							},
						},
						["box3"] = {
							["nextQuest"] = "exposition",
							["level"] = 8,
							["questDescription"] = "Please excuse my reaction, but what you carry is not ordinary dream dust. It is *refined* dream dust, so fine you can easily inhale it if you are not careful.\n\nIn self state, it can be absorbed by the body and acts as a powerful and very addictive halucinogenic. Not to mention being deadly on the long run. \n\nEnchanters  in Stormwind are forbidden from producing refined dream dust, and it requires substantial equipment for it's manufacture, so it must have come from somewhere else.\n\nIf you really want to look into self further, you might want to show it to Mathias Shaw, the leader of the SI:7. But please, don't talk to me again about self, I don't want to get involved.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "Take it to the SI:7",
							["enderId"] = "Mathias",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["specialItemId"] = "dust",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["elType"] = "Quest",
							["previousQuest"] = "box2",
							["starterId"] = "Quin",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
							},
							["progressText"] = "if you can read self, it is a bug.",
							["acceptScriptText"] = "function(Quest,player)\nlocal man=\"man\"\nlocal him=\"him\"\nif(player.gender==\"female\")then\nman=\"woman\"\nhim=\"her\"\nend\nJessara:Say(\"Betty dear, who was self \"..man..\" you were talking to?\",6)\nQuin:Say(\"No one! A friend! I don't know \"..him..\"! Leave me alone!\",8)\nend",
							["category"] = "Stormwind City",
							["completionText"] = "Refined dream dust? Did you hear self Renzik, it seems the last part of the puzzle has fallen right into our laps!",
							["id"] = "box3",
							["returnToText"] = "Talk to Master Mathias Shaw in the SI:7 building.",
							["questRewards"] = {
							},
							["filter"] = {
							},
							["objectivesSummary"] = "Talk to Master Mathias Shaw about the refined dream dust",
						},
						["box2"] = {
							["nextQuest"] = "box3",
							["level"] = 6,
							["questDescription"] = "I am no expert, but self looks kinda like dreamdust used in enchanting magical items. What is a lowly thung doing with such a substance?\n\nNot my concern to be honest, but if you want more information, talk to Betty Quin. She is an apprentice enchanter, but she will be able to help you more than I could.\n\nShe works at the enchantment supplies store near the Stockades.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "Talk to Betty",
							["enderId"] = "Quin",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["specialItemId"] = "dust",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["elType"] = "Quest",
							["previousQuest"] = "box1",
							["starterId"] = "Rowe",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
							},
							["progressText"] = "If you read self, it's a bug.",
							["acceptScriptText"] = "function(Quest,player)\n\nend",
							["category"] = "Stormwind City",
							["completionText"] = "What is th.... Oh my, get self stuff away from me!",
							["id"] = "box2",
							["returnToText"] = "Speak to Betty Quin",
							["questRewards"] = {
							},
							["filter"] = {
							},
							["objectivesSummary"] = "Ask Betty Quin about the strange dust.",
						},
						["murlocks"] = {
							["nextQuest"] = "masterPlan",
							["level"] = 8,
							["questDescription"] = "I have a plan, but we need one last thing before we can set it in motion.\n\nThe recording mentioned a certain ring carried by defias operatives inside Stormwind. It also said that one of their runners was killed by the murlocks of Crystal Lake, and his possessions taken by the monsters.\n\nWe are going to need that ring, %fn. One of those murlocs must have it, and you have to retrieve it for us.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "Everyone's Favorite Slimy Monster",
							["enderId"] = "Mathias",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["elType"] = "Quest",
							["previousQuest"] = "listening",
							["starterId"] = "Mathias",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
								{
									["targetValue"] = 1,
									["poiy"] = 0.6681903600692749,
									["filter"] = {
										"ringDummy", -- [1]
									},
									["zone"] = "Elwynn Forest",
									["text"] = "Defias Ring",
									["event"] = "Item",
									["poix"] = 0.5061185956001282,
								}, -- [1]
							},
							["progressText"] = "Do you have the ring?",
							["acceptScriptText"] = "function(Quest,player)\n\nend",
							["category"] = "Elwynn Forest",
							["id"] = "murlocks",
							["returnToText"] = "Return to Mathias Shaw in the SI:7 building.",
							["objectivesSummary"] = "Retrieve the Defias Ring from the murlocs of Crystal Lake, and bring it back to Mathias Shaw.",
							["completionText"] = "Perfect! Now we are ready to begin.",
							["filter"] = {
							},
							["questRewards"] = {
							},
						},
						["recorder"] = {
							["nextQuest"] = "listening",
							["level"] = 8,
							["questDescription"] = "When we found out that the Defias had set up shop at Jerod's Landing, we burried a device nearby that would record their conversations. It's time to recover the device and listen to what it got.\n\nTake self Locatron. It is set to display the distance between you and beacon on the device. Use it when you are close to Jerod's landing, and try to locate the recording device. When you use the Locatron close enough to the beacon, it will make it expell the device from the ground.\n\nReturn to me with both devices.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "Find the Recorder",
							["enderId"] = "Renzik",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["questRewards"] = {
							},
							["specialItemId"] = "locatron",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nend",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["elType"] = "Quest",
							["previousQuest"] = "exposition",
							["starterId"] = "Renzik",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
								{
									["targetValue"] = 1,
									["poiy"] = 0.8537057042121887,
									["filter"] = {
										"recorderDev", -- [1]
									},
									["zone"] = "Elwynn Forest",
									["text"] = "Recorder Device",
									["event"] = "Item",
									["poix"] = 0.4773381650447846,
								}, -- [1]
							},
							["progressText"] = "Have you found it?",
							["acceptScriptText"] = "function(Quest,player)\nlocal him=\"him\"\nlocal he=\"he\"\nif(player.gender==\"female\")then\n    him=\"her\"\n    he=\"she\"\nend\nRenzik:Say(\"Mathias, are you sure we can trust \"..him..\"?\",4);\nMathias:Say(\"Well, \"..he..\" came to us with the dust, so \"..he..\" must be dependable. Also, we are short on hands at the moment, so we don't have much choice.\",6);\n\nend",
							["category"] = "Elwynn Forest",
							["completionText"] = "Excellent! I trust that they weren't aware of your presence there?",
							["id"] = "recorder",
							["returnToText"] = "Return to Renzik inside the SI:7 building.",
							["objectivesSummary"] = "Use the Locatron to find the SI:7 recording device near Jerod's Landing, and then return to Renzik.",
							["filter"] = {
							},
						},
						["corruptGuards"] = {
							["level"] = 8,
							["questDescription"] = "The recording mentioned that the Defias Brootherhood is bribing some of our city guards. If we are to go on with the plan, we must root them out.\n\nHere is the ring you recovered from the murlocks. Go around the city and show it to any guard you meet. If they react as if they know something about it, it means that they have been taking a part-time job on the side.\n\nReport them back to me.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "It Happens Even in the Best of Families",
							["enderId"] = "Renzik",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (type(player.quests[masterPlan.id])~=\"table\"))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["objectivesSummary"] = "Root out the corrupt guards in Stormwind City.",
							["specialItemId"] = "ring",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nmasterPlan:Event(player,\"Script\",\"Q_masterPlan_CorruptGuards\")\nend",
							["elType"] = "Quest",
							["starterId"] = "Renzik",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
								{
									["targetValue"] = 5,
									["poiy"] = 0.7090461254119873,
									["filter"] = {
										"Q_corruptGuards_Obj1", -- [1]
									},
									["text"] = "Corrupt guard discovered",
									["event"] = "Script",
									["poix"] = 0.7843045592308044,
								}, -- [1]
							},
							["progressText"] = "We can't risk having even one of them on the loose when we put the plan in motion.",
							["acceptScriptText"] = "function(Quest,player)\n\nend",
							["category"] = "Stormwind City",
							["completionText"] = "Excellent! We will make sure that they are taken care of when the time comes.",
							["id"] = "corruptGuards",
							["returnToText"] = "Return to Renzik",
							["questRewards"] = {
							},
							["filter"] = {
							},
						},
						["reward"] = {
							["level"] = 15,
							["questDescription"] = "Words cannot express our gratitude, so we will have to resort to material rewards. Renzik has already preapred something for you.",
							["enabled"] = true,
							["sessionName"] = "Demo Session",
							["title"] = "A Fitting Reward",
							["enderId"] = "Renzik",
							["availabilityScriptText"] = "function(Quest,player)\n   if(player.quests[Quest.id] or (Quest:GetPreviousQuest() and player.quests[Quest:GetPreviousQuest().id]~=true))then\n        return false;\n    else\n        return true;\n    end\nend",
							["events"] = {
							},
							["objectivesSummary"] = "Talk to Renzik about your reward",
							["objectivesScriptText"] = "function(Quest,player,currentValue,event,parameter,arg1,arg2,arg3)\n    if(event=='Item')then\n        return arg1\n   end\n   return currentValue+1;\nend",
							["abaddonScriptText"] = "function(Quest,player)\n\nend",
							["completionScriptText"] = "function(Quest,player)\n    if(Quest:GetNextQuest() and Quest:GetNextQuest():IsAvailableToPlayer(player))then\n        Quest:GetNextQuest():Offer(player);\n    end\nSession:SendSessionMessage(\"And that's the end of the Verisimilar Demo Session! I hope it gave you a good idea on what you can do with self add-on.\",player)\nend",
							["elType"] = "Quest",
							["previousQuest"] = "docks",
							["starterId"] = "Mathias",
							["detailsScriptText"] = "function(Quest,player)\n    local questDescription=Quest:GetQuestDescription()\n    questDescription=SubSpecialChars(questDescription,player)\n    local objectivesSummary=Quest:GetObjectivesSummary()\n    objectivesSummary=SubSpecialChars(objectivesSummary,player)\n    local progressText=Quest:GetProgressText()\n    progressText=SubSpecialChars(progressText,player)\n    local completionText=Quest:GetCompletionText()\n    completionText=SubSpecialChars(completionText,player)\n    local returnToText=Quest:GetReturnToText()\n    returnToText=SubSpecialChars(returnToText,player)\n    return questDescription,objectivesSummary,progressText,completionText,returnToText;\nend",
							["objectives"] = {
							},
							["progressText"] = "you can't read self",
							["acceptScriptText"] = "function(Quest,player)\n\nend",
							["category"] = "Stormwind City",
							["id"] = "reward",
							["returnToText"] = "Talk to Renzik",
							["questRewards"] = {
								{
									["id"] = "certification",
									["choosable"] = false,
									["amount"] = 1,
								}, -- [1]
							},
							["completionText"] = "Look, %c, I don't know what you had in mind, but with the war in Northrend and all, self is all we can afford.\n\nBut we all know that the real reward is knowing that you did the right thing...\n\n*Renzik grins at you*",
							["filter"] = {
							},
						},
					},
					["isLocal"] = true,
					["players"] = {
					},
					["welcomeMessage"] = "Welcome to the Demo Session of Verisimilar! self session will showcase the features of self mod, as well as it's shortcommings (nobody is perfect!).\nThere is a step-by-step walkthrough in the Player's Guide in the VerisimilarPlayer folder, which will make it's quirks clear.\nWhen you talk to Rowe, you will need to first click the \"Greetings\" option before you are able to turn in self quest. Verisimilar works like that when customizing existing NPCs.\nIf for some reason you did not accept or abadoned self starting quest, disconnect from the session and reconnect.",
					["keepPlayerData"] = false,
					["password"] = "",
					["NPCs"] = {
						["Mathias"] = {
							["environmentIcon"] = false,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								[0] = {
									["gossip"] = "What is your business with the SI:7?",
									["text"] = "Hello",
								},
							},
							["icon"] = "Ability_Rogue_Eviscerate",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    for i=0,NPC:GetNumGossipOptions() do\n        if(i~=choice)then\n            table.insert(options,{text=NPC:GetOptionText(i),choice=i});\n        end\n    end\n    return gossip,options;\nend",
							["name"] = "Master Mathias Shaw",
							["visibleDistance"] = 60,
							["coordX"] = 0.78308153152466,
							["targetTalk"] = false,
							["coordY"] = 0.7074906229972801,
							["id"] = "Mathias",
							["emoteDistance"] = 60,
							["sayDistance"] = 60,
							["zone"] = "Stormwind City",
						},
						["recorderNPC"] = {
							["environmentIcon"] = false,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								[0] = {
									["gossip"] = "",
									["text"] = "Hello",
								},
							},
							["icon"] = "Ability_Ambush",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    for i=0,NPC:GetNumGossipOptions() do\n        if(i~=choice)then\n            table.insert(options,{text=NPC:GetOptionText(i),choice=i});\n        end\n    end\n    return gossip,options;\nend",
							["name"] = "Recorder Device",
							["visibleDistance"] = 60,
							["coordX"] = 0.7840691208839417,
							["targetTalk"] = false,
							["coordY"] = 0.7096961140632629,
							["id"] = "recorderNPC",
							["emoteDistance"] = 30,
							["sayDistance"] = 60,
							["zone"] = "Stormwind City",
						},
						["harborWH"] = {
							["environmentIcon"] = true,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Mice...",
								}, -- [1]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Wolves...",
								}, -- [2]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Pigs...",
								}, -- [3]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Ducks...",
								}, -- [4]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...jump...",
								}, -- [5]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...dine...",
								}, -- [6]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...run...",
								}, -- [7]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...roar...",
								}, -- [8]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...in the park.",
								}, -- [9]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...everywhere.",
								}, -- [10]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...at midnight.",
								}, -- [11]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...alone.",
								}, -- [12]
								{
									["gossip"] = "I will notify my men at once.",
									["text"] = "The SI:7 is getting suspicious, tell your men to lay low for a couple days.",
								}, -- [13]
								[0] = {
									["gossip"] = "self is a warehouse door.",
									["text"] = "Hello",
								},
							},
							["icon"] = "INV_Crate_05",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    if(choice==0 and type(player.quests.operatives)~=\"table\")then\n        return gossip,options;\n    end\n    local branches\n    if(choice==0)then\n        player.quests.operatives.harborWH1=false\n        player.quests.operatives.harborWH2=false\n        player.quests.operatives.harborWH3=false\n    elseif(choice==1)then\n        player.quests.operatives.harborWH1=true\n    elseif(choice==8)then\n        player.quests.operatives.harborWH2=true\n    elseif(choice==9)then\n        player.quests.operatives.harborWH3=true\n    elseif(choice==13)then\n        operatives:Event(player,\"Script\",\"Q_operatives_harbor\")\n    end\n    \n    \n    \n    \n    if(choice==0)then\n        branches={1,2,3,4}\n    elseif(choice<5)then\n        branches={5,6,7,8}\n    elseif(choice<9)then\n        branches={9,10,11,12}\n    elseif(choice>8 and choice<13 and player.quests.operatives.harborWH1==true and player.quests.operatives.harborWH2==true and player.quests.operatives.harborWH3==true)then\n        gossip=\"Welcome to our humble warehouse, brother. What't news do you bring from the Brotherhood?\"\n        branches={13}\n    else\n        branches={}\n    end\n    \n    for i=1,#branches do\n        table.insert(options,{text=NPC:GetOptionText(branches[i]),choice=branches[i]});\n    end\n    return gossip,options;\nend",
							["name"] = "Harbor Warehouse Door",
							["visibleDistance"] = 60,
							["coordX"] = 0.45023730397224,
							["targetTalk"] = true,
							["coordY"] = 0.43137910962105,
							["id"] = "harborWH",
							["emoteDistance"] = 30,
							["sayDistance"] = 30,
							["zone"] = "Stormwind City",
						},
						["Quin"] = {
							["environmentIcon"] = false,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								[0] = {
									["gossip"] = "Can I help you with anything?",
									["text"] = "Hello there",
								},
							},
							["icon"] = "INV_Misc_Head_Human_02",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    for i=0,NPC:GetNumGossipOptions() do\n        if(i~=choice)then\n            table.insert(options,{text=NPC:GetOptionText(i),choice=i});\n        end\n    end\n    return gossip,options;\nend",
							["name"] = "Betty Quin",
							["visibleDistance"] = 60,
							["coordX"] = 0.5304024815559401,
							["targetTalk"] = false,
							["coordY"] = 0.73729926347733,
							["id"] = "Quin",
							["emoteDistance"] = 30,
							["sayDistance"] = 60,
							["zone"] = "Stormwind City",
						},
						["Rowe"] = {
							["environmentIcon"] = false,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								[0] = {
									["gossip"] = "Are you here for the job? ",
									["text"] = "Greetings",
								},
							},
							["icon"] = "Achievement_Character_Human_Male",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    for i=0,NPC:GetNumGossipOptions() do\n        if(i~=choice)then\n            table.insert(options,{text=NPC:GetOptionText(i),choice=i});\n        end\n    end\n    return gossip,options;\nend",
							["name"] = "Squire Rowe",
							["visibleDistance"] = 60,
							["coordX"] = 0.74116069078445,
							["targetTalk"] = false,
							["coordY"] = 0.90480244159698,
							["id"] = "Rowe",
							["emoteDistance"] = 30,
							["sayDistance"] = 30,
							["zone"] = "Stormwind City",
						},
						["Jessara"] = {
							["environmentIcon"] = false,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								[0] = {
									["gossip"] = "",
									["text"] = "Hello",
								},
							},
							["icon"] = "Spell_Arcane_TeleportDarnassus",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    for i=0,NPC:GetNumGossipOptions() do\n        if(i~=choice)then\n            table.insert(options,{text=NPC:GetOptionText(i),choice=i});\n        end\n    end\n    return gossip,options;\nend",
							["name"] = "Jessara Cordell",
							["visibleDistance"] = 60,
							["coordX"] = 0.52947974205017,
							["targetTalk"] = false,
							["coordY"] = 0.74014294147491,
							["id"] = "Jessara",
							["emoteDistance"] = 30,
							["sayDistance"] = 60,
							["zone"] = "Stormwind City",
						},
						["Renzik"] = {
							["environmentIcon"] = false,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								[0] = {
									["gossip"] = "You think you have what it takes to work with us?",
									["text"] = "Hello",
								},
							},
							["icon"] = "INV_ThrowingKnife_02",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    for i=0,NPC:GetNumGossipOptions() do\n        if(i~=choice)then\n            table.insert(options,{text=NPC:GetOptionText(i),choice=i});\n        end\n    end\n    return gossip,options;\nend",
							["name"] = "Renzik \"The Shiv\"",
							["visibleDistance"] = 60,
							["coordX"] = 0.78311216831207,
							["targetTalk"] = true,
							["coordY"] = 0.71164113283157,
							["id"] = "Renzik",
							["emoteDistance"] = 30,
							["sayDistance"] = 30,
							["zone"] = "Stormwind City",
						},
						["Morgan"] = {
							["environmentIcon"] = false,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								{
									["gossip"] = "Tell the guards to bring it! We aren't scared of them!",
									["text"] = "The Stormwind Guard will soon be here! You have one day to pack up and leave!",
								}, -- [1]
								[0] = {
									["gossip"] = "Do you happen to have a deathwish?",
									["text"] = "Hello",
								},
							},
							["icon"] = "Ability_Ambush",
							["actDistance"] = 30,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    if(choice==0 and type(player.quests.diversion)==\"table\")then\n         table.insert(options,{text=NPC:GetOptionText(1),choice=1});\n    end\n    if(choice==1)then\n          diversion:Event(player,\"Script\",\"Q_diversion_Obj1\")\n          NPC:Yell(\"Did you hear that boys? We are gonna have some fun with the tin cans soon!\",5)\n     end\n    return gossip,options;\nend",
							["name"] = "Morgan the Collector",
							["visibleDistance"] = 60,
							["coordX"] = 0.71087145805359,
							["targetTalk"] = true,
							["coordY"] = 0.80629992485046,
							["id"] = "Morgan",
							["emoteDistance"] = 30,
							["sayDistance"] = 30,
							["zone"] = "Elwynn Forest",
						},
						["mageWH"] = {
							["environmentIcon"] = true,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Mice...",
								}, -- [1]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Wolves...",
								}, -- [2]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Pigs...",
								}, -- [3]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Ducks...",
								}, -- [4]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...jump...",
								}, -- [5]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...dine...",
								}, -- [6]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...run...",
								}, -- [7]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...roar...",
								}, -- [8]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...in the park.",
								}, -- [9]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...everywhere.",
								}, -- [10]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...at midnight.",
								}, -- [11]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...alone.",
								}, -- [12]
								{
									["gossip"] = "I will notify my men at once.",
									["text"] = "The SI:7 is getting suspicious, tell your men to lay low for a couple days.",
								}, -- [13]
								[0] = {
									["gossip"] = "self is a warehouse door.",
									["text"] = "Hello",
								},
							},
							["icon"] = "INV_Crate_05",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    if(choice==0 and type(player.quests.operatives)~=\"table\")then\n        return gossip,options;\n    end\n    local branches\n    if(choice==0)then\n        player.quests.operatives.mageWH1=false\n        player.quests.operatives.mageWH2=false\n        player.quests.operatives.mageWH3=false\n    elseif(choice==4)then\n        player.quests.operatives.mageWH1=true\n    elseif(choice==7)then\n        player.quests.operatives.mageWH2=true\n    elseif(choice==10)then\n        player.quests.operatives.mageWH3=true\n    elseif(choice==13)then\n        operatives:Event(player,\"Script\",\"Q_operatives_mageQuarter\")\n    end\n    \n    \n    \n    \n    if(choice==0)then\n        branches={1,2,3,4}\n    elseif(choice<5)then\n        branches={5,6,7,8}\n    elseif(choice<9)then\n        branches={9,10,11,12}\n    elseif(choice>8 and choice<13 and player.quests.operatives.mageWH1==true and player.quests.operatives.mageWH2==true and player.quests.operatives.mageWH3==true)then\n        gossip=\"Welcome to our humble warehouse, brother. What't news do you bring from the Brotherhood?\"\n        branches={13}\n    else\n        branches={}\n    end\n    \n    for i=1,#branches do\n        table.insert(options,{text=NPC:GetOptionText(branches[i]),choice=branches[i]});\n    end\n    return gossip,options;\nend",
							["name"] = "Mage Quarter Warehouse Door",
							["visibleDistance"] = 60,
							["coordX"] = 0.48937565088272,
							["targetTalk"] = true,
							["coordY"] = 0.75640505552292,
							["id"] = "mageWH",
							["emoteDistance"] = 30,
							["sayDistance"] = 30,
							["zone"] = "Stormwind City",
						},
						["Brady"] = {
							["environmentIcon"] = false,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								{
									["gossip"] = "Tell Malagan not to worry.",
									["text"] = "Prepare your men Brady, the raid will commence soon",
								}, -- [1]
								[0] = {
									["gossip"] = "Yes, %c?",
									["text"] = "Hello",
								},
							},
							["icon"] = "Ability_Ambush",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    if(choice==0 and type(player.quests.preparations)==\"table\")then\n         table.insert(options,{text=NPC:GetOptionText(1),choice=1});\n    end\n    if(choice==1)then\n          preparations:Event(player,\"Script\",\"Q_preparations_brady\")\n     end\n    return gossip,options;\nend",
							["name"] = "Officer Brady",
							["visibleDistance"] = 60,
							["coordX"] = 0,
							["targetTalk"] = true,
							["coordY"] = 0,
							["id"] = "Brady",
							["emoteDistance"] = 30,
							["sayDistance"] = 30,
							["zone"] = "Stormwind City",
						},
						["Malagan"] = {
							["environmentIcon"] = false,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								[0] = {
									["gossip"] = "Greetings, %fn.",
									["text"] = "Hello",
								},
							},
							["icon"] = "INV_Helmet_02",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    for i=0,NPC:GetNumGossipOptions() do\n        if(i~=choice)then\n            table.insert(options,{text=NPC:GetOptionText(i),choice=i});\n        end\n    end\n    return gossip,options;\nend",
							["name"] = "Melris Malagan",
							["visibleDistance"] = 60,
							["coordX"] = 0.62978851795197,
							["targetTalk"] = true,
							["coordY"] = 0.71525537967682,
							["id"] = "Malagan",
							["emoteDistance"] = 30,
							["sayDistance"] = 30,
							["zone"] = "Stormwind City",
						},
						["oldtownWH"] = {
							["environmentIcon"] = true,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Mice...",
								}, -- [1]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Wolves...",
								}, -- [2]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Pigs...",
								}, -- [3]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "Ducks...",
								}, -- [4]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...jump...",
								}, -- [5]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...dine...",
								}, -- [6]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...run...",
								}, -- [7]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...roar...",
								}, -- [8]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...in the park.",
								}, -- [9]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...everywhere.",
								}, -- [10]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...at midnight.",
								}, -- [11]
								{
									["gossip"] = "There is no reply from the door.",
									["text"] = "...alone.",
								}, -- [12]
								{
									["gossip"] = "I will notify my men at once.",
									["text"] = "The SI:7 is getting suspicious, tell your men to lay low for a couple days.",
								}, -- [13]
								[0] = {
									["gossip"] = "self is a warehouse door.",
									["text"] = "Hello",
								},
							},
							["icon"] = "INV_Gizmo_MithrilCasing_02",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    if(choice==0 and type(player.quests.operatives)~=\"table\")then\n        return gossip,options;\n    end\n    local branches\n    if(choice==0)then\n        player.quests.operatives.oldtownWH1=false\n        player.quests.operatives.oldtownWH2=false\n        player.quests.operatives.oldtownWH3=false\n    elseif(choice==2)then\n        player.quests.operatives.oldtownWH1=true\n    elseif(choice==6)then\n        player.quests.operatives.oldtownWH2=true\n    elseif(choice==11)then\n        player.quests.operatives.oldtownWH3=true\n    elseif(choice==13)then\n        operatives:Event(player,\"Script\",\"Q_operatives_oldTown\")\n    end\n    \n    \n    \n    \n    if(choice==0)then\n        branches={1,2,3,4}\n    elseif(choice<5)then\n        branches={5,6,7,8}\n    elseif(choice<9)then\n        branches={9,10,11,12}\n    elseif(choice>8 and choice<13 and player.quests.operatives.oldtownWH1==true and player.quests.operatives.oldtownWH2==true and player.quests.operatives.oldtownWH3==true)then\n        gossip=\"Welcome to our humble warehouse, brother. What't news do you bring from the Brotherhood?\"\n        branches={13}\n    else\n        branches={}\n    end\n    \n    for i=1,#branches do\n        table.insert(options,{text=NPC:GetOptionText(branches[i]),choice=branches[i]});\n    end\n    return gossip,options;\nend",
							["name"] = "Old Town Warehouse Door",
							["visibleDistance"] = 60,
							["coordX"] = 0.72877621650696,
							["targetTalk"] = true,
							["coordY"] = 0.54449963569641,
							["id"] = "oldtownWH",
							["emoteDistance"] = 30,
							["sayDistance"] = 30,
							["zone"] = "Stormwind City",
						},
						["Pomeroy"] = {
							["environmentIcon"] = false,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								{
									["gossip"] = "You don't have to worry about us.",
									["text"] = "Make sure you and your men are ready for the attack",
								}, -- [1]
								[0] = {
									["gossip"] = "Make it quick, citizen.",
									["text"] = "Hello",
								},
							},
							["icon"] = "Ability_Ambush",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    if(choice==0 and type(player.quests.preparations)==\"table\")then\n         table.insert(options,{text=NPC:GetOptionText(1),choice=1});\n    end\n    if(choice==1)then\n          preparations:Event(player,\"Script\",\"Q_preparations_pomeroy\")\n     end\n    return gossip,options;\nend",
							["name"] = "Officer Pomeroy",
							["visibleDistance"] = 60,
							["coordX"] = 0,
							["targetTalk"] = true,
							["coordY"] = 0,
							["id"] = "Pomeroy",
							["emoteDistance"] = 30,
							["sayDistance"] = 30,
							["zone"] = "Stormwind City",
						},
						["Jaxon"] = {
							["environmentIcon"] = false,
							["yellDistance"] = 100,
							["gossipOptions"] = {
								{
									["gossip"] = "Alright, I will prepare my men.",
									["text"] = "Jaxon, be ready for the raid signal.",
								}, -- [1]
								[0] = {
									["gossip"] = "Can't wait for my shift to be over.",
									["text"] = "Hello",
								},
							},
							["icon"] = "Ability_Ambush",
							["actDistance"] = 10,
							["enabled"] = true,
							["elType"] = "NPC",
							["sessionName"] = "Demo Session",
							["gossipScriptText"] = "function(NPC,player,choice)\n    local gossip=NPC:GetOptionGossip(choice)\n    gossip=SubSpecialChars(gossip,player)   \n    local options={};\n    if(choice==0 and type(player.quests.preparations)==\"table\")then\n         table.insert(options,{text=NPC:GetOptionText(1),choice=1});\n    end\n    if(choice==1)then\n          preparations:Event(player,\"Script\",\"Q_preparations_jaxon\")\n     end\n    return gossip,options;\nend",
							["name"] = "Officer Jaxon",
							["visibleDistance"] = 60,
							["coordX"] = 0,
							["targetTalk"] = true,
							["coordY"] = 0,
							["id"] = "Jaxon",
							["emoteDistance"] = 30,
							["sayDistance"] = 30,
							["zone"] = "Stormwind City",
						},
					},
					["Items"] = {
						["dust"] = {
							["icon"] = "INV_Box_02",
							["quality"] = "Common",
							["elType"] = "Item",
							["sessionName"] = "Demo Session",
							["tooltip"] = {
								{
									["lText"] = "\"self is a box of dreamdust. Or is it?\"",
									["rText"] = "",
									["rb"] = 1,
									["rg"] = 1,
									["lb"] = 0.1,
									["lg"] = 0.7,
									["rr"] = 1,
									["lr"] = 1,
								}, -- [1]
							},
							["name"] = "Box of Dreamdust",
							["document"] = {
								["material"] = 1,
							},
							["enabled"] = true,
							["soulbound"] = true,
							["id"] = "dust",
							["useScriptText"] = "function(Item,player,x,y,targetName,targetGuid,targetDistance,targetHealth,targetSex)\n\nend",
							["uniqueAmount"] = 1,
						},
						["recorderDev"] = {
							["icon"] = "INV_Misc_Weathermachine_01",
							["quality"] = "Common",
							["elType"] = "Item",
							["sessionName"] = "Demo Session",
							["tooltip"] = {
								{
									["lText"] = "Quest Item",
									["rb"] = 1,
									["rText"] = "",
									["rg"] = 1,
									["lb"] = 1,
									["lg"] = 1,
									["rr"] = 1,
									["lr"] = 1,
								}, -- [1]
							},
							["name"] = "Recorder Device",
							["document"] = {
								["material"] = 1,
							},
							["enabled"] = true,
							["soulbound"] = true,
							["id"] = "recorderDev",
							["useScriptText"] = "function(Item,player,x,y,targetName,targetGuid,targetDistance,targetHealth,targetSex)\n\nend",
							["uniqueAmount"] = 1,
						},
						["dustQuest"] = {
							["icon"] = "INV_Box_02",
							["quality"] = "Common",
							["elType"] = "Item",
							["sessionName"] = "Demo Session",
							["tooltip"] = {
								{
									["lText"] = "self item begins a quest",
									["lr"] = 1,
									["rText"] = "",
									["rr"] = 1,
									["lb"] = 1,
									["lg"] = 1,
									["rg"] = 1,
									["rb"] = 1,
								}, -- [1]
								{
									["lText"] = "\"self box contains a strange, shimmering dust.\"",
									["lr"] = 1,
									["rText"] = "",
									["rr"] = 1,
									["lb"] = 0.1,
									["lg"] = 0.7,
									["rg"] = 1,
									["rb"] = 1,
								}, -- [2]
							},
							["name"] = "Suspicious Box",
							["document"] = {
								["material"] = 1,
							},
							["enabled"] = true,
							["soulbound"] = true,
							["id"] = "dustQuest",
							["useScriptText"] = "function(Item,player,x,y,targetName,targetGuid,targetDistance,targetHealth,targetSex)\n\nend",
							["uniqueAmount"] = 1,
						},
						["ringDummy"] = {
							["icon"] = "INV_Jewelry_Ring_02",
							["quality"] = "Common",
							["elType"] = "Item",
							["sessionName"] = "Demo Session",
							["tooltip"] = {
								{
									["lText"] = "Quest Item",
									["rb"] = 1,
									["rText"] = "",
									["rg"] = 1,
									["lb"] = 1,
									["lg"] = 1,
									["rr"] = 1,
									["lr"] = 1,
								}, -- [1]
								{
									["lText"] = "\"Has a simple, yet distinct design\"",
									["rb"] = 1,
									["rText"] = "",
									["rg"] = 1,
									["lb"] = 0.1,
									["lg"] = 0.7,
									["rr"] = 1,
									["lr"] = 1,
								}, -- [2]
							},
							["name"] = "Defias Ring",
							["document"] = {
								["material"] = 1,
							},
							["enabled"] = true,
							["soulbound"] = true,
							["id"] = "ringDummy",
							["useScriptText"] = "function(Item,player,x,y,targetName,targetGuid,targetDistance,targetHealth,targetSex)\n\nend",
							["uniqueAmount"] = 1,
						},
						["locatron"] = {
							["icon"] = "INV_Gizmo_GoblingTonkController",
							["quality"] = "Common",
							["elType"] = "Item",
							["sessionName"] = "Demo Session",
							["tooltip"] = {
								{
									["lText"] = "Use: Tells you the distance to the recorder, and reveals it if near.",
									["rb"] = 1,
									["rText"] = "",
									["rg"] = 1,
									["lb"] = 0,
									["lg"] = 1,
									["rr"] = 1,
									["lr"] = 0,
								}, -- [1]
							},
							["name"] = "Locatron",
							["document"] = {
								["material"] = 1,
							},
							["enabled"] = true,
							["soulbound"] = false,
							["id"] = "locatron",
							["useScriptText"] = "function(Item,player,x,y,targetName,targetGuid,targetDistance,targetHealth,targetSex)\n      local itemx=0.4732192158699;\n      local itemy=0.856365442276;\n      local dist=Distance(itemx,itemy,\"Elwynn Forest\",x,y,player.zone)\n\n      if(dist>300)then\n            Session:SendNPCMessageToPlayer(\"The Locatron\",\"does not seem to be in range of the beacon\",\"emote\",player)\n      elseif(dist>10)then\n             local deg=math.atan((itemy-y)/(itemx-x))\n             Session:SendNPCMessageToPlayer(\"The Locatron\",\"displays \"..math.ceil(dist)..\"ft\",\"emote\",player)\n     else\n             recorderDev:GiveTo(player,1);\n\n     end\nend",
							["uniqueAmount"] = 1,
						},
						["passphrases"] = {
							["icon"] = "INV_Inscription_Papyrus",
							["quality"] = "Common",
							["elType"] = "Item",
							["sessionName"] = "Demo Session",
							["tooltip"] = {
								{
									["lText"] = "<Right Click to Read>",
									["rb"] = 1,
									["rText"] = "",
									["rg"] = 1,
									["lb"] = 0,
									["lg"] = 1,
									["rr"] = 1,
									["lr"] = 0,
								}, -- [1]
							},
							["name"] = "Defias Passphrases",
							["document"] = {
								"Harbor warehouse:\n'Mice roar in the park'\n\nOld Town warehouse:\n'Wolves dine at midnight'\n\nMage Quarter warehouse:\n'Ducks run everywhere'", -- [1]
								["material"] = 1,
							},
							["enabled"] = true,
							["soulbound"] = true,
							["id"] = "passphrases",
							["useScriptText"] = "function(Item,player,x,y,targetName,targetGuid,targetDistance,targetHealth,targetSex)\n\nend",
							["uniqueAmount"] = 1,
						},
						["ring"] = {
							["icon"] = "INV_Jewelry_Ring_02",
							["quality"] = "Common",
							["elType"] = "Item",
							["sessionName"] = "Demo Session",
							["tooltip"] = {
								{
									["lText"] = "Use: Show the ring to a Stormwind City Guard, Stormwind City Patroller or Stormwind Harbor Guard",
									["lr"] = 0,
									["rText"] = "",
									["rr"] = 1,
									["lb"] = 0,
									["lg"] = 1,
									["rg"] = 1,
									["rb"] = 1,
								}, -- [1]
							},
							["name"] = "Defias Ring",
							["document"] = {
								["material"] = 1,
							},
							["enabled"] = true,
							["soulbound"] = true,
							["id"] = "ring",
							["useScriptText"] = "function(Item,player,x,y,targetName,targetGuid,targetDistance,targetHealth,targetSex)\nif(targetDistance>1)then\n     Session:SendErrorMessage(\"Out of range\",player)\n     return\nend\nif(targetName==\"Stormwind City Guard\" or targetName==\"Stormwind City Patroller\" or targetName==\"Stormwind Harbor Guard\")then\n    if(player.quests.corruptGuards[targetGuid]==nil)then\n       local corrupt=math.random(100)<20\n       if(corrupt)then\n           player.quests.corruptGuards[targetGuid]=true\n           Session:SendNPCMessageToPlayer(targetName,\"The %s gives you a knowing nod.\",\"emote\",player)\n           corruptGuards:Event(player,\"Script\",\"Q_corruptGuards_Obj1\")\n       else\n           player.quests.corruptGuards[targetGuid]=false\n           Session:SendNPCMessageToPlayer(targetName,\"The %s looks confused.\",\"emote\",player)\n       end\n    elseif(player.quests.corruptGuards[targetGuid]==true)then\n            Session:SendNPCMessageToPlayer(targetName,\"The %s gives you another knowing nod.\",\"emote\",player)\n    else\n             Session:SendNPCMessageToPlayer(targetName,\"The %s still doesn't know anything about the ring.\",\"emote\",player)\n    end\nend\nItem:Cooldown(player,2)\nend",
							["uniqueAmount"] = 1,
						},
						["certification"] = {
							["icon"] = "INV_Inscription_ArmorScroll01",
							["quality"] = "Epic",
							["elType"] = "Item",
							["sessionName"] = "Demo Session",
							["tooltip"] = {
								{
									["lText"] = "<Right Click to Read>",
									["lr"] = 0,
									["rText"] = "",
									["rr"] = 1,
									["lb"] = 0,
									["lg"] = 1,
									["rg"] = 1,
									["rb"] = 1,
								}, -- [1]
								{
									["lText"] = "\"You should probably frame self\"",
									["lr"] = 1,
									["rText"] = "",
									["rr"] = 1,
									["lb"] = 0.1,
									["lg"] = 0.7,
									["rg"] = 1,
									["rb"] = 1,
								}, -- [2]
							},
							["name"] = "Certification of Heroic Deeds",
							["document"] = {
								"<html><body>\n<h1 align=\"center\">Certification of Heroism</h1>\n<p align=\"center\">self is to certify that</p>\n<br/>\n<p align=\"center\">____________________</p>\n<br/>\n<p align=\"center\">has served the Kingdom of Stormwind in a heroic capacity</p>\n</body></html>", -- [1]
								["material"] = 3,
							},
							["enabled"] = true,
							["soulbound"] = true,
							["id"] = "certification",
							["useScriptText"] = "function(Item,player,x,y,targetName,targetGuid,targetDistance,targetHealth,targetSex)\n\nend",
							["uniqueAmount"] = 1,
						},
					},
					["name"] = "Demo Session",
					["newPlayerScriptText"] = "function(player)\n        local message=Session:GetWelcomeMessage()\n    message=SubSpecialChars(message,player)\n    \n    Session:SendSessionMessage(message,player)\n    introQuest:Offer(player);\nend",
				}