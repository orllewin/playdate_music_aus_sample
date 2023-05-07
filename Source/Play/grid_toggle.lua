import 'CoracleViews/label_left'
import 'CoracleViews/label_right'
import 'Coracle/math'

class('GridToggle').extends(playdate.graphics.sprite)

local cornerRad = 3

local modePlay = 1
local modeLoop = 2
local modeHit = 3

local typeFile = 1
local typeSample = 2
local typeEmpty = 3

local modePlayImage = playdate.graphics.image.new("Images/play")
local modeHitImage = playdate.graphics.image.new("Images/hit")
local modeLoopImage = playdate.graphics.image.new("Images/loop")
local typeSampleImage = playdate.graphics.image.new("Images/sample")
local typeFileImage = playdate.graphics.image.new("Images/file")

function GridToggle:init(sample, x, y, width, height, active, listener)
	GridToggle.super.init(self)
	
	if sample.title ~= nil then
		self.title = sample.title
		self.label = LabelLeft(self.title, x - width/2 + 7, y - height/2 + 6)
	end
	
	self.cancelling = false
	
	if sample.mode == 'play' then
		self.mode = modePlay
		self.modeSprite = playdate.graphics.sprite.new(modePlayImage)
	elseif sample.mode == 'loop' then
		self.mode = modeLoop
		self.modeSprite = playdate.graphics.sprite.new(modeLoopImage)
	elseif sample.mode == 'hit' then
		self.mode = modeHit
		self.modeSprite = playdate.graphics.sprite.new(modeHitImage)
	end
	
	if sample.image ~= nil then
		local sampleImage = playdate.graphics.image.new(sample.image)
		local sW, sH = sampleImage:getSize()
		
		if sW > sH then
			--scale on width
			local scaledSampleImage = sampleImage:scaledImage(width/sW)
			self.sampleSprite = playdate.graphics.sprite.new(scaledSampleImage)
		else
			--scale on height
			local scaledSampleImage = sampleImage:scaledImage(height/sH)
			self.sampleSprite = playdate.graphics.sprite.new(scaledSampleImage)
		end
		
		self.sampleSprite:moveTo(x, y)
		self.sampleSprite:setScale(0.5)
		self.sampleSprite:add()
	end
	

	self.looping = false
	self.path = sample.path
	if sample.type == 'empty' then
		self.type = typeEmpty
	elseif sample.type == 'file' then
		self.type = typeFile
		self.player = playdate.sound.fileplayer.new(self.path)
		assert(self.player ~= nil)
		if sample.volume ~= nil then
			self.player:setVolume(sample.volume)
		end
		if sample.rate ~= nil then
			self.player:setRate(sample.rate)
		end
		self.length = self.player:getLength()
		self.player:setFinishCallback(function(fp) 
			if self.mode == modeLoop and self.cancelling ~= true then
				print("Callback retrigger")
				self.player:play()
			end
			
			self.cancelling = false
		end)
		
	elseif sample.type == 'sample' then
		self.type = typeSample
		self.sample = playdate.sound.sampleplayer.new(self.path)
		self.length = self.sample:getLength()
		assert(self.sample ~= nil)
	end

	self.xx = x
	self.yy = y
	
	self.width = width
	self.height = height
	
	self.hasFocus = false
	
	self.listener = listener
	
	local focusBorder = playdate.graphics.image.new(width, height)
	playdate.graphics.pushContext(focusBorder)
	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	playdate.graphics.setLineWidth(1)
	playdate.graphics.drawRoundRect(1, 1, width-1, height-1, cornerRad) 
	playdate.graphics.setLineWidth(1)
	playdate.graphics.popContext()
	--self:setImage(focusBorder)
	
	self.unfocusedBorder = playdate.graphics.image.new(width, height)
	playdate.graphics.pushContext(self.unfocusedBorder)
	focusBorder:drawFaded(0, 0, 0.5, playdate.graphics.image.kDitherTypeBayer2x2)
	playdate.graphics.popContext()
	self:setImage(self.unfocusedBorder)
	
	self.focusedBorder = focusBorder
	
	self:moveTo(x, y)
	self:add()	

	if self.modeSprite ~= nnil then
		self.modeSprite:moveTo(x - width/2 + 15, y + height/2 - 15)
		self.modeSprite:setScale(0.4)
		self.modeSprite:add()
	end
	
	if sample.type ~= nil then
		if sample.type == 'file' then
			self.typeSprite = playdate.graphics.sprite.new(typeFileImage)
			self.typeSprite:moveTo(x + width/2 - 10, y + height/2 - 10)
		elseif sample.type == 'sample' then
			self.typeSprite = playdate.graphics.sprite.new(typeSampleImage)
			self.typeSprite:moveTo(x + width/2 - 12, y + height/2 - 10)
		end

		if self.typeSprite ~= nil then
			self.typeSprite:setScale(0.25)
			self.typeSprite:add()
		end
	end
	

