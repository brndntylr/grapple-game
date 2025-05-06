import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "grapple"
import "arrow"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)

function Player:init(x, y, speed, jumpspeed, gravity)
	Player.super.init(self)

    -- Movement on the ground
    self.vx = 0
    self.vy = 0

    self.ax = 0.2
    self.friction = 0.1 
    self.onGround = false
    self.max_vx = speed

    -- Movement whilst jumping
    self.jump_speed = jumpspeed
    self.gravity = gravity
    self.max_vy_fall = 10

    -- Movement whilst grappling
    self.grappleLength = 0

    self.air_resistance = -1
    self.max_omega = 12

    self.ropeLength = 100

    -- Other
    self.aim_angle = 0

	-- Define player sprite image (need to look at adding animation eventually)
	local player_image = gfx.image.new("images/dude-0001.png")
    self:setImage(player_image)
	self:setCollideRect(0, 0, self:getSize())
    self:setCollidesWithGroups(1)
	self:setZIndex(10)
    self:moveTo(x, y)

    -- Initialising grapple and arrow within the player sprite
    self.grapple = Grapple(self.x+self.width, self.y+(self.height/2))
    self.arrow = Arrow(self.x, self.y)
end

function Player:update()

    Player.super.update(self)

    self.vy += self.gravity

    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        self.vx -= 3.3
    elseif playdate.buttonIsPressed(playdate.kButtonRight) then
        self.vx += 3.3
    end

    self.vy = math.min(self.vy, self.max_vy_fall)
    self.vx = math.max(math.min(self.vx, self.max_vx), -self.max_vx)

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

    local targetX = self.x + self.vx
    local targetY = self.y + self.vy

    if self.isGrappling and self.grapplePoint then
        local dx = targetX - self.grapple.x
        local dy = targetY - self.grapple.y
        local dist = math.sqrt(dx * dx + dy * dy)

        if dist > self.ropeLength then
            local scale = self.ropeLength / dist
            targetX = self.grapplePoint.x + dx * scale
            targetY = self.grapplePoint.y + dy * scale
    
            self.vx = targetX - self.x
            self.vy = targetY - self.y
        end
    end

    local actualX, actualY, collisions, count = self:moveWithCollisions(targetX, targetY)

    if self.grapple.state = "out" then
        self.arrow:moveTo(self.x, self.y-(self.height/2))
    end

    if self.grapple.state == "stuck" then
        self:CrankCheck()
    end
end

function Player:collisionResponse(other)
    if other.super.className == "Platform" then
        self.onGround = false
        self.vy = 0.1;
        return "slide"
    end
end

function Player:CrankCheck()
    if pd.isCrankDocked() then
        CrankInd = 1
    end

    if CrankInd == 1 then
        if self.grapple.state ~= "stuck" then
            CrankInd = 0
        end
        if pd.isCrankDocked() == false then
            CrankInd = 0
        end
    end
end