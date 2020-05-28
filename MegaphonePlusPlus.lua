--[[ 
Megaphone Plus Plus
Warhammer Online: Age of Reckoning UI modification that announces the
messages from the group's leader.
    
Copyright (C) 2020  Tim Neill
kinghfb@gmail.com		timneill.net

Original by Richard Conner rkc@pacbell.net

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]--

----------------------------------------------------------------
Megaphone = {}

Megaphone.Options = {}
Megaphone.Options.Window = "MegaphoneMain"

local playerFilter
local showLeaderName = true

local function printMsg(str)
	EA_ChatWindow.Print(towstring("<LINK data=\"0\" text=\"[Megaphone++]\" color=\"255,50,50\"> " .. str))
end
----------------------------------------------------------------
-- Taken from GesConstants
Megaphone.AlertText = {
	{ id = nil                                                   , name = "Do not alert" }
  , { id = SystemData.AlertText.Types.DEFAULT                    , name = "Default" }
  , { id = SystemData.AlertText.Types.COMBAT                     , name = "Combat" }
  , { id = SystemData.AlertText.Types.QUEST_NAME                 , name = "Quest Name" }
  , { id = SystemData.AlertText.Types.QUEST_CONDITION            , name = "Quest Condition" }
  , { id = SystemData.AlertText.Types.QUEST_END                  , name = "Quest End" }
  , { id = SystemData.AlertText.Types.OBJECTIVE                  , name = "Objective" }
  , { id = SystemData.AlertText.Types.RVR                        , name = "RvR" }
  , { id = SystemData.AlertText.Types.SCENARIO                   , name = "Scenario" }
  , { id = SystemData.AlertText.Types.MOVEMENT_RVR               , name = "Movement RvR" }
  , { id = SystemData.AlertText.Types.ENTERAREA                  , name = "Enter Area" }
  , { id = SystemData.AlertText.Types.STATUS_ERRORS              , name = "Status Errors" }
  , { id = SystemData.AlertText.Types.STATUS_ACHIEVEMENTS_GOLD   , name = "Status Achievements Gold"   }
  , { id = SystemData.AlertText.Types.STATUS_ACHIEVEMENTS_PURPLE , name = "Status Achievements Purple" }
  , { id = SystemData.AlertText.Types.STATUS_ACHIEVEMENTS_RANK   , name = "Status Achievements Rank"   }
  , { id = SystemData.AlertText.Types.STATUS_ACHIEVEMENTS_RENOUN , name = "Status Achievements Renown" }
  , { id = SystemData.AlertText.Types.PQ_ENTER                   , name = "PQ Enter" }
  , { id = SystemData.AlertText.Types.PQ_NAME                    , name = "PQ Name" }
  , { id = SystemData.AlertText.Types.PQ_DESCRIPTION             , name = "PQ Description" }
  , { id = SystemData.AlertText.Types.ENTERZONE                  , name = "Enter Zone" }
  , { id = SystemData.AlertText.Types.ORDER                      , name = "Order" }
  , { id = SystemData.AlertText.Types.DESTRUCTION                , name = "Destruction" }
  , { id = SystemData.AlertText.Types.NEUTRAL                    , name = "Neutral" }
  , { id = SystemData.AlertText.Types.ABILITY                    , name = "Ability" }
  , { id = SystemData.AlertText.Types.BO_ENTER                   , name = "BO Enter" }
  , { id = SystemData.AlertText.Types.BO_NAME                    , name = "BO Name" }
  , { id = SystemData.AlertText.Types.BO_DESCRIPTION             , name = "BO Description" }
  , { id = SystemData.AlertText.Types.ENTER_CITY                 , name = "Enter City" }
  , { id = SystemData.AlertText.Types.CITY_RATING                , name = "City Rating" }
  , { id = SystemData.AlertText.Types.GUILD_RANK                 , name = "Guild Rank" }
  , { id = SystemData.AlertText.Types.RRQ_UNPAUSED               , name = "RRQ Unpaused" }
  , { id = SystemData.AlertText.Types.LARGE_ORDER                , name = "Large Order" }
  , { id = SystemData.AlertText.Types.LARGE_DESTRUCTION          , name = "Large Destruction" }
  , { id = SystemData.AlertText.Types.LARGE_NEUTRAL              , name = "Large Neutral" }
}

Megaphone.SoundTypes = {
	{ id = nil                                           , name = "Do not play a sound"}
  , { id = GameData.Sound.ACTION_FAILED                  , name = "Action Failed"}
  , { id = GameData.Sound.ADVANCE_RANK                   , name = "Advance Rank"}
  , { id = GameData.Sound.ADVANCE_TIER                   , name = "Advance Tier"}
  , { id = GameData.Sound.APOTHECARY_ADD_FAILED          , name = "Apothecary Add Failed"}
  , { id = GameData.Sound.APOTHECARY_BREW_STARTED        , name = "Apothecary Brew Started"}
  , { id = GameData.Sound.APOTHECARY_CONTAINER_ADDED     , name = "Apothecary Container Added"}
  , { id = GameData.Sound.APOTHECARY_DETERMINENT_ADDED   , name = "Apothecary Determinent Added"}
  , { id = GameData.Sound.APOTHECARY_FAILED              , name = "Apothecary Failed"}
  , { id = GameData.Sound.APOTHECARY_ITEM_REMOVED        , name = "Apothecary Item Removed"}
  , { id = GameData.Sound.APOTHECARY_RESOURCE_ADDED      , name = "Apothecary Resource Added"}
  , { id = GameData.Sound.BETA_WARNING                   , name = "Beta Warning"}
  , { id = GameData.Sound.BUTTON_CLICK                   , name = "Button Click"}
  , { id = GameData.Sound.BUTTON_OVER                    , name = "Button Over"}
  , { id = GameData.Sound.CULTIVATING_HARVEST_CROP       , name = "Cultivating Harvest Crop"}
  , { id = GameData.Sound.CULTIVATING_NUTRIENT_ADDED     , name = "Cultivating Nutrient Added"}
  , { id = GameData.Sound.CULTIVATING_SEED_ADDED         , name = "Cultivating Seed Added"}
  , { id = GameData.Sound.CULTIVATING_SOIL_ADDED         , name = "Cultivating Soil Added"}
  , { id = GameData.Sound.CULTIVATING_WATER_ADDED        , name = "Cultivating Water Added"}
  , { id = GameData.Sound.ICON_CLEAR                     , name = "Icon Clear"}
  , { id = GameData.Sound.ICON_DROP                      , name = "Icon Drop"}
  , { id = GameData.Sound.ICON_PICKUP                    , name = "Icon Pickup"}
  , { id = GameData.Sound.LOOT_MONEY                     , name = "Loot Money"}
  , { id = GameData.Sound.MONETARY_TRANSACTION           , name = "Monetary Transaction"}
  , { id = GameData.Sound.OBJECTIVE_CAPTURE              , name = "Objective Capture"}
  , { id = GameData.Sound.OBJECTIVE_LOSE                 , name = "Objective Lose"}
  , { id = GameData.Sound.PREGAME_PLAY_GAME_BUTTON       , name = "Pregame Play Game Button"}
  , { id = GameData.Sound.PUBLIC_TOME_UNLOCKED           , name = "Public Tome Unlocked"}
  , { id = GameData.Sound.QUEST_ABANDONED                , name = "Quest Abandoned"}
  , { id = GameData.Sound.QUEST_ACCEPTED                 , name = "Quest Accepted"}
  , { id = GameData.Sound.QUEST_COMPLETED                , name = "Quest Completed"}
  , { id = GameData.Sound.QUEST_OBJECTIVES_COMPLETED     , name = "Quest Objective Complete"}
  , { id = GameData.Sound.RESPAWN                        , name = "Respawn"}
  , { id = GameData.Sound.RVR_FLAG_OFF                   , name = "RvR Flag Off"}
  , { id = GameData.Sound.RVR_FLAG_ON                    , name = "RvR Flag On"}
  , { id = GameData.Sound.TARGET_DESELECT                , name = "Target Deselect"}
  , { id = GameData.Sound.TARGET_SELECT                  , name = "Target Select"}
  , { id = GameData.Sound.TOME_TURN_PAGE                 , name = "Tome Turn Page"}
  , { id = GameData.Sound.WINDOW_CLOSE                   , name = "Window Close"}
  , { id = GameData.Sound.WINDOW_OPEN                    , name = "Window Open"}
  , { id = GameData.Sound.CLOSE_WORLD_MAP                , name = "World Map Close"}
  , { id = GameData.Sound.OPEN_WORLD_MAP                 , name = "World Map Open"}	          
}
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.Initialize()
	if not Megaphone.Settings then
		Megaphone.Settings = {}
		Megaphone.Settings.Font = SystemData.AlertText.Types.QUEST_END
		Megaphone.Settings.ShowName = true
		Megaphone.Settings.Sound = GameData.Sound.QUEST_COMPLETED
  end
  
  -- Cast to bool in case the settings are empty for this
  Megaphone.Settings.ShowName = not not Megaphone.Settings.ShowName
  showLeaderName = Megaphone.Settings.ShowName

  Megaphone.CreateWindow()
  
	RegisterEventHandler(SystemData.Events.CHAT_TEXT_ARRIVED, "Megaphone.FilterChat");
	RegisterEventHandler(SystemData.Events.GROUP_UPDATED, "Megaphone.GroupUpdate");
	RegisterEventHandler(SystemData.Events.BATTLEGROUP_UPDATED, "Megaphone.GroupUpdate");
	RegisterEventHandler(SystemData.Events.INTERFACE_RELOADED, "Megaphone.GroupUpdate");
	RegisterEventHandler(SystemData.Events.GROUP_LEAVE, "Megaphone.Clear");
	RegisterEventHandler(SystemData.Events.GROUP_PLAYER_ADDED, "Megaphone.GroupPlayerAdd");
  
	LibSlash.RegisterSlashCmd("megaphonepp", Megaphone.ShowConfig)
  LibSlash.RegisterSlashCmd("mppp", Megaphone.ShowConfig)
	
  printMsg("Type /megaphonepp or /mppp to show config.")
end
----------------------------------------------------------------

function Megaphone.OnShutdown()
	UnregisterEventHandler(SystemData.Events.CHAT_TEXT_ARRIVED, "Megaphone.FilterChat");
	UnregisterEventHandler(SystemData.Events.GROUP_UPDATED, "Megaphone.GroupUpdate");
	UnregisterEventHandler(SystemData.Events.BATTLEGROUP_UPDATED, "Megaphone.GroupUpdate");
	UnregisterEventHandler(SystemData.Events.INTERFACE_RELOADED, "Megaphone.GroupUpdate");
	UnregisterEventHandler(SystemData.Events.GROUP_LEAVE, "Megaphone.Clear");
	UnregisterEventHandler(SystemData.Events.GROUP_PLAYER_ADDED, "Megaphone.GroupPlayerAdd");
end

----------------------------------------------------------------
function Megaphone.CreateWindow()
	CreateWindow(Megaphone.Options.Window, true)
	Megaphone.HideWindow()
  
	LabelSetText(Megaphone.Options.Window.."TitleBarText", L"Megaphone++")
	ButtonSetText(Megaphone.Options.Window.."SaveButton", L"Save")	 
	ButtonSetText(Megaphone.Options.Window.."CloseButton", L"Close")
  
	Megaphone.OptionsInitExtra()
	Megaphone.OptionsInitSounds()
	Megaphone.OptionsInitFonts()
end

function Megaphone.OptionsInitExtra()
	ButtonSetPressedFlag(Megaphone.Options.Window.."ShowLeaderCheckbox", showLeaderName)
	LabelSetText(Megaphone.Options.Window.."ShowLeaderLabel", L"Show Leader Name")
end

function Megaphone.OptionsInitSounds()
	LabelSetText(Megaphone.Options.Window.."SFXTitleLabel", L"Alert Sound");
	for k, snd in ipairs(Megaphone.SoundTypes) do
	 	ComboBoxAddMenuItem(Megaphone.Options.Window.."SFXComboBox", towstring(snd.name))
	end
end

function Megaphone.OptionsInitFonts()
	LabelSetText(Megaphone.Options.Window.."FontTitleLabel", L"Alert Text Style");
	for k, fnt in ipairs(Megaphone.AlertText) do
	 	ComboBoxAddMenuItem(Megaphone.Options.Window.."FontComboBox", towstring(fnt.name))
	end
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.ShowConfig()
	ComboBoxSetSelectedMenuItem(Megaphone.Options.Window.."SFXComboBox", Megaphone.IndexFromId(Megaphone.SoundTypes, Megaphone.Settings.Sound))
	ComboBoxSetSelectedMenuItem(Megaphone.Options.Window.."FontComboBox", Megaphone.IndexFromId(Megaphone.AlertText, Megaphone.Settings.Font))
	WindowSetShowing(Megaphone.Options.Window, true)
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.ShowLeaderToggle()
  showLeaderName = not showLeaderName
	ButtonSetPressedFlag(Megaphone.Options.Window.."ShowLeaderCheckbox", showLeaderName)
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.HideWindow()
	WindowSetShowing(Megaphone.Options.Window, false)
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.SaveSettings()
	Megaphone.Settings.Font = Megaphone.AlertText[ComboBoxGetSelectedMenuItem(Megaphone.Options.Window.."FontComboBox")].id
	Megaphone.Settings.ShowName = ButtonGetPressedFlag(Megaphone.Options.Window.."ShowLeaderCheckbox")
  Megaphone.Settings.Sound = Megaphone.SoundTypes[ComboBoxGetSelectedMenuItem(Megaphone.Options.Window.."SFXComboBox")].id
  printMsg("Settings updated.")
  Megaphone.HideWindow()
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.Clear()
	playerFilter = Megaphone.CleanPlayerName("x");
	printMsg("Cleared Leader.");
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.GroupPlayerAdd()
	Megaphone.AssignLeader();
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.GroupUpdate()
	Megaphone.AssignLeader();
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.IndexFromId(table, id)
  -- Given an ID, find the index of that item in a table
  for k, item in ipairs(table) do
    if (item.id == id) then
      return k
    end
 end

 return 0
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.AssignLeader()
  local lastKnownLeader = playerFilter;
	playerFilter = Megaphone.FindLeader()

  if (playerFilter == nil) then
      playerFilter = lastKnownLeader;
  end

  if (playerFilter ~= lastKnownLeader) then
      printMsg("Found new leader - " .. WStringToString(playerFilter))
  end
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.FindLeader()
  local wb = PartyUtils.GetWarbandData()
  
	for _, grp in ipairs(wb) do
		for _, player in ipairs(grp.players) do
      if player.isGroupLeader then
				return Megaphone.CleanPlayerName(player.name)
			end
		end
  end
  
  return nil
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.FilterChat()
	local chatType = GameData.ChatData.type
	local chatSender = Megaphone.CleanPlayerName(GameData.ChatData.name)
	local chatText = GameData.ChatData.text

	if chatSender == playerFilter then 
		-- Include only group-type chats
    	if chatType == SystemData.ChatLogFilters.GROUP or chatType == SystemData.ChatLogFilters.BATTLEGROUP or chatType == SystemData.ChatLogFilters.SCENARIO_GROUPS then
			  Megaphone.ShowNotification(chatSender, chatText)
		  end
	end
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.ShowNotification(chatSender, chatText)
	PlaySound(Megaphone.Settings.Sound);
	
	if Megaphone.Settings.ShowName then
		chatText = chatSender .. L": " .. chatText
  end
  
  AlertTextWindow.AddLine(Megaphone.Settings.Font, chatText);
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.CleanPlayerName(playerName)
  if not playerName then
    return ""
  end

  local cleanPlayerName = wstring.gsub(playerName, L"%^%a,in", L"")

  if cleanPlayerName == "" then
		return ""
  end
  
	cleanPlayerName = wstring.gsub(towstring(cleanPlayerName), L"%^%a", L"")

	return cleanPlayerName
end
----------------------------------------------------------------
