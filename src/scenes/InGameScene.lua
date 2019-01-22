local InGameScene = {}

InGameScene.__index = InGameScene

function InGameScene:new(world)
    local this = {
        player = gameDirector:getLibrary("Player"):new(world.world, 60, 50),
        cameraController = nil
    }
    this.cameraController = gameDirector:getLibrary("CameraController"):new(this.player, {w = 1800, h = 2400}, 2)
    sceneDirector:addSubscene("pause", require "scenes.subscenes.PauseGame":new())
    return setmetatable(this, InGameScene)
end

function InGameScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:switchSubscene("pause")
    end
    self.player:keypressed(key, scancode, isrepeat)
end

function InGameScene:keyreleased(key, scancode)
    self.player:keyreleased(key, scancode)
end

function InGameScene:reset()
    gameDirector:reset()
end

function InGameScene:update(dt)
    gameDirector:update(dt)
    self.cameraController:update(dt)
    self.player:update(dt)
end

function InGameScene:draw()
    self.cameraController:draw(function()
        self.player:draw()
    end)
end

return InGameScene
