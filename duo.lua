-- title:  The Boring World of Niels Bohr
-- author: Torakko, Hattes, sfabian
-- desc:   Help Niels to survive in the boring world! Game made for Global Game Jam 2022.
-- script: lua


------ CONSTANTS ----------
-- size
HEIGHT = 136
WIDTH = 240
TILE_SIZE = 8
TILE_HEIGHT = 77 -- 136 / 8
TILE_WIDTH = 30 -- 240 / 8

-- buttons
BUTTON_UP = 0
BUTTON_DOWN = 1
BUTTON_LEFT = 2
BUTTON_RIGHT = 3
BUTTON_Z = 4
BUTTON_X = 5
BUTTON_A = 6
BUTTON_S = 7

-- colors (default palette SWEETIE-16)
BLACK = 0
PURPLE = 1
RED = 2
ORANGE = 3
YELLOW = 4
LIGHT_GREEN = 5
GREEN = 6
DARK_GREEN = 7
DARK_BLUE = 8
BLUE = 9
LIGHT_BLUE = 10
CYAN = 11
WHITE = 12
LIGHT_GREY = 13
GREY = 14
DARK_GREY = 15

-- tile flags
SOLID = 0
DEADLY = 1

-- sprites
DANSK = 256
CAT_CLOSED = 272
CAT_OPEN = 304
BOHR = 275
HEIGHT = 136
WIDTH = 240
TILE_SIZE = 8
TILE_HEIGHT = 17 -- 136 / 8
TILE_WIDTH = 30 -- 240 / 8
PLAYER_SPEED = 1
DIR_UP = 1
DIR_DOWN = 2
DIR_LEFT = 3
DIR_RIGHT = 4
DIR_DOWN_LEFT = 5
DIR_DOWN_RIGHT = 6
DIR_UP_LEFT = 7
DIR_UP_RIGHT = 8

------ GLOBAL VARIABLES ----------
t=0
STATE_MENU = 1
STATE_GAME = 2
STATE_GAME_OVER = 3
STATE_GAME_STARTING = 4
state = STATE_MENU
------ UTILITIES ------

function inarray(needle, haystack)
  for _, hay in ipairs(haystack) do
    if hay == needle then
      return true
    end
  end
  return false
end

------ FUNCTIONS -----------
function TIC()
    if state == STATE_MENU then
        update_menu()
        draw_menu()
    elseif state == STATE_GAME_STARTING then
        restart()
    elseif state == STATE_GAME_OVER then
        update_game_over()
        draw_game_over()
    elseif state == STATE_GAME then
        update_game()
        draw_game()
    end
    t=t+1
end

function update_menu()
    if btnp(BUTTON_Z) then
        state = STATE_GAME_STARTING
    end
end

function draw_menu()
    cls(BLACK)
    spr(BOHR,0,40,BLACK,6,0,0,1,2)
    spr(BOHR,192,40,BLACK,6,1,0,1,2)
    spr(CAT_OPEN,64,88,BLACK,3,0,0,2,2)
    spr(CAT_CLOSED,128,88,BLACK,3,1,0,2,2)
    print_centered("The Boring World", 10, ORANGE, false, 2)
    print_centered("of Niels Bohr", 30, ORANGE, false, 2)
    print_centered("Based on a true story", 50, ORANGE)
    print_centered("Press Z to start", 75, ORANGE)
end

function restart()
    -- This is where we set state of players etc. to their initial values
    playerA = {
        x=8,
        y=8,
        tileX=1,
        tileY=1,
        speed=PLAYER_SPEED,
    }
    playerB = {
        x=8,
        y=HEIGHT-16,
        tileX=1,
        tileY=TILE_HEIGHT - 2,
        speed=PLAYER_SPEED,
    }
    state = STATE_GAME
end

function update_game_over()
    if btn(BUTTON_Z) then
        state = STATE_GAME_STARTING
    end
end

function draw_game_over()
    cls(BLACK)
    print_centered("GAME OVER :(", 30, GRAY, false, 3)
    print_centered("Press Z to restart",72)
end

function update_game()
    handle_input()
end

function draw_game()
    cls(LIGHT_GREY)
    map()
    spr(DANSK,playerA.x,playerA.y,BLACK,1,0,0,1,1)
    spr(DANSK,playerB.x,playerB.y,BLACK,1,0,0,1,1)
end

