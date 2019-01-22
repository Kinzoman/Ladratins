local InGameScene = {}

InGameScene.__index = InGameScene

function InGameScene:new(world)
    local this = {
        player = gameDirector:getLibrary("Player"):new(world.world, 60, 50),
        playerLife = 15,
        map = love.graphics.newImage("assets/sprites/game_map.png"),
        music = love.audio.newSource("assets/sounds/in_game.wav", "static"),
        hud = gameDirector:getLibrary("HeadUpDisplay"):new(15),
        cameraController = nil,
        walls = {},
        npcs = {},
        elapsedTime = 0,
        waitTime = love.math.random(2, 7)
    }
    this.music:setLooping(true)
    this.cameraController = gameDirector:getLibrary("CameraController"):new(this.player, {w = 2400, h = 1800}, 2)
    sceneDirector:addSubscene("pause", require "scenes.subscenes.PauseGame":new())
    --[[Adding walls to game --]]
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 1200, 0, {w = 2400, h = 10}))
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 1200, 1800, {w = 2400, h = 10}))
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 0, 900, {w = 10, h = 1800}))
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 2400, 900, {w = 10, h = 1800}))
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
    self.elapsedTime = self.elapsedTime + dt
    self.music:play()
    gameDirector:update(dt)
    self.cameraController:update(dt)
    self.player:update(dt)
    if self.elapsedTime >= self.waitTime then
        self.elapsedTime = 0
        self.waitTime = love.math.random(2, 7)
        --[[ Here will spawn NPCs --]]
    end
end

function InGameScene:draw()
    self.cameraController:draw(function()
        love.graphics.draw(self.map, 0, 0)
        for _, wall in pairs(self.walls) do
            wall:draw()
        end
        self.player:draw()
    end)
    self.hud:draw()
end

return InGameScene
