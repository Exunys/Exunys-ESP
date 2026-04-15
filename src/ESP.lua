--[[

	Universal Extra-Sensory Perception (ESP) Module by Exunys © CC0 1.0 Universal (2023)

	https://github.com/Exunys

	- ESP						  > [Players, NPCs & Parts]
	- Tracer					  > [Players, NPCs & Parts]
	- Head Dot					  > [Players & NPCs]
	- Box (Square, Quad, Corner)  > [Players, NPCs & Parts]
	- Health Bar				  > [Players & NPCs]
	- Chams (R6 & R15)			  > [Players, NPCs & Parts]
	- Skeleton (R6 & R15)		  > [Players & NPCs]
	- Highlight					  > [Players, NPCs & Parts]

]]

--// Luraph Macros

if LPH_OBFUSCATED == nil then -- Must wrap in an "if" statement: "The macro 'LPH_NO_VIRTUALIZE' cannot be assigned to. Check if LPH_OBFUSCATED is nil before assigning to macros."
	LPH_NO_VIRTUALIZE = function(...)
		return ...
	end
end

--// Caching

local game, workspace = game, workspace
local assert, loadstring, select, next, type, typeof, pcall, setmetatable, tick, warn = assert, loadstring, select, next, type, typeof, pcall, setmetatable, tick, warn
local mathfloor, mathabs, mathcos, mathsin, mathrad, mathdeg, mathmin, mathmax, mathclamp, mathrandom = math.floor, math.abs, math.cos, math.sin, math.rad, math.deg, math.min, math.max, math.clamp, math.random
local stringformat, stringfind, stringchar = string.format, string.find, string.char
local unpack = table.unpack
local wait, spawn = task.wait, task.spawn
local getgenv, getrawmetatable, gethiddenproperty, cloneref, clonefunction = getgenv, getrawmetatable, gethiddenproperty or function(self, Index)
	return self[Index]
end, cloneref or function(...)
	return ...
end, clonefunction or function(...)
	return ...
end

--// Custom Drawing Library

if not Drawing or not Drawing.new or not Drawing.Fonts then
	loadstring(game.HttpGet(game, "https://pastebin.com/raw/huyiRsK0"))()

	repeat
		wait(0)
	until Drawing and Drawing.new and type(Drawing.new) == "function" and Drawing.Fonts and type(Drawing.Fonts) == "table"
end

--// References

local ConfigLibrary = loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()
local Vector2new, Vector3new, Vector3zero, CFramenew, Instancenew = Vector2.new, Vector3.new, Vector3.zero, CFrame.new, Instance.new
local Drawingnew, DrawingFonts = Drawing and Drawing.new, Drawing and Drawing.Fonts
local Color3fromRGB, Color3fromHSV = Color3.fromRGB, Color3.fromHSV
local WorldToViewportPoint, GetPlayers, GetMouseLocation

local GameMetatable = getrawmetatable and getrawmetatable(game) or {
	-- Auxillary functions - if the executor doesn't support "getrawmetatable".

	__index = LPH_NO_VIRTUALIZE(function(self, Index)
		return self[Index]
	end),

	__newindex = LPH_NO_VIRTUALIZE(function(self, Index, Value)
		self[Index] = Value
	end)
}

local __index = GameMetatable.__index
local __newindex = GameMetatable.__newindex

local getrenderproperty, setrenderproperty = getrenderproperty or __index, setrenderproperty or __newindex

local _get, _set = LPH_NO_VIRTUALIZE(function(self, Index)
	return self[Index]
end), LPH_NO_VIRTUALIZE(function(self, Index, Value)
	self[Index] = Value
end)

if identifyexecutor() == "Solara" then
	local DrawQuad = loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/Exunys/Custom-Quad-Render-Object/main/Main.lua"))() -- Custom Quad Drawing Object
	local _Drawingnew = clonefunction(Drawing.new)

	Drawingnew = LPH_NO_VIRTUALIZE(function(...)
		return ({...})[1] == "Quad" and DrawQuad(...) or _Drawingnew(...)
	end)
end

local _GetService = __index(game, "GetService")
local FindFirstChild, WaitForChild = __index(game, "FindFirstChild"), __index(game, "WaitForChild")
local IsA = __index(game, "IsA")

local GetService = function(Service)
	return cloneref(_GetService(game, Service))
end

local Workspace = GetService("Workspace")
local Players = GetService("Players")
local RunService = GetService("RunService")
local UserInputService = GetService("UserInputService")

local CurrentCamera = __index(Workspace, "CurrentCamera")
local LocalPlayer = __index(Players, "LocalPlayer")

local FindFirstChildOfClass = LPH_NO_VIRTUALIZE(function(self, ...)
	return typeof(self) == "Instance" and self.FindFirstChildOfClass(self, ...)
end)

local Cache = {
	WorldToViewportPoint = __index(CurrentCamera, "WorldToViewportPoint"),
	GetPlayers = __index(Players, "GetPlayers"),
	GetPlayerFromCharacter = __index(Players, "GetPlayerFromCharacter"),
	GetMouseLocation = __index(UserInputService, "GetMouseLocation")
}

WorldToViewportPoint = LPH_NO_VIRTUALIZE(function(...)
	return Cache.WorldToViewportPoint(CurrentCamera, ...)
end)

GetPlayers = LPH_NO_VIRTUALIZE(function()
	return Cache.GetPlayers(Players)
end)

GetPlayerFromCharacter = LPH_NO_VIRTUALIZE(function(...)
	return Cache.GetPlayerFromCharacter(Players, ...)
end)

GetMouseLocation = LPH_NO_VIRTUALIZE(function()
	return Cache.GetMouseLocation(UserInputService)
end)

local IsDescendantOf = LPH_NO_VIRTUALIZE(function(self, ...)
	return typeof(self) == "Instance" and __index(self, "IsDescendantOf")(self, ...)
end)

--// Optimized functions / methods

local Connect, Disconnect = __index(game, "DescendantAdded").Connect

do
	local TemporaryConnection = Connect(__index(game, "DescendantAdded"), function() end)
	Disconnect = TemporaryConnection.Disconnect
	Disconnect(TemporaryConnection)
end

--// Variables

local Inf, Nan, Loaded, Restarting, CrosshairParts = 1 / 0, 0 / 0, false, false, {
	OutlineLeftLine = Drawingnew("Line"),
	OutlineRightLine = Drawingnew("Line"),
	OutlineTopLine = Drawingnew("Line"),
	OutlineBottomLine = Drawingnew("Line"),
	OutlineCenterDot = Drawingnew("Circle"),

	LeftLine = Drawingnew("Line"),
	RightLine = Drawingnew("Line"),
	TopLine = Drawingnew("Line"),
	BottomLine = Drawingnew("Line"),
	CenterDot = Drawingnew("Circle")
}

local ValidProperties = {
	--Color = true,
	Visible = true,
	Outline = true,
	Transparency = true,
	Thickness = true,
	Center = true,
	Filled = true,
	Radius = true,
	NumSides = true,
	Font = true
}

for _, Value in next, CrosshairParts do
	setrenderproperty(Value, "Visible", false) -- For various exploits, the render objects' "Visible" property is set to "true" when initialized.
end

--// Core Parameters

local FrameTick = tick()
local Rainbow = Color3fromRGB(255, 255, 255)
local CameraCFrame = __index(CurrentCamera, "CFrame")
local CameraViewportSize = __index(CurrentCamera, "ViewportSize")

--// Checking for multiple processes

if ExunysDeveloperESP and ExunysDeveloperESP.Exit then
	ExunysDeveloperESP:Exit()
end

--// Settings

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
		TeamColor = Color3fromRGB(170, 170, 255),
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

			Color = Color3fromRGB(255, 255, 255),
			Transparency = 1,
			Size = 14,
			Font = DrawingFonts.Plex, -- Direct2D Fonts: {UI, System, Plex, Monospace}; ROBLOX Fonts: {Roboto, Legacy, SourceSans, RobotoMono}

			OutlineColor = Color3fromRGB(0, 0, 0),
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
			Color = Color3fromRGB(255, 255, 255),

			OutlineColor = Color3fromRGB(0, 0, 0),
			Outline = true
		},

		HeadDot = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,

			Color = Color3fromRGB(255, 255, 255),
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
			FillColor = Color3fromRGB(255, 255, 255),
			FillRainbowColor = false,
			FillTransparency = 0.1,
			LineSize = 14, -- For corner box option: Min = 2; Max = 20

			Color = Color3fromRGB(255, 255, 255),
			Transparency = 1,
			Thickness = 1,

			OutlineColor = Color3fromRGB(0, 0, 0),
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

			OutlineColor = Color3fromRGB(0, 0, 0),
			Outline = true
		},

		Chams = {
			Enabled = false,
			RainbowColor = false,

			Color = Color3fromRGB(255, 255, 255),
			Transparency = 0.2,
			Thickness = 1,
			Filled = false
		},

		Skeleton = {
			Enabled = false,
			RainbowColor = false,

			Transparency = 1,
			Thickness = 1,
			Color = Color3fromRGB(255, 255, 255)
		},

		Highlight = {
			Enabled = false,
			RainbowColor = false,
			RainbowOutlineColor = false,

			DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, -- AlwaysOnTop (0) / Occluded (1)
			FillColor = Color3fromRGB(255, 255, 255),
			FillTransparency = 0.5,
			HealthColor = false, -- Only works for Players / NPCs (Requires a Humanoid); Overrides "RainbowColor" property
			HealthColorBlue = 100,

			OutlineTransparency = 1,
			OutlineColor = Color3fromRGB(255, 255, 255)
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

			Color = Color3fromRGB(0, 255, 0),
			Thickness = 1,
			Transparency = 1,

			OutlineColor = Color3fromRGB(0, 0, 0),
			Outline = true,

			CenterDot = {
				Enabled = true,
				RainbowColor = false,
				RainbowOutlineColor = false,

				Radius = 2,

				Color = Color3fromRGB(0, 255, 0),
				Transparency = 1,
				Thickness = 1,
				NumSides = 60,
				Filled = false,

				OutlineColor = Color3fromRGB(0, 0, 0),
				Outline = true
			}
		}
	},

	UtilityAssets = {
		WrappedObjects = {},
		ServiceConnections = {}
	}
}

local Environment, _warn = getgenv().ExunysDeveloperESP, clonefunction(warn); warn = function(...)
	return not Environment.DeveloperSettings.DisableWarnings and _warn(...)
end

--// Functions

local function Recursive(Table, Callback)
	for Index, Value in next, Table do
		Callback(Index, Value)

		if type(Value) == "table" then
			Recursive(Value, Callback)
		end
	end
end

