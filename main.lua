-- main.lua

entities = require "entities"
osbmath = require "osbmath"

function love.load()
    -- Se carga la fuente at01.ttf
    local font = love.graphics.newFont("ttf/at01.ttf", 50)
    love.graphics.setFont(font)

    -- Se cargan los sonidos.
    hit_sound = love.audio.newSource("ogg/ping_pong_8bit_plop.ogg", "static")
    brick_sound = love.audio.newSource("ogg/ping_pong_8bit_beeep.ogg", "static")
    lose_sound = love.audio.newSource("ogg/ping_pong_8bit_peeeeeep.ogg", "static")
    
    hit_sound:setVolume(5.0)

    -- Se carga la música de fondo en bucle
    background_music = love.audio.newSource("wav/Mercury.wav", "stream")
    background_music:setLooping(true)
    background_music:setVolume(0.8)
    background_music:play()


    -- Se ejecuta una sola vez al iniciar el juego
    love.window.setTitle("OSB Brick Breaker")
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0.8, 0.8, 1)

    width, height = love.graphics.getDimensions()

    player_maxspeed = 800
    ball_maxspeed = 0.8 * player_maxspeed

    player_length = 60
    player_height = 10

    player_points = 0
    player_lives = 3

    brick_length = 40

    sqrt2 = math.sqrt(2)

    ball_collided = false

    -- Creamos al jugador.
    player = entities.create({x = (width / 2)-player_length/2, y = height - player_height*2}, {x = player_maxspeed, y = 0}, {x = player_length, y = player_height})

    -- Creamos la bola. Usamos pos = top-left para que las AABB funcionen correctamente
    ball = entities.create({x = (width - player_height)/2, y = (height - player_height)/2}, {x = 0, y = 0}, {x = player_height, y = player_height})

    -- Creamos las paredes del juego (no visibles).
    wall_top = entities.create({x = 0, y = -100}, {x = 0, y = 0}, {x = width, y = 100})
    wall_left = entities.create({x = -100, y = 0}, {x = 0, y = 0}, {x = 100, y = height})
    wall_right = entities.create({x = width, y = 0}, {x = 0, y = 0}, {x = 100, y = height})
    wall_bottom = entities.create({x = 0, y = height}, {x = 0, y = 0}, {x = width, y = 100})
    
    -- Creamos los ladrillos
    bricks = {}

    for i=0,6 do
        for j=0,16 do
            table.insert(bricks, entities.create({x = 20 + j*(brick_length + 3) + osbmath.oddevenmap(i)*(brick_length/4 + 1.5), y = 20 + i*(brick_length/2 + 3)}, {x = 0, y = 0}, {x = brick_length, y = brick_length/2}))
            bricks[#bricks].dead = false
        end
    end
    --brick = entities.create({x = 500, y = 300}, {x = 0, y = 0}, {x = 100, y = 50})
    --brick.dead = false

end

function love.update(dt)
    -- Movimiento básico con AD
    if love.keyboard.isDown("a") then
        entities.move(player, -dt)
        if ball.speed.y == 0 and ball.speed.x == 0 then
            vector_aux = osbmath.new_univector(1,2)
            ball.speed = {x = -ball_maxspeed/sqrt2, y = ball_maxspeed/sqrt2}
        end
    end

    if love.keyboard.isDown("d") then
        entities.move(player, dt)
        if ball.speed.y == 0 and ball.speed.x == 0 then
            ball.speed = {x = ball_maxspeed/sqrt2, y = ball_maxspeed/sqrt2}
        end
    end

    if love.keyboard.isDown("r") then
        player.pos.x = (width / 2)-player_length/2
        ball.pos.x = width/2 - player_height/2
        ball.pos.y = height/2 - player_height/2
        ball.speed = {x = 0, y = 0}

        for i, brick in ipairs(bricks) do
            brick.dead = false
        end

        player_points = 0
        player_lives = 3
        love.audio.play(lose_sound)
    end

    -- Reescribimos las comprobaciones de colision para ejecutarlas independientemente
    local collided_this_frame = false

    if entities.are_colliding(player, ball) then
        if not ball_collided then
            deltax = (ball.pos.x + ball.dims.x/2) - player.pos.x

            ball_speed_norm = osbmath.new_univector(-math.cos(math.pi * deltax / player.dims.x), (-1) * (math.sin(math.pi * deltax / player.dims.x) * 3/4 + 1/4))
            ball.speed.x = ball_maxspeed * ball_speed_norm.x
            ball.speed.y = ball_maxspeed * ball_speed_norm.y
        end
        collided_this_frame = true

        -- Toca el sonido de rebote
        love.audio.play(hit_sound)
    end

    if entities.are_colliding(ball, wall_top) then
        if not ball_collided then
            ball.speed.y = math.abs(ball.speed.y)
        end
        collided_this_frame = true
        love.audio.play(hit_sound)
    end

    if entities.are_colliding(ball, wall_left) then
        if not ball_collided then
            ball.speed.x = math.abs(ball.speed.x)
        end
        collided_this_frame = true
        love.audio.play(hit_sound)
    end

    if entities.are_colliding(ball, wall_right) then
        if not ball_collided then
            ball.speed.x = -math.abs(ball.speed.x)
        end
        collided_this_frame = true
        love.audio.play(hit_sound)
    end

    if entities.are_colliding(ball, wall_bottom) then
        ball.speed = {x = 0, y = 0}
        ball.pos.x = width/2 - player_height/2
        ball.pos.y = height/2 - player_height/2

        player.pos.x = (width / 2)-player_length/2
        love.audio.play(lose_sound)
        player_points = player_points - 200
        player_lives = player_lives - 1
    end

    for i, brick in ipairs(bricks) do
        if not brick.dead and entities.are_colliding(ball, brick) then
            if not ball_collided then
                ball.speed.y = math.abs(ball.speed.y)
            end
            brick.dead = true
            collided_this_frame = true
            player_points = player_points + 100
            love.audio.play(brick_sound)
        end
    end

    ball_collided = collided_this_frame
    -- Movimiento de la bola
    entities.move(ball, dt)

    if player_lives <= 0 then
        player.pos.x = (width / 2)-player_length/2
        ball.pos.x = width/2 - player_height/2
        ball.pos.y = height/2 - player_height/2
        ball.speed = {x = 0, y = 0}

        for i, brick in ipairs(bricks) do
            brick.dead = false
        end

        player_points = 0
        player_lives = 3
    end
end

function love.draw()
    -- Dibujado
    love.graphics.setColor(0.2, 0, 0.8)
    love.graphics.rectangle("fill", player.pos.x, player.pos.y, player.dims.x, player.dims.y)

    love.graphics.rectangle("fill", ball.pos.x, ball.pos.y, ball.dims.x, ball.dims.y)

    love.graphics.print("POINTS " .. player_points, width*3/4, height - 100)
    love.graphics.print("PRESS R TO RESET", 20, height - 150)
    love.graphics.print("PRESS A, D TO MOVE", 20, height - 200)

    love.graphics.print("LIVES " .. player_lives, width*3/4, height - 150)


    love.graphics.setColor(0.8, 0.2, 0)
    for i, brick in ipairs(bricks) do
         if not brick.dead then
            love.graphics.rectangle("fill", brick.pos.x, brick.pos.y, brick.dims.x, brick.dims.y)
        end
    end

    
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        print("Click en:", x, y)
    end
end

function love.resize(w, h)
    width, height = w, h
end
