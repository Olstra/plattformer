--[[
    plattformer
    Author: olstra
    Date: Jan 2020
    as a part of 'edx course CS50g'
]]

level_map = { 
    "---------------------------------------------",
    "---------------------------------------------",
    "---------------------------------------------",
    "---------------------------------------------",
    "-------##------------------------------------",
    "-----------##--------------------------------",
    "#-###########################################",
    "#############################################",
    "#############################################"
}


Level = Class{}


function Level:init()
    self.tiles = generateLevel(level_map)
end


function Level:render()
    local xxx = self.tiles
    local tile = nil

    for row = 1, #xxx do
        for col = 1, #xxx[1] do

            tile = xxx[row][col]

            if tile['id'] == ID_GROUND then
                -- draw tiles
                love.graphics.draw( 
                    gTextures['tiles'], 
                    gFrames['tile_sets'][1][ID_GROUND],
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
            end

                -- add toppers
                --[[ if level_map[row-1]:sub(col,col) == '-' then
                    love.graphics.draw( 
                        gTextures['toppers'], 
                        gFrames['topper_sets'][1][ID_GROUND],
                        x_pos, y_pos 
                    )
                end ]]      

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

            y_pos = (row > 1) and (row-1)*TILE_SIZE or 0
            x_pos = (col > 1) and (col-1)*TILE_SIZE or 0

            if temp == '#' then
                
                -- find out if we need a topper
                temp_y = (row-1 > 1) and row-1 or 1
                temp = map[temp_y]:sub(col,col) == '-'

                tile = Tile{
                    id = ID_GROUND,
                    x = x_pos,
                    y = y_pos,
                    topper = temp
                }
                
            elseif temp == '-' then
                tile = Tile{
                    id = ID_SKY,
                    x = x_pos,
                    y = y_pos,  
                    topper = false                  
                }
            else
                print('ERROR, ivalid chara in map!')
                return -1
            end

            table.insert(level[row], tile)
        end
    end

    return level
end