local CoreFunctions; LPH_NO_VIRTUALIZE(function()
	CoreFunctions = {
		ConvertVector = function(Vector)
			return Vector2new(Vector.X, Vector.Y)
		end,

		GetColorFromHealth = function(Health, MaxHealth, Blue)
			return Color3fromRGB(255 - mathfloor(Health / MaxHealth * 255), mathfloor(Health / MaxHealth * 255), Blue or 0)
		end,

		GetRainbowColor = function()
			local RainbowSpeed = Environment.DeveloperSettings.RainbowSpeed

			return Color3fromHSV(FrameTick % RainbowSpeed / RainbowSpeed, 1, 1)
		end,

		GetLocalCharacterPosition = function()
			local LocalCharacter = __index(LocalPlayer, "Character")
			local LocalPlayerCheckPart = LocalCharacter and (__index(LocalCharacter, "PrimaryPart") or FindFirstChild(LocalCharacter, "Head"))

			return LocalPlayerCheckPart and __index(LocalPlayerCheckPart, "Position") or CameraCFrame.Position
		end,

		GenerateHash = function(Bits)
			local Result = ""

			for _ = 1, Bits do
				Result ..= ("EXUNYS_ESP")[mathrandom(1, 2) == 1 and "upper" or "lower"](stringchar(mathrandom(97, 122)))
			end

			return Result
		end,

		CalculateParameters = function(Object)
			Object = type(Object) == "table" and Object.Object or Object

			local Entry = type(Object) == "table" and Object or nil

			if Entry then
				Entry._Cache = Entry._Cache or {}
				local _Cache = Entry._Cache

				if _Cache.Tick == FrameTick then
					return _Cache.Position, _Cache.Size, _Cache.Visible, _Cache.Top, _Cache.Bottom
				end
			end

			local DeveloperSettings = Environment.DeveloperSettings
			local WidthBoundary = DeveloperSettings.WidthBoundary

			local IsAPlayer, Part = IsA(Object, "Player")

			if IsAPlayer then
				Part = __index(Object, "Character")
				if Part then
					Part = (__index(Part, "PrimaryPart") or FindFirstChild(Part, "HumanoidRootPart"))
				end
			else
				if IsA(Object, "Model") then
					Part = __index(Object, "PrimaryPart")
				else
					Part = Object
				end
			end

			if not Part or IsA(Part, "Player") or IsA(Part, "Model") or not IsDescendantOf(Part, Workspace) then
				return nil, nil, false, nil, nil
			end

			local PartCFrame, PartPosition = __index(Part, "CFrame"), __index(Part, "Position")
			local PartUpVector = PartCFrame.UpVector

			local PartParent = __index(Part, "Parent")
			local RigType = PartParent and FindFirstChild(PartParent, "Torso") and "R6" or "R15"

			local CameraUpVector = CameraCFrame.UpVector

			local Top, TopOnScreen = WorldToViewportPoint(PartPosition + (PartUpVector * (RigType == "R6" and 0.5 or 1.8)) + CameraUpVector)
			local Bottom, BottomOnScreen = WorldToViewportPoint(PartPosition - (PartUpVector * (RigType == "R6" and 4 or 2.5)) - CameraUpVector)

			local TopX, TopY = Top.X, Top.Y
			local BottomX, BottomY = Bottom.X, Bottom.Y

			local Width = mathmax(mathfloor(mathabs(TopX - BottomX)), 3)
			local Height = mathmax(mathfloor(mathmax(mathabs(BottomY - TopY), Width / 2)), 3)
			local BoxSize = Vector2new(mathfloor(mathmax(Height / (IsAPlayer and WidthBoundary or 1), Width)), Height)
			local BoxPosition = Vector2new(mathfloor(TopX / 2 + BottomX / 2 - BoxSize.X / 2), mathfloor(mathmin(TopY, BottomY)))

			if Entry then
				local _Cache = Entry._Cache
				_Cache.Tick = FrameTick
				_Cache.Position = BoxPosition
				_Cache.Size = BoxSize
				_Cache.Visible = (TopOnScreen and BottomOnScreen)
				_Cache.Top = Top
				_Cache.Bottom = Bottom
			end

			return BoxPosition, BoxSize, (TopOnScreen and BottomOnScreen), Top, Bottom
		end,

		Calculate3DQuad = function(_CFrame, SizeVector, YVector)
			YVector = YVector or SizeVector

			return {

				--// Quad 1 - Front

				{
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Left
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Right
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, SizeVector.Z).Position), -- Bottom Left
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, SizeVector.Z).Position) -- Bottom Right
				},


				--// Quad 2 - Back

				{
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, -SizeVector.Z).Position), -- Top Left
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, -SizeVector.Z).Position), -- Top Right
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, -SizeVector.Z).Position), -- Bottom Left
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, -SizeVector.Z).Position) -- Bottom Right
				},

				--// Quad 3 - Top

				{
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Left
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Right
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, -SizeVector.Z).Position), -- Bottom Left
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, -SizeVector.Z).Position) -- Bottom Right
				},

				--// Quad 4 - Bottom

				{
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, SizeVector.Z).Position), -- Top Left
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, SizeVector.Z).Position), -- Top Right
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, -SizeVector.Z).Position), -- Bottom Left
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, -SizeVector.Z).Position) -- Bottom Right
				},

				--// Quad 5 - Right

				{
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Left
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, -SizeVector.Z).Position), -- Top Right
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, SizeVector.Z).Position), -- Bottom Left
					WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, -SizeVector.Z).Position) -- Bottom Right
				},

				--// Quad 6 - Left

				{
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Left
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, -SizeVector.Z).Position), -- Top Right
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, SizeVector.Z).Position), -- Bottom Left
					WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, -SizeVector.Z).Position) -- Bottom Right
				}
			}
		end,

		GetColor = function(Player, DefaultColor)
			local Settings, TeamCheckOption = Environment.Settings, Environment.DeveloperSettings.TeamCheckOption

			return Settings.EnableTeamColors and __index(Player, TeamCheckOption) == __index(LocalPlayer, TeamCheckOption) and Settings.TeamColor or DefaultColor
		end
	}
end)()

