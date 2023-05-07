class('MiniSlider').extends(playdate.graphics.sprite)

function MiniSlider:init(label, xx, yy, w, value, rangeStart, rangeEnd, segments, showValue, listener)
	MiniSlider.super.init(self)
	
	local nWidth, labelHeight = playdate.graphics.getTextSize(label)
	
	self.labelHeight = labelHeight
	
	self.label = label
	self.value = value
	self.segments = segments
	self.showValue = showValue
	self.xx = xx
	self.yy = yy
	self.w = w
	self.rangeStart = rangeStart
	self.rangeEnd = rangeEnd
	self.listener = listener
	self.labelIsFloat = labelIsFloat
	self.hasFocus = false
	
	self.debounceActive = false
	self.wait = false
	
	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	
	local sliderHeight = 20
	self.sliderHeight = sliderHeight
	
	local backplateImage = playdate.graphics.image.new(w, sliderHeight + labelHeight)
	
	--Start backplate drawing
	playdate.graphics.pushContext(backplateImage)
	playdate.graphics.setLineWidth(1)

	for i=1,self.segments do
		local x = map(i, 1, self.segments, 0, w)
		playdate.graphics.drawLine(x, labelHeight, x, sliderHeight/2 - 2 + labelHeight) 
		playdate.graphics.drawLine(x, labelHeight + sliderHeight/2 + 2, x, sliderHeight + labelHeight) 
	end	
	playdate.graphics.setLineWidth(1)
	playdate.graphics.popContext()
	--End backplate drawing
	
	self:setImage(backplateImage)
		
	self:moveTo(xx, yy)
	self:add()
	
	self.label = LabelLeft(label, xx - w/2, yy - sliderHeight - 1, 0.4)
	
	local knobImage = playdate.graphics.image.new(10, sliderHeight + 6)
	playdate.graphics.pushContext(knobImage)
	playdate.graphics.setColor(playdate.graphics.kColorBlack)

	playdate.graphics.fillRoundRect(0, 0, 10, sliderHeight + 6, 2) 
	playdate.graphics.popContext()
	self.knobSprite = playdate.graphics.sprite.new(knobImage)
	self.knobSprite:moveTo(xx - (w/2) + map(value, rangeStart, rangeEnd, 5, self.w - 10), yy + labelHeight - (sliderHeight/2))
	self.knobSprite:add()
	
	if showValue then 
		self.valueLabel = LabelRight("" .. self.value, xx - (w/2) + w - 4, yy - sliderHeight - 3, 0.4) 
	end
	
	local focusedImage = playdate.graphics.image.new(w + 12, sliderHeight + labelHeight + 12)
	playdate.graphics.pushContext(focusedImage)
	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	playdate.graphics.setLineWidth(2)
	playdate.graphics.drawRoundRect(1, 1, w + 6, sliderHeight + labelHeight + 10, 5) 
	playdate.graphics.setLineWidth(1)
	playdate.graphics.popContext()
	self.focusedSprite = playdate.graphics.sprite.new(focusedImage)
	self.focusedSprite:moveTo(xx, yy + 1)
	self.focusedSprite:add()
	self.focusedSprite:setVisible(false)

	self.viewId = "unknown"
	end
	
	function MiniSlider:setViewId(viewId)
		self.viewId = viewId
	end
	
	function MiniSlider:getViewId()
		return self.viewId
	end

function MiniSlider:removeAll()
	self.focusedSprite:remove()
	if self.showValue then 
		self.valueLabel:remove()
	end
	self.knobSprite:remove()
	self.label:remove()
	self:remove()
end

function MiniSlider:activateDebounce()
	self.debounceActive = true
end

function MiniSlider:turn(degrees)
	if self.debounceActive and self.wait then return end

	if(degrees == 0.0)then return end --indicates no change from crank in this frame
	-- self:setRotation(math.max(0, (math.min(300, self:getRotation() + degrees))))
	if degrees > 0 and self.value < self.rangeEnd then
		self.value += 1
	elseif degrees < 0 and self.value > self.rangeStart then
		self.value -= 1
	else
		return
	end

	self.knobSprite:moveTo(self.xx - (self.w/2) + map(self.value, self.rangeStart, self.rangeEnd, 5, self.w - 10), self.yy + self.labelHeight - (self.sliderHeight/2))
	
	if self.showValue then
		self.valueLabel:setText(self.value)
	end
		
	if self.listener ~= nil then self.listener(self.value) end
	
	if self.debounceActive then
		self.wait = true
		playdate.timer.new(200, function()
			self.wait = false
		end)
	end
end

function MiniSlider:setValue(value)
	self.value = value
	self.knobSprite:moveTo(self.xx - (self.w/2) + map(self.value, self.rangeStart, self.rangeEnd, 5, self.w - 10), self.yy + self.labelHeight - (self.sliderHeight/2))
	
	if self.showValue then
		self.valueLabel:setText(self.value)
	end
end

function MiniSlider:setFocus(focus)
	self.hasFocus = focus
	self.focusedSprite:setVisible(focus)
	
	if focus == true then
		if self.onFocus ~= nil then self.onFocus() end
	end
end

function MiniSlider:setOnFocus(onFocus, message)
	self.onFocus = onFocus
end