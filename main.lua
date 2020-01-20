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

        map = level.tiles
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

    player:update(dt) --ani_current:update(dt)

    -- set the camera's left edge to half the screen to the left of the player's center
    local player_mid_x = player.x + player.w / 2
    cam_scroll = math.max(player_mid_x - (VIRTUAL_W/2), 0)

end


function love.draw()
    push:start()

    love.graphics.translate(-math.floor(cam_scroll), 0) -- translate using int (floor), else blur
    love.graphics.clear(0, 255, 150, 255)

    -- TODO set nice bg
   --[[  love.graphics.draw(
        gTextures['backgrounds'],
        gFrames['backgrounds'][1],
        1,1
    ) ]]

    level:render()

    player:render()

    push:finish()

end