local UpdatingFunctions; LPH_NO_VIRTUALIZE(function()
	UpdatingFunctions = {
		ESP = function(Entry, TopTextObject, BottomTextObject)
			local Settings = Environment.Properties.ESP

			local Position, Size, OnScreen, Top, Bottom = CoreFunctions.CalculateParameters(Entry)

			setrenderproperty(TopTextObject, "Visible", OnScreen)
			setrenderproperty(BottomTextObject, "Visible", OnScreen)

			if OnScreen then
				for Index, Value in next, Settings do
					if ValidProperties[Index] then
						setrenderproperty(TopTextObject, Index, Value)
						setrenderproperty(BottomTextObject, Index, Value)
					end
				end

				local FontSize = Settings.RelativeFontSize and mathclamp(mathabs((Top - Bottom).Y) - 3, 6, Settings.Size) or Settings.Size

				setrenderproperty(TopTextObject, "Size", FontSize)
				setrenderproperty(BottomTextObject, "Size", FontSize)

				local GetColor = CoreFunctions.GetColor

				local MainColor = GetColor(Entry.Object, Settings.RainbowColor and Rainbow or Settings.Color)
				local OutlineColor = Settings.RainbowOutlineColor and Rainbow or Settings.OutlineColor

				setrenderproperty(TopTextObject, "Color", MainColor)
				setrenderproperty(TopTextObject, "OutlineColor", OutlineColor)
				setrenderproperty(BottomTextObject, "Color", MainColor)
				setrenderproperty(BottomTextObject, "OutlineColor", OutlineColor)

				local Offset = mathclamp(Settings.Offset, 10, 30)
				local LabelsXPosition = Position.X + (Size.X / 2)

				local Player, IsAPlayer = Entry.Object, Entry.IsAPlayer
				local Name, DisplayName = Entry.Name, Entry.DisplayName

				local Character = IsAPlayer and __index(Player, "Character") or Player
				local Humanoid = FindFirstChildOfClass(Character, "Humanoid")
				local Health, MaxHealth = Humanoid and __index(Humanoid, "Health") or Nan, Humanoid and __index(Humanoid, "MaxHealth") or Nan

				local Tool = Settings.DisplayTool and FindFirstChildOfClass(Character, "Tool")

				local TopContent = ""

				if Settings.DisplayDisplayName and Settings.DisplayName and DisplayName ~= Name then
					TopContent = stringformat("%s (%s)", DisplayName, Name)
				elseif Settings.DisplayDisplayName and not Settings.DisplayName then
					TopContent = DisplayName
				elseif not Settings.DisplayDisplayName and Settings.DisplayName then
					TopContent = Name
				elseif Settings.DisplayDisplayName and Settings.DisplayName and DisplayName == Name then
					TopContent = Name
				end

				if Settings.DisplayHealth and IsAPlayer then
					TopContent = stringformat("[%s / %s] %s", mathfloor(Health), MaxHealth, TopContent)
				end

				if Entry._LastTopText ~= TopContent then
					Entry._LastTopText = TopContent
					setrenderproperty(TopTextObject, "Text", TopContent)
				end

				Entry._DistFrame = (Entry._DistFrame or 0) + 1

				if Entry._DistFrame % 3 == 0 then
					local PlayerPosition = __index((IsAPlayer and (__index(Character, "PrimaryPart") or __index(Character, "Head")) or Character), "Position") or Vector3zero
					Entry._Distance = Settings.DisplayDistance and mathfloor((PlayerPosition - CoreFunctions.GetLocalCharacterPosition()).Magnitude)
				end

				local Distance = Entry._Distance

				local BottomContent = Distance and stringformat("%s Studs", Distance) or ""

				if Tool then
					local ToolName = __index(Tool, "Name")
					BottomContent = BottomContent..((Distance and "\n" or "")..ToolName)
				end

				if Entry._LastBottomText ~= BottomContent then
					Entry._LastBottomText = BottomContent
					setrenderproperty(BottomTextObject, "Text", BottomContent)
				end

				if Entry.PositionChanged then
					setrenderproperty(TopTextObject, "Position", Vector2new(LabelsXPosition, Top.Y - Offset * 2.05))
					setrenderproperty(BottomTextObject, "Position", Vector2new(LabelsXPosition, Bottom.Y + Offset / 2))
				end
			end
		end,

		Tracer = function(Entry, TracerObject, TracerOutlineObject)
			local Settings = Environment.Properties.Tracer

			local Position, Size, OnScreen = CoreFunctions.CalculateParameters(Entry)

			setrenderproperty(TracerObject, "Visible", OnScreen)
			setrenderproperty(TracerOutlineObject, "Visible", OnScreen and Settings.Outline)

			if OnScreen then
				for Index, Value in next, Settings do
					if ValidProperties[Index] then
						setrenderproperty(TracerObject, Index, Value)
					end
				end

				setrenderproperty(TracerObject, "Color", CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and Rainbow or Settings.Color))

				if Settings.Position == 1 then
					setrenderproperty(TracerObject, "From", Vector2new(CameraViewportSize.X / 2, CameraViewportSize.Y))
				elseif Settings.Position == 2 then
					setrenderproperty(TracerObject, "From", CameraViewportSize / 2)
				elseif Settings.Position == 3 then
					setrenderproperty(TracerObject, "From", GetMouseLocation())
				else
					Settings.Position = 1
				end

				if Entry.PositionChanged then
					setrenderproperty(TracerObject, "To", Vector2new(Position.X + (Size.X / 2), Position.Y + Size.Y))
				end

				if Settings.Outline then
					setrenderproperty(TracerOutlineObject, "Color", Settings.RainbowOutlineColor and Rainbow or Settings.OutlineColor)
					setrenderproperty(TracerOutlineObject, "Thickness", Settings.Thickness + 1)
					setrenderproperty(TracerOutlineObject, "Transparency", Settings.Transparency)

					setrenderproperty(TracerOutlineObject, "From", getrenderproperty(TracerObject, "From"))

					if not Entry.PositionChanged then
						return
					end

					setrenderproperty(TracerOutlineObject, "To", getrenderproperty(TracerObject, "To"))
				end
			end
		end,

		HeadDot = function(Entry, CircleObject, CircleOutlineObject)
			local Settings = Environment.Properties.HeadDot

			local Character = Entry.IsAPlayer and __index(Entry.Object, "Character") or __index(Entry.Object, "Parent")
			local Head = Character and FindFirstChild(Character, "Head")

			if not Head then
				setrenderproperty(CircleObject, "Visible", false)
				setrenderproperty(CircleOutlineObject, "Visible", false)

				return
			end

			local HeadCFrame, HeadSize = __index(Head, "CFrame"), __index(Head, "Size")

			local Vector, OnScreen = WorldToViewportPoint(HeadCFrame.Position)
			local Top, Bottom = WorldToViewportPoint((HeadCFrame * CFramenew(0, HeadSize.Y / 2, 0)).Position), WorldToViewportPoint((HeadCFrame * CFramenew(0, -HeadSize.Y / 2, 0)).Position)

			setrenderproperty(CircleObject, "Visible", OnScreen)
			setrenderproperty(CircleOutlineObject, "Visible", OnScreen and Settings.Outline)

			if OnScreen then
				for Index, Value in next, Settings do
					if ValidProperties[Index] then
						setrenderproperty(CircleObject, Index, Value)

						if Settings.Outline then
							setrenderproperty(CircleOutlineObject, Index, Value)
						end
					end
				end

				setrenderproperty(CircleObject, "Color", CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and Rainbow or Settings.Color))

				if Entry.PositionChanged then
					setrenderproperty(CircleObject, "Position", CoreFunctions.ConvertVector(Vector))
					setrenderproperty(CircleObject, "Radius", mathabs((Top - Bottom).Y) - 3)
				end

				if Settings.Outline then
					setrenderproperty(CircleOutlineObject, "Color", Settings.RainbowOutlineColor and Rainbow or Settings.OutlineColor)

					setrenderproperty(CircleOutlineObject, "Thickness", Settings.Thickness + 1)
					setrenderproperty(CircleOutlineObject, "Transparency", Settings.Transparency)

					if not Entry.PositionChanged then
						return
					end

					setrenderproperty(CircleOutlineObject, "Position", getrenderproperty(CircleObject, "Position"))
					setrenderproperty(CircleOutlineObject, "Radius", getrenderproperty(CircleObject, "Radius"))
				end
			end
		end,

		Box = function(Entry, BoxParts, BoxOutlines, SquareBox, FillBox, Quads)
			local Settings = Environment.Properties.Box
			local DeveloperSettings = Environment.DeveloperSettings

			local Position, Size, OnScreen = CoreFunctions.CalculateParameters(Entry)

			local ConvertVector = CoreFunctions.ConvertVector

			local Object = Entry.Object
			local IsAPlayer = Entry.IsAPlayer

			local Character = IsAPlayer and __index(Object, "Character") or __index(Object, "Parent")

			if Character == Players then
				return
			end

			local Primary = Character and (__index(Character, "PrimaryPart") or FindFirstChild(Character, "HumanoidRootPart"))

			Primary = Primary or not IsAPlayer and Object

			local Type, Fill = Settings.Type, Settings.FillSquare

			local SquareBoxObject = SquareBox[1]
			local SquareBoxOutline = SquareBox[2]

			local Visibility, Visibility3D = function(Value)
				for Index, _Value in next, BoxParts do
					setrenderproperty(_Value, "Visible", Value and Type == 3)
					setrenderproperty(BoxOutlines[Index], "Visible", Value and Settings.Outline and Type == 3)
				end
			end, function(Value)
				for _, _Value in next, Quads do
					_set(_Value, "Visible", Value and Type == 2)
				end
			end

			if Type == 1 then
				setrenderproperty(SquareBoxObject, "Visible", OnScreen and Type == 1)
				setrenderproperty(SquareBoxOutline, "Visible", OnScreen and Settings.Outline and Type == 1)
				Visibility(false)
				Visibility3D(false)
			elseif Type == 2 then
				setrenderproperty(SquareBoxObject, "Visible", false)
				setrenderproperty(SquareBoxOutline, "Visible", false)
				Visibility(false)
				Visibility3D(OnScreen and Type == 2)
			elseif Type == 3 then
				setrenderproperty(SquareBoxObject, "Visible", false)
				setrenderproperty(SquareBoxOutline, "Visible", false)
				Visibility(OnScreen and Type == 3)
				Visibility3D(false)
			end

			setrenderproperty(FillBox, "Visible", Fill and OnScreen and Type ~= 2)

			if not Primary then
				setrenderproperty(FillBox, "Visible", false)
				setrenderproperty(SquareBoxObject, "Visible", false)
				setrenderproperty(SquareBoxOutline, "Visible", false)
				Visibility(false)
				Visibility3D(false)

				return
			end

			local PrimaryCFrame, PrimarySize = __index(Primary, "CFrame"), __index(Primary, "Size")
			local _3DSize = PrimarySize * Vector3new(1.05, 1.5, 0)
			local Top, Bottom = WorldToViewportPoint((PrimaryCFrame * CFramenew(0, PrimarySize.Y / 2, 0)).Position), WorldToViewportPoint((PrimaryCFrame * CFramenew(0, -PrimarySize.Y / 2, 0)).Position)

			local LineSize = mathclamp(mathabs((Top - Bottom).Y) - 3, 2, mathmax(Settings.LineSize, 20))

			if getrenderproperty(BoxParts.TopLeft_Bottom, "Visible") or getrenderproperty(SquareBoxObject, "Visible") or getrenderproperty(Quads.Top, "Visible") then
				if Fill and Type ~= 2 then
					setrenderproperty(FillBox, "Transparency", Settings.FillTransparency)
					setrenderproperty(FillBox, "Thickness", 0)
					setrenderproperty(FillBox, "Color", CoreFunctions.GetColor(Entry.Object, Settings.FillRainbowColor and Rainbow or Settings.FillColor))

					if not Entry.PositionChanged then
						return
					end

					setrenderproperty(FillBox, "Position", Position)
					setrenderproperty(FillBox, "Size", Size)
				end

				if Type == 1 then -- Square Box
					for Index, Value in next, Settings do
						if ValidProperties[Index] then
							setrenderproperty(SquareBoxObject, Index, Value)
						end
					end

					setrenderproperty(SquareBoxObject, "Color", CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and Rainbow or Settings.Color))

					if not Entry.PositionChanged then
						return
					end

					setrenderproperty(SquareBoxObject, "Position", Position)
					setrenderproperty(SquareBoxObject, "Size", Size)
				elseif Type == 2 then -- 3D Box
					if DeveloperSettings.Throttle then
						Entry._Frame = (Entry._Frame or 0) + 1

						if Entry._Frame % mathclamp(DeveloperSettings.ThrottleStep, 2, 4) ~= 0 then
							return
						end
					end

					for Index, Value in next, Settings do
						for _, RenderObject in next, Quads do
							if ValidProperties[Index] then
								_set(RenderObject, Index, Value)
							end
						end
					end

					for _, Value in next, Quads do
						_set(Value, "Fill", Fill)
						_set(Value, "Color", CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and Rainbow or Settings.Color))
					end

					if not Entry.PositionChanged then
						return
					end

					local Indexes, Positions = {1, 3, 4, 2}, CoreFunctions.Calculate3DQuad(PrimaryCFrame, PrimarySize, _3DSize)

					for Index, RenderObject in next, Quads do
						for _Index = 1, 4 do
							_set(RenderObject, "Point"..stringchar(_Index + 64), ConvertVector(Positions[Index][Indexes[_Index]]))
						end
					end
				elseif Type == 3 then -- Corner Box
					for Index, Value in next, Settings do
						for _, RenderObject in next, BoxParts do
							if ValidProperties[Index] then
								setrenderproperty(RenderObject, Index, Value)
							end
						end
					end

					for _, Value in next, BoxParts do
						setrenderproperty(Value, "Color", CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and Rainbow or Settings.Color))
					end

					if not Entry.PositionChanged then
						return
					end

					--// Top Left

					setrenderproperty(BoxParts.TopLeft_Bottom, "From", Position)
					setrenderproperty(BoxParts.TopLeft_Bottom, "To", Vector2new(Position.X, Position.Y + LineSize + LineSize / 2))

					setrenderproperty(BoxParts.TopLeft_Right, "From", Position)
					setrenderproperty(BoxParts.TopLeft_Right, "To", Vector2new(Position.X + LineSize, Position.Y))

					--// Top Right

					setrenderproperty(BoxParts.TopRight_Bottom, "From", Vector2new(Position.X + Size.X, Position.Y))
					setrenderproperty(BoxParts.TopRight_Bottom, "To", Vector2new(Position.X + Size.X, Position.Y + LineSize + LineSize / 2))

					setrenderproperty(BoxParts.TopRight_Left, "From", Vector2new(Position.X + Size.X, Position.Y))
					setrenderproperty(BoxParts.TopRight_Left, "To", Vector2new(Position.X + Size.X - LineSize, Position.Y))

					--// Bottom Left

					setrenderproperty(BoxParts.BottomLeft_Top, "From", Vector2new(Position.X, Position.Y + Size.Y - LineSize - LineSize / 2))
					setrenderproperty(BoxParts.BottomLeft_Top, "To", Vector2new(Position.X, Position.Y + Size.Y))

					setrenderproperty(BoxParts.BottomLeft_Right, "From", Vector2new(Position.X, Position.Y + Size.Y))
					setrenderproperty(BoxParts.BottomLeft_Right, "To", Vector2new(Position.X + LineSize, Position.Y + Size.Y))

					--// Bottom Right

					setrenderproperty(BoxParts.BottomRight_Top, "From", Vector2new(Position.X + Size.X, Position.Y + Size.Y - LineSize - LineSize / 2))
					setrenderproperty(BoxParts.BottomRight_Top, "To", Vector2new(Position.X + Size.X, Position.Y + Size.Y))

					setrenderproperty(BoxParts.BottomRight_Left, "From", Vector2new(Position.X + Size.X, Position.Y + Size.Y))
					setrenderproperty(BoxParts.BottomRight_Left, "To", Vector2new(Position.X + Size.X - LineSize, Position.Y + Size.Y))
				end

				if Settings.Outline then
					if Type == 1 then
						setrenderproperty(SquareBoxOutline, "Color", Settings.RainbowOutlineColor and Rainbow or Settings.OutlineColor)

						setrenderproperty(SquareBoxOutline, "Thickness", Settings.Thickness + 1)
						setrenderproperty(SquareBoxOutline, "Transparency", Settings.Transparency)

						if not Entry.PositionChanged then
							return
						end

						setrenderproperty(SquareBoxOutline, "Position", Position)
						setrenderproperty(SquareBoxOutline, "Size", Size)
					elseif Type == 3 then
						for Index, Value in next, BoxOutlines do
							setrenderproperty(Value, "Color", Settings.RainbowOutlineColor and Rainbow or Settings.OutlineColor)

							setrenderproperty(Value, "Thickness", Settings.Thickness + 2)
							setrenderproperty(Value, "Transparency", Settings.Transparency)

							if not Entry.PositionChanged then
								return
							end

							setrenderproperty(Value, "From", getrenderproperty(BoxParts[Index], "From"))
							setrenderproperty(Value, "To", getrenderproperty(BoxParts[Index], "To"))
						end
					end
				end
			end
		end,

		HealthBar = function(Entry, MainObject, OutlineObject, Humanoid)
			local Settings = Environment.Properties.HealthBar

			local Position, Size, OnScreen = CoreFunctions.CalculateParameters(Entry)

			setrenderproperty(MainObject, "Visible", OnScreen)
			setrenderproperty(OutlineObject, "Visible", OnScreen and Settings.Outline)

			if OnScreen and Position and Size then
				for Index, Value in next, Settings do
					if ValidProperties[Index] then
						setrenderproperty(MainObject, Index, Value)
					end
				end

				Humanoid = Humanoid or FindFirstChildOfClass(__index(Entry.Object, "Character"), "Humanoid")

				local MaxHealth = Humanoid and __index(Humanoid, "MaxHealth") or 100
				local Health = Humanoid and mathclamp(__index(Humanoid, "Health"), 0, MaxHealth) or 0

				local Offset = mathclamp(Settings.Offset, 4, 12)

				setrenderproperty(MainObject, "Color", CoreFunctions.GetColorFromHealth(Health, MaxHealth, Settings.Blue))

				if Settings.Outline then
					setrenderproperty(OutlineObject, "Color", Settings.RainbowOutlineColor and Rainbow or Settings.OutlineColor)

					setrenderproperty(OutlineObject, "Thickness", Settings.Thickness + 1)
					setrenderproperty(OutlineObject, "Transparency", Settings.Transparency)
				end

				if not Entry.PositionChanged then
					return
				end

				if Settings.Position == 1 then
					setrenderproperty(MainObject, "From", Vector2new(Position.X, Position.Y - Offset))
					setrenderproperty(MainObject, "To", Vector2new(Position.X + (Health / MaxHealth) * Size.X, Position.Y - Offset))

					if Settings.Outline then
						setrenderproperty(OutlineObject, "From", Vector2new(Position.X - 1, Position.Y - Offset))
						setrenderproperty(OutlineObject, "To", Vector2new(Position.X + Size.X + 1, Position.Y - Offset))
					end
				elseif Settings.Position == 2 then
					setrenderproperty(MainObject, "From", Vector2new(Position.X, Position.Y + Size.Y + Offset))
					setrenderproperty(MainObject, "To", Vector2new(Position.X + (Health / MaxHealth) * Size.X, Position.Y + Size.Y + Offset))

					if Settings.Outline then
						setrenderproperty(OutlineObject, "From", Vector2new(Position.X - 1, Position.Y + Size.Y + Offset))
						setrenderproperty(OutlineObject, "To", Vector2new(Position.X + Size.X + 1, Position.Y + Size.Y + Offset))
					end
				elseif Settings.Position == 3 then
					setrenderproperty(MainObject, "From", Vector2new(Position.X - Offset, Position.Y + Size.Y))
					setrenderproperty(MainObject, "To", Vector2new(Position.X - Offset, getrenderproperty(MainObject, "From").Y - (Health / MaxHealth) * Size.Y))

					if Settings.Outline then
						setrenderproperty(OutlineObject, "From", Vector2new(Position.X - Offset, Position.Y + Size.Y + 1))
						setrenderproperty(OutlineObject, "To", Vector2new(Position.X - Offset, (getrenderproperty(OutlineObject, "From").Y - 1 * Size.Y) - 2))
					end
				elseif Settings.Position == 4 then
					setrenderproperty(MainObject, "From", Vector2new(Position.X + Size.X + Offset, Position.Y + Size.Y))
					setrenderproperty(MainObject, "To", Vector2new(Position.X + Size.X + Offset, getrenderproperty(MainObject, "From").Y - (Health / MaxHealth) * Size.Y))

					if Settings.Outline then
						setrenderproperty(OutlineObject, "From", Vector2new(Position.X + Size.X + Offset, Position.Y + Size.Y + 1))
						setrenderproperty(OutlineObject, "To", Vector2new(Position.X + Size.X + Offset, (getrenderproperty(OutlineObject, "From").Y - 1 * Size.Y) - 2))
					end
				else
					Settings.Position = 3
				end
			end
		end,

		Chams = function(Entry, Part, Cham)
			local Settings = Environment.Properties.Chams

			if not (Part and Cham and Entry) then
				return
			end

			local ChamsEnabled, ESPEnabled = Settings.Enabled, Environment.Settings.Enabled
			local IsReady = Entry.Checks.Ready

			local ConvertVector = CoreFunctions.ConvertVector

			local _CFrame, PartSize = select(2, pcall(function()
				return __index(Part, "CFrame"), __index(Part, "Size") / 2
			end))

			if not (ChamsEnabled and ESPEnabled and IsReady and _CFrame and PartSize and select(2, WorldToViewportPoint(_CFrame.Position))) then
				for Index = 1, 6 do
					_set(Cham["Quad"..Index], "Visible", false)
				end

				return
			end

			local Quads = {
				Quad1Object = Cham.Quad1,
				Quad2Object = Cham.Quad2,
				Quad3Object = Cham.Quad3,
				Quad4Object = Cham.Quad4,
				Quad5Object = Cham.Quad5,
				Quad6Object = Cham.Quad6
			}

			for Index, Value in next, Settings do
				if Index == "Enabled" then
					Index, Value = "Visible", ChamsEnabled and ESPEnabled and IsReady
				elseif Index == "Color" then
					Value = CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and Rainbow or Settings.Color)
				end

				if not pcall(_get, Quads.Quad1Object, Index) then
					continue
				end

				for _, RenderObject in next, Quads do
					_set(RenderObject, Index, Value)
				end
			end

			if not Entry.PositionChanged then
				return
			end

			local Indexes, Positions = {1, 3, 4, 2}, CoreFunctions.Calculate3DQuad(_CFrame, PartSize)

			for Index = 1, 6 do
				local RenderObject = Quads["Quad"..Index.."Object"]

				for _Index = 1, 4 do
					_set(RenderObject, "Point"..stringchar(_Index + 64), ConvertVector(Positions[Index][Indexes[_Index]]))
				end
			end
		end,

		Skeleton = function(Entry)
			local Settings = Environment.Properties.Skeleton
			local DeveloperSettings = Environment.DeveloperSettings

			local Character = Entry.IsAPlayer and __index(Entry.Object, "Character") or __index(Entry.Object, "Parent")
			local Head = Character and FindFirstChild(Character, "Head")
			local Primary = Character and (FindFirstChild(Character, "HumanoidRootPart") or __index(Character, "PrimaryPart"))

			Primary = Primary or not Entry.IsAPlayer and Entry.Object

			local Limbs, RigType = {}, Entry.RigType
			local ConvertVector, HeightModifier = CoreFunctions.ConvertVector, Environment.DeveloperSettings.SkeletonR6HeightModifier

			for Index, Value in next, Entry.Visuals.Skeleton do
				Limbs[Index] = Value
			end

			local Visibility = function(Value)
				for _, _Value in next, Limbs do
					setrenderproperty(_Value, "Visible", Value)
				end
			end

			if not Head or not Primary or RigType == "N/A" then
				return Visibility(false)
			end

			if DeveloperSettings.Throttle then
				Entry._Frame = (Entry._Frame or 0) + 1

				if Entry._Frame % mathclamp(DeveloperSettings.ThrottleStep, 2, 4) ~= 0 then
					return
				end
			end

			if select(3, CoreFunctions.CalculateParameters(Entry)) then
				for _, RenderObject in next, Limbs do
					setrenderproperty(RenderObject, "Visible", true)

					for _Index, _Value in next, Settings do
						if ValidProperties[_Index] then
							setrenderproperty(RenderObject, _Index, _Value)
						end
					end

					setrenderproperty(RenderObject, "Color", CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and Rainbow or Settings.Color))
				end

				local Head_Position = ConvertVector(WorldToViewportPoint(__index(Head, "Position")))

				if RigType == "R15" then
					for _, Value in next, {"LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"} do
						if not FindFirstChild(Character, Value) then
							repeat
								Visibility(false); wait(0)
							until WaitForChild(Character, Value)
						end
					end

					if not Entry.PositionChanged then
						return
					end

					local Spine_Start_Position = ConvertVector(WorldToViewportPoint(__index(Character.UpperTorso, "Position")))
					local Spine_End_Position = ConvertVector(WorldToViewportPoint(__index(Character.LowerTorso, "Position")))

					local LeftArm_Start_Position = ConvertVector(WorldToViewportPoint(__index(Character.LeftUpperArm, "Position")))
					local LeftArm_Middle_Position = ConvertVector(WorldToViewportPoint(__index(Character.LeftLowerArm, "Position")))
					local LeftArm_End_Position = ConvertVector(WorldToViewportPoint(__index(Character.LeftHand, "Position")))

					local RightArm_Start_Position = ConvertVector(WorldToViewportPoint(__index(Character.RightUpperArm, "Position")))
					local RightArm_Middle_Position = ConvertVector(WorldToViewportPoint(__index(Character.RightLowerArm, "Position")))
					local RightArm_End_Position = ConvertVector(WorldToViewportPoint(__index(Character.RightHand, "Position")))

					local LeftLeg_Start_Position = ConvertVector(WorldToViewportPoint(__index(Character.LeftUpperLeg, "Position")))
					local LeftLeg_Middle_Position = ConvertVector(WorldToViewportPoint(__index(Character.LeftLowerLeg, "Position")))
					local LeftLeg_End_Position = ConvertVector(WorldToViewportPoint(__index(Character.LeftFoot, "Position")))

					local RightLeg_Start_Position = ConvertVector(WorldToViewportPoint(__index(Character.RightUpperLeg, "Position")))
					local RightLeg_Middle_Position = ConvertVector(WorldToViewportPoint(__index(Character.RightLowerLeg, "Position")))
					local RightLeg_End_Position = ConvertVector(WorldToViewportPoint(__index(Character.RightFoot, "Position")))

					--// Spine

					setrenderproperty(Limbs.Spine_Start, "From", Head_Position)
					setrenderproperty(Limbs.Spine_Start, "To", Spine_Start_Position)

					setrenderproperty(Limbs.Spine_End, "From", Spine_Start_Position)
					setrenderproperty(Limbs.Spine_End, "To", Spine_End_Position)

					--// Left Arm

					setrenderproperty(Limbs.LeftArm_Start, "From", Spine_Start_Position)
					setrenderproperty(Limbs.LeftArm_Start, "To", LeftArm_Start_Position)

					setrenderproperty(Limbs.LeftArm_Middle, "From", LeftArm_Start_Position)
					setrenderproperty(Limbs.LeftArm_Middle, "To", LeftArm_Middle_Position)

					setrenderproperty(Limbs.LeftArm_End, "From", LeftArm_Middle_Position)
					setrenderproperty(Limbs.LeftArm_End, "To", LeftArm_End_Position)

					--// Right Arm

					setrenderproperty(Limbs.RightArm_Start, "From", Spine_Start_Position)
					setrenderproperty(Limbs.RightArm_Start, "To", RightArm_Start_Position)

					setrenderproperty(Limbs.RightArm_Middle, "From", RightArm_Start_Position)
					setrenderproperty(Limbs.RightArm_Middle, "To", RightArm_Middle_Position)

					setrenderproperty(Limbs.RightArm_End, "From", RightArm_Middle_Position)
					setrenderproperty(Limbs.RightArm_End, "To", RightArm_End_Position)

					--// Left Leg

					setrenderproperty(Limbs.LeftLeg_Start, "From", Spine_End_Position)
					setrenderproperty(Limbs.LeftLeg_Start, "To", LeftLeg_Start_Position)

					setrenderproperty(Limbs.LeftLeg_Middle, "From", LeftLeg_Start_Position)
					setrenderproperty(Limbs.LeftLeg_Middle, "To", LeftLeg_Middle_Position)

					setrenderproperty(Limbs.LeftLeg_End, "From", LeftLeg_Middle_Position)
					setrenderproperty(Limbs.LeftLeg_End, "To", LeftLeg_End_Position)

					--// Right Leg

					setrenderproperty(Limbs.RightLeg_Start, "From", Spine_End_Position)
					setrenderproperty(Limbs.RightLeg_Start, "To", RightLeg_Start_Position)

					setrenderproperty(Limbs.RightLeg_Middle, "From", RightLeg_Start_Position)
					setrenderproperty(Limbs.RightLeg_Middle, "To", RightLeg_Middle_Position)

					setrenderproperty(Limbs.RightLeg_End, "From", RightLeg_Middle_Position)
					setrenderproperty(Limbs.RightLeg_End, "To", RightLeg_End_Position)
				elseif RigType == "R6" then
					for _, Value in next, {"Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"} do
						if not FindFirstChild(Character, Value) then
							repeat
								Visibility(false); wait(0)
							until WaitForChild(Character, Value)
						end
					end

					if not Entry.PositionChanged then
						return
					end

					local Torso = __index(Character, "Torso")
					local LeftArm = __index(Character, "Left Arm")
					local RightArm = __index(Character, "Right Arm")
					local LeftLeg = __index(Character, "Left Leg")
					local RightLeg = __index(Character, "Right Leg")

					local Torso_Height = __index(Torso, "Size").Y / 2 - (HeightModifier + 0.15)
					local Spine_Start_Position = ConvertVector(WorldToViewportPoint((__index(Torso, "CFrame") * CFramenew(0, Torso_Height, 0)).Position))
					local Spine_End_Position = ConvertVector(WorldToViewportPoint((__index(Torso, "CFrame") * CFramenew(0, -Torso_Height, 0)).Position))

					local LeftArm_Height = __index(LeftArm, "Size").Y / 2 - HeightModifier
					local LeftArm_Start_Position =ConvertVector(WorldToViewportPoint((__index(LeftArm, "CFrame") * CFramenew(0, LeftArm_Height, 0)).Position))
					local LeftArm_End_Position = ConvertVector(WorldToViewportPoint((__index(LeftArm, "CFrame") * CFramenew(0, -LeftArm_Height, 0)).Position))

					local RightArm_Height = __index(RightArm, "Size").Y / 2 - HeightModifier
					local RightArm_Start_Position = ConvertVector(WorldToViewportPoint((__index(RightArm, "CFrame") * CFramenew(0, RightArm_Height, 0)).Position))
					local RightArm_End_Position = ConvertVector(WorldToViewportPoint((__index(RightArm, "CFrame") * CFramenew(0, -RightArm_Height, 0)).Position))

					local LeftLeg_Height = __index(LeftLeg, "Size").Y / 2 - HeightModifier
					local LeftLeg_Start_Position = ConvertVector(WorldToViewportPoint((__index(LeftLeg, "CFrame") * CFramenew(0, LeftLeg_Height, 0)).Position))
					local LeftLeg_End_Position = ConvertVector(WorldToViewportPoint((__index(LeftLeg, "CFrame") * CFramenew(0, -LeftLeg_Height, 0)).Position))

					local RightLeg_Height = __index(RightLeg, "Size").Y / 2 - HeightModifier
					local RightLeg_Start_Position = ConvertVector(WorldToViewportPoint((__index(RightLeg, "CFrame") * CFramenew(0, RightLeg_Height, 0)).Position))
					local RightLeg_End_Position = ConvertVector(WorldToViewportPoint((__index(RightLeg, "CFrame") * CFramenew(0, -RightLeg_Height, 0)).Position))

					--// Spine

					setrenderproperty(Limbs.Spine_Start, "From", Head_Position)
					setrenderproperty(Limbs.Spine_Start, "To", Spine_Start_Position)

					setrenderproperty(Limbs.Spine_End, "From", Spine_Start_Position)
					setrenderproperty(Limbs.Spine_End, "To", Spine_End_Position)

					--// Left Arm

					setrenderproperty(Limbs.LeftArm_Start, "From", LeftArm_Start_Position)
					setrenderproperty(Limbs.LeftArm_Start, "To", LeftArm_End_Position)

					setrenderproperty(Limbs.LeftArm_End, "From", Spine_Start_Position)
					setrenderproperty(Limbs.LeftArm_End, "To", LeftArm_Start_Position)

					--// Right Arm

					setrenderproperty(Limbs.RightArm_Start, "From", RightArm_Start_Position)
					setrenderproperty(Limbs.RightArm_Start, "To", RightArm_End_Position)

					setrenderproperty(Limbs.RightArm_End, "From", Spine_Start_Position)
					setrenderproperty(Limbs.RightArm_End, "To", RightArm_Start_Position)

					--// Left Leg

					setrenderproperty(Limbs.LeftLeg_Start, "From", LeftLeg_Start_Position)
					setrenderproperty(Limbs.LeftLeg_Start, "To", LeftLeg_End_Position)

					setrenderproperty(Limbs.LeftLeg_End, "From", Spine_End_Position)
					setrenderproperty(Limbs.LeftLeg_End, "To", LeftLeg_Start_Position)

					--// Right Leg

					setrenderproperty(Limbs.RightLeg_Start, "From", RightLeg_Start_Position)
					setrenderproperty(Limbs.RightLeg_Start, "To", RightLeg_End_Position)

					setrenderproperty(Limbs.RightLeg_End, "From", Spine_End_Position)
					setrenderproperty(Limbs.RightLeg_End, "To", RightLeg_Start_Position)
				else
					Visibility(false)
				end
			else
				Visibility(false)
			end
		end,

		Highlight = function(Entry, Highlight)
			local Settings = Environment.Properties.Highlight

			if not (Entry.IsAPlayer and __index(Entry.Object, "Character") or __index(Entry.Object, "Parent")) then
				return __newindex(Highlight, "Enabled", false)
			end

			__newindex(Highlight, "Enabled", select(3, CoreFunctions.CalculateParameters(Entry)))

			if __index(Highlight, "Enabled") then
				for Index, Value in next, Settings do
					if stringfind(Index, "Color") or stringfind(Index, "Enabled") then
						continue
					elseif stringfind(Index, "Transparency") then
						Value = 1 - Value -- Drawing libraries' and ROBLOX Instances' "Transparency" properties work differently.
					end

					if not pcall(__index, Highlight, Index) then
						continue
					end

					__newindex(Highlight, Index, Value)
				end

				local Humanoid = Entry.Humanoid

				if Settings.HealthColor and Humanoid then
					Highlight.FillColor = CoreFunctions.GetColorFromHealth(__index(Humanoid, "Health"), __index(Humanoid, "MaxHealth"), Settings.HealthColorBlue)
				else
					Highlight.FillColor = CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and Rainbow or Settings.FillColor)
				end

				Highlight.OutlineColor = CoreFunctions.GetColor(Entry.Object, Settings.RainbowOutlineColor and Rainbow or Settings.OutlineColor)
			end
		end
	}
