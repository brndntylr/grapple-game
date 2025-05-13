import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "grapple"
import "arrow"
import "utils"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)

function Player:init(x, y, speed, jumpspeed, gravity)
	Player.super.init(self)

    -- Movement on the ground
    self.vx = 0
    self.vy = 0

    self.ax = 0.8
    self.friction = 0.4
    self.jumped = false
    self.max_vx = 3

    -- Movement whilst jumping
    self.jump_speed = jumpspeed
    self.gravity = gravity
    self.air_ax = 0.3
    self.max_vy_fall = 10

    -- Movement whilst grappling
    self.grappleLength = 0

    self.air_resistance = 1
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

    local acc = self.ax
    if self.jumped == true then
        acc = self.air_ax
    end

    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        self.vx -= acc
    elseif playdate.buttonIsPressed(playdate.kButtonRight) then
        self.vx += acc
    end
    print(self.vx)

    self.vy = math.min(self.vy, self.max_vy_fall)

    if self.grapple.state == "stuck" and not pd.isCrankDocked() then
        local crankChange = pd.getCrankChange()
        if math.abs(crankChange) > 0 then
            self.ropeLength = math.max(10, self.ropeLength - crankChange)
        end
    end

    -- self.vx = math.max(math.min(self.vx, self.max_vx), -self.max_vx)
    self.vx = math.clamp(self.vx, -self.max_vx, self.max_vx)


    if pd.buttonJustPressed(pd.kButtonA) then
        if not self.jumped then
            self.vy = -self.jump_speed
            self.jumped = true
        end
    end

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

    if self.grapple.state == "stuck" and not pd.isCrankDocked() then
        local crankChange = pd.getCrankChange()
        if crankChange ~= 0 then
            self.ropeLength = math.max(10, self.ropeLength - crankChange)
        end
    end

    local targetX = self.x + self.vx
    if self.grapple.state == "out" then
        targetX = self.x
    end
    local targetY = self.y + self.vy

    if self.grapple.state == "stuck" and self.grapple.x and self.grapple.y then
        local dx = targetX - self.grapple.x
        local dy = targetY - self.grapple.y
        local dist = math.sqrt(dx * dx + dy * dy)

        if dist > self.ropeLength then
            local scale = self.ropeLength / dist
            targetX = self.grapple.x + dx * scale
            targetY = self.grapple.y + dy * scale
            self.vx = targetX - self.x
            self.vy = targetY - self.y
        end
    end

    local actualX, actualY, collisions, count = self:moveWithCollisions(targetX, targetY)

    if self.grapple.state == "out" then
        self.arrow:moveTo(self.x, self.y-(self.height/2))
    end

    self:CrankCheck()
end

function Player:collisionResponse(other)
    if other.super.className ~= "Platform" then return "slide" end

    local _, sy, _, sh = self:getBounds()
    local _, oy, _, oh = other:getBounds()

    if sy + sh <= oy + 4 and self.vy >= 0 then -- small threshold to detect top-side landings whilst the player is moving downwards
        self.jumped = false
        self.vy = 0.1
        self.vx = math.sign(self.vx) * math.max(0, math.abs(self.vx) - self.friction)
    end

    return "slide"
end

function Player:CrankCheck()
    if self.grapple.state == "stuck" then
        if pd.isCrankDocked() then
            CrankInd = 1
        end
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