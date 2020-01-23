--[[
    plattformer
    Author: olstra
    Date: Jan 2020
    as a part of 'edx course CS50g'
]]


Level = Class{}


function Level:init()
    self.map = self:generateLevel(map_txt)    
end


function Level:render()
    local xxx = self.map
    local tile = nil

    for row = 1, #xxx do
        for col = 1, #xxx[1] do

            tile = xxx[row][col]

            if tile['id'] == ID_GROUND then
                -- draw tiles
                love.graphics.draw( 
                    gTextures['tiles'], 
                    gFrames['tile_sets'][5][ID_GROUND],
                    tile.x, tile.y 
                )

                -- add toppers where needed
                if tile['topper'] then
                    love.graphics.draw( 
                        gTextures['toppers'], 
                        gFrames['topper_sets'][1][ID_GROUND],
                        tile.x, tile.y 
                    )
                end
            elseif tile['id'] == ID_LAVA then
                -- draw tiles
                love.graphics.draw( 
                    gTextures['tiles'], 
                    gFrames['tile_sets'][5][ID_GROUND],
                    tile.x, tile.y 
                )

                -- add toppers (=lava)
                if tile['topper'] then
                    love.graphics.draw( 
                        gTextures['toppers'], 
                        gFrames['topper_sets'][79][ID_GROUND],
                        tile.x, tile.y 
                    )
                end                
            elseif tile['id'] == ID_EXIT then
                -- draw 'exit' sign for level end
                love.graphics.draw(
                    gTextures['exit'], 
                    gFrames['exit'][ID_EXIT],
                    tile.x, tile.y 
                )
            elseif tile['id'] == 'cookie' then
                -- draw cookies
                love.graphics.draw(
                    gTextures['cookie'], 
                    gFrames['cookie'][1],
                    tile.x+3, tile.y +6
                )
            end    

        end
    end
end


------------------------------
function Level:generateLevel(map)

    if #map == 0 then
        print("ERROR: problem with level map!")
        return -1
    end

    local level = {}
    local temp_id = nil
    local temp_y = nil

    local y_pos = 0
    local x_pos = 0

    for row = 1, #map do
        table.insert(level, {})

        for col = 1, #map[1] do

            temp = map[row]:sub(col,col)

            -- calculate position
            y_pos = (row > 1) and (row-1)*TILE_SIZE or 0
            x_pos = (col > 1) and (col-1)*TILE_SIZE or 0

            if temp == '#' then                
                -- find out if we need a topper
                temp_y = (row-1 > 1) and row-1 or 1
                bla = map[temp_y]:sub(col,col)
                temp = bla == '-' or bla == 'T' or bla == 'X' or bla == 'O'

                tile = Tile{
                    id = ID_GROUND,
                    collidable = true,
                    topper = temp
                }
                
            elseif temp == '-' then
                tile = Tile{
                    id = ID_SKY,  
                    topper = false,
                    collidable = false                 
                }
            elseif temp == 'k' then -- LAVA
                tile = Tile{
                    id = ID_LAVA,
                    collidable = true,
                    topper = 'true'
                }
                tile.deadly = true
            elseif temp == 'T' then
                tile = Tile{
                    id = ID_EXIT,
                    collidable = true
                }
            elseif temp == 'X' then
                s_player_x = tile.x + CHARA_W
                s_player_y = tile.y - CHARA_H/2

                tile = Tile {
                    id = 'id_player'
                }
            elseif temp == 'O' then
                tile = Tile {
                    id = 'cookie',
                    collidable = true
                }
            else
                print('ERROR, ivalid chara in map!')
                return -1
            end

            tile.x = x_pos
            tile.y = y_pos

            table.insert(level[row], tile)
        end
    end

    return level
end
------------------------------