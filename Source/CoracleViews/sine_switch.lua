import 'CoreLibs/graphics'

class('SineSwitch').extends(playdate.graphics.sprite)

function SineSwitch:init(xx, yy, w, h, period, active, listener)
	SineSwitch.super.init(self)
	
	self.xx = xx
	self.yy = yy
	
	self.w = w
	self.h = h
	
	self.active = active
	self.hasFocus = false
	self.clickable = true
	
	self.listener = listener
	self.onFocus = nil
	
	local sineImage = playdate.graphics.image.new(w, h)
	playdate.graphics.pushContext(sineImage)
	playdate.graphics.drawSineWave(0, h/2, w- 30, h/2, h/4, h/4, period)
	playdate.graphics.popContext()
	self.sineSprite = playdate.graphics.sprite.new(sineImage)
	self.sineSprite:moveTo(xx, yy)
	self.sineSprite:add()
	
	
	self:draw()
	self:moveTo(xx, yy)
	self:add()
	
	local focusedImage = playdate.graphics.image.new(w + 12, h + 4)
	playdate.graphics.pushContext(focusedImage)
	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	playdate.graphics.setLineWidth(2)
	playdate.graphics.drawRoundRect(1, 1, w + 6, h + 2, 5) 
	playdate.graphics.setLineWidth(1)
	playdate.graphics.popContext()
	self.focusedSprite = playdate.graphics.sprite.new(focusedImage)
	self.focusedSprite:moveTo(xx, yy + 1)
	self.focusedSprite:add()
	self.focusedSprite:setVisible(false)
	
	self.viewId = "unknown"
	end
	
	function SineSwitch:setViewId(viewId)
		self.viewId = viewId
	end
	
	function SineSwitch:getViewId()
		return self.viewId
	end

function SineSwitch:removeAll()
	self.sineSprite:remove()
	self.focusedSprite:remove()
	self:remove()
	
end
local sineSwitchBoxH = 14
function SineSwitch:draw()
	local image = playdate.graphics.image.new(self.w, self.h)
	playdate.graphics.pushContext(image)
	playdate.graphics.setColor(playdate.graphics.kColorBlack)

if self.clickable == false then 
		print("UNCLICKABLE")
		playdate.graphics.fillRect(self.w - 20, (self.h/2) - 8, 16, 16)
	elseif(self.active)then
		playdate.graphics.fillRect(self.w - 20, (self.h/2) - 8, 16, 16)
	else
		playdate.graphics.drawRect(self.w - 20, (self.h/2) - 8, 16, 16)
	end
	playdate.graphics.popContext()
	
	if self.clickable == false then
		local fadeImage = playdate.graphics.image.new(self.w, self.h)
		playdate.graphics.pushContext(fadeImage)
		image:drawFaded(0, 0, 0.4, playdate.graphics.image.kDitherTypeBayer2x2)
		playdate.graphics.popContext()
		self:setImage(fadeImage)
	else
		self:setImage(image)
	end
	
	
end

function SineSwitch:setUnclickable()
	print("Switch:setUnclickable()")
	self.clickable = false
	self:draw()
end

function SineSwitch:setActive(active)
	if self:getActive() == active then return end
	self.active = active
	self:draw()
end

function SineSwitch:getActive()
	return self.active
end

function SineSwitch:setFocus(focus)
	self.hasFocus = focus
	self.focusedSprite:setVisible(focus)
	
	if focus == true then
		if self.onFocus ~= nil then self.onFocus() end
	end
end

function SineSwitch:tap()
	print("switch tap, clickable: " .. tostring(self.clickable))
	if self.clickable == false then return end
	self.active = not self.active	
	self:draw()
	
	if self.listener ~= nil then self.listener(self.active) end
end

function SineSwitch:setOnFocus(onFocus, message)
	self.onFocus = onFocus
end