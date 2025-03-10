import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
-- import "player"
-- import "grapple"
-- import "platform"
-- import "grapple_surface"

playdate.display.setRefreshRate(30)

local pd = playdate
local gfx = pd.graphics
local spritelib = gfx.sprite
local screenWidth = pd.display.getWidth()
local screenHeight = pd.display.getHeight()

local player_x = 200
local player_y = 120
local player_x_speed = 2
local player_y_speed = 0

local ground_y = 180

local player_image = gfx.image.new("images/dude-0001")
local player_sprite = gfx.sprite.new(player_image)
player_sprite:setCollideRect(4, 4, 24, 40)
player_sprite:moveTo(player_x, player_y)
player_sprite:add()

function pd.update()
    gfx.sprite.update()
    local player_pos_y  = player_sprite.y
    print(player_pos_y)
    if player_pos_y < ground_y then
        player_y_speed += 2
    elseif player_pos_y >= ground_y then
        player_sprite:moveBy(0, ground_y-player_pos_y)
        player_y_speed = 0
    end
    local left = pd.buttonIsPressed("left")
    local right = pd.buttonIsPressed("right")
    local jump = pd.buttonJustPressed("a")
    if left then
        player_sprite:moveBy(-player_x_speed, 0)
    end
    if right then
        player_sprite:moveBy(player_x_speed, 0)
    end
    if jump then
        player_y_speed = -6
    end
    print(player_y_speed)
    player_sprite:moveBy(0,player_y_speed)
end