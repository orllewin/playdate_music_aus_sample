class('Block').extends(playdate.graphics.sprite)

function Block:init(x, y, width, height, alpha)
	Block.super.init(self)
	self.alpha = alpha
	self.h = height
	local blockImage = playdate.graphics.image.new(width, height)
	playdate.graphics.pushContext(blockImage)
	local rectImage = playdate.graphics.image.new(width, height)
	playdate.graphics.pushContext(rectImage)
	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	playdate.graphics.fillRect(0, 0, width, height) 
	playdate.graphics.popContext()
	
	if alpha == nil then
		rectImage:draw(0, 0)
	else
		rectImage:drawFaded(0, 0, alpha, playdate.graphics.image.kDitherTypeBayer4x4)
	end
			
	playdate.graphics.popContext()
	self:setImage(blockImage)
	self:moveTo(x, y)
	self:add()
end

function Block:setWidth(width)
	local blockImage = playdate.graphics.image.new(width, self.h)
	playdate.graphics.pushContext(blockImage)
	local rectImage = playdate.graphics.image.new(width, self.h)
	playdate.graphics.pushContext(rectImage)
	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	playdate.graphics.fillRect(0, 0, width, self.h) 
	playdate.graphics.popContext()
	
	if self.alpha == nil then
		rectImage:draw(0, 0)
	else
		rectImage:drawFaded(0, 0, self.alpha, playdate.graphics.image.kDitherTypeDiagonalLine)
	end
			
	playdate.graphics.popContext()
	self:setImage(blockImage)
end