end)()

local CreatingFunctions; LPH_NO_VIRTUALIZE(function()
	CreatingFunctions = {
		ESP = function(Entry)
			local Allowed = Entry.Allowed

			if type(Allowed) == "table" and type(Allowed.ESP) == "boolean" and not Allowed.ESP then
				return
			end

			local Settings = Environment.Properties.ESP

			local TopText = Drawingnew("Text")
			local TopTextObject = TopText

			setrenderproperty(TopTextObject, "ZIndex", 4)
			setrenderproperty(TopTextObject, "Center", true)

			local BottomText = Drawingnew("Text")
			local BottomTextObject = BottomText

			setrenderproperty(BottomTextObject, "ZIndex", 4)
			setrenderproperty(BottomTextObject, "Center", true)

			Entry.Visuals.ESP[1] = TopText
			Entry.Visuals.ESP[2] = BottomText

			Entry.Connections.ESP = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
				local Primed, Ready = pcall(function()
					return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
				end)

				if not Primed then
					pcall(TopText.Remove, TopText)
					pcall(BottomText.Remove, BottomText)

					return Disconnect(Entry.Connections.ESP)
				end

				if Ready then
					UpdatingFunctions.ESP(Entry, TopTextObject, BottomTextObject)
				else
					setrenderproperty(TopTextObject, "Visible", false)
					setrenderproperty(BottomTextObject, "Visible", false)
				end
			end)
		end,

		Tracer = function(Entry)
			local Allowed = Entry.Allowed

			if type(Allowed) == "table" and type(Allowed.Tracer) == "boolean" and not Allowed.Tracer then
				return
			end

			local Settings = Environment.Properties.Tracer

			local TracerOutline = Drawingnew("Line")
			local TracerOutlineObject = TracerOutline

			local Tracer = Drawingnew("Line")
			local TracerObject = Tracer

			Entry.Visuals.Tracer[1] = Tracer
			Entry.Visuals.Tracer[2] = TracerOutline

			Entry.Connections.Tracer = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
				local Primed, Ready = pcall(function()
					return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
				end)

				if not Primed then
					pcall(Tracer.Remove, Tracer)
					pcall(TracerOutline.Remove, TracerOutline)

					return Disconnect(Entry.Connections.Tracer)
				end

				if Ready then
					UpdatingFunctions.Tracer(Entry, TracerObject, TracerOutlineObject)
				else
					setrenderproperty(TracerObject, "Visible", false)
					setrenderproperty(TracerOutlineObject, "Visible", false)
				end
			end)
		end,

		HeadDot = function(Entry)
			local Allowed = Entry.Allowed

			if type(Allowed) == "table" and type(Allowed.HeadDot) == "boolean" and not Allowed.HeadDot then
				return
			end

			if not Entry.IsAPlayer and not Entry.PartHasCharacter then
				if not FindFirstChild(__index(Entry.Object, "Parent"), "Head") then
					return
				end
			end

			local Settings = Environment.Properties.HeadDot

			local CircleOutline = Drawingnew("Circle")
			local CircleOutlineObject = CircleOutline

			local Circle = Drawingnew("Circle")
			local CircleObject = Circle

			--setrenderproperty(CircleObject, "ZIndex", 2)
			--setrenderproperty(CircleOutlineObject, "ZIndex", 1)

			Entry.Visuals.HeadDot[1] = Circle
			Entry.Visuals.HeadDot[2] = CircleOutline

			Entry.Connections.HeadDot = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
				local Primed, Ready = pcall(function()
					return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
				end)

				if not Primed then
					pcall(Circle.Remove, Circle)
					pcall(CircleOutline.Remove, CircleOutline)

					return Disconnect(Entry.Connections.HeadDot)
				end

				if Ready then
					UpdatingFunctions.HeadDot(Entry, CircleObject, CircleOutlineObject)
				else
					setrenderproperty(CircleObject, "Visible", false)
					setrenderproperty(CircleOutlineObject, "Visible", false)
				end
			end)
		end,

		Box = function(Entry)
			local Allowed = Entry.Allowed

			if type(Allowed) == "table" and type(Allowed.Box) == "boolean" and not Allowed.Box then
				return
			end

			local Settings = Environment.Properties.Box

			local _BoxOutlines = {
				TopLeft_Bottom = Drawingnew("Line"),
				TopLeft_Right = Drawingnew("Line"),
				TopRight_Bottom = Drawingnew("Line"),
				TopRight_Left = Drawingnew("Line"),
				BottomLeft_Top = Drawingnew("Line"),
				BottomLeft_Right = Drawingnew("Line"),
				BottomRight_Top = Drawingnew("Line"),
				BottomRight_Left = Drawingnew("Line")
			}

			local BoxOutlines = {}

			local _Quads = {
				Top = Drawingnew("Quad"),
				Bottom = Drawingnew("Quad"),
				Front = Drawingnew("Quad"),
				Back = Drawingnew("Quad"),
				Left = Drawingnew("Quad"),
				Right = Drawingnew("Quad")
			}

			local Quads = {}

			for Index, Value in next, _BoxOutlines do
				BoxOutlines[Index] = Value
			end

			for Index, Value in next, _Quads do
				Quads[Index] = Value
			end

			local _BoxParts, BoxParts = {}, {}

			for Index, _ in next, BoxOutlines do
				BoxParts[Index] = Drawingnew("Line")
				_BoxParts[Index] = _BoxOutlines[Index]
			end

			local _SquareBoxOutline = Drawingnew("Square")
			local _SquareBox = Drawingnew("Square")
			local SquareBoxOutline = _SquareBoxOutline
			local SquareBoxObject = _SquareBox

			setrenderproperty(SquareBoxObject, "ZIndex", 4)
			setrenderproperty(SquareBoxOutline, "ZIndex", 3)

			local SquareBox, _FillBox = {SquareBoxObject, SquareBoxOutline}, Drawingnew("Square")
			local FillBox = _FillBox

			setrenderproperty(FillBox, "Filled", true)

			Entry.Visuals.Box[1] = _BoxParts
			Entry.Visuals.Box[2] = _BoxOutlines
			Entry.Visuals.Box[3] = {_SquareBox, _SquareBoxOutline}
			Entry.Visuals.Box[4] = _FillBox
			Entry.Visuals.Box[5] = _Quads

			Entry.Connections.Box = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
				local Primed, Ready = pcall(function()
					return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
				end)

				if not Primed then
					for Index, Value in next, BoxParts do
						pcall(Value.Remove, Value)
						pcall(BoxOutlines[Index].Remove, BoxOutlines[Index])
					end

					for _, Value in next, Quads do
						pcall(Value.Remove, Value)
					end

					pcall(SquareBox.Remove, SquareBox)
					pcall(FillBox.Remove, FillBox)

					return Disconnect(Entry.Connections.Box)
				end

				if Ready then
					UpdatingFunctions.Box(Entry, BoxParts, BoxOutlines, SquareBox, FillBox, Quads)
				else
					setrenderproperty(SquareBoxObject, "Visible", false)
					setrenderproperty(SquareBoxOutline, "Visible", false)
					setrenderproperty(FillBox, "Visible", false)

					for Index, Value in next, BoxParts do
						setrenderproperty(Value, "Visible", false)
						setrenderproperty(BoxOutlines[Index], "Visible", false)
					end

					for _, Value in next, Quads do
						setrenderproperty(Value, "Visible", false)
					end
				end
			end)
		end,

		HealthBar = function(Entry)
			local Allowed = Entry.Allowed

			if type(Allowed) == "table" and type(Allowed.HealthBar) == "boolean" and not Allowed.HealthBar then
				return
			end

			local Humanoid = FindFirstChildOfClass(__index(Entry.Object, "Parent"), "Humanoid")

			if not Entry.IsAPlayer and not Humanoid then
				return
			end

			local Settings = Environment.Properties.HealthBar

			local Outline = Drawingnew("Line")
			local OutlineObject = Outline

			local Main = Drawingnew("Line")
			local MainObject = Main

			Entry.Visuals.HealthBar[1] = Main
			Entry.Visuals.HealthBar[2] = Outline

			Entry.Connections.HealthBar = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
				local Primed, Ready = pcall(function()
					return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
				end)

				if not Primed then
					pcall(Main.Remove, Main)
					pcall(Outline.Remove, Outline)

					return Disconnect(Entry.Connections.HealthBar)
				end

				if Ready then
					UpdatingFunctions.HealthBar(Entry, MainObject, OutlineObject, Humanoid)
				else
					setrenderproperty(MainObject, "Visible", false)
					setrenderproperty(OutlineObject, "Visible", false)
				end
			end)
		end,

		Chams = function(Entry)
			local Allowed = Entry.Allowed

			if type(Allowed) == "table" and type(Allowed.Chams) == "boolean" and not Allowed.Chams then
				return
			end

			local Object = Entry.Object
			local RigType = Entry.RigType
			local IsAPlayer = Entry.IsAPlayer

			local ChamsEntry = {}

			local PlayerCharacter = IsAPlayer and __index(Object, "Character")

			local Settings = Environment.Properties.Chams

			local UnconfirmedRigType = RigType == "N/A"

			if UnconfirmedRigType and PlayerCharacter then
				RigType = (FindFirstChild(PlayerCharacter, "UpperTorso") or WaitForChild(PlayerCharacter, "LowerTorso", Inf)) and "R15" or FindFirstChild(PlayerCharacter, "Torso") and "R6" or "N/A"
			end

			if RigType == "N/A" then
				ChamsEntry[__index(Object, "Name")] = {}
			else
				ChamsEntry = RigType == "R15" and {
					Head = {},
					UpperTorso = {}, LowerTorso = {},
					LeftLowerArm = {}, LeftUpperArm = {}, LeftHand = {},
					RightLowerArm = {}, RightUpperArm = {}, RightHand = {},
					LeftLowerLeg = {}, LeftUpperLeg = {}, LeftFoot = {},
					RightLowerLeg = {}, RightUpperLeg = {}, RightFoot = {}
				} or RigType == "R6" and {
					Head = {},
					Torso = {},
					["Left Arm"] = {},
					["Right Arm"] = {},
					["Left Leg"] = {},
					["Right Leg"] = {}
				}
			end

			Entry.Visuals.Chams = ChamsEntry

			local ChamsEntryObjects = {}

			for _Index, Value in next, ChamsEntry do
				ChamsEntryObjects[_Index] = {}

				for Index = 1, 6 do
					Value["Quad"..Index] = Drawingnew("Quad")
					ChamsEntryObjects[_Index]["Quad"..Index] = Value["Quad"..Index]
				end
			end

			local Visibility = function(Value)
				for _, _Value in next, ChamsEntryObjects do
					for Index = 1, 6 do
						setrenderproperty(_Value["Quad"..Index], "Visible", Value)
					end
				end
			end

			Entry.Connections.Chams = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
				local Primed, Ready = pcall(function()
					return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
				end)

				if not Primed then
					for _, Value in next, ChamsEntry do
						pcall(Value.Remove, Value)
					end

					return Disconnect(Entry.Connections.Chams)
				end

				if Ready then
					local Character = PlayerCharacter or __index(Object, "Parent")

					if Character and IsDescendantOf(Character, Workspace) then
						for Index, Value in next, ChamsEntryObjects do
							local Part = WaitForChild(Character, Index, Inf)

							if Part and IsDescendantOf(Part, Workspace) then
								UpdatingFunctions.Chams(Entry, Part, Value)
							else
								Visibility(false)
							end
						end
					else
						Visibility(false)
					end
				else
					Visibility(false)
				end
			end)
		end,

		Skeleton = function(Entry)
			local Allowed = Entry.Allowed
			local Settings = Environment.Properties.Skeleton

			if type(Allowed) == "table" and type(Allowed.Skeleton) == "boolean" and not Allowed.Skeleton then
				return
			end

			local Object = Entry.Object

			if not Entry.IsAPlayer and not Entry.PartHasCharacter then
				if not FindFirstChild(__index(Object, "Parent"), "Head") then
					return
				end
			end

			local RigType = Entry.RigType

			Entry.Visuals.Skeleton = RigType == "R15" and {
				Spine_Start = Drawingnew("Line"),
				Spine_End = Drawingnew("Line"),

				LeftArm_Start = Drawingnew("Line"),
				LeftArm_Middle = Drawingnew("Line"),
				LeftArm_End = Drawingnew("Line"),

				RightArm_Start = Drawingnew("Line"),
				RightArm_Middle = Drawingnew("Line"),
				RightArm_End = Drawingnew("Line"),

				LeftLeg_Start = Drawingnew("Line"),
				LeftLeg_Middle = Drawingnew("Line"),
				LeftLeg_End = Drawingnew("Line"),

				RightLeg_Start = Drawingnew("Line"),
				RightLeg_Middle = Drawingnew("Line"),
				RightLeg_End = Drawingnew("Line")
			} or RigType == "R6" and {
				Spine_Start = Drawingnew("Line"),
				Spine_End = Drawingnew("Line"),

				LeftArm_Start = Drawingnew("Line"),
				LeftArm_End = Drawingnew("Line"),

				RightArm_Start = Drawingnew("Line"),
				RightArm_End = Drawingnew("Line"),

				LeftLeg_Start = Drawingnew("Line"),
				LeftLeg_End = Drawingnew("Line"),

				RightLeg_Start = Drawingnew("Line"),
				RightLeg_End = Drawingnew("Line")
			}

			local SkeletonEntry = Entry.Visuals.Skeleton

			if not type(SkeletonEntry) == "table" or not SkeletonEntry then
				return warn("EXUNYS_ESP > CreatingFunctions.Skeleton (Critical Skeleton Error) - Couldn't identify Humanoid Rig Type for user \""..Entry.Name.."\". Aborted rendering.")
			end

			Entry.Connections.Skeleton = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
				local Primed, Ready = pcall(function()
					return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
				end)

				if not Primed then
					for _, Value in next, SkeletonEntry do
						pcall(Value.Remove, Value)
					end

					return Disconnect(Entry.Connections.Skeleton)
				end

				if Ready then
					UpdatingFunctions.Skeleton(Entry)
				else
					for _, Value in next, SkeletonEntry do
						setrenderproperty(Value, "Visible", false)
					end
				end
			end)
		end,

		Highlight = function(Entry)
			local Settings = Environment.Properties.Highlight
			local Allowed = Entry.Allowed

			if type(Allowed) == "table" and type(Allowed.Highlight) == "boolean" and not Allowed.Highlight then
				return
			end

			local Character = Entry.IsAPlayer and __index(Entry.Object, "Character") or __index(Entry.Object, "Parent")

			if not Character and Entry.IsAPlayer then
				repeat
					Character = __index(Entry.Object, "Character"); wait()
				until Character
			end

			Entry.Visuals.Highlight = Instancenew("Highlight", Character)

			local Highlight = Entry.Visuals.Highlight

			__newindex(Highlight, "Name", "EXUNYS_HIGHLIGHT")

			Entry.Connections.Highlight = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
				local Primed, Ready = pcall(function()
					return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
				end)

				if not Primed then
					pcall(Highlight.Destroy, Highlight)

					return Disconnect(Entry.Connections.Highlight)
				end

				Character = Entry.IsAPlayer and __index(Entry.Object, "Character") or __index(Entry.Object, "Parent")

				if Character and IsDescendantOf(Character, Workspace) and FindFirstChild(Character, "EXUNYS_HIGHLIGHT") then
					if Ready then
						UpdatingFunctions.Highlight(Entry, Highlight)
					else
						pcall(Highlight.Destroy, Highlight)
						Entry.Visuals.Highlight = Instancenew("Highlight", Character)
						Highlight = Entry.Visuals.Highlight
						__newindex(Highlight, "Name", "EXUNYS_HIGHLIGHT")
						__newindex(Highlight, "Enabled", false)
					end
				else
					pcall(Highlight.Destroy, Highlight)
					Entry.Visuals.Highlight = Instancenew("Highlight", Character)
					Highlight = Entry.Visuals.Highlight
					__newindex(Highlight, "Name", "EXUNYS_HIGHLIGHT")
					__newindex(Highlight, "Enabled", false)
				end
			end)
		end,

		Crosshair = function()
			local ServiceConnections = Environment.UtilityAssets.ServiceConnections
			local DeveloperSettings = Environment.DeveloperSettings
			local Settings = Environment.Properties.Crosshair

			local RenderObjects = {}

			for Index, Value in next, CrosshairParts do
				RenderObjects[Index] = Value
			end

			local Axis, Rotation, GapSize = GetMouseLocation(), Settings.Rotation, Settings.GapSize

			ServiceConnections.UpdateCrosshairProperties, ServiceConnections.UpdateCrosshair = Connect(__index(RunService, DeveloperSettings.UpdateMode), function()
				if Settings.Enabled and Environment.Settings.Enabled then
					if Settings.PulseGap then
						Settings.PulsingStep = mathclamp(Settings.PulsingStep, 0, 24)
						Settings.PulsingSpeed = mathclamp(Settings.PulsingSpeed, 1, 20)

						local PulsingStep = mathclamp(Settings.PulsingStep, unpack(Settings.PulsingBounds))

						GapSize = mathabs(mathsin(FrameTick * Settings.PulsingSpeed) * PulsingStep)
						GapSize = mathclamp(GapSize, unpack(Settings.PulsingBounds))
					else
						GapSize = Settings.GapSize
					end

					if Settings.Rotate then
						Settings.RotationSpeed = mathclamp(Settings.RotationSpeed, 1, 20)

						Rotation = mathdeg(FrameTick * Settings.RotationSpeed)
						Rotation = Settings.RotateClockwise and Rotation or -Rotation
					else
						Rotation = Settings.Rotation
					end

					GapSize = mathclamp(GapSize, 0, 24)

					if Settings.Position == 1 then
						Axis = GetMouseLocation()
					elseif Settings.Position == 2 then
						Axis = CameraViewportSize / 2
					else
						Settings.Position = 1
					end
				end
			end), Connect(__index(RunService, DeveloperSettings.UpdateMode), function()
				if Settings.Enabled and Environment.Settings.Enabled then
					local AxisX, AxisY, Size = Axis.X, Axis.Y, Settings.Size

					for ObjectName, RenderObject in next, RenderObjects do
						for Index, _ in next, {Color = true, Transparency = true, Thickness = true} do
							local Value = Settings[Index]

							if (Index == "Color" or Index == "Thickness") and (stringfind(ObjectName, "Outline") or stringfind(ObjectName, "CenterDot")) then
								continue
							end

							if Index == "Color" and not (stringfind(ObjectName, "Outline") or stringfind(ObjectName, "CenterDot")) then
								Value = Settings.RainbowColor and Rainbow or Value
							end

							if ValidProperties[Index] or Index == "Color" then
								setrenderproperty(RenderObject, Index, Value)
							end
						end
					end

					--// Left Line

					setrenderproperty(RenderObjects.LeftLine, "Visible", Settings.Enabled)

					setrenderproperty(RenderObjects.LeftLine, "From", Vector2new(AxisX - (mathcos(mathrad(Rotation)) * GapSize), AxisY - (mathsin(mathrad(Rotation)) * GapSize)))
					setrenderproperty(RenderObjects.LeftLine, "To", Vector2new(AxisX - (mathcos(mathrad(Rotation)) * (Size + GapSize)), AxisY - (mathsin(mathrad(Rotation)) * (Size + GapSize))))

					--// Right Line

					setrenderproperty(RenderObjects.RightLine, "Visible", Settings.Enabled)

					setrenderproperty(RenderObjects.RightLine, "From", Vector2new(AxisX + (mathcos(mathrad(Rotation)) * GapSize), AxisY + (mathsin(mathrad(Rotation)) * GapSize)))
					setrenderproperty(RenderObjects.RightLine, "To", Vector2new(AxisX + (mathcos(mathrad(Rotation)) * (Size + GapSize)), AxisY + (mathsin(mathrad(Rotation)) * (Size + GapSize))))

					--// Top Line

					setrenderproperty(RenderObjects.TopLine, "Visible", Settings.Enabled and not Settings.TStyled)

					setrenderproperty(RenderObjects.TopLine, "From", Vector2new(AxisX - (mathsin(mathrad(-Rotation)) * GapSize), AxisY - (mathcos(mathrad(-Rotation)) * GapSize)))
					setrenderproperty(RenderObjects.TopLine, "To", Vector2new(AxisX - (mathsin(mathrad(-Rotation)) * (Size + GapSize)), AxisY - (mathcos(mathrad(-Rotation)) * (Size + GapSize))))

					--// Bottom Line

					setrenderproperty(RenderObjects.BottomLine, "Visible", Settings.Enabled)

					setrenderproperty(RenderObjects.BottomLine, "From", Vector2new(AxisX + (mathsin(mathrad(-Rotation)) * GapSize), AxisY + (mathcos(mathrad(-Rotation)) * GapSize)))
					setrenderproperty(RenderObjects.BottomLine, "To", Vector2new(AxisX + (mathsin(mathrad(-Rotation)) * (Size + GapSize)), AxisY + (mathcos(mathrad(-Rotation)) * (Size + GapSize))))

					--// Outlines

					if Settings.Outline then
						local Table = {"LeftLine", "RightLine", "TopLine", "BottomLine"}

						for _Index = 1, 4 do
							local Index = Table[_Index]
							local Value, _Value = RenderObjects["Outline"..Index], RenderObjects[Index]

							setrenderproperty(Value, "Visible", getrenderproperty(_Value, "Visible"))
							setrenderproperty(Value, "Thickness", getrenderproperty(_Value, "Thickness") + 1)
							setrenderproperty(Value, "Color", Settings.RainbowOutlineColor and Rainbow or Settings.OutlineColor)

							local From, To = getrenderproperty(_Value, "From"), getrenderproperty(_Value, "To")

							if not (Settings.Rotate and Settings.RotationSpeed <= 5) then
								if Index == "TopLine" then
									setrenderproperty(Value, "From", Vector2new(From.X, From.Y + 1))
									setrenderproperty(Value, "To", Vector2new(To.X, To.Y - 1))
								elseif Index == "BottomLine" then
									setrenderproperty(Value, "From", Vector2new(From.X, From.Y - 1))
									setrenderproperty(Value, "To", Vector2new(To.X, To.Y + 1))
								elseif Index == "LeftLine" then
									setrenderproperty(Value, "From", Vector2new(From.X + 1, From.Y))
									setrenderproperty(Value, "To", Vector2new(To.X - 1, To.Y))
								elseif Index == "RightLine" then
									setrenderproperty(Value, "From", Vector2new(From.X - 1, From.Y))
									setrenderproperty(Value, "To", Vector2new(To.X + 1, To.Y))
								end
							else
								setrenderproperty(Value, "From", From)
								setrenderproperty(Value, "To", To)
							end
						end
					else
						for _, Index in next, {"LeftLine", "RightLine", "TopLine", "BottomLine"} do
							setrenderproperty(RenderObjects["Outline"..Index], "Visible", false)
						end
					end

					--// Center Dot

					local CenterDot = RenderObjects.CenterDot
					local OutlineCenterDot = RenderObjects.OutlineCenterDot
					local CenterDotSettings = Settings.CenterDot

					setrenderproperty(CenterDot, "Visible", Settings.Enabled and CenterDotSettings.Enabled)
					setrenderproperty(RenderObjects.OutlineCenterDot, "Visible", Settings.Enabled and CenterDotSettings.Enabled and CenterDotSettings.Outline)

					if getrenderproperty(CenterDot, "Visible") then
						for Index, Value in next, CenterDotSettings do
							if Index == "Color" then
								Value = CenterDotSettings.RainbowColor and Rainbow or Value
							end

							if ValidProperties[Index] or Index == "Color" then
								setrenderproperty(CenterDot, Index, Value)

								if Index ~= "Color" and Index ~= "Thickness" then
									setrenderproperty(OutlineCenterDot, Index, Value)
								end
							end
						end

						setrenderproperty(CenterDot, "Position", Axis)

						if CenterDotSettings.Outline then
							setrenderproperty(OutlineCenterDot, "Thickness", getrenderproperty(CenterDot, "Thickness") + 1)
							setrenderproperty(OutlineCenterDot, "Color", CenterDotSettings.RainbowOutlineColor and Rainbow or CenterDotSettings.OutlineColor)

							setrenderproperty(OutlineCenterDot, "Position", Axis)
						end
					end
				else
					for _, RenderObject in next, RenderObjects do
						setrenderproperty(RenderObject, "Visible", false)
					end
				end
			end)
		end
	}
