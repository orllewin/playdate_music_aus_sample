import 'CoracleViews/focus_manager'
import 'Play/grid_toggle'

class('PlayDialog').extends(playdate.graphics.sprite)

local graphics <const> = playdate.graphics
local focusManager = FocusManager()

local liveView1 = nil
local liveView2 = nil
local liveView3 = nil
local liveView4 = nil

local viewA = nil
local viewB = nil
local viewU = nil
local viewD = nil
local viewL = nil
local viewR = nil

local liveInputManager = {
	BButtonDown = function()
		if viewB ~= nil and viewB.tapA ~= nil then viewB:tapA() end
	end,
	AButtonDown = function()
		if viewA ~= nil and viewA.tapA ~= nil then viewA:tapA() end
	end,
	leftButtonDown = function()
		if viewL ~= nil and viewL.tapA ~= nil then viewL:tapA() end
	end,
	rightButtonDown = function()
		if viewR ~= nil and viewR.tapA ~= nil then viewR:tapA() end
	end,
	upButtonDown = function()
		if viewU ~= nil and viewU.tapA ~= nil then viewU:tapA() end
	end,
	downButtonDown = function()
		if viewD ~= nil and viewD.tapA ~= nil then viewD:tapA() end
	end
}

function PlayDialog:init()
	PlayDialog.super.init(self)
	self.showing = false
end

function PlayDialog:show(path)
	local background = graphics.image.new(400, 240, graphics.kColorWhite)
	self:moveTo(200, 120)
	self:setImage(background)
	self:add()
	
	local font = playdate.graphics.font.new("Fonts/font-rains-1x")
	playdate.graphics.setFont(font)
	
	--400x240
	local config = json.decodeFile(path)
	local columns = config.columns
	local rows = config.rows
	local w = math.floor(400/columns)
	local h = math.floor(240/rows)
	
	local total = rows * columns
	
	for r = 1, rows do
		for c = 1, columns do
			local index = ((r-1) * columns) + c
			local sample = config.samples[index]
			local view = GridToggle(sample, ((c * w) - w/2), ((r * h) - h/2), w - 5, h - 5, false, function()
				
			end)
			
			if sample.key ~= nil then
				if sample.key == 'a' then viewA = view
				elseif sample.key == 'b' then viewB = view
				elseif sample.key == 'left' then viewL = view
				elseif sample.key == 'right' then viewR = view
				elseif sample.key == 'up' then viewU = view
				elseif sample.key == 'down' then viewD = view
				end
			end
			focusManager:addView(view, r)
		end
	end
	
	focusManager:start()
	focusManager:push()
	
	--live mode by default:
	focusManager:pop() 
	playdate.inputHandlers.push(liveInputManager)
	
	self.showing = true
	
	-- local i = playdate.graphics.image.new("Images/agent_cooper")
	-- local fsSprite = playdate.graphics.sprite.new(i)
	-- fsSprite:moveTo(210, 120)
	-- fsSprite:add()
end	

function PlayDialog:isShowing()
	return self.showing
end

function PlayDialog:update()
	
	local change, acceleratedChange = playdate.getCrankChange()
	if change ~= 0 then 
		local position = playdate.getCrankPosition()
		if position > 0 and position < 180 then
			--edit mode
			playdate.inputHandlers.pop()
			if focusManager:isHandlingInput() == false then focusManager:push() end
		elseif position > 180 and position < 360 then
			--live mode
			if focusManager:isHandlingInput() == true then 
				focusManager:pop() 
				playdate.inputHandlers.push(liveInputManager)
			end
			
		end
	end

end

function PlayDialog:updatePost()
	if self.showing == false then return end

	for r=1,focusManager:rowCount() do
		local rowViews = focusManager:getViews(r)
		for i=1, #rowViews do
			local view = focusManager:getView(r, i)
			if view.update ~= nil then view:update() end
		end
	end
end

function PlayDialog:dismiss()

end
	
