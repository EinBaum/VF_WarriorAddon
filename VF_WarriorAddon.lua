--VF_WarriorAddon
--Written by Dilatazu @ EmeraldDream @ www.EmeraldDream.com / www.wow-one.com

VF_WA_Version = "1.0";

function VF_WA_OnLoad()
	--this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
end

g_DebugMode = false;

function VF_WA_DebugPrint(theText)
	if(g_DebugMode == true) then
		DEFAULT_CHAT_FRAME:AddMessage(theText, 1, 1, 0);
	end
end

g_CurrTime = 0;

VF_ShieldWallTime = 15;

function VF_GetBuffCount(unitID, buffIcon)
	for u = 1, 16 do
		local buffIconPath, buffCount = UnitBuff(unitID, u);
		if(buffIconPath) then
			if(strfind(buffIconPath, buffIcon) ~= nil) then
				return buffCount;
			end
		end
	end
	return 0;
end

function VF_WA_OnEvent()
	if(event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS") then
		local _, _, gainWhat = string.find(arg1, "You gain (.*).");
		if(gainWhat ~= nil) then
			if(gainWhat == "Last Stand") then
				SendChatMessage("Last Stand is activated for 20 seconds!", "RAID");
				SendChatMessage("Last Stand is activated for 20 seconds!", "PARTY");
			elseif(gainWhat == "Shield Wall") then
				SendChatMessage("Shield Wall is activated for "..VF_ShieldWallTime.." seconds!", "RAID");
				SendChatMessage("Shield Wall is activated for "..VF_ShieldWallTime.." seconds!", "PARTY");
			else
				VF_WA_DebugPrint("I gained "..gainWhat);
			end
		else
			VF_WA_DebugPrint("UNPARSED1: "..arg1);
		end
	elseif(event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE") then
		--[[local _, _, creature, spellEffect = string.find(arg1, "(.*) is afflicted by (.*).");
		if(creature ~= nil and spellEffect ~= nil) then
			if(spellEffect == "Taunt") then
				g_TauntCastTime = -1;
			elseif(spellEffect == "Challenging Shout") then
				g_ChallengingShoutCastTime = -1;
			elseif(spellEffect == "Mocking Blow") then
				VF_WA_DebugPrint("This message should never be shown!");
			else
				VF_WA_DebugPrint(spellEffect.." on "..creature.." was successful!");
			end
		else
			VF_WA_DebugPrint("UNPARSED2: "..arg1);
		end--]]
	elseif(event == "CHAT_MSG_SPELL_SELF_DAMAGE") then
		local actionStatus = "Hit";
		local _, _, spellEffect, creature, dmg = string.find(arg1, "Your (.*) hits (.*) for (.*).");
		
		if(spellEffect == nil or creature == nil or dmg == nil) then
			_, _, spellEffect, creature, dmg = string.find(arg1, "Your (.*) crits (.*) for (.*).");
			actionStatus = "Crit";
		end
		
		if(spellEffect == nil or creature == nil or dmg == nil) then
			_, _, spellEffect, creature = string.find(arg1, "Your (.*) was resisted by (.*).");
			dmg = 0;
			actionStatus = "Resist";
		end
		
		if(spellEffect == nil or creature == nil or dmg == nil) then
			_, _, spellEffect, creature = string.find(arg1, "Your (.*) missed (.*).");
			dmg = 0;
			actionStatus = "Miss";
		end
		
		if(spellEffect == nil or creature == nil or dmg == nil) then
			_, _, spellEffect, creature = string.find(arg1, "Your (.*) was dodged by (.*).");
			dmg = 0;
			actionStatus = "Dodge";
		end
		
		if(spellEffect == nil or creature == nil or dmg == nil) then
			actionStatus = "Unknown";
		end
		if((actionStatus == "Miss" or actionStatus == "Resist" or actionStatus == "Dodge") and spellEffect == "Mocking Blow") then
			SendChatMessage("Mocking Blow Resisted!", "RAID");
			SendChatMessage("Mocking Blow Resisted!", "PARTY");
		elseif(actionStatus == "Resist" and spellEffect == "Taunt") then
			SendChatMessage("Taunt Resisted!", "RAID");
			SendChatMessage("Taunt Resisted!", "PARTY");
		elseif(actionStatus == "Resist" and spellEffect == "Challenging Shout") then
			SendChatMessage("Challenging Shout Resisted!", "RAID");
			SendChatMessage("Challenging Shout Resisted!", "PARTY");
		elseif(actionStatus == "Unknown") then
			VF_WA_DebugPrint("UNPARSED3: "..arg1);
		end
	elseif(event == "VF_INSTANT_SUCCESSFULL_SPELLCAST") then
		VF_WA_DebugPrint("Instant Cast Spell: "..arg1);
	else
		if(arg1 == nil) then
			VF_WA_DebugPrint("UNPARSED4: "..event);
		else
			VF_WA_DebugPrint("UNPARSED4: "..event..arg1);
		end
	end
	--AURAADDEDOTHERHARMFUL == %s is afflicted by %s.
end

function VF_WA_OnUpdate()
	g_CurrTime = GetTime();
end