function handle_input()
    -- buttons:
    -- up       0
    -- down     1
    -- left     2
    -- right    3
    -- z        4
    -- x        5
    -- a        6
    -- s        7

    if btn(BUTTON_UP) and btn(BUTTON_LEFT) then
        movePlayer(playerA, -PLAYER_SPEED, -PLAYER_SPEED, DIR_UP_LEFT)
        movePlayer(playerB, -PLAYER_SPEED,  PLAYER_SPEED, DIR_DOWN_LEFT)
    elseif btn(BUTTON_UP) and btn(BUTTON_RIGHT) then
        movePlayer(playerA,  PLAYER_SPEED, -PLAYER_SPEED, DIR_UP_RIGHT)
        movePlayer(playerB,  PLAYER_SPEED,  PLAYER_SPEED, DIR_DOWN_RIGHT)
    elseif btn(BUTTON_DOWN) and btn(BUTTON_LEFT) then
        movePlayer(playerA, -PLAYER_SPEED,  PLAYER_SPEED, DIR_DOWN_LEFT)
        movePlayer(playerB, -PLAYER_SPEED, -PLAYER_SPEED, DIR_UP_LEFT)
    elseif btn(BUTTON_DOWN) and btn(BUTTON_RIGHT) then
        movePlayer(playerA,  PLAYER_SPEED,  PLAYER_SPEED, DIR_DOWN_RIGHT)
        movePlayer(playerB,  PLAYER_SPEED, -PLAYER_SPEED, DIR_UP_RIGHT)
    elseif btn(BUTTON_UP) then
        movePlayer(playerA,             0, -PLAYER_SPEED, DIR_UP)
        movePlayer(playerB,             0,  PLAYER_SPEED, DIR_DOWN)
    elseif btn(BUTTON_DOWN) then
        movePlayer(playerA,             0,  PLAYER_SPEED, DIR_DOWN)
        movePlayer(playerB,             0, -PLAYER_SPEED, DIR_UP)
    elseif btn(BUTTON_LEFT) then
        movePlayer(playerA, -PLAYER_SPEED,             0, DIR_LEFT)
        movePlayer(playerB, -PLAYER_SPEED,             0, DIR_LEFT)
    elseif btn(BUTTON_RIGHT) then
        movePlayer(playerA,  PLAYER_SPEED,             0, DIR_RIGHT)
        movePlayer(playerB,  PLAYER_SPEED,             0, DIR_RIGHT)
    end
    playerA.tileX = math.floor(playerA.x/8)
    playerA.tileY = math.floor(playerA.y/8)
    playerB.tileX = math.floor(playerB.x/8)
    playerB.tileY = math.floor(playerB.y/8)
end

function movePlayer(player, dx, dy, dir)
    entity = player
    if inarray(dir, {DIR_LEFT, DIR_RIGHT}) and not is_entity_next_to_solid(entity, dir) then
        entity.x = entity.x + dx
    elseif inarray(dir, {DIR_UP, DIR_DOWN}) and not is_entity_next_to_solid(entity, dir) then
        entity.y = entity.y + dy
    else
        for diag, diagpart in pairs({[DIR_UP_RIGHT]=  {DIR_UP,   DIR_RIGHT},
                                     [DIR_UP_LEFT]=   {DIR_UP,   DIR_LEFT},
                                     [DIR_DOWN_RIGHT]={DIR_DOWN, DIR_RIGHT},
                                     [DIR_DOWN_LEFT]= {DIR_DOWN, DIR_LEFT}}) do
            if dir == diag then
            if not is_entity_next_to_solid(entity, diagpart[1]) then
                entity.y = entity.y + dy
            end
            if not is_entity_next_to_solid(entity, diagpart[2]) then
                entity.x = entity.x + dx
            end
            break
            end
        end
    end
end

function is_entity_next_to_solid(entity, dir)
  return is_entity_by_solid(entity, dir, entity.speed)
end

function is_entity_by_solid(entity, dir, margin)
    if dir == DIR_LEFT then
        left  = is_solid(entity.x - margin,     entity.y)
             or is_solid(entity.x - margin,     entity.y + 7)
        return left
    elseif dir == DIR_RIGHT then
        right = is_solid(entity.x + 7 + margin, entity.y)
             or is_solid(entity.x + 7 + margin, entity.y + 7)
        return right
    elseif dir == DIR_UP then
        up    = is_solid(entity.x,              entity.y - margin)
             or is_solid(entity.x + 7,          entity.y - margin)
        return up
    elseif dir == DIR_DOWN then
        down  = is_solid(entity.x,              entity.y + 7 + margin)
             or is_solid(entity.x + 7,          entity.y + 7 + margin)
        return down
    end
end

