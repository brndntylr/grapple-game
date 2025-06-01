-- title_scene.lua
import "CoreLibs/object"
import "CoreLibs/graphics"
import "roomy-playdate"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Title").extends(Room)

function Title:enter(previous, manager)
    -- Initialize your level selection screen
    self.manager = manager
end

function Title:update()
    gfx.sprite.update()
    -- Handle input and update logic
    if pd.buttonJustPressed(pd.kButtonA) then
        self.manager:enter(LevelSelect(), self.manager)   
    end
end

function Title:draw()
    -- Render the title screen
    gfx.clear()

    -- Draw title text
    local titleText = "Grapple Game"
    local titleWidth, titleHeight = gfx.getTextSize(titleText)
    local titleX = (400 - titleWidth) / 2
    local titleY = 240 / 3 - titleHeight / 2
    gfx.drawText(titleText, titleX, titleY)

    -- Draw start prompt
    local promptText = "Press Ⓐ to Start"
    local promptWidth, promptHeight = gfx.getTextSize(promptText)
    local promptX = (400 - promptWidth) / 2
    local promptY = titleY + titleHeight + 40
    gfx.drawText(promptText, promptX, promptY)
end

function Title:leave(next, ...)
    -- Cleanup when leaving the scene
end