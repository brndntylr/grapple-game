import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

local ground_y = 180

class('Player').extends(gfx.sprite)

function Player:init(x, y, speed, jumpspeed, gravity)
	Player.super.init(self)

    self.speed = speed
    self.jump_speed = jumpspeed
    self.y_speed = 0
    self.gravity = gravity
    self.max_speed = 10

    self.jumped = false

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
    end
    if pd.buttonIsPressed(pd.kButtonLeft) then
        self:moveWithCollisions(self.x-self.speed, self.y)
    end
    if pd.buttonJustPressed(pd.kButtonA) then
        if self.jumped == false then
            self.y_speed = -self.jump_speed
            self.jumped = true
        end
    end

    self:moveWithCollisions(self.x,self.y+self.y_speed)

    self.y_speed += self.gravity
    if self.y_speed > 0 then
        self.y_speed = math.min(self.y_speed, self.max_speed)
    end
end

function Player:collisionResponse(other)
    if other.super.className == "Platform" then
        self.jumped = false
        return "slide"
    end
end
