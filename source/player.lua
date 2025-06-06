import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "grapple"
import "arrow"
import "utils"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)

function Player:init(x, y, onLevelEnd)
	Player.super.init(self)

    -- Movement on the ground
    self.vx = 0
    self.vy = 0

    self.ax = 1.5
    -- self.friction = 0.4
    self.jumped = false
    self.max_vx = 5

    -- Movement whilst jumping
    self.jump_speed = 15
    self.min_jump_speed = 8  -- Reduced for smaller tap jump
    self.max_jump_speed = 16 -- Increased for higher held jump
    self.gravity = 1.8
    self.air_ax = 0.3
    self.max_vy_fall = 10
    self.is_jumping = false  -- Track if we're in a jump

    -- Movement whilst grappling
    self.grappleLength = 0
    self.air_resistance = 0.5
    self.theta = 0  -- angle of the rope
    self.omega = 0  -- angular velocity
    self.swinging = false
    self.angular_acceleration = 0.01  -- Small value to adjust swing acceleration
    self.max_omega = 0.1

    self.ropeLength = 100

    -- Other
    self.aim_angle = 0

	-- Define player sprite image (need to look at adding animation eventually)
	local player_image = gfx.image.new("images/dude-0001.png")
    self:setImage(player_image)
	self:setCollideRect(0, 0, self:getSize())
    self:setCollidesWithGroups({1,3})
	self:setZIndex(10)
    self:moveTo(x, y)

    -- Initialising grapple and arrow within the player sprite
    self.grapple = Grapple(self.x+self.width, self.y+(self.height/2))
    self.arrow = Arrow(self.x, self.y)

    -- Call back function that moves to level end scene on collision with EndFlag
    self.onLevelEnd = onLevelEnd

    self:add()
end

function Player:update()
    Player.super.update(self)

    self.vy += self.gravity

    self.grounded = false

    local acc = self.ax
    if self.jumped then
        acc = self.air_ax
    end

    if playdate.buttonIsPressed(pd.kButtonLeft) then
        self.vx -= acc
    elseif playdate.buttonIsPressed(pd.kButtonRight) then
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
            if self.swinging then
                self.vx += math.cos(self.theta) * self.omega * self.ropeLength
                self.vy += math.sin(self.theta) * self.omega * self.ropeLength
                self.grapple.state = "none"
            end
            self.vy = -self.min_jump_speed  -- Initial jump velocity
            self.jumped = true
            self.is_jumping = true
        end
    elseif pd.buttonIsPressed(pd.kButtonA) and self.is_jumping then
        -- Continue rising if button held and within max jump height
        if self.vy > -self.max_jump_speed then
            self.vy -= 0.8  -- Increased from 0.5 for faster height gain
        end
    end

    if pd.buttonJustReleased(pd.kButtonA) then
        self.is_jumping = false
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
            self.vx += math.cos(self.theta) * self.omega * self.ropeLength
            self.vy += math.sin(self.theta) * self.omega * self.ropeLength
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

    -- local _, _, coll, _ = self:checkCollisions(self.x, self.y)
    -- if self.grapple.state == "stuck" and self.grapple.x and self.grapple.y and self.grounded == false then
    if self.grapple.state == "stuck" and self.grapple.x and self.grapple.y then
        if not self.swinging then
            -- Initialize swing from current position
            local dx = self.x - self.grapple.x
            local dy = self.y - self.grapple.y
            self.theta = math.atan(dx, dy) -- angle from vertical
            self.omega = 0
            self.swinging = true
        end

        -- Apply angular acceleration to the angular velocity
        local angular_force = (-self.gravity / self.ropeLength) * math.sin(self.theta) -- pendulum physics
        
        local angular_accel = angular_force
        if pd.buttonIsPressed(pd.kButtonLeft) then 
            angular_accel -= self.angular_acceleration  -- Apply custom angular acceleration
        elseif pd.buttonIsPressed(pd.kButtonRight) then
            angular_accel += self.angular_acceleration
        end

        -- Update angular velocity with the new angular acceleration
        self.omega += angular_accel
        self.omega *= 0.9  -- damping

        -- Ensure the omega (angular velocity) doesn't exceed max limit
        print(self.omega)
        self.omega = math.clamp(self.omega, -self.max_omega, self.max_omega)

        -- Update the angle
        self.theta += self.omega

        -- Convert polar back to Cartesian
        local swingX = self.grapple.x + self.ropeLength * math.sin(self.theta)
        local swingY = self.grapple.y + self.ropeLength * math.cos(self.theta)

        self.vx = swingX - self.x
        self.vy = swingY - self.y

        targetX = swingX
        targetY = swingY
    else
        self.swinging = false
    end

    -- Clamp to screen bounds (left, right, top)
    local spriteWidth, spriteHeight = self:getSize()
    targetX = math.clamp(targetX, spriteWidth // 2, 400 - spriteWidth // 2)
    targetY = math.max(targetY, spriteHeight // 2)

    -- Check if player has fallen out of the bottom of the screen
    if targetY > 240 + spriteHeight then
        -- Restart the level
        if self.onLevelEnd then
            self.onLevelEnd("restart")
        end
        return
    end

    local actualX, actualY, collisions, count = self:moveWithCollisions(targetX, targetY)

    if self.grapple.state == "out" then
        self.arrow:moveTo(self.x, self.y-(self.height/2))
    end

    self:CrankCheck()

    -- Make sure to call draw after position updates
    -- self:draw()
end

function Player:collisionResponse(other)
    -- if other.super.className ~= "Platform" then return "slide" end

    if other.type == "Platform" then
        local _, sy, _, sh = self:getBounds()
        local _, oy, _, oh = other:getBounds()

        if sy + sh <= oy + 4 and self.vy >= 0 then -- small threshold to detect top-side landings whilst the player is moving downwards
            self.jumped = false
            -- self.grounded = true
            self.vy = 0
            self.vx = math.sign(self.vx) * math.max(0, math.abs(self.vx) - other.friction)
        end

        return "slide"
    end

    if other.type == "EndFlag" then
        self.onLevelEnd()
        return "overlap"
    end
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

function Player:draw()
    -- First draw the sprite normally
    Player.super.draw(self)
    
    -- Then draw the rope when grapple is stuck
    if self.grapple and self.grapple.state == "stuck" then
        -- Calculate player hand position
        local handX = self.x + self.width/2
        local handY = self.y + self.height/3
        
        -- Set line style if desired
        -- gfx.setLineWidth(2)  -- Optional: make rope thicker
        
        -- Draw the rope line
        gfx.drawLine(handX, handY, self.grapple.x, self.grapple.y)
    end
end