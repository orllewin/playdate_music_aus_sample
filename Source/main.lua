import 'CoreLibs/sprites'
import 'CoreLibs/graphics'
import 'CoreLibs/timer'
import 'Play/play_dialog'
import 'PatchChooser/chooser_dialog'
import 'file_io'

initialiseUserPatchDir()

playdate.setCrankSoundsDisabled(true)

local graphics <const> = playdate.graphics
local playDialog = nil
local transitionPlayer = playdate.sound.fileplayer.new()

graphics.sprite.setBackgroundDrawingCallback(function(x, y, width, height)
	playdate.graphics.setColor(playdate.graphics.kColorWhite)
	playdate.graphics.fillRect(0, 0, 400, 240)
end)

local graphics <const> = playdate.graphics
local inverted = true
playdate.display.setInverted(inverted)

local font = playdate.graphics.font.new("Fonts/font-rains-1x")
playdate.graphics.setFont(font)

local chooserDialog = ChooserDialog(function(patch) 
	showPatch(patch)
end)
chooserDialog:show()

local menu = playdate.getSystemMenu()
local menuItem, error = menu:addMenuItem("Patches", function()
		if playDialog ~= nil and playDialog:isShowing() then 
			playDialog:dismiss() 
			playDialog = nil
		end
		chooserDialog = ChooserDialog(function(patch) 
			showPatch(patch)
		end)
		chooserDialog:show()
end)

local invertMenuItem, error = menu:addMenuItem("Invert screen", function()
		inverted = not inverted
		playdate.display.setInverted(inverted)
end)





function showPatch(patch)
	print("main.lua - patch chosen: " .. patch.path)
	chooserDialog:dismiss()
	chooserDialog = nil
	playDialog = PlayDialog()
	playDialog:show(patch.path)
end

function playdate.update()
	if playDialog ~= nil and playDialog:isShowing() then playDialog:update() end

	playdate.graphics.sprite.update()
	playdate.timer.updateTimers()
	
	if playDialog ~= nil and playDialog:isShowing() then playDialog:updatePost() end
end

function l(message)
	print("PD > " .. message)
end

function serialTap(c, r)
	print("Serial comms received: " .. c .. "x" .. r)
	if playDialog ~= nil and playDialog:isShowing() then playDialog:serialTap(c, r) end
end

function mainTransition(samplePath, patchPath)
	print("Play global: " .. samplePath)
	
	if samplePath ~= nil then
		if transitionPlayer:isPlaying() then
			transitionPlayer:stop()
		end
		
		transitionPlayer:load(samplePath)
		transitionPlayer:play()
	
	end
	
	
	
	
	print("Patch path: " .. patchPath)
	if playDialog ~= nil and playDialog:isShowing() then 
		playDialog:dismiss() 
		playDialog = nil
	end
	
	playDialog = PlayDialog()
	playDialog:show(patchPath)
end