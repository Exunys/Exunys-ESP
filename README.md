# 🌌 Exunys ESP [![Visitors](https://visitor-badge.laobi.icu/badge?page_id=Exunys.Exunys-ESP)](https://exunys.gitbook.io/exunys-esp-documentation)

This project represents a collection of visuals / wall hacks (Tracers, ESP, Boxes, Head Dots, Chams & Crosshair). This script is also undetected because it uses [Synapse X's Drawing Library](https://docs.synapse.to/docs/reference/drawing_lib.html). It has modulized support for NPCs & parts and it offers a very simple and easy to use wrapping and unwrapping system.

This project's source is optimized, organized and simplified to the maximal level to be executive, fast, stable and precise.

This project is in beta testing, feel free to create pull requests (you will get credited), issues or just contact me on any of my linked platforms.

This project has been inspired from [AirHub](https://github.com/Exunys/AirHub) which has an improved version of my [old examplery discontinued wall hack script](https://github.com/Exunys/Wall-Hack). It has a CS:GO-styled look which looks beautiful for fps games.

This project is used in the new [AirHub V2](https://github.com/Exunys/AirHub-V2) where you can use and edit the configuration through a GUI (it also includes a really fast Aimbot).

### ❗ Notice
This project has been written and tested with and only with [Synapse X](https://x.synapse.to) however, I will attempt my best to modulize support for every exploit. So far, the required functions for this module to run will be listed below:

<details> <summary> Dependencies (required functions & libraries): </summary>

- Libraries:
    - **Drawing**
        - Drawing.new *(function)*
        - Drawing.Fonts *(table)*
    - **debug**
        - debug.getupvalue *(function)*

- Functions:
    - **getgenv**
    - **getrawmetatable**
    - **gethiddenproperty**
</details>

This project also uses [Exunys' Config Library](https://github.com/Exunys/Config-Library) as a way of storing user settings, meaning, your script executor must support the dependencies for the module if you want the *configuration storing & loading functions* in the ESP module to function.

### 📜 License
This project is completely free and open sourced. But, that does not mean you own rights to it. Read this [document](https://github.com/Exunys/Exunys-ESP/blob/main/LICENSE) for more information.
You can re-use / stitch this script or any system of this project into any of your repositories, as long as you credit the developer [Exunys](https://github.com/Exunys).

## 📑 Update log (DD/MM/YYYY): 

<details> <summary> 14/04/2023 </summary>

- [**v1.0b**] First (BETA) release </details> <details> <summary> 15/04/2023 </summary>
- [**v1.0.3b**] Optimizations, bug fixes, silenced errors </details> <details> <summary> 18/04/2023 </summary>
- [**v1.0.8b**] Optimizations & bug fixes, added distance parameter for wrapping </details> <details> <summary> 19/04/2023 </summary>
- [**v1.1.1b**] Optimizations, bug fixes, improved `Restart` interactive method, added new core function for getting the local users's positions and more... </details> <details> <summary> 31/08/2023 </summary>
- [**v1.1.3b**] Added a variable that changes the teammates' visuals' color to differ from the enemies (team color) and made the script return the environment </details>

# 📋 Documentation

### The documentation for the interactive functions of this module can be found by clicking [here](https://exunys.gitbook.io/exunys-esp-documentation/) or at the following link:
### https://exunys.gitbook.io/exunys-esp-documentation/

More detailed information for this project will be documented by time in this README.md document.

# 👋 Introduction

First of all, to implement the module in your script's environment you must use the function `loadstring` like below:
```lua
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()
-- ESPLibrary and ExunysDeveloperESP is equivalent
```
The code above loads the module's environment in your script executor's global environment meaning it will be achivable across every script.

The identificator for the environment is `ExunysDeveloperESP` which is a table that has configurable settings and interactive user functions.

The table loaded into the exploit's global environment by the module has a [*metatable*](https://create.roblox.com/docs/scripting/luau/metatables) set to it with a **__call** metamethod, meaning you can call the table which would wrap every player in the game and render a crosshair.
```lua
ExunysDeveloperESP()
-- or
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()()
```
This is equivalent to the `Load` function (which would be more optimized and faster).
```lua
ExunysDeveloperESP.Load()
```

This module has customizable settings for every drawing property and other miscellaneous properties with unique functions. You can see the configurable settings below.

<details> <summary> The script's configurable settings </summary>

```lua
getgenv().ExunysDeveloperESP = {
	DeveloperSettings = {
		Path = "Exunys Developer/Exunys ESP/Configuration.cfg",
		UnwrapOnCharacterAbsence = false,
		UpdateMode = "RenderStepped",
		TeamCheckOption = "TeamColor",
		RainbowSpeed = 1, -- Bigger = Slower
		WidthBoundary = 1.5 -- Smaller Value = Bigger Width
	},

	Settings = {
		Enabled = true,
		PartsOnly = false,
		TeamCheck = false,
		AliveCheck = true,
		LoadConfigOnLaunch = true,
		EnableTeamColors = false,
		TeamColor = Color3.fromRGB(170, 170, 255)
	},

	Properties = {
		ESP = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,
			Offset = 10,

			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
			Size = 14,
			Font = DrawingFonts.System, -- UI, System, Plex, Monospace

			OutlineColor = Color3.fromRGB(0, 0, 0),
			Outline = true,

			DisplayDistance = true,
			DisplayHealth = false,
			DisplayName = false,
			DisplayDisplayName = true,
			DisplayTool = true
		},

		Tracer = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,
			Position = 1, -- 1 = Bottom; 2 = Center; 3 = Mouse

			Transparency = 1,
			Thickness = 1,
			Color = Color3.fromRGB(255, 255, 255),

			Outline = true,
			OutlineColor = Color3.fromRGB(0, 0, 0)
		},

		HeadDot = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,

			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
			Thickness = 1,
			NumSides = 30,
			Filled = false,

			OutlineColor = Color3.fromRGB(0, 0, 0),
			Outline = true
		},

		Box = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,

			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
			Thickness = 1,
			Filled = false,

			OutlineColor = Color3.fromRGB(0, 0, 0),
			Outline = true
		},

		HealthBar = {
			Enabled = true,
			RainbowOutlineColor = false,
			Offset = 4,
			Blue = 100,
			Position = 3, -- 1 = Top; 2 = Bottom; 3 = Left; 4 = Right

			Thickness = 1,
			Transparency = 1,

			OutlineColor = Color3.fromRGB(0, 0, 0),
			Outline = true
		},

		Chams = {
			Enabled = false, -- Keep disabled, broken, WIP...
			RainbowColor = false,

			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 0.2,
			Thickness = 1,
			Filled = true
		},

		Crosshair = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,
			TStyled = false,
			Position = 1, -- 1 = Mouse; 2 = Center

			Size = 12,
			GapSize = 6,
			Rotation = 0,

			Rotate = false,
			RotateClockwise = true,
			RotationSpeed = 5,

			PulseGap = false,
			PulsingStep = 10,
			PulsingSpeed = 5,
			PulsingBounds = {4, 8}, -- {...}[1] => GapSize Min; {...}[2] => GapSize Max

			Color = Color3.fromRGB(0, 255, 0),
			Thickness = 1,
			Transparency = 1,

			OutlineColor = Color3.fromRGB(0, 0, 0),
			Outline = true,

			CenterDot = {
				Enabled = true,
				RainbowColor = false,
				RainbowOutlineColor = false,

				Radius = 2,

				Color = Color3.fromRGB(0, 255, 0),
				Transparency = 1,
				Thickness = 1,
				NumSides = 60,
				Filled = false,

				OutlineColor = Color3.fromRGB(0, 0, 0),
				Outline = true
			}
		}
	}

	-- The rest is core data for the functionality of the module...
}
```
</details>

<details> <summary> Previews </summary>

![image](https://user-images.githubusercontent.com/76539058/232103151-42664a64-a942-46ad-8883-ae1fe1ac7e81.png) (ESP with factory settings)

![image](https://user-images.githubusercontent.com/76539058/232103294-e79b6c64-c655-4df7-ad70-6db4e5f66f54.png) (Crosshair with factory settings)

https://user-images.githubusercontent.com/76539058/232102118-14961c64-bb39-41aa-8b6a-d5af3ef5f922.mp4

The settings for the video above:

```lua
ExunysDeveloperESP.RenderCrosshair()

ExunysDeveloperESP.DeveloperSettings.RainbowSpeed = 2.5

local CrosshairProperties = ExunysDeveloperESP.Properties.Crosshair

CrosshairProperties.RainbowColor = true
CrosshairProperties.Position = 2

CrosshairProperties.Size = 18
CrosshairProperties.Thickness = 2

CrosshairProperties.Rotate = true
CrosshairProperties.RotateClockwise = false
CrosshairProperties.RotationSpeed = 10

CrosshairProperties.PulseGap = true
CrosshairProperties.PulsingBounds = {0, 24}

CrosshairProperties.CenterDot.Color = Color3.fromHex("#FFFFFF")
```

</details>

## Wrapping & unwrapping Parts / NPCs
Wrapping objects:
```rust
<string> Hash | ExunysDeveloperESP:WrapObject(<Instance> Object[, <string> Pseudo Name, <table> Allowed Visuals, <uint> Distance])
```
Unwrapping objects:
```rust
<void> | ExunysDeveloperESP.UnwrapObject(<Instance/string> Object / Hash)
```

### ❗ Notice
It is more recommended you store & parse hashes (given from the WrapObject function) for unwrapping for more precise results.

For players, the function `WrapObject` will only wrap & work on the parsed player object *(class type: "**Player**")* if the player has a character achievable by `OBJECT.Character`.

<details> <summary> Code example </summary>

```lua
for Index, Value in next, workspace.Landmines:GetChildren() do
	local Part = Value:IsA("Model") and gethiddenproperty(Value, "PrimaryPart")
    
	if not Part then
		continue 
	end
    
	local Hash = ExunysDeveloperESP:WrapObject(Part, "Landmine "..Index, {Tracer = false})

	task.delay(3, function()
		ExunysDeveloperESP.UnwrapObject(Hash)
	end)
end
```

https://user-images.githubusercontent.com/76539058/232627964-8230c006-770c-4f8a-a101-b5c2fd2e5d91.mp4

</details>

These 2 functions also apply to players & NPCs (anything with a character).

<details> <summary> Code example </summary>

```lua
ExunysDeveloperESP:WrapObject(workspace.Dummys.Dummy, "Dumb Dummy")

-- The object parsed in the first parameter is a model that has a R15 character rig and a humanoid (which it must contain)
```

https://user-images.githubusercontent.com/76539058/232631988-18d8a058-db4a-4d24-b7e1-ff7909ef527e.mp4

</details>
