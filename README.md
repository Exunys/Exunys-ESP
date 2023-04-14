# 🌌 Exunys ESP [![Visitors](https://visitor-badge.glitch.me/badge?page_id=Exunys.Exunys-ESP)](https://github.com/Exunys/Exunys-ESP)

## In beta testing, documentation soon...

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()

-- This loads the module's environment which identificator is "ExunysDeveloperESP".
-- With that you can proceed to change the settings.

-- The table has a metatable attached to it with a __call metamethod that loads a crosshair and wraps every player in the game automatically.
-- Meaning, you can just call the table, example:

ExunysDeveloperESP()
```
Previews:

![image](https://user-images.githubusercontent.com/76539058/232103151-42664a64-a942-46ad-8883-ae1fe1ac7e81.png) (ESP with factory settings)

![image](https://user-images.githubusercontent.com/76539058/232103294-e79b6c64-c655-4df7-ad70-6db4e5f66f54.png) (Crosshair with factory settings)

https://user-images.githubusercontent.com/76539058/232102118-14961c64-bb39-41aa-8b6a-d5af3ef5f922.mp4

The settings for the video above:

```lua
ExunysDeveloperESP.RenderCrosshair()

ExunysDeveloperESP.DeveloperSettings.RainbowSpeed = 2.5

ExunysDeveloperESP.Properties.Crosshair.RainbowColor = true
ExunysDeveloperESP.Properties.Crosshair.Position = 2

ExunysDeveloperESP.Properties.Crosshair.Size = 18
ExunysDeveloperESP.Properties.Crosshair.Thickness = 2

ExunysDeveloperESP.Properties.Crosshair.Rotate = true
ExunysDeveloperESP.Properties.Crosshair.RotateClockwise = false
ExunysDeveloperESP.Properties.Crosshair.RotationSpeed = 10

ExunysDeveloperESP.Properties.Crosshair.PulseGap = true
ExunysDeveloperESP.Properties.Crosshair.PulsingBounds = {0, 24}

ExunysDeveloperESP.Properties.Crosshair.CenterDot.Color = Color3.fromHex("#FFFFFF")
```
