local game = game
local select, pcall, loadstring , warn = select, pcall, loadstring, warn

if ExunysDeveloperESP then
	warn("EXUNYS_ESP > Loader - Exunys ESP Module is already loaded into your environment!")
	warn("EXUNYS_ESP > Loader - Execute \"ExunysDeveloperESP:Exit()\" before running a new instance of this module.")
else
	if select(2, pcall(select(2, pcall(loadstring, game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/Modules/Original.lua"))))) then
		if ExunysDeveloperESP then
			ExunysDeveloperESP:Exit()
		end

		if select(2, pcall(select(2, pcall(loadstring, game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/Modules/UWP%20Support.lua"))))) then
			warn("EXUNYS_ESP > Loader - Your script execution software does not support this module.")
			ExunysDeveloperESP:Exit()
		end
	end
end

-- Exunys <3
