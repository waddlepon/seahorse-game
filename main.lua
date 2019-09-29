--All this code is raw garbage, extremely dirty for the sake of hw

game_state = {
    phase = 1,
    progress = 0,
    max_progress = 100,
    last_key = nil,
}

function game_state.add_progress(x)
    game_state.progress = game_state.progress + x
    if game_state.progress >= game_state.max_progress then
        game_state.progress = 0
        game_state.phase = game_state.phase + 1
    end
end

player = {
    x = 400,
    y = 400,
    visible = true,
    image = nil,
    direction = 3, -- 1 = left, 2 = down, 3 = right, 4 = up
}

hot_girl = {
    x = 1000,
    y = 400,
    visible = true,
    image = nil,
    direction = 1, -- 1 = left, 2 = down, 3 = right, 4 = up
}

baby = {
    x = 600,
    y = 500,
    visible = false,
    image = nil,
}


heart = {
    x = 600,
    y = 300,
    visible = false,
    image = nil,
}

font = nil
big_font = nil

function love.load()
    player.img = love.graphics.newImage('assets/seahorse.png')
    hot_girl.img = love.graphics.newImage('assets/female_seahorse.png')
    baby.img = love.graphics.newImage('assets/baby_seahorse.png')
    heart.img = love.graphics.newImage('assets/red-heart.png')
    font = love.graphics.newFont(30)
    big_font = love.graphics.newFont(100)
end

function love.update(dt)
    if game_state.phase == 2 then
        if player.direction == hot_girl.direction then
            local ret
            repeat
                ret = math.random(4)
            until ret ~= player.direction
            hot_girl.direction = ret
            game_state.add_progress(10)
        end
    elseif game_state.phase == 3 then
        player.x = 600
        hot_girl.x = 800
    elseif game_state.phase == 4 then
        game_state.add_progress(dt * 20)
        heart.visible = true
    elseif game_state.phase == 5 then
        baby.visible = true
        heart.visible = false
        player.x = 400
        player.y = 400
        hot_girl.x = 1000
        hot_girl.y = 400
    end
end

keypress_functions = {}

keypress_functions[1] = function(key)
    if key == "left" and player.direction == 3 then
        player.direction = 1
        hot_girl.direction = 1
        game_state.add_progress(1)
    elseif key == "right" and player.direction == 1 then
        player.direction = 3
        hot_girl.direction = 3
        game_state.add_progress(1)
    end
end

keypress_functions[2] = function(key)
    if key == "left" then
        player.direction = 1
    elseif key == "down" then
        player.direction = 2
    elseif key == "right" then
        player.direction = 3
    elseif key == "up" then
        player.direction = 4
    end
end

keypress_functions[3] = function(key)
    if key == "space" then
        player.y = player.y - 6
        hot_girl.y = hot_girl.y - 6
        game_state.add_progress(1)
    end
end

function love.keypressed(key)
    if game_state.phase < 4 then
        keypress_functions[game_state.phase](key)
    end
    game_state.last_key = key
end

function love.draw(dt)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setBackgroundColor(0, 20, 200)
    if player.visible then
        orientation = 1
        rotation = 0
        if player.direction == 1 then
            orientation = -1
        end
        if player.direction == 2 then
            rotation = math.pi/2
        elseif player.direction == 4 then
            rotation = -math.pi/2
        end
        love.graphics.draw(player.img, player.x, player.y, rotation, -2*orientation, 2, player.img:getWidth()/2, player.img:getHeight()/2)
    end
    if hot_girl.visible then
        orientation = 1
        rotation = 0
        if hot_girl.direction == 1 then
            orientation = -1
        end
        if hot_girl.direction == 2 then
            rotation = math.pi/2
        elseif hot_girl.direction == 4 then
            rotation = -math.pi/2
        end
        love.graphics.draw(hot_girl.img, hot_girl.x, hot_girl.y, rotation, -2*orientation, 2, hot_girl.img:getWidth()/2, hot_girl.img:getHeight()/2)
    end
    if baby.visible then
        love.graphics.draw(baby.img, baby.x, baby.y)
    end
    if heart.visible then
        love.graphics.draw(heart.img, heart.x, heart.y, 0, 1, 1)
    end

    love.graphics.setFont(font)
    text = "" 
    description_text = ""
    if game_state.phase == 1 then
        text = "Phase 1: Quivering"
        description_text = "Alternate pressing left and right arrows as fast as possible"
    elseif game_state.phase == 2 then
        text = "Phase 2/3: Pointing"
        description_text = "Use the arrow keys to match where the female is pointing"
    elseif game_state.phase == 3 then
        text = "Phase 4: Rising"
        description_text = "Spam the spacebar"
    elseif game_state.phase == 4 then
        love.graphics.setFont(big_font)
        text = "Censored content"
    else
        text = "Congratulations you managed to reproduce"
        description_text = "Thank you for playing the worst game of all time"
    end

    love.graphics.printf(text, 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf(description_text, 0, 140, love.graphics.getWidth(), "center")

    love.graphics.setLineWidth(7)
    love.graphics.rectangle("line", 200, 20, 1000, 50)
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", 200, 20, (game_state.progress/game_state.max_progress)*1000, 50)
end