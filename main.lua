--[[
    plattformer
    Author: olstra
    Date: Jan 2020
    as a part of 'edx course CS50g'
]]


require 'src/dependencies'


function love.load()
    love.window.setTitle("OLIVER CODES A PLATFORMER")
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_W, VIRTUAL_H, WIN_W, WIN_H, {        
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- ANIMATION FRAMES

    ani_idle = Animation {
        frames = {1},
        interval = 1
    }
    ani_moving = Animation {
        frames = {10, 11},
        interval = 0.2
    }
    ani_jump = Animation {
        frames = {3},
        interval = 1
    }

    --ani_current = ani_idle

    cam_scroll = 0

    level = Level{}

    player = Player{
        -- dimensions
        w = CHARA_W,
        h = CHARA_H,

        -- position
        x = CHARA_H,
        y = FLOOR_H * TILE_SIZE - CHARA_H,

        texture = 'player',

        direction = 'right',

        map = level.map,

        animation = ani_idle
    }
   
end


--function love.resize(w, h)
--    push:resize(w, h)
--end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end


function love.update(dt)

    if player.alive then
        player:update(dt)
    end

    -- cam clamping
    -- set the camera's left edge to half the screen to the left of the player's center
    cam_scroll = math.max( 0,
        math.min( (TILE_SIZE * #level.map[1] - VIRTUAL_W), (player.x - (VIRTUAL_W / 2 - 8)) ) )

    -- adjust background x-pos to move a third the rate of the camera for parallax
    bg_x = (cam_scroll / 3) % 256

end


function love.draw()
    push:start()
    
    love.graphics.clear()

    -- draw the background (as seen in course repo)
    love.graphics.draw(
        gTextures['backgrounds'], 
        gFrames['backgrounds'][1], 
        math.floor(-bg_x), 0)

    love.graphics.draw(
        gTextures['backgrounds'], 
        gFrames['backgrounds'][1], 
        math.floor(-bg_x),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)

    love.graphics.draw(
        gTextures['backgrounds'], 
        gFrames['backgrounds'][1], 
        math.floor(-bg_x + 256), 0)
    
    love.graphics.draw(
        gTextures['backgrounds'], 
        gFrames['backgrounds'][1], 
        math.floor(-bg_x + 256),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    ---------------------

    -- game over
    if not(player.alive) then
        love.graphics.setColor(100, 0, 0, 255)
        love.graphics.setFont(gFonts['medium'])
        love.graphics.print("GAME OVER", VIRTUAL_W/3, VIRTUAL_H/4)
    end

    love.graphics.translate(-math.floor(cam_scroll), 0) -- translate using int (floor), else blur

    level:render()

    player:render()

    push:finish()

end