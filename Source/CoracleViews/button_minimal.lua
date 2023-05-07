import 'CoracleViews/label_centre'

class('ButtonMinimal').extends()

function ButtonMinimal:init(label, xx, yy, w, h, listener)
	ButtonMinimal.super.init(self)
	
	self.hasFocus = false
	self.active = true
	self.disabled = false
	
	self.listener = listener
	
	-- local focusedBGImage = playdate.graphics.image.new(w + 2, h + 6)
	-- playdate.graphics.pushContext(focusedBGImage)
	-- playdate.graphics.setColor(playdate.graphics.kColorBlack)
	-- playdate.graphics.fillRoundRect(1, 1, w, h + 4, 5) 
	-- playdate.graphics.popContext()
	-- local focusedBGImageFaded = playdate.graphics.image.new(w+1, h + 6)
	-- playdate.graphics.pushContext(focusedBGImageFaded)
	-- focusedBGImage:drawFaded(0, 0, 0.2, playdate.graphics.image.kDitherTypeDiagonalLine)
	-- focusedBGImage:setInverted(true)
	-- playdate.graphics.popContext()
	-- self.focusedBGSprite = playdate.graphics.sprite.new(focusedBGImageFaded)
	-- self.focusedBGSprite:moveTo(xx-2, yy + (h/2) - 2)
	-- self.focusedBGSprite:add()
	-- self.focusedBGSprite:setVisible(false)
	
	local nWidth, nHeight = playdate.graphics.getTextSize(label)
	self.label = LabelCentre(label, xx, yy + ((h - nHeight)/2), 0.4)
	
	
	self.label:setAlpha(0.4)
		
	nHeight = h
	nWidth = w
	
	local preFadeBorderImage = playdate.graphics.image.new(nWidth+1, nHeight + 6)
	playdate.graphics.pushContext(preFadeBorderImage)
	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	playdate.graphics.setLineWidth(1)
	playdate.graphics.drawRoundRect(1, 1, nWidth, nHeight + 4, 3) 
	playdate.graphics.setLineWidth(1)
	playdate.graphics.popContext()
	local borderImage = playdate.graphics.image.new(nWidth+1, nHeight + 6)
	playdate.graphics.pushContext(borderImage)
	preFadeBorderImage:drawFaded(0, 0, 0.5, playdate.graphics.image.kDitherTypeBayer2x2)
	playdate.graphics.popContext()
	self.borderSprite = playdate.graphics.sprite.new(borderImage)
	self.borderSprite:moveTo(xx - 2, yy + (nHeight/2) - 2)
	self.borderSprite:add()
	self.borderSprite:setVisible(true)
	
	local focusedImage = playdate.graphics.image.new(nWidth + 2, nHeight + 6)
	playdate.graphics.pushContext(focusedImage)
	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	playdate.graphics.setLineWidth(2)
	playdate.graphics.drawRoundRect(1, 1, nWidth, nHeight + 4, 5) 
	playdate.graphics.setLineWidth(1)
	playdate.graphics.popContext()
	self.focusedSprite = playdate.graphics.sprite.new(focusedImage)
	self.focusedSprite:moveTo(xx-2, yy + (nHeight/2) - 2)
	self.focusedSprite:add()
	self.focusedSprite:setVisible(false)
	self.viewId = "unknown"
	end
	
	function ButtonMinimal:setViewId(viewId)
		self.viewId = viewId
	end
	
	function ButtonMinimal:getViewId()
		return self.viewId
	end

function ButtonMinimal:setText(label)
	self.label:setText(label)
end

function ButtonMinimal:removeAll()
	self.label:remove()
	self.borderSprite:remove()
	self.focusedSprite:remove()
end

function ButtonMinimal:getSprites()
	return {self.label, self.borderSprite, self.focusedSprite}
end

function ButtonMinimal:isFocused()
	return self.hasFocus
end

function ButtonMinimal:setActive(active)
	self.active = active
end

function ButtonMinimal:isActive()
	return self.active
end

function ButtonMinimal:setDisabled()
	self.disabled = true
	self.label:setAlpha(0.4)
end

function ButtonMinimal:setFocus(focus)
	self.hasFocus = focus
	self.focusedSprite:setVisible(focus)
	--self.focusedBGSprite:setVisible(focus)
	if focus then
		self:setActive(true)
	else
	end
end

function ButtonMinimal:tap()	
	self.focusedSprite:moveBy(0, 1)
	playdate.timer.new(200, function()
		self.focusedSprite:moveBy(0, -1)
		
		if self.disabled then
			-- do nothing
		else
			if self.listener ~= nil then self.listener() end
		end
		
	end)
end
