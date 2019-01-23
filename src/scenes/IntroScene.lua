local IntroScene = {}
IntroScene.__index = IntroScene

function IntroScene:new()
    local this = {
        text = [[História
        Sigmundneyson, um cara que está devendo a todas as pessoas possíveis na cidade, resolve que ele vai ter que tirar esse dinheiro pra pagar todo mundo de alguma forma. Daí ele pega um par de patins e uma máscara e sai correndo pela cidade furtando as pessoas pra tentar pagar os agiotas que ele está devendo.
        
        Gameplay
        Você pode andar nas 8 direções, mas o personagem está sempre correndo em alguma direção, e tem um botão de pulo também. O objetivo é encostar nas pessoas que estão usando celular, crianças jogando bola, meninas brincando com uma boneca, etc, etc, enquanto desvia de buracos, cones, carros em movimento, policiais e os capangas da máfia. No final de cada estágio você tem acesso a uma loja, onde você vende as coisas que conseguiu roubar. Ah, e a cada assalto a vítima começa a correr pro policial mais perto pra ele correr atrás de você.
        ]],
        y = love.graphics.getHeight(),
        elapsedTime = 0,
        speed = 1,
        finalY = love.graphics.getHeight()
    }

    return setmetatable(this, IntroScene)
end

function IntroScene:reset()
    self.y = love.graphics.getHeight(); self.elapsedTime = 0; self.finalY = self.y
end

function IntroScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    elseif key == "space" then
        self.speed = 4
    end
end

function IntroScene:keyreleased(key, scancode)
    if key == "space" then
        self.speed = 1
    end
end

function IntroScene:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= 0.01 then
        self.y = self.y - self.speed
        self.elapsedTime = 0
    end
    if self.finalY <= 0 then
        sceneDirector:previousScene()
        sceneDirector:switchScene("inGame")
    end
end

function IntroScene:draw()
    love.graphics.printf(self.text, love.graphics.getWidth() / 4, self.y, 400, "center")
    self.finalY = self.y
end

return IntroScene
