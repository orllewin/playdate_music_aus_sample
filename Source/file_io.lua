
function initialiseUserPatchDir()
	if not playdate.file.exists("UserPatches") then
		playdate.file.mkdir("UserPatches")
	end
end

function initialisePatches()
	local patches = buitInPatches()
	local user = userPatches()
	
	for _,v in ipairs(user) do
		 table.insert(patches, v)
	end
	
	return patches
end

function buitInPatches()
		print("\nListing built-in patches:\n")
		local files = playdate.file.listFiles("Patches/")
		
		local patches = {}
		
		for k, v in pairs(files) do
			local path = "Patches/" .. v .. "config.json"
			if playdate.file.exists(path) then
				local patch = json.decodeFile(path)
				patch.path = path
				table.insert(patches, patch)
				print("Patch: " .. v .. ": " .. patch.label)
			end
		end
		
		return patches
end

function userPatches()
	print("\nListing user patches:\n")
	local files = playdate.file.listFiles("UserPatches/")
	
	local userPatches = {}
	
	for k, v in pairs(files) do
		local path = "Patches/" .. v .. "config.json"
		if playdate.file.exists(path) then
			local patch = json.decodeFile(path)
			patch.path = path
			table.insert(userPatches, patch)
			print("Patch: " .. v .. ": " .. patch.label)
		end
	end
	
	return userPatches
	
end