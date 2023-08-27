local game = game
local select, pcall, loadstring , warn = select, pcall, loadstring, warn

if select(2, pcall(pcall(loadstring, game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/Modules/Original.lua")))) then
	if select(2, pcall(pcall(loadstring, game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/Modules/UWP%20Support.lua")))) then
		warn("EXUNYS_ESP > Loader - Your script execution software does not support this module.")
	end
end

-- Exunys <3