end)()

local UtilityFunctions; LPH_NO_VIRTUALIZE(function()
	UtilityFunctions = {
		InitChecks = function(self, Entry)
			local Settings = Environment.Settings
			local DeveloperSettings = Environment.DeveloperSettings

			local Player = Entry.Object
			local Checks = Entry.Checks
			local Hash = Entry.Hash
			local IsAPlayer = Entry.IsAPlayer
			local PartHasCharacter = Entry.PartHasCharacter
			local RenderDistance = Entry.RenderDistance

			if not IsAPlayer and not PartHasCharacter and not RenderDistance then
				return
			end

			local Top = select(4, CoreFunctions.CalculateParameters(Entry))

			Entry.OldPosition = Environment.Settings.CachePositions and Top and CoreFunctions.GetLocalCharacterPosition() - select(4, CoreFunctions.CalculateParameters(Entry))

			Entry.Connections.UpdateChecks = Connect(__index(RunService, DeveloperSettings.UpdateMode), function()
				if DeveloperSettings.Throttle then
					Entry._Frame = (Entry._Frame or 0) + 1

					if Entry._Frame % mathclamp(DeveloperSettings.ThrottleStep, 2, 4) ~= 0 then
						return
					end
				end

				Top = select(4, CoreFunctions.CalculateParameters(Entry))

				if Top and Environment.Settings.CachePositions then
					Entry.Position = CoreFunctions.GetLocalCharacterPosition() - Top
					Entry.PositionChanged = Entry.OldPosition ~= Entry.Position
					Entry.OldPosition = Entry.OldPosition == Entry.Position and Entry.OldPosition or Entry.Position
				else
					Entry.PositionChanged = true
				end

				RenderDistance = Entry.RenderDistance

				if not Settings.Enabled then
					Checks.Ready = false
					Checks.Alive = false
					Checks.Team = false

					return
				end

				if not IsAPlayer and not PartHasCharacter then -- Part ESP
					Checks.Ready = (__index(Player, "Position") - CoreFunctions.GetLocalCharacterPosition()).Magnitude <= RenderDistance; return
				end

				if not IsAPlayer then -- NPC
					local PartHumanoid = FindFirstChildOfClass(__index(Player, "Parent"), "Humanoid")

					Checks.Ready = PartHasCharacter and PartHumanoid and IsDescendantOf(Player, Workspace)

					if not Checks.Ready then
						return self.UnwrapObject(Hash)
					end

					local IsInDistance = (__index(Player, "Position") - CoreFunctions.GetLocalCharacterPosition()).Magnitude <= RenderDistance

					if Settings.AliveCheck then
						Checks.Alive = __index(PartHumanoid, "Health") > 0
					end

					Checks.Ready = Checks.Ready and Checks.Alive and IsInDistance and Environment.Settings.EntityESP

					return
				end

				local Character = __index(Player, "Character")
				local Humanoid = Character and FindFirstChildOfClass(Character, "Humanoid")
				local Head = Character and FindFirstChild(Character, "Head")

				local IsInDistance

				if Character and IsDescendantOf(Character, Workspace) and Humanoid and Head then
					local TeamCheckOption = DeveloperSettings.TeamCheckOption

					Checks.Alive = true
					Checks.Team = true

					if Settings.AliveCheck then
						Checks.Alive = __index(Humanoid, "Health") > 0
					end

					if Settings.TeamCheck then
						Checks.Team = __index(Player, TeamCheckOption) ~= __index(LocalPlayer, TeamCheckOption)
					end

					IsInDistance = (__index(Head, "Position") - CoreFunctions.GetLocalCharacterPosition()).Magnitude <= RenderDistance
				else
					Checks.Alive = false
					Checks.Team = false

					if DeveloperSettings.UnwrapOnCharacterAbsence then
						self.UnwrapObject(Hash)
					end
				end

				Checks.Ready = Checks.Alive and Checks.Team and not Settings.PartsOnly and IsInDistance

				if Checks.Ready then
					if Humanoid then
						Entry.Humanoid = Humanoid
					end

					local Part = IsAPlayer and (FindFirstChild(Players, __index(Player, "Name")) and __index(Player, "Character"))
					Part = IsAPlayer and (Part and (__index(Part, "PrimaryPart") or FindFirstChild(Part, "HumanoidRootPart"))) or Player

					Entry.RigType = Humanoid and FindFirstChild(__index(Part, "Parent"), "Torso") and "R6" or "R15"
					Entry.RigType = Entry.RigType == "N/A" and Humanoid and (__index(Humanoid, "RigType") == 0 and "R6" or "R15") or "N/A" -- Deprecated method (might be faulty sometimes)
					Entry.RigType = Entry.RigType == "N/A" and Humanoid and (__index(Humanoid, "RigType") == Enum.HumanoidRigType.R6 and "R6" or "R15") or "N/A" -- Secondary check
				end
			end)
		end,

		GetObjectEntry = function(Object, Hash)
			Hash = type(Object) == "string" and Object or Hash

			for _, Value in next, Environment.UtilityAssets.WrappedObjects do
				if Hash and Value.Hash == Hash or Value.Object == Object then
					return Value
				end
			end
		end,

		WrapObject = function(self, Object, PseudoName, Allowed, RenderDistance)
			assert(self, "EXUNYS_ESP > UtilityFunctions.WrapObject - Internal error, unassigned parameter \"self\".")

			--// Because gethiddenproperty behaves differently on Xeno, this part breaks the code. This is the universal solution.

			-- if pcall(gethiddenproperty, Object, "PrimaryPart") then
			-- 	Object = __index(Object, "PrimaryPart")
			-- end

			do
				local Signal = {pcall(gethiddenproperty, Object, "PrimaryPart")}

				if Signal[1] and typeof(Signal[2]) ~= "number" then
					Object = __index(Object, "PrimaryPart")
				end
			end

			if not Object then
				return
			end

			if Object == LocalPlayer then
				return
			end

			local DeveloperSettings = Environment.DeveloperSettings
			local WrappedObjects = Environment.UtilityAssets.WrappedObjects

			for _, Value in next, WrappedObjects do
				if Value.Object == Object then
					return
				end
			end

			local Entry = {
				Hash = CoreFunctions.GenerateHash(0x100),

				Object = Object,
				Allowed = Allowed,
				Name = PseudoName or __index(Object, "Name"),
				DisplayName = PseudoName or __index(Object, (IsA(Object, "Player") and "Display" or "").."Name"),
				RenderDistance = RenderDistance or Inf,

				IsAPlayer = IsA(Object, "Player") or __index(Object, "ClassName") == "Player",
				PartHasCharacter = false,
				RigType = "N/A",
				Humanoid = nil,

				Checks = {
					Alive = true,
					Team = true,
					Ready = true
				},

				Visuals = {
					ESP = {},
					Tracer = {},
					Box = {},
					HealthBar = {},
					HeadDot = {}
				},

				Connections = {}
			}

			repeat
				wait(0)
			until Entry.IsAPlayer and FindFirstChildOfClass(__index(Entry.Object, "Character"), "Humanoid") or true

			if not Entry.IsAPlayer then
				if not pcall(function()
						return __index(Entry.Object, "Position"), __index(Entry.Object, "CFrame")
					end) then
					warn("EXUNYS_ESP > UtilityFunctions.WrapObject - Attempted to wrap object of an unsupported class type: \""..(__index(Entry.Object, "ClassName") or "N / A").."\"")
					return self.UnwrapObject(Entry.Hash)
				end

				Entry.Connections.UnwrapSignal = Connect(Entry.Object.Changed, function(Property)
					if Property == "Parent" and not IsDescendantOf(__index(Entry.Object, Property), Workspace) then
						self.UnwrapObject(nil, Entry.Hash)
					end
				end)
			end

			local Humanoid = Entry.IsAPlayer and FindFirstChildOfClass(__index(Entry.Object, "Character"), "Humanoid") or FindFirstChildOfClass(__index(Entry.Object, "Parent"), "Humanoid")

			Entry.PartHasCharacter = not Entry.IsAPlayer and Humanoid
			Entry.RigType = Humanoid and (__index(Humanoid, "RigType") == 0 and "R6" or "R15") or "N/A"
			Entry.Humanoid = Humanoid

			self:InitChecks(Entry)

			spawn(function()
				repeat
					wait(0)
				until Entry.Checks.Ready

				CreatingFunctions.Box(Entry)
				CreatingFunctions.Tracer(Entry)
				CreatingFunctions.HealthBar(Entry)
				CreatingFunctions.Skeleton(Entry)
				CreatingFunctions.HeadDot(Entry)
				CreatingFunctions.ESP(Entry)
				--CreatingFunctions.Chams(Entry)
				CreatingFunctions.Highlight(Entry)

				--delay(1, CoreFunctions.ResetScreenDistortion, CoreFunctions)
			end)

			WrappedObjects[Entry.Hash] = Entry

			Entry.Connections.PlayerUnwrapSignal = Connect(Entry.Object.Changed, function(Property)
				if DeveloperSettings.UnwrapOnCharacterAbsence and Property == "Parent" and not IsDescendantOf(__index(Entry.Object, (Entry.IsAPlayer and "Character" or Property)), Workspace) then
					self.UnwrapObject(nil, Entry.Hash)
				end
			end)

			return Entry.Hash
		end,

		UnwrapObject = function(Object, Hash)
			Hash = type(Object) == "string" and Object
			Object = type(Object) == "string" and nil

			for _, Value in next, Environment.UtilityAssets.WrappedObjects do
				if Value.Object == Object or Value.Hash == Hash then
					for _, _Value in next, Value.Connections do
						pcall(Disconnect, _Value)
					end

					if Value.Visuals then
						if Value.Visuals.Highlight then
							pcall(Value.Visuals.Highlight.Destroy, Value.Visuals.Highlight); Value.Visuals.Highlight = nil
						end

						Recursive(Value.Visuals, function(_, _Value)
							if type(_Value) == "table" and _Value then
								pcall(_Value.Remove, _Value)
							end
						end)
					end

					Environment.UtilityAssets.WrappedObjects[Hash] = nil; break
				end
			end
		end
	}
end)()

