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
	playDialog:update()

	playdate.graphics.sprite.update()
	playdate.timer.updateTimers()
	
	playDialog:updatePost()
end