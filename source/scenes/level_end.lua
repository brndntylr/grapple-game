-- LevelEnd_scene.lua
import "CoreLibs/object"
import "CoreLibs/graphics"
import "roomy-playdate"
import "scenes/level_select"
import "scenes/title"
import "scenes/gameplay"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("LevelEnd").extends(PauseRoom)

function LevelEnd:enter(previous, manager, levels, selected)
    -- Initialize your level selection screen
    self.manager = manager
    self.selectedIndex = 1
    self.options = {
        { label = "Next Level", action = function()
            if selected < #levels then
                selected += 1
                self.manager:enter(Gameplay(), self.manager, levels, selected)
            else
                self.manager:enter(LevelSelect(), self.manager)
            end
        end },
        { label = "Restart Level", action = function() self.manager:enter(Gameplay(), self.manager, levels, selected) end },
        { label = "Level Select", action = function() self.manager:enter(LevelSelect(), self.manager) end },
        { label = "Quit to Title", action = function() self.manager:enter(Title(), self.manager) end }
    }
end

function LevelEnd:update()
    if pd.buttonJustPressed(pd.kButtonUp) then
        self.selectedIndex = (self.selectedIndex - 2) % #self.options + 1
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        self.selectedIndex = self.selectedIndex % #self.options + 1
    elseif pd.buttonJustPressed(pd.kButtonA) then
        self.options[self.selectedIndex].action()
    end
end

function LevelEnd:draw()
    gfx.clear()

    local title = "Level Complete"
    local titleWidth, titleHeight = gfx.getTextSize(title)
    local titleX = (400 - titleWidth) / 2
    local titleY = 240 / 6 - titleHeight / 2
    gfx.drawText(title, titleX, titleY)

    for i, option in ipairs(self.options) do
        local text = option.label
        local width, height = gfx.getTextSize(text)
        local x = (400 - width) / 2
        local y = 120 + (i - 1) * 30
        if i == self.selectedIndex then
            gfx.fillRect(x - 5, y - 2, width + 10, height + 4)
            gfx.setImageDrawMode(gfx.kDrawModeInverted)
            gfx.drawText(text, x, y)
            gfx.setImageDrawMode(gfx.kDrawModeCopy)
        else
            gfx.drawText(text, x, y)
        end
    end
end

function LevelEnd:leave(next, ...)
    -- Cleanup when leaving the scene
end