local LoadESP; LPH_NO_VIRTUALIZE(function()
	LoadESP = function()
		local ServiceConnections = Environment.UtilityAssets.ServiceConnections

		ServiceConnections.UpdateCoreParameters = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
			FrameTick = tick()
			Rainbow = CoreFunctions.GetRainbowColor()
			CameraCFrame = __index(CurrentCamera, "CFrame")
			CameraViewportSize = __index(CurrentCamera, "ViewportSize")
		end)

		ServiceConnections.PlayerRemoving = Connect(__index(Players, "PlayerRemoving"), UtilityFunctions.UnwrapObject)

		ServiceConnections.CharacterAdded = Connect(__index(Workspace, "DescendantAdded"), function(Object)
			if not IsA(Object, "Model") then
				return
			end

			if not GetPlayerFromCharacter(Object) or not FindFirstChild(Players, __index(Object, "Name")) then
				return
			end

			for _, Value in next, GetPlayers() do
				local Player = nil

				for _, _Value in next, Environment.UtilityAssets.WrappedObjects do
					if not _Value.IsAPlayer then
						continue
					end

					if __index(_Value.Object, "Name") == __index(Value, "Name") then
						Player = _Value
					end
				end

				if not Player then
					UtilityFunctions:WrapObject(GetPlayerFromCharacter(Object))
				end
			end

			--CoreFunctions:ResetScreenDistortion()
		end)

		ServiceConnections.PlayerAdded = Connect(__index(Players, "PlayerAdded"), function(Player)
			local WrappedObjects = Environment.UtilityAssets.WrappedObjects
			local Hash = UtilityFunctions:WrapObject(Player)

			for _, Entry in next, WrappedObjects do
				if Entry.Hash ~= Hash then
					continue
				end

				Entry.Connections[__index(Player, "Name").."_CharacterAdded"] = Connect(__index(Player, "CharacterAdded"), function(Object)
					for _, _Value in next, Environment.UtilityAssets.WrappedObjects do
						if not _Value.Name == __index(Object, "Name") then
							continue
						end

						UtilityFunctions:WrapObject(GetPlayerFromCharacter(Object))
					end
				end)
			end
		end)

		--// Wrap all players
		
		for _, Value in next, GetPlayers() do
			if Value ~= LocalPlayer then
				UtilityFunctions:WrapObject(Value)
			end
		end

		--// Entity ESP

		for _, Value in next, workspace:GetDescendants() do
			if Value:IsA("Humanoid") then
				local PotentialCharacter = Value.Parent:IsA("Model") and Value.Parent

				if PotentialCharacter and not GetPlayerFromCharacter(PotentialCharacter) and FindFirstChild(PotentialCharacter, "Head") and (__index(PotentialCharacter, "PrimaryPart") or FindFirstChild(PotentialCharacter, "HumanoidRootPart")) then
					UtilityFunctions:WrapObject(PotentialCharacter, PotentialCharacter.Name)
				end
			end
		end

		ServiceConnections.Entity_DescendantAdded = Connect(__index(workspace, "DescendantAdded"), function(Value)
			if Value:IsA("Model") and Value:FindFirstChildOfClass("Humanoid") and not GetPlayerFromCharacter(Value) and (__index(Value, "PrimaryPart") or FindFirstChild(Value, "HumanoidRootPart")) then
				UtilityFunctions:WrapObject(Value.Parent, Value.Parent.Name)
			end
		end)
	end
