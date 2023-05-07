import 'Coracle/math'
	
class('ADSR').extends(playdate.graphics.sprite)
	
local graphics <const> = playdate.graphics
	 
function ADSR:init(xx, yy, w, h)
	ADSR.super.init(self)
	
	self.xx = xx
	self.yy = yy
	self.w = w
	self.h = h
	
	self.a = 0.75
	self.d = 0.55
	self.s = 0.75
	self.r = 0.55

	self:moveTo(xx, yy)
	self:add()
	self:draw()
end
	
function ADSR:set(a, d, s, r)
	self.a = a
	self.d = d
	self.s = s
	self.r = r
	self:draw()
end
	
function ADSR:setAttack(attack)
	self.a = attack
	self:draw()
end
	
function ADSR:setDecay(decay)
	self.d = decay
	self:draw()
end
	
function ADSR:setSustain(sustain)
	self.s = sustain
	self:draw()
end
	
function ADSR:setRelease(release)
	self.r = release
	self:draw()
end
	
function ADSR:draw()
	local cWidth = self.w/4
	local aWidth = map(self.a, 0.0, 1.0, 0.0, cWidth)
	local dWidth = map(self.d, 0.0, 1.0, 0.0, cWidth)
	local sWidth = cWidth
	local sHeight = map(self.s, 0.0, 1.0, 1.0, self.h)
	local rWidth = map(self.r, 0.0, 1.0, 0.0, cWidth)

	local image = graphics.image.new(self.w, self.h)
	graphics.pushContext(image)
	graphics.setLineWidth(3)
	graphics.drawLine(0, self.h, aWidth, 0)
	graphics.drawLine(aWidth, 0, aWidth + dWidth, self.h - sHeight)
	graphics.drawLine(aWidth + dWidth, self.h - sHeight, aWidth + dWidth + sWidth, self.h - sHeight)
	graphics.drawLine(aWidth + dWidth + sWidth, self.h - sHeight, aWidth + dWidth + sWidth +  rWidth, self.h)
	graphics.popContext()
	local dithered = graphics.image.new(self.w, self.h)
	graphics.pushContext(dithered)
	image:drawFaded(0, 0, 0.4, graphics.image.kDitherTypeBayer2x2)
	graphics.popContext()
	self:setImage(dithered)
end 
