import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

local ground_y = 180

class('Player').extends(gfx.sprite)

function Player:init(x, y, speed, jumpspeed, gravity)
	Player.super.init(self)

    self.speed = speed
    self.yspeed = 0
    self.gravity = gravity

	-- Currently just a single image for the sprite but will add animation in the future
	local player_image = gfx.image.new("images/dude-0001.png")
    self:setImage(player_image)
	self:setCollideRect(0, 0, self:getSize())
    self:setCollidesWithGroups(1)
	self:setZIndex(10)
    self:moveTo(x, y)
end

function Player:update()

    Player.super.update(self)

    if pd.buttonIsPressed(pd.kButtonRight) then
        self:moveWithCollisions(self.x+self.speed, self.y)
        -- print(pos_x+self.speed)
        -- self:moveTo(pos_x+self.speed, 0)
    end
    if pd.buttonIsPressed(pd.kButtonLeft) then
        self:moveWithCollisions(self.x-self.speed, self.y)
        -- print(pos_x-self.speed)
        -- self.moveTo(pos_x-self.speed, 0)
    end
    if pd.buttonJustPressed(pd.kButtonA) then
        self.yspeed = -
    end

    self:moveWithCollisions(self.x,self.y+self.jumpspeed)

    self.yspeed += self.gravity
end

function Player:collisionResponse(other)
    if other.super.className == "Platform" then
        return "slide"
    end
end