end)()

setmetatable(Environment, {
	__call = function()
		if Loaded then
			return
		end

		Loaded = true
		return LoadESP(), CreatingFunctions.Crosshair()
	end
})

pcall(spawn, function()
	if Environment.Settings.LoadConfigOnLaunch then
		repeat wait(0) until Environment.LoadConfiguration

		Environment:LoadConfiguration()
	end
end)

--// Interactive User Methods

Environment.UnwrapPlayers = function() -- (<void>) => <boolean> Success Status
	local UtilityAssets = Environment.UtilityAssets

	local WrappedObjects = UtilityAssets.WrappedObjects
	local ServiceConnections = UtilityAssets.ServiceConnections

	for _, Entry in next, WrappedObjects do
		pcall(UtilityFunctions.UnwrapObject, Entry.Hash)
	end

	for _, ConnectionIndex in next, {"PlayerRemoving", "PlayerAdded", "CharacterAdded"} do
		pcall(Disconnect, ServiceConnections[ConnectionIndex])
	end

	return #WrappedObjects == 0
end

Environment.UnwrapAll = function(self) -- (self) => <boolean> Success Status
	assert(self, "EXUNYS_ESP.UnwrapAll: Missing parameter #1 \"self\" <table>.")

	if self.UnwrapPlayers() and CrosshairParts.LeftLine then
		self.RemoveCrosshair()
	end

	return #self.UtilityAssets.WrappedObjects == 0 and not CrosshairParts.LeftLine
