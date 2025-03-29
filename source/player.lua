import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "grapple"
import "arrow"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)

function Player:init(x, y, speed, jumpspeed, gravity)
	Player.super.init(self)

    self.speed = speed
    self.jump_speed = jumpspeed
    self.y_speed = 0
    self.gravity = gravity
    self.max_speed = 10

    self.aim_angle = 0

    self.jumped = false

	-- Currently just a single image for the sprite but will add animation in the future
	local player_image = gfx.image.new("images/dude-0001.png")
    self:setImage(player_image)
	self:setCollideRect(0, 0, self:getSize())
    self:setCollidesWithGroups(1)
	self:setZIndex(10)
    self:moveTo(x, y)

    self.grapple = Grapple(self.x+self.width, self.y+(self.height/2))
    -- self.grapple:add()

    self.arrow = Arrow(self.x, self.y)
    -- self.Arrow:add()
end

function Player:update()

    Player.super.update(self)

    if pd.buttonJustPressed(pd.kButtonB) then
        if self.grapple.state == "none" then
            self.arrow:reset()
            self.arrow:add()
            self.grapple:moving(self.x,self.y,self.width,self.height)
            self.grapple:add()
            self.grapple.state = "out"
        elseif self.grapple.state == "out" then
            self.arrow:remove()
            self.aim_angle = self.arrow:posOut()
            self.grapple:launch(self.aim_angle)
        elseif (self.grapple.state == "launched" or self.grapple.state == "stuck") then
            self.grapple:remove()
            self.grapple.state = "none"
        end
    end

    if self.grapple.state == "None" then
        if pd.buttonIsPressed(pd.kButtonLeft) then
            self:moveWithCollisions(self.x-self.speed, self.y)
        end
        if pd.buttonIsPressed(pd.kButtonRight) then
            self:moveWithCollisions(self.x+self.speed, self.y)
        end
        if pd.buttonJustPressed(pd.kButtonA) then
            if self.jumped == false then
                self.y_speed = -self.jump_speed
                self.jumped = true
            end
        end
    elseif self.grapple.state == "out" then
        -- local a = 1
    elseif self.grapple.state == "launched" then
        -- self.grapple.state = "None"
    end

    self:moveWithCollisions(self.x,self.y+self.y_speed)
    self.arrow:moveTo(self.x, self.y-(self.height/2))

    self.y_speed += self.gravity
    if self.y_speed > 0 then
        self.y_speed = math.min(self.y_speed, self.max_speed)
    end
end

function Player:collisionResponse(other)
    if other.super.className == "Platform" then
        self.jumped = false
        self.y_Speed = 0.1;
        return "slide"
    end
end
