# Megaphone++
Warhammer Online: Age of Reckoning UI modification that announces the messages from the group's leader.

## Description
Have you ever been in a warband and find yourself sitting alone in a zone wondering where you're supposed to be? This plugin helps you stay informed on the warband's plans by announcing the leader's text on screen so you don't have to keep scanning the chat window. 

## Installation
Simply unzip the addon contents and place in your add directory. This is probably something like:

```
<ROR Install Dir>/Interface/AddOns/
```

Once it's there, you can enable it from the mods menu in-game.

## Configuration
You can open the plugin's configuration window by using `/megaphonepp` or `/mppp`.

![Configuration window](docs/mppp-config.jpg?raw=true "Configuration window")

### Alert
You can configure the alert font style and alert sound using the dropdowns. You can check the current display and sound combination by using the "test" button. You can also optionally prefix the message with the leader's name, should you forget who you're supposed to be listening to.

**Note** that the alert text area in the game has an upper limit of 600 recent messages, and that subsequent messages will push others off screen. You may need to wait a few seconds if you find your tests disappear.

![Alert example](docs/mppp-alert.jpg?raw=true "Alert example")

### Highlight Leader
As a secondary function, you have the ability to place a marker over the current warband leader. This is useful to find them in a crowd, which you may need to do if you get the vague command "follow me" in a collection of roaming warbands. It is also useful if you find yourself suddenly in charge of the pug.

![Highlight leader example](docs/mppp-highlight.jpg?raw=true "Highlight leader example")

## Known Issues
* Due to the way Mythic handles world objects, it is possible to lose track of the leader's highlight marker, causing it to incorrectly display. There are a number of edge-case workarounds in the code to address this. This is a global problem that affects all plugins that add additional information such as GES, Enemy, Effigy, and Buffhead, so it is unlikely to be fixed.
