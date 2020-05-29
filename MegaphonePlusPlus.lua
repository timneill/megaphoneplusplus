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

Megaphone.Windows = {}
Megaphone.Windows.Main = "MegaphoneMain"
Megaphone.Windows.Marker = "MegaphoneMarker"

local leaderId = nil             -- The object ID of the leader
local chatNameFilter = ""        -- The player name to filter for in chat

local showLeaderName = true      -- Local checkbox setting for showing leader name in alert text
local highlightLeader = false    -- Local checkbox setting for highlighting leader

local function printMsg(str)
	EA_ChatWindow.Print(towstring("<LINK data=\"0\" text=\"[Megaphone++]\" color=\"255,255,50\"> " .. str))
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
    Megaphone.Settings.Sound = GameData.Sound.QUEST_COMPLETED
		Megaphone.Settings.ShowName = true
		Megaphone.Settings.Highlight = false
  end
  
  -- Cast to bool in case the settings are empty for this
  Megaphone.Settings.ShowName = not not Megaphone.Settings.ShowName
  Megaphone.Settings.Highlight = not not Megaphone.Settings.Highlight
  showLeaderName = Megaphone.Settings.ShowName
  highlightLeader = Megaphone.Settings.Highlight

  Megaphone.CreateWindows()
  
	RegisterEventHandler(SystemData.Events.CHAT_TEXT_ARRIVED, "Megaphone.FilterChat")
  RegisterEventHandler(SystemData.Events.BATTLEGROUP_UPDATED, "Megaphone.GroupUpdate")
  RegisterEventHandler(SystemData.Events.BATTLEGROUP_MEMBER_UPDATED, "Megaphone.GroupUpdate")
  RegisterEventHandler(SystemData.Events.INTERFACE_RELOADED, "Megaphone.GroupUpdate")
  RegisterEventHandler(SystemData.Events.GROUP_LEAVE, "Megaphone.Refresh")
  RegisterEventHandler(SystemData.Events.LOADING_END, "Megaphone.Refresh")
  RegisterEventHandler(SystemData.Events.PLAYER_ZONE_CHANGED, "Megaphone.Refresh")
  
	LibSlash.RegisterSlashCmd("megaphonepp", Megaphone.ShowConfig)
  LibSlash.RegisterSlashCmd("mppp", Megaphone.ShowConfig)
	
  printMsg("Type /megaphonepp or /mppp to show config.")
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.OnShutdown()
	UnregisterEventHandler(SystemData.Events.CHAT_TEXT_ARRIVED, "Megaphone.FilterChat")
  UnregisterEventHandler(SystemData.Events.BATTLEGROUP_UPDATED, "Megaphone.GroupUpdate")
  UnregisterEventHandler(SystemData.Events.BATTLEGROUP_MEMBER_UPDATED, "Megaphone.GroupUpdate")
  UnregisterEventHandler(SystemData.Events.INTERFACE_RELOADED, "Megaphone.GroupUpdate")
  UnregisterEventHandler(SystemData.Events.GROUP_LEAVE, "Megaphone.Refresh")
  UnregisterEventHandler(SystemData.Events.LOADING_END, "Megaphone.Refresh")
  UnregisterEventHandler(SystemData.Events.PLAYER_ZONE_CHANGED, "Megaphone.Refresh")
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.CreateWindows()
  CreateWindow(Megaphone.Windows.Main, true)
  Megaphone.HideWindow()

  CreateWindow(Megaphone.Windows.Marker, true)
  Megaphone.DetachMarker()
  
	LabelSetText(Megaphone.Windows.Main.."TitleBarText", L"Megaphone++")
  ButtonSetText(Megaphone.Windows.Main.."CloseButton", L"Close")
  ButtonSetText(Megaphone.Windows.Main.."TestButton", L"Test")
  
	Megaphone.OptionsInitExtra()
	Megaphone.OptionsInitSounds()
  Megaphone.OptionsInitFonts()
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.OptionsInitExtra()
	ButtonSetPressedFlag(Megaphone.Windows.Main.."ShowLeaderCheckbox", showLeaderName)
  LabelSetText(Megaphone.Windows.Main.."ShowLeaderLabel", L"Show Leader Name")
  
  ButtonSetPressedFlag(Megaphone.Windows.Main.."HighlightLeaderCheckbox", highlightLeader)
	LabelSetText(Megaphone.Windows.Main.."HighlightLeaderLabel", L"Highlight Leader")
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.OptionsInitSounds()
	LabelSetText(Megaphone.Windows.Main.."SFXTitleLabel", L"Alert Sound")
	for k, snd in ipairs(Megaphone.SoundTypes) do
	 	ComboBoxAddMenuItem(Megaphone.Windows.Main.."SFXComboBox", towstring(snd.name))
	end
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.OptionsInitFonts()
	LabelSetText(Megaphone.Windows.Main.."FontTitleLabel", L"Alert Text Style")
	for k, fnt in ipairs(Megaphone.AlertText) do
	 	ComboBoxAddMenuItem(Megaphone.Windows.Main.."FontComboBox", towstring(fnt.name))
	end
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.ShowConfig()
	ComboBoxSetSelectedMenuItem(Megaphone.Windows.Main.."SFXComboBox", Megaphone.IndexFromId(Megaphone.SoundTypes, Megaphone.Settings.Sound))
	ComboBoxSetSelectedMenuItem(Megaphone.Windows.Main.."FontComboBox", Megaphone.IndexFromId(Megaphone.AlertText, Megaphone.Settings.Font))
	WindowSetShowing(Megaphone.Windows.Main, true)
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.HighlightLeaderToggle()
  highlightLeader = not highlightLeader
  ButtonSetPressedFlag(Megaphone.Windows.Main.."HighlightLeaderCheckbox", highlightLeader)
  Megaphone.SaveSettings()
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.ShowLeaderToggle()
  showLeaderName = not showLeaderName
  ButtonSetPressedFlag(Megaphone.Windows.Main.."ShowLeaderCheckbox", showLeaderName)
  Megaphone.SaveSettings()
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.TestAlert()
  Megaphone.ShowNotification(L"Sigmar", L"It is on the anvil of pain that the gods forge heroes")
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.HideWindow()
	WindowSetShowing(Megaphone.Windows.Main, false)
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.SaveSettings()
	Megaphone.Settings.Font = Megaphone.AlertText[ComboBoxGetSelectedMenuItem(Megaphone.Windows.Main.."FontComboBox")].id
  Megaphone.Settings.Sound = Megaphone.SoundTypes[ComboBoxGetSelectedMenuItem(Megaphone.Windows.Main.."SFXComboBox")].id
  Megaphone.Settings.ShowName = ButtonGetPressedFlag(Megaphone.Windows.Main.."ShowLeaderCheckbox")
  Megaphone.Settings.Highlight = ButtonGetPressedFlag(Megaphone.Windows.Main.."HighlightLeaderCheckbox")

  -- Update to refresh marker if applicable
  Megaphone.Refresh()
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.GroupUpdate()
	Megaphone.AssignLeader()
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
  local lastKnownLeader = chatNameFilter

  -- Get the leader object and see if their name matches our current filter or not
  local leader = Megaphone.FindLeader()
  
  if leader ~= nil then
    chatNameFilter = Megaphone.CleanPlayerName(leader.name)
    leaderId = leader.worldObjNum
  
    if not leaderId then
      Megaphone.DetachMarker()
    end
  
      -- Comparing IDs breaks if the leader is out of range. Use the name instead
    if lastKnownLeader ~= chatNameFilter then
      printMsg("Found leader - " .. WStringToString(chatNameFilter))
      Megaphone.AttachMarkerToPlayer()
    end
  end
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.FindLeader()
  local wb = PartyUtils.GetWarbandData()
  
	for _, grp in ipairs(wb) do
		for _, player in ipairs(grp.players) do
      if player.isGroupLeader then
        return player
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

	if chatSender == chatNameFilter then 
		-- Include only group-type chats
    	if chatType == SystemData.ChatLogFilters.GROUP or chatType == SystemData.ChatLogFilters.BATTLEGROUP or chatType == SystemData.ChatLogFilters.SCENARIO_GROUPS then
			  Megaphone.ShowNotification(chatSender, chatText)
		  end
	end
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.ShowNotification(chatSender, chatText)
  if (Megaphone.Settings.Sound ~= nil) then
    PlaySound(Megaphone.Settings.Sound)
  end
  
  if (Megaphone.Settings.Font == nil) then
    return
  end
	
	if Megaphone.Settings.ShowName then
		chatText = chatSender .. L": " .. chatText
  end

  AlertTextWindow.AddLine(Megaphone.Settings.Font, chatText)
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


----------------------------------------------------------------
function Megaphone.AttachMarkerToPlayer()
  if not Megaphone.Settings.Highlight then
    Megaphone.DetachMarker()
  elseif not leaderId then
    Megaphone.DetachMarker()
  else
    AttachWindowToWorldObject(Megaphone.Windows.Marker, leaderId)
    WindowSetShowing(Megaphone.Windows.Marker, true)
  end
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.DetachMarker()
  WindowSetShowing(Megaphone.Windows.Marker, false)
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.ResetMarker()
  Megaphone.DetachMarker()
  leaderId = nil
end
----------------------------------------------------------------


----------------------------------------------------------------
function Megaphone.Refresh()
  Megaphone.ResetMarker()
  chatNameFilter = ""
	Megaphone.GroupUpdate()
end
----------------------------------------------------------------