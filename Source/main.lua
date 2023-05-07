import 'CoreLibs/sprites'
import 'CoreLibs/graphics'
import 'CoreLibs/timer'
import 'Play/play_dialog'
import 'PatchChooser/chooser_dialog'
import 'file_io'

initialiseUserPatchDir()

playdate.setCrankSoundsDisabled(true)

local graphics <const> = playdate.graphics

graphics.sprite.setBackgroundDrawingCallback(function(x, y, width, height)
	playdate.graphics.setColor(playdate.graphics.kColorWhite)
	playdate.graphics.fillRect(0, 0, 400, 240)
end)

local graphics <const> = playdate.graphics
local inverted = true
playdate.display.setInverted(inverted)

local font = playdate.graphics.font.new("Fonts/font-rains-1x")
playdate.graphics.setFont(font)

local menu = playdate.getSystemMenu()
local menuItem, error = menu:addMenuItem("Item 1", function()
		print("Item 1 selected")
end)

local playDialog = PlayDialog()

local chooserDialog = ChooserDialog(function(patch) 
	showPatch(patch)
end)
chooserDialog:show()

function showPatch(patch)
	print("main.lua - patch chosen: " .. patch.path)
	chooserDialog:dismiss()
	playDialog:show(patch.path)
end

function playdate.update()
	if playDialog ~= nil and playDialog:isShowing() then playDialog:update() end

	playdate.graphics.sprite.update()
	playdate.timer.updateTimers()
	
	if playDialog ~= nil and playDialog:isShowing() then playDialog:updatePost() end
end

function mainTransition(samplePath, patchPath)
	print("Play global: " .. samplePath)
	print("Patch path: " .. patchPath)
	if playDialog ~= nil and playDialog:isShowing() then 
		playDialog:dismiss() 
		playDialog = nil
	end
	
	playDialog = PlayDialog()
	playDialog:show(patchPath)
end