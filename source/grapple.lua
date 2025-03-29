import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Grapple').extends(gfx.sprite)

function Grapple:init()
	Grapple.super.init(self)

    self.len = 4
    self.initial_speed = 12
    self.gravity = 0.3
    self.speed = 0

    self.wind_resist = 0.1

    self.state = "none"

    local grapple_image = gfx.image.new(self.len, self.len)
    gfx.pushContext(grapple_image)
        gfx.fillRect(0, 0, self.len, self.len)
    gfx.popContext()
    self:setImage(grapple_image)

	self:setCollideRect(0, 0, self:getSize())
    self:setCollidesWithGroups({1, 2})
	self:setZIndex(9)

    self:moveTo(240, 120)
end

function Grapple:moving(player_pos_x,player_pos_y,player_width,player_height)
    local x = player_pos_x + (player_width/2) + 5
    local y = player_pos_y
    self:moveTo(x,y)
end

function Grapple:launch(aim_angle)
    self.xspeed = math.sin(math.rad(aim_angle)) * self.initial_speed
    self.yspeed = -math.cos(math.rad(aim_angle)) * self.initial_speed
    self.state = "launched"
end

function Grapple:collisionResponse(other)
    if other.super.className == "Platform" then
        if self.xspeed < 0.5 then
            self.xspeed = 0
            self.state = "none"
        end
        return "slide"
    elseif other.super.className == "Grapple_Surface" then
        self.state = "stuck"
        return "freeze"
    end
end

function Grapple:update()
    Grapple.super.update(self)
    if self.state == "launched" then
        self:moveWithCollisions(self.x+self.xspeed, self.y+self.yspeed)
        if self.xspeed > 0 then
            self.xspeed -= self.wind_resist
        elseif self.xspeed < 0 then
            self.xspeed += self.wind_resist
        end
        self.yspeed += self.gravity
    end
end