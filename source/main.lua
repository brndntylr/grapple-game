import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "roomy-playdate"
import "scenes/level_select"
import "scenes/level_editor"
import "scenes/manager"

local pd <const> = playdate
local gfx <const> = pd.graphics

pd.display.setRefreshRate(30)

CrankInd = 0

local manager = Manager()
-- manager:enter(LevelSelect(), manager)
manager:enter(Title(), manager)

function pd.update()
  gfx.sprite.update()
  manager:emit('update')
  manager:emit('draw')
end