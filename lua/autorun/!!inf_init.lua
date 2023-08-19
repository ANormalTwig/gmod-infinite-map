if string.Explode("_", string.lower(game.GetMap()))[2] ~= "infmap" then return end	-- initialize infinite map code on maps with 'infmap' as the second word

InfMap = InfMap or {}
InfMap.chunk_size = 10000
InfMap.source_bounds = Vector(1, 1, 1) * math.pow(2, 14)

-- I stole this shit from another init file I wrote a month ago.

local addFile
if SERVER then
	-- I moved all the resource.AddFile() statements into lib/sv_loadresources.lua

	-- Server init
	addFile = function(name, path)
		local prefix = string.match(name, "^(...).+%.lua$")
		if prefix == "sv_" then
			include(path)
		elseif prefix == "cl_" then
			AddCSLuaFile(path)
		else
			AddCSLuaFile(path)
			include(path)
		end
	end
else
	-- Client init
	addFile = function(name, path)
		local prefix = string.match(name, "^(...).+%.lua$")
		if prefix == "sv_" then
			-- Shouldn't happen
		elseif prefix == "cl_" then
			include(path)
		else
			include(path)
		end
	end
end

--- Load directory recursively
---@param directoryName string
local function addRecursive(directoryName)
	local files, directories = file.Find(directoryName .. "/*", "LUA")

	if files then
		for _, filename in ipairs(files) do
			addFile(filename, string.format("%s/%s", directoryName, filename))
		end
	end

	if directories then
		for _, directory in ipairs(directories) do
			addRecursive(string.format("%s/%s", directoryName, directory))
		end
	end
end

addRecursive("infmap_lib")
addRecursive("infmap")

