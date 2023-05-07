import 'CoracleViews/focus_manager'
import 'CoracleViews/text_list'
import 'CoracleViews/label_left'
import 'CoracleViews/divider_horizontal'
import 'file_io'

class('ChooserDialog').extends(playdate.graphics.sprite)

local graphics <const> = playdate.graphics
local focusManager = FocusManager()

function ChooserDialog:init(onPatch)
	ChooserDialog.super.init(self)
	self.showing = false
	self.onPatch = onPatch
end

function ChooserDialog:show()
	local background = graphics.image.new(400, 240, graphics.kColorWhite)
	self:moveTo(200, 120)
	self:setImage(background)
	self:add()
	
	local font = playdate.graphics.font.new("Fonts/pixarlmed")
	playdate.graphics.setFont(font)
	
	self.title = LabelLeft("Beetroot", 10, 10, 0.4)
	
	
	
	local patches = initialisePatches()
	self.list = TextList(patches, 10, 45, 380, 185, 32, nil, function(index, patch) 
		print("Patch chosen: " .. patch.label .. " at " .. patch.path)
		if self.onPatch ~= nil then self.onPatch(patch) end
	end)
	
	focusManager:addView(self.list, 1)
	focusManager:start()
	focusManager:push()

	self.div = DividerHorizontal(5, 35, 390, 0.4)
end

function ChooserDialog:dismiss()
	focusManager:getFocusedView():removeAll()
	self.title:remove()
	self:remove()
end