end

Environment.Restart = function(self, RewriteEntries) -- (self[, <bool> Rewrite entries]) => <void>
	assert(self, "EXUNYS_ESP.Restart: Missing parameter #1 \"self\" <table>.")

	if Restarting then
		return
	end

	Restarting = true

	if RewriteEntries then
		if self:UnwrapAll() then
			self.Load()
		end
	else
		local Objects = {}

		for _, Value in next, self.UtilityAssets.WrappedObjects do
			Objects[#Objects + 1] = {Value.Hash, Value.Object, Value.Name, Value.Allowed, Value.RenderDistance}
		end

		for _, Value in next, Objects do
			self.UnwrapObject(Value[1])
		end

		wait(1)

		for _, Value in next, Objects do
			self.WrapObject(select(2, unpack(Value)))
		end

		if CrosshairParts.LeftLine then
			self.RemoveCrosshair()
			self.RenderCrosshair()
		end
	end

	Restarting = false
end

Environment.Exit = function(self) -- (self) => <void>
	assert(self, "EXUNYS_ESP.Exit: Missing parameter #1 \"self\" <table>.")

	if self:UnwrapAll() then
		for _, Connection in next, self.UtilityAssets.ServiceConnections do
			pcall(Disconnect, Connection)
		end

		for _, RenderObject in next, CrosshairParts do
			pcall(RenderObject.Remove, RenderObject)
		end

		for _, Table in next, {CoreFunctions, UpdatingFunctions, CreatingFunctions, UtilityFunctions} do
			for FunctionName, _ in next, Table do
				Table[FunctionName] = nil
			end

			Table = nil
		end

		for Index, _ in next, Environment do
			Environment[Index] = nil
		end

		LoadESP = nil; Recursive = nil; Loaded = false

		if cleardrawcache then
			cleardrawcache()
		end

		getgenv().ExunysDeveloperESP = nil; pcall(collectgarbage, "step", 200)
	end
end

Environment.WrapObject = function(...) -- (<Instance> Object[, <string> Pseudo Name, <table> Allowed Visuals, <uint> Render Distance]) => <string> Hash
	return UtilityFunctions:WrapObject(...)
end

Environment.UnwrapObject = UtilityFunctions.UnwrapObject -- (<Instance/string> Object/Hash[, <string> Hash]) => <void>

Environment.RenderCrosshair = CreatingFunctions.Crosshair -- (<void>) => <void>

Environment.RemoveCrosshair = function() -- (<void>) => <void>
	if not CrosshairParts.LeftLine then
		return
	end

	local ServiceConnections = Environment.UtilityAssets.ServiceConnections

	pcall(Disconnect, ServiceConnections.UpdateCrosshairProperties)
	pcall(Disconnect, ServiceConnections.UpdateCrosshair)

	for _, RenderObject in next, CrosshairParts do
		pcall(RenderObject.Remove, RenderObject)
	end

	CrosshairParts = {}
end

Environment.WrapPlayers = LoadESP -- (<void>) => <void>

Environment.GetEntry = UtilityFunctions.GetObjectEntry -- (<Instance> Object[, <string> Hash]) => <table> Entry

Environment.Load = function() -- (<void>) => <void>
	if Loaded then
		return
	end

	LoadESP(); CreatingFunctions.Crosshair(); Loaded = true
end

Environment.UpdateConfiguration = function(DeveloperSettings, Settings, Properties) -- (<table> DeveloperSettings, <table> Settings, <table> Properties) => <table> New Environment
	assert(DeveloperSettings, "EXUNYS_ESP.UpdateConfiguration: Missing parameter #1 \"DeveloperSettings\" <table>.")
	assert(Settings, "EXUNYS_ESP.UpdateConfiguration: Missing parameter #2 \"Settings\" <table>.")
	assert(Properties, "EXUNYS_ESP.UpdateConfiguration: Missing parameter #3 \"Properties\" <table>.")

	getgenv().ExunysDeveloperESP.DeveloperSettings = DeveloperSettings
	getgenv().ExunysDeveloperESP.Settings = Settings
	getgenv().ExunysDeveloperESP.Properties = Properties

	Environment = getgenv().ExunysDeveloperESP

	return Environment
end

Environment.LoadConfiguration = function(self) -- (self) => <void>
	assert(self, "EXUNYS_ESP.LoadConfiguration: Missing parameter #1 \"self\" <table>.")

	local Path = self.DeveloperSettings.Path

	if self:UnwrapAll() then
		pcall(function()
			local Configuration, Data = ConfigLibrary:LoadConfig(Path), {}

			for _, Index in next, {"DeveloperSettings", "Settings", "Properties"} do
				Data[#Data + 1] = ConfigLibrary:CloneTable(Configuration[Index])
			end

			self.UpdateConfiguration(unpack(Data))()
		end)
	end
end

Environment.SaveConfiguration = function(self) -- (self) => <void>
	assert(self, "EXUNYS_ESP.SaveConfiguration: Missing parameter #1 \"self\" <table>.")

	local DeveloperSettings = self.DeveloperSettings

	ConfigLibrary:SaveConfig(DeveloperSettings.Path, {
		DeveloperSettings = DeveloperSettings,
		Settings = self.Settings,
		Properties = self.Properties
	})
end

return Environment
