local InGameScene = {}

InGameScene.__index = InGameScene

local instance = nil

local function getPlayerFixture(a, b)
    local aFixture = nil; local bFixture = nil
    if a:getUserData() == "Player" then
        aFixture = a; bFixture = b
    else
        aFixture = b; bFixture = a
    end
    return aFixture, bFixture
end

local function beginContact(a, b, col)
    a, b = getPlayerFixture(a, b)
    if a:getUserData() == "Player" then
        if b:getUserData() == "Cop" then
            instance:stopNpc(b); instance:applyDamageInPlayer(1)
        elseif b:getUserData() == "Citzen" then
            instance:stealCtizen(b); instance:stopNpc(b)
        end
    end
end

local function endContact(a, b, col)
end

local function getPlayerLocation()
    return instance.player:getPosition()
end

function InGameScene:new(world)
    local this = {
        world = world,
        player = gameDirector:getLibrary("Player"):new(world.world, 60, 50),
        playerLife = 15,
        map = love.graphics.newImage("assets/sprites/game_map.png"),
        mapSize = {w = 2400, h = 1800},
        music = love.audio.newSource("assets/sounds/in_game.wav", "static"),
        hud = gameDirector:getLibrary("HeadUpDisplay"):new(15),
        cameraController = nil,
        walls = {},
        npcs = {},
        elapsedTime = 0,
        waitTime = love.math.random(2, 7)
    }
    this.world:addCallback("inGame", beginContact, "beginContact"); this.world:changeCallbacks("inGame")
    this.music:setLooping(true)
    this.cameraController = gameDirector:getLibrary("CameraController"):new(this.player, this.mapSize, 2)
    sceneDirector:addSubscene("pause", require "scenes.subscenes.PauseGame":new())
    sceneDirector:addSubscene("gameOver", require "scenes.subscenes.GameOver":new())
    --[[Adding walls to game --]]
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 1200, 0, {w = 2400, h = 10}))
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 1200, 1800, {w = 2400, h = 10}))
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 0, 900, {w = 10, h = 1800}))
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 2400, 900, {w = 10, h = 1800}))
    return setmetatable(this, InGameScene)
end

function InGameScene:getInstance(world)
    if not instance then instance = InGameScene:new(world) end
    return instance
end

function InGameScene:stopNpc(fixture)
    if self.npcs[fixture] then
        self.npcs[fixture]:setStopTime(5)
    end
end

function InGameScene:stealCtizen(fixture)
    if self.npcs[fixture] then
        self.npcs[fixture]:callCops()
        self.hud:updateComponent("stalkersCounter", 1)
    end
end

function InGameScene:applyDamageInPlayer(amount)
    self.playerLife = self.playerLife - amount
    self.hud:updateComponent("lifebar", amount)
    if self.playerLife <= 0 then
        sceneDirector:switchSubscene("gameOver")
    end
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
    
end

function InGameScene:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    self.music:play()
    gameDirector:update(dt)
    self.cameraController:update(dt)
    for _, npc in pairs(self.npcs) do
        npc:update(dt)
    end
    self.player:update(dt)
    if self.elapsedTime >= self.waitTime then
        self.elapsedTime = 0
        self.waitTime = love.math.random(2, 7)
        --[[ Here will spawn NPCs --]]
        local newNPC = gameDirector:getLibrary("NonPlayerCharacter"):new(love.math.random(0, 2),
        self.world.world, love.math.random(self.mapSize.w), love.math.random(self.mapSize.h), getPlayerLocation)
        self.npcs[newNPC:getFixture()] = newNPC
    end
end

function InGameScene:draw()
    self.cameraController:draw(function()
        love.graphics.draw(self.map, 0, 0)
        for _, wall in pairs(self.walls) do
            wall:draw()
        end
        for _, npc in pairs(self.npcs) do
            npc:draw()
        end
        self.player:draw()
    end)
    self.hud:draw()
end

return InGameScene
