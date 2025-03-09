class('Player').extends(playdate.graphics.sprite)

function Player:init()

	Player.super.init(self)

	-- Currently just a single image for the sprite but will iadd animation in the future
	self.player_image = playdate.graphics.image("images/dude-0001.png")

	self:setCollideRect(0, 0, 32, 48)
	self:setZIndex(800)

	self:reset()
	self:addSprite()
end

function Player:reset()
	-- self.xd = 0
	-- self.yd = 0
	-- self.v = 0

	self.frame = 0
	self:updateFrame()

	self:moveTo(playdate.display.getWidth() / 4, playdate.display.getHeight() / 4)
end



function Player:up()

end


function Player:left()

end


function Player:right()

end

