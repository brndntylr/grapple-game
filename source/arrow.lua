import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = pd.geometry

class('Arrow').extends(gfx.sprite)

function Arrow:init(x, y, player_data)
    Arrow.super.init(self)
    self.poly = geom.polygon.new(-1, 0, -1, -20, -5, -20, 0, -25, 5, -20, 1, -20, 1, 0)
    self.poly:close()
    self.arrow_image = gfx.image.new(120, 100)
    self.translate_transform = geom.affineTransform.new()

    self:moveTo(x, y)
    self:setZIndex(11)

    self:translate(self.arrow_image.width/2,45)
    self:rotate(0)

    self.init_speed = 1
    self.accel = 0.3
    self.max_speed = 5

    self.pos = 0
    self.speed = 1
end

function Arrow:rotate(pos)
    self.rotate_transform = geom.affineTransform.new()
    self.rotate_transform:rotate(pos, self.arrow_image.width/2,76)
    self.draw_poly = self.poly * self.rotate_transform
end

function Arrow:translate(x,y)
    self.translate_transform:translate(x,y)
    self.poly = self.poly * self.translate_transform
end

function Arrow:reset()
    self.pos = 0
    self.speed = self.init_speed
    
    self:rotate(self.pos)
    self:draw()
end

function Arrow:posOut()
    return self.pos
end

function Arrow:collisionResponse(other)
    return "overlap"
end

function Arrow:draw()
    self.arrow_image:clear(playdate.graphics.kColorClear)

    gfx.pushContext(self.arrow_image)
        gfx.fillPolygon(self.draw_poly)
    gfx.popContext()

    self:setImage(self.arrow_image)
end

function Arrow:update()
    Arrow.super.update(self)

    if pd.buttonIsPressed(pd.kButtonLeft) then
        self.pos -= self.speed
        self.pos = math.max(self.pos, -90)
        self:rotate(self.pos)
        self.speed = math.min(self.max_speed, self.speed + self.accel)
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self.pos += self.speed
        self.pos = math.min(self.pos, 90)
        self:rotate(self.pos)
        self.speed = math.min(self.max_speed, self.speed + self.accel)
    else
        self.speed = self.init_speed
    end

    self:draw()
end
