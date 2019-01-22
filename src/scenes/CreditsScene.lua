local CreditsScene = {}
CreditsScene.__index = CreditsScene

function CreditsScene:new()
    local this = {
        variableNames = {mechanics = "Mechanics Programmers", gameDesign = "Game Designers",
        graphicalDesigners = "Graphical Designers", levelDesign = "Level Designers"},
        mechanics = {"Jictyvoo - João Victor Oliveira Couto"},
        gameDesign = {"João Victor Oliveira Couto", "João Matheus"},
        graphicalDesigners = {"João Matheus"},
        levelDesign = {"João Victor Oliveira Couto", "João Matheus"},
        companyImage = love.graphics.newImage("assets/company_logo.png"),
        y = love.graphics.getHeight(),
        elapsedTime = 0,
        speed = 1,
        finalY = love.graphics.getHeight()
    }

    return setmetatable(this, CreditsScene)
end

function CreditsScene:reset()
    self.y = love.graphics.getHeight(); self.elapsedTime = 0; self.finalY = self.y
end

function CreditsScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    elseif key == "space" then
        self.speed = 4
    end
end

function CreditsScene:keyreleased(key, scancode)
    if key == "space" then
        self.speed = 1
    end
end

function CreditsScene:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= 0.01 then
        self.y = self.y - self.speed
        self.elapsedTime = 0
    end
    if self.finalY <= 0 then
        sceneDirector:previousScene()
    end
end

function CreditsScene:draw()
    local y = self.y
    local x = (love.graphics.getWidth() / 2) - 200
    for index, value in pairs(self.variableNames) do
        love.graphics.printf(value, x, y, 400, "left")
        y = y + 20
        for _, names in pairs(self[index]) do
            love.graphics.printf(names, x, y, 400, "center")
            y = y + 20
        end
        y = y + 15
    end
    y = y + 30
    local scales = scaleDimension:getScale("splash_company")
    love.graphics.draw(self.companyImage, scales.x, y, 0, scales.relative.x, scales.relative.y)
    self.finalY = y + self.companyImage:getHeight() * scales.relative.y
end

return CreditsScene
