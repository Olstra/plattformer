--[[
    plattformer
    Author: olstra
    Date: Jan 2020
    as a part of 'edx course CS50g'
]]

map_txt = { 
    "------------------------------------------------------",
    "------------------------------------------------------",
    "------------------------------------------------------",
    "------------------------------------------------------",
    "--------------------------####------------------------",
    "-----###-----##---------#####-------------------------",
    "####------######-############kkkk#--kkkkkkkkkkkk--####",
    "####kkkkkk######-#################----------------####",
    "################-#####################################",
}


Level = Class{}


function Level:init()
    self.map = generateLevel(map_txt)
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
            end    

        end
    end
end


------------------------------
function generateLevel(map)

    if #map == 0 then
        print("ups! problem with level map!")
        return -1
    end

    level = {}
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
                temp = map[temp_y]:sub(col,col) == '-'

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