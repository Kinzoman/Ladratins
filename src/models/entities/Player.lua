local Player = {}

Player.__index = Player

function Player:new(world, x, y)
    assert(world, "Player needs to receive a world")
    local this = {
        body = love.physics.newBody(world, x or 0, y or 0, "dynamic"),
        shape = love.physics.newCircleShape(16),
        fixture = nil,
        speed = 150,
        sprite = {
            down = gameDirector:getLibrary("Pixelurite").configureSpriteSheet("Sigmundneyson_Front", "assets/sprites/Sigmundneyson/", true, nil, 1, 1, true),
            up = gameDirector:getLibrary("Pixelurite").configureSpriteSheet("Sigmundneyson_Back", "assets/sprites/Sigmundneyson/", true, nil, 1, 1, true),
            left = gameDirector:getLibrary("Pixelurite").configureSpriteSheet("Sigmundneyson_Back", "assets/sprites/Sigmundneyson/", true, nil, 1, 1, true),
            right = gameDirector:getLibrary("Pixelurite").configureSpriteSheet("Sigmundneyson_Back", "assets/sprites/Sigmundneyson/", true, nil, 1, 1, true)
        },
        currentSprite = "down",
        canMove = false,
        keys = {up = "up", down = "down", left = "left", right = "right"},
        orientations = {up = "vertical", down = "vertical", right = "horizontal", left = "horizontal"}
    }
    this.body:setFixedRotation(true)
    this.fixture = love.physics.newFixture(this.body, this.shape)
    this.fixture:setRestitution(30)
    return setmetatable(this, Player)
end

function Player:keypressed(key, scancode, isrepeat)
    local changeSprite = nil
    if self.keys[key] == "down" or self.keys[key] == "up" or self.keys[key] == "left" or self.keys[key] == "right" then
        changeSprite = self.keys[key]
    end
    if changeSprite then
        self.currentSprite = changeSprite
        self.canMove = true
    end
end

function Player:keyreleased(key, scancode)
    if self.keys[key] == self.currentSprite then
        self.canMove = false
    end
end

function Player:getPosition()
    return self.body:getX(), self.body:getY()
end

function Player:update(dt)
    if self.canMove then
        local xForce = 0; local yForce = 0
        if self.orientations[self.currentSprite] == "horizontal" then
            xForce = self.speed * (self.currentSprite == "right" and 1 or -1)
        else
            yForce = self.speed * (self.currentSprite == "down" and 1 or -1)
        end
        self.body:setLinearVelocity(xForce, yForce)
        self.sprite[self.currentSprite]:update(dt)
    else
        self.body:setLinearVelocity(0, 0)
    end
end

function Player:draw()
    self.sprite[self.currentSprite]:draw(self.body:getX(), self.body:getY())
end

return Player
