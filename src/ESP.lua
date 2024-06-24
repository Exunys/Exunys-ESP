local game = game
local select, pcall, loadstring , warn = select, pcall, loadstring, warn

local Success, ESP = pcall(select(2, pcall(loadstring, game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/Modules/Original.lua")))) -- Original / best version

if not Success then
    warn("EXUNYS_ESP > Loader - Your script execution software does not support the original / best version, trying the degraded version...")
    
    Success, ESP = pcall(select(2, pcall(loadstring, game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/Modules/UWP%20Support.lua")))) -- Degraded for UWP (works on web version)

    if not Success then
        warn("EXUNYS_ESP > Loader - Your script execution software does not support the degraded version. Trying the primitive version.")

        Success, ESP = pcall(select(2, pcall(loadstring, game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/Modules/Primitive.lua")))) -- Degraded for UWP & free / weaker exploits (works on web version)

        if not Success then
            return warn("EXUNYS_ESP > Loader - Your script execution software does not support this module.")
        end
    end
end

return ESP

-- Exunys <3
