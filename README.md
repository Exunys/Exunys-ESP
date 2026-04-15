# 🌌 Exunys ESP [![Visitors](https://visitor-badge.laobi.icu/badge?page_id=Exunys.Exunys-ESP)](https://exunys.gitbook.io/exunys-esp-documentation)

This project represents a collection of visuals / wall hacks (Tracers, ESP, Boxes, Head Dots & Crosshair). This script is also undetected because it uses [Synapse X's Drawing Library](https://synapsexdocs.github.io/libraries/drawing). It has modulized support for NPCs & parts and it offers a very simple and easy to use wrapping and unwrapping system.

This project's source is optimized, organized and simplified to the maximal level to be executive, fast, stable and precise.

This project is in beta testing, feel free to create pull requests (you will get credited), issues or just contact me on any of my linked platforms.

This project has been inspired from [AirHub](https://github.com/Exunys/AirHub) which has an improved version of my [old examplery discontinued wall hack script](https://github.com/Exunys/Wall-Hack). It has a FPS-styled look which looks beautiful for any game.

This project is used in the new [AirHub V2](https://github.com/Exunys/AirHub-V2) where you can use and edit the configuration through a GUI (it also includes a really fast Aimbot).

### ❗ Notice
This project has been written and tested with Synapse X and Electron. However, I will do my best to modularize support for every exploit. So far, the required functions for this module to run are listed below:

<details> <summary> Dependencies (required functions & libraries): </summary>

- Libraries & Methods:
    - **Drawing**
        - Drawing.new *(function)*
        - Drawing.Fonts *(table)*
    - **debug**
        - debug.getupvalue *(function)*

- Functions:
    - **getgenv**
    - **getrawmetatable**
    - **gethiddenproperty**
    - **cloneref**
    - **clonefunction**
    - **setrenderproperty**
    - **getrenderproperty**
    - **cleardrawcache**
</details>

This project also uses [Exunys' Config Library](https://github.com/Exunys/Config-Library) as a way of storing user settings, meaning, your script executor must support the dependencies for the module if you want the *configuration storing & loading functions* in the ESP module to function.

### 📜 License
This project is completely free and open source. However, that does not mean you own the rights to it. Please read this [document](https://github.com/Exunys/Exunys-ESP/blob/main/LICENSE) for more information.
You can reuse or integrate this script or any system from this project into your own repositories, as long as you credit the developer, [Exunys](https://github.com/Exunys) (me).

## 📑 Update log (DD/MM/YYYY): 

<details> <summary> 14/04/2023 </summary>

- [**v1.0b**] First (BETA) release

</details> <details> <summary> 15/04/2023 </summary>

- [**v1.0.3b**] Optimizations, bug fixes, silenced errors

</details> <details> <summary> 18/04/2023 </summary>

- [**v1.0.8b**] Optimizations & bug fixes, added distance parameter for wrapping

</details> <details> <summary> 19/04/2023 </summary>

- [**v1.1.1b**] Optimizations, bug fixes, improved `Restart` interactive method, added new core function for getting the local users's positions and more...

</details> <details> <summary> 31/08/2023 </summary>

- [**v1.1.3b**] Added a variable that changes the teammates' visuals' color to differ from the enemies (team color) and made the script return the environment

</details> <details> <summary> 18/08/2024 </summary>

- [**v1.1.4b**] Packed the module to a singular file with support for any executor and more... </details>

</details> <details> <summary> 22/08/2024 </summary>

- [**v1.1.5b**] Added screen resolution stretching </details>

</details> <details> <summary> 29/08/2024 </summary>

- [**v1.1.6b**] Shelved chams & bug fixes </details>

<details> <summary> 09/10/2024 </summary>

- [**v1.1.7b**] Shelved screen resolution stretching, bug fixes, brought back chams </details>

<details> <summary> 16/11/2024 </summary>

- [**v1.1.8b**] Bug fixes, logic improvements & minor optimizations. </details>

<details> <summary> 16/04/2026 </summary>

- [**v1.3b**]
	- First of all, lots of logic improvements and bug fixes.
	- New **Skeleton visual** (R6 & R15).
	- New **Highlights visual**. Use this instead of the **Chams visual** for better performance. **WARNING! THIS FEATURE IS VERY UNSAFE AND CAN BE DETECTED.**
	- Implemented Luraph Macros (for whatever reason you would need these if you want to copy the source).
	- Source optimizations and performance enhancing options (throttling and position caching).
	- Added global caching of the frame and camera parameters. This reduces the updating speed of the visuals but massively improves performance.
	- **ESP visual** optimizations such as distance throttling (66% slower update speed of the bottom text) and caching both of the labels' content (string caching) to reduce garbage collection pressure. Please note these optimizations are the best I could do and if it is still laggy it is because of your script execution engine.
	- Entity ESP / Wrapping - Everything that is / has a humanoid gets wrapped.
	- Buffed up introspection to further prevent unexpected failures.
	- New `RelativeFontSize` property for the **ESP visual** - Font size changes depending on the player's distance. Looks better for longer distances.
	- New **Box visual** types: *Square*, *Quad / 3D Box* and *Corner*.
	- New `FillSquare` property for the **Box visual**.
	- New `Restart` method parameter `<bool> Rewrite Entries`. If you call this method and parse `true` as the first argument, the module does a hard restart removing all the entries and applying new hashes. Be warned that this method will remove any manually entered entries like parts and NPCs.
	- Fixed support for Xeno and Solara. </details>

# 📋 Documentation

### The documentation for the methods of this module can be found [here](https://exunys.gitbook.io/exunys-esp-documentation/).

# 👋 Introduction

First of all, to implement the module in your script's environment you must use the function `loadstring` like below:
```lua
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()
-- ESPLibrary and getgenv().ExunysDeveloperESP is equivalent.
```
The code above loads the module's environment in your script executor's global environment meaning it will be achievable across every script.

The identificator for the environment is `ExunysDeveloperESP` which is a table that has configurable settings and interactive methods.

The table loaded into the exploit's global environment by the module has a [*metatable*](https://create.roblox.com/docs/scripting/luau/metatables) set to it with a **__call** metamethod, meaning you can call the table which would wrap every player in the game and render a crosshair.
```lua
ExunysDeveloperESP()
-- or
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()()
```
This is a pointer to the `Load` method. Loading the module this way would be a faster alternative.
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
		DisableWarnings = false,
		UpdateMode = "RenderStepped",
		TeamCheckOption = "TeamColor",
		SkeletonR6HeightModifier = 0.35, -- 0.0 - 1.0
		RainbowSpeed = 1, -- Bigger = Slower
		WidthBoundary = 1.5, -- Smaller value = Bigger width
		Throttle = false, -- Update tankier functions less frequently. Instead of 60 updates per second, it will be around 30-40 updates per second. Helps preserve FPS.
		ThrottleStep = 2 -- 2 - 4 - Higher value = Less updates.
	},

	Settings = {
		Enabled = true,
		PartsOnly = false,
		TeamCheck = false,
		AliveCheck = true,
		EnableTeamColors = false,
		TeamColor = Color3.fromRGB(170, 170, 255),
		CachePositions = true,
		EntityESP = false
	},

	Properties = {
		ESP = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,
			Offset = 10,
			RelativeFontSize = true, -- Font size changes depending on the player's distance. Looks better for longer distances.

			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
			Size = 14,
			Font = DrawingFonts.Plex, -- Direct2D Fonts: {UI, System, Plex, Monospace}; ROBLOX Fonts: {Roboto, Legacy, SourceSans, RobotoMono}

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

			OutlineColor = Color3.fromRGB(0, 0, 0),
			Outline = true
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

			OutlineColor = Color3fromRGB(0, 0, 0),
			Outline = true
		},

		Box = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,

			Type = 1, -- 1 = Square; 2 = Quad; 3 = Corner
			FillSquare = true,
			FillColor = Color3.fromRGB(255, 255, 255),
			FillRainbowColor = false,
			FillTransparency = 0.1,
			LineSize = 14, -- For corner box option: Min = 2; Max = 20

			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
			Thickness = 1,

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
			Enabled = false,
			RainbowColor = false,

			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 0.2,
			Thickness = 1,
			Filled = false
		},

		Skeleton = {
			Enabled = false,
			RainbowColor = false,

			Transparency = 1,
			Thickness = 1,
			Color = Color3.fromRGB(255, 255, 255)
		},

		Highlight = {
			Enabled = false,
			RainbowColor = false,
			RainbowOutlineColor = false,

			DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, -- AlwaysOnTop (0) / Occluded (1)
			FillColor = Color3.fromRGB(255, 255, 255),
			FillTransparency = 0.5,
			HealthColor = false, -- Only works for Players / NPCs (Requires a Humanoid); Overrides "RainbowColor" property
			HealthColorBlue = 100,

			OutlineTransparency = 1,
			OutlineColor = Color3.fromRGB(255, 255, 255)
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
	},

	-- The rest is core data for the functionality of the module...
}
```

### NOTE: Do not execute this code, it is attached here as an example, executing this would rewrite the environment and critical core data for the ESP to function. Instead if you want to change some setting make sure you use the example below:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()
ExunysDeveloperESP.Settings.Enabled = false
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

## Wrapping & unwrapping objects (Players / Parts / NPCs)
Wrapping objects:
```rust
<string> Hash | ExunysDeveloperESP:WrapObject(<Instance> Object[, <string> Pseudo Name, <table> Allowed Visuals, <uint> Distance])
```
Unwrapping objects:
```rust
<void> | ExunysDeveloperESP.UnwrapObject(<Instance/string> Object / Hash)
```

### ❗ Notice
It is more recommended you store & parse hashes (given from the `WrapObject` method) for unwrapping the proxies with precise results.

For players, the method `WrapObject` will only wrap & work on the parsed player object *(class type: "**Player**")* if the player has a character achievable by `OBJECT.Character`.

<details> <summary> Example program showcasing the part ESP - (WrapObject & UnwrapObject) </summary>

```lua
for Index, Value in next, workspace.Landmines:GetChildren() do
	local Part = Value:IsA("Model") and gethiddenproperty(Value, "PrimaryPart")
    
	if not Part then
		continue 
	end
    
	local Hash = ExunysDeveloperESP:WrapObject(Part, "Landmine "..Index, {Tracer = false})

	task.delay(3, ExunysDeveloperESP.UnwrapObject, Hash)
end
```

https://user-images.githubusercontent.com/76539058/232627964-8230c006-770c-4f8a-a101-b5c2fd2e5d91.mp4

</details>

These 2 methods also apply to players & NPCs (anything with a character).

<details> <summary> Example program showcasing the ESP Module for NPCs </summary>

```lua
ExunysDeveloperESP:WrapObject(workspace.Dummys.Dummy, "Dumb Dummy")

-- The object parsed in the first parameter is a model that has an R15 character rig and a humanoid (which is a dependance)
```

https://user-images.githubusercontent.com/76539058/232631988-18d8a058-db4a-4d24-b7e1-ff7909ef527e.mp4

</details>
