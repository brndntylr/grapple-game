import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

local ground_y = 180

class('Player').extends(gfx.sprite)

function Player:init(x, y, speed, jumpspeed, gravity)
	Player.super.init(self)

    self.speed = speed
    self.jumpspeed = jumpspeed
    self.gravity = gravity

	-- Currently just a single image for the sprite but will add animation in the future
	local player_image = gfx.image.new("images/dude-0001.png")
    self:setImage(player_image)
	self:setCollideRect(4, 4, 24, 40)
	self:setZIndex(10)
    self:moveTo(x, y)
end

function Player:update()

    Player.super.update(self)

    -- local player_pos_x  = self.x

    if pd.buttonIsPressed(pd.kButtonRight) then
        self:moveBy(self.speed, 0)
    end
    if pd.buttonIsPressed(pd.kButtonLeft) then
        self:moveBy(-self.speed, 0)
    end
    if pd.buttonJustPressed(pd.kButtonA) then
        self.jumpspeed = -10
    end

    self:moveBy(0,self.jumpspeed)

    local player_pos_y  = self.y

    if player_pos_y < ground_y then
        self.jumpspeed += self.gravity
    elseif player_pos_y >= ground_y then
        self:moveBy(0, ground_y-player_pos_y)
        self.jumpspeed = 0
    end
end


-- function Player:reset()
-- 	-- self.xd = 0
-- 	-- self.yd = 0
-- 	-- self.v = 0

-- 	self.frame = 0
-- 	self:updateFrame()

-- 	self:moveTo(playdate.display.getWidth() / 4, playdate.display.getHeight() / 4)
-- end



-- function Player:up()

-- end


-- function Player:left()

-- end


-- function Player:right()

-- end

