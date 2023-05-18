
function initialiseUserPatchDir()
	if not playdate.file.exists("UserPatches") then
		playdate.file.mkdir("UserPatches")
	end
end

function initialisePatches()
	local uiPatches = {}
	
	local user = userPatches()
	
	if #user > 0 then	
		local userTitlePatch = {
			label = "User Patches:",
			type = "div"
		}
		table.insert(uiPatches, userTitlePatch)
		
		
		for _,v in ipairs(user) do
		 	table.insert(uiPatches, v)
		end
		
		local divPatch = {
			label = " ",
			type = "div"
		}
		
		table.insert(uiPatches, divPatch)
	
	end

	local patches = buitInPatches()
	
	if #patches > 0 then
		
		local demoTitlePatch = {
			label = "Demo Patches:",
			type = "div"
		}
		table.insert(uiPatches, demoTitlePatch)
	
		for _,v in ipairs(patches) do
		 	table.insert(uiPatches, v)
		end
	
	end
	
	return uiPatches
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
		local path = "UserPatches/" .. v .. "config.json"
		if playdate.file.exists(path) then
			local patch = json.decodeFile(path)
			patch.path = path
			patch.isUserPatch = true
			table.insert(userPatches, patch)
			print("Patch: " .. v .. ": " .. patch.label)
		end
	end
	
	return userPatches
	
end