-- check if pixel coordinate is solid
function is_solid(x, y)
  local tile_x = math.floor(x/8)
  local tile_y = math.floor(y/8)
  return is_tile_solid(tile_x, tile_y)
end

function is_tile_solid(tileX, tileY)
    tile_id = mget(tileX, tileY)
    if fget(tile_id, SOLID) then
        return true
    elseif fget(tile_id, DEADLY) then
        game_over()
    else
        return false
    end
end

function game_over()
    trace("GAME OVER!")
    state = STATE_GAME_OVER
end

function print_centered(string, y, color, fixed, scale, smallfont)
        y = y or 0
        color = color or 15
        fixed = fixed or false
        scale = scale or 1
        smallfont = smallfont or false
        local string_width = print(string, -100, -100, color, fixed, scale, smallfont)
        return print(string, (WIDTH-string_width)//2, y, color, fixed, scale, smallfont)
end

-- <TILES>
-- 001:ccccccccc2222222c2222222c2222222c2222222c2222222c2222222c222222c
-- 002:cccccccc2222222c2222222c2222222c2222222c2222222c2222222cc222222c
-- 003:9999999999a999999aa999999aa99aa99aa9aaa99999aaa99999aa9999999999
-- 016:ccccccccffcffffffcffffffcfffffffffffcffcffffffcffffffcffcccccccc
-- 017:c222222cc2222222c2222222c2222222c2222222c2222222c2222222cccccccc
-- 018:c222222c2222222c2222222c2222222c2222222c2222222c2222222ccccccccc
-- 032:2222222222222222222222222222222222222222222222222222222222222222
-- 033:c222222cc222222cc222222cc222222cc222222cc222222cc222222cc222222c
-- 034:cccccccc222222222222222222222222222222222222222222222222cccccccc
-- </TILES>

-- <SPRITES>
-- 000:002c2200002c2200222c2222cccccccc222c2222222c2222022c22200cc00cc0
-- 019:00ffef000fefefe0ef4444f00e4e4e40044a4a40044433400442244000444400
-- 032:00004444000044440000444400004444000044440000444f000044443333333f
-- 033:4444000044440000444400004444000044440000f444000044440000fcfc3333
-- 035:0ffc9cf0fffe9efffffe9efffffefeff4ffffff40ffffff00ff00ff022200222
-- 048:0000000000000000000000000000000000000000000000000000000400000044
-- 049:0000000000000000000000000000000000000000000000000000300040003000
-- 064:0000444400444444004444440004444f000444f400004444000044ff333333ff
-- 065:4403000044f30f0044ffff004ff2f2f04ffffff0ffff1ff0ffffff00fffc0fc0
-- </SPRITES>

-- <MAP>
-- 000:102222222222222222222202222222222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:120000000030300000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:120000000030300000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:120000000030300000002202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:120000000030300000003030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:120000000030300000003030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:120101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:120000000000000000001020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:120000000000000000001121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:120000000030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:120000000030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:120000000030300000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:120000000030300000001212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:120000000030300000121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:112222222222222222222222222222222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 003:011223469bcddeeffeeddcb964322110
-- 004:3b0e294c31e4b0250d82f85e0f2d14a6
-- 005:021436587a9cbedfefcdab8967452301
-- 006:0134455689bccddefeedba8776653200
-- 007:12121246accdcdefffedcbb975321010
-- 008:0001122345678acf0001122345678acf
-- 009:000112234579ba86000112234579ba86
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- 001:010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100300000000000
-- 002:020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200300000000000
-- 003:030003000300030003000300030003000300030003000300030003000300030003000300030003000300030003000300030003000300030003000300304000000000
-- 004:040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400300000000000
-- 005:050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500300000000000
-- 006:060006000600060006000600060006000600060006000600060006000600060006000600060006000600060006000600060006000600060006000600302000000000
-- 007:070007000700070007000700070007000700070007000700070007000700070007000700070007000700070007000700070007000700070007000700204000000000
-- 008:080008000800080008000800080008000800080008000800080008000800080008000800080008000800080008000800080008000800080008000800200000000000
-- 009:090009000900090009000900090009000900090009000900090009000900090009000900090009000900090009000900090009000900090009000900302000000000
-- 016:030003200340037003000320034003700300032003400370030003200340037003000320034003700300032003400370030003200340037003000370400000000000
-- 017:070007000700070007200720072007200740074007400740077007700770077007000700070007000720072007400740074007400770077007700770405000000000
-- </SFX>

-- <FLAGS>
-- 000:00101020000000000000000000000000101010000000000000000000000000001010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </FLAGS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