end

function GridToggle:setFocus(focus)
	self.hasFocus = focus
	--self.focusedSprite:setVisible(focus)
	
	if focus then
		self:setImage(self.focusedBorder)
		if self.label ~= nil then self.label:setAlpha(1) end
	else
		self:setImage(self.unfocusedBorder)
		if self.label ~= nil then self.label:setAlpha(0.4) end
	end
end

function GridToggle:update()
	if self.type == typeFile then
		if self.player:isPlaying() then
			local elapsed = self.player:getOffset()
			local elapsedWidth = map(elapsed, 0, self.length, 0, self.width)
			playdate.graphics.setColor(playdate.graphics.kColorXOR)
			playdate.graphics.fillRoundRect(self.x - self.width/2 + 1, self.y - self.height/2 + 1, math.max(1, elapsedWidth - 3), self.height - 3, cornerRad+1) 
		end
	elseif self.type == typeSample then
		if self.sample:isPlaying() then
			local elapsed = self.sample:getOffset()
			local elapsedWidth = map(elapsed, 0, self.length, 0, self.width)
			playdate.graphics.setColor(playdate.graphics.kColorXOR)
			playdate.graphics.fillRoundRect(self.x - self.width/2 + 1, self.y - self.height/2 + 1, math.max(1, elapsedWidth - 3), self.height - 3, cornerRad+1) 
		end
	end
end

function GridToggle:turn(degrees)
	-- local rate = self.player:getRate()
	-- 
	-- if degrees > 0 then
	-- if rate < 3 then rate += 0.01 end
	-- elseif degrees < 0 then
	-- 	if rate > 0.1 then rate -= 0.01 end
	-- end
	-- 
	-- self.player:setRate(rate)
end

function GridToggle:tapA()
	if self.type == typeEmpty then return end
	if self.type == typeFile then
		if self.player:isPlaying() then
			self.cancelling = true
			self.player:stop()
			if self.mode == modeHit then
				print("RETRIGGGGGGGGGGER")
				self.player:play()
			end
		else 
			self.player:play()
		end
	elseif self.type == typeSample then
		if self.sample:isPlaying() then
			self.cancelling = true
			self.sample:stop()
			if self.mode == modeHit then
				self.sample:play()
			end
		else 
			self.sample:play()
		end
	end
		
	self.listener(self.active)
end

function GridToggle:setButtonImage(path)
	print("")
	local keyImage = playdate.graphics.image.new(path)
	local kW, kH = keyImage:getSize()
	self.keySprite = playdate.graphics.sprite.new(keyImage)
	--self.keySprite:moveTo(self.xx + self.width/2 - kW/4 - 5, self.yy + self.height/2 - kH/4 - 5)
	self.keySprite:moveTo(self.xx, self.yy)
	self.keySprite:setScale(0.5)
	self.keySprite:add()
end

function GridToggle:tapB()	
	if self.type == typeEmpty then return end
	self.mode += 1
	
	if self.mode > 3 then
		self.mode = 1
	end
	
	if self.mode == modePlay then
		self.modeSprite:setImage(modePlayImage)
	elseif self.mode == modeLoop then
		self.modeSprite:setImage(modeLoopImage)
	elseif self.mode == modeHit then
		self.modeSprite:setImage(modeHitImage)
	end
end

