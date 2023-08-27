local xpcall, loadstring, type, warn = xpcall, loadstring, type, warn

xpcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/Modules/Original.lua"))()
end, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/Modules/UWP%20Support.lua"))()
end)

if not type(ExunysDeveloperESP) == "table" then
	warn("EXUNYS_ESP > Loader - Your script execution software does not support this module.")
end

-- Exunys <3
