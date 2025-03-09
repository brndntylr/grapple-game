import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "player"
import "grapple"
import "platform"
import "grapple_surface"

playdate.display.setRefreshRate(30)

local gfx = playdate.graphics
local spritelib = gfx.sprite
local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()