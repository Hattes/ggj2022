-- title:  The Boring World of Niels Bohr
-- author: Torakko, Hattes, sfabian
-- desc:   Help Niels to survive in the boring world! Game made for Global Game Jam 2022.
-- script: lua


music(00)

------ CONSTANTS ----------
-- size
HEIGHT = 136
WIDTH = 240
TILE_SIZE = 8
TILE_HEIGHT = 77 -- 136 / 8
TILE_WIDTH = 30 -- 240 / 8
CAMERA_MAX = 1680 -- map_width - screen_width -> 240*8 - 30*8 = 1680

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
TILE_SOLID = 0
TILE_DEADLY = 1
TILE_WINNING = 2

-- player states
PLAYER_STATE_STAND = 1
PLAYER_STATE_MOVE = 2
PLAYER_WEAPON_STATE_FIRE_NO = 1
PLAYER_WEAPON_STATE_FIRE_WAVE = 2
PLAYER_WEAPON_STATE_FIRE_PARTICLE = 3

-- sprites
SPRITE_DANSK = 256
SPRITE_CAT_CLOSED = 272
SPRITE_CAT_OPEN = 304
SPRITE_BOHR = 275
SPRITE_BIRD1 = 306
SPRITE_BIRD2 = 307
SPRITE_RADIATION_1 = 352
SPRITE_RADIATION_2 = 353
SPRITE_HEART = 368

SPRITE_BOHR_HEAD = 275
SPRITE_BOHR_BODY = {
    [PLAYER_STATE_STAND] = {
        [PLAYER_WEAPON_STATE_FIRE_NO] = {{sprite=291}},
        [PLAYER_WEAPON_STATE_FIRE_PARTICLE] = {{sprite=308, width=2}},
        [PLAYER_WEAPON_STATE_FIRE_WAVE] = {{sprite=292, width=2}}
    },
    [PLAYER_STATE_MOVE] = {
        [PLAYER_WEAPON_STATE_FIRE_NO] = {{sprite=294, width=3, width_offset=-8},
                                         {sprite=310, width=3, width_offset=-8}},
        [PLAYER_WEAPON_STATE_FIRE_PARTICLE] = {{sprite=298}, {sprite=314}},
        [PLAYER_WEAPON_STATE_FIRE_WAVE] = {{sprite=297}, {sprite=313}}
    }
}

-- sound effects

SFX_HURT = 48

-- directions
DIR_UP = 1
DIR_DOWN = 2
DIR_LEFT = 3
DIR_RIGHT = 4
DIR_DOWN_LEFT = 5
DIR_DOWN_RIGHT = 6
DIR_UP_LEFT = 7
DIR_UP_RIGHT = 8

-- game states
STATE_MENU = 1
STATE_GAME = 2
STATE_GAME_OVER = 3
STATE_GAME_STARTING = 4
STATE_VICTORY = 5

-- other
PLAYER_SPEED = 1
VICTORY_WAIT_FRAMES = 300
FIRE_PARTICLE = 1
FIRE_WAVE = 2
PARTICLE_SHOOT_INTERVAL = 60
PARTICLE_SPEED = 2
BIRD_SPAWN_RATE = 60
NUM_RADIATION_PARTICLES = 256
MAX_HEALTH = 5
PLAYER_ANIMATION_MOVE_SPEED = 0.1

------ GLOBAL VARIABLES ----------
t=0
victory_time=0
state = STATE_MENU

------ UTILITIES ------
function add(list, elem)
    list[#list+1] = elem
end

function del(list, elem)
    local found = false
    for i=1, #list do
        if found then
            list[i-1] = list[i]
        end

        if list[i] == elem then
            found = true
        end
    end
    if found then
        list[#list] = nil
    end
end

function print_centered(string, y, color, fixed, scale, smallfont)
    y = y or 0
    color = color or DARK_GREY
    fixed = fixed or false
    scale = scale or 1
    smallfont = smallfont or false
    local string_width = print(string, -100, -100, color, fixed, scale, smallfont)
    print(string, (WIDTH-string_width)//2, y, color, fixed, scale, smallfont)
end

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
    elseif state == STATE_VICTORY then
        update_victory()
        draw_victory()
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
    spr(SPRITE_BOHR,0,40,BLACK,6,0,0,1,2)
    spr(SPRITE_BOHR,192,40,BLACK,6,1,0,1,2)
    spr(SPRITE_CAT_OPEN,64,88,BLACK,3,0,0,2,2)
    spr(SPRITE_CAT_CLOSED,128,88,BLACK,3,1,0,2,2)
    print_centered("The Boring World", 10, ORANGE, false, 2)
    print_centered("of Niels Bohr", 30, ORANGE, false, 2)
    print_centered("Based on a true story", 50, ORANGE)
    print_centered("Press Z to start", 75, ORANGE)
end

function restart()
    -- This is where we set state of players etc. to their initial values
    enemies_cat = {}
    enemies_bird = {}
    playerA = {
        x=8,
        y=8,
        tileX=2,
        tileY=1,
        speed=PLAYER_SPEED,
        particle_timer=0,
        fire_mode=FIRE_PARTICLE,
        firing=false,
        begin_firing=false,
        health=MAX_HEALTH,
        bbox=bounding_box({}),
        iframes=0,
        weapon_state=PLAYER_WEAPON_STATE_FIRE_NO,
        move_state=PLAYER_STATE_STAND,
        spr_counter = 0,
        iframes_max=60,
        sfxs={hurt=SFX_HURT},
        dead=false,
    }
    playerB = {
        x=8,
        y=HEIGHT-16,
        tileX=1,
        tileY=TILE_HEIGHT - 2,
        speed=PLAYER_SPEED,
        particle_timer=0,
        fire_mode=FIRE_WAVE,
        firing=false,
        begin_firing=false,
        health=MAX_HEALTH,
        bbox=bounding_box({}),
        iframes=0,
        weapon_state=PLAYER_WEAPON_STATE_FIRE_NO,
        move_state=PLAYER_STATE_STAND,
        spr_counter = 0,
        iframes_max=60,
        sfxs={hurt=SFX_HURT},
        dead=false,
    }
    state = STATE_GAME
    cam = {x=0,y=0}
    particles = {}
    spawn_cat(16,14)
    spawn_cat(28,2)
    wave = {x=0,y=0,firing=false}
    radiation_x = -10
    radiation_particles = {}
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

function update_victory()
    if t > victory_time + VICTORY_WAIT_FRAMES then
        state = STATE_MENU
    end
end

function draw_victory()
    cls(BLACK)
    print_centered("VICTORY :)", 30, GRAY, false, 3)
    print_centered("Niels escaped from the boring world",72)
end

function update_game()
    update_players()
    update_enemies()
    update_camera()
    if t % BIRD_SPAWN_RATE == 0 then
        spawn_bird()
    end
    update_radiation()
end

function draw_game()
    draw_map()
    draw_bohr(playerA)
    draw_separator()
    draw_enemies()
    draw_bohr(playerB)
    draw_particles()
    draw_wave()
    draw_radiation()
    draw_health()
end

function draw_separator()
    draw_a_wave(160, 4, 20, YELLOW, 1, 1)
    draw_a_wave(240, 1, 60, CYAN, 3, 1.2)
    draw_a_wave(120, 2, 180, BLUE, 2, 1.4)
    draw_a_wave(80, 3, 120, RED, 1, 1.6)
end

function draw_a_wave(samples, amp, freq, color, offset_factor, freq_factor)
    local center = HEIGHT / 2

    local i_f = 240/freq
    local wave_dx = 240/samples
    y_offs = math.sin(math.pi * (t % 60 * offset_factor) / (60 * offset_factor)) * 2 - 1
    sine_x = t * freq_factor
    for x=240, 0, -wave_dx do
        line(x,         center-math.sin((sine_x)   /i_f)*amp + y_offs,
             x+wave_dx, center-math.sin((sine_x+wave_dx)/i_f)*amp + y_offs,
             color)
        sine_x = sine_x - wave_dx
    end
end

function draw_health()
    draw_health_for_player(playerA, 1)
    draw_health_for_player(playerB, 129)
end

function draw_health_for_player(player, y)
    for i = 1, player.health do
        spr(SPRITE_HEART, WIDTH + (i - 1) * 9 - MAX_HEALTH * 9, y, BLACK)
    end
end

function draw_map()
    cls(LIGHT_GREY)
    local tile_x=math.floor(cam.x/8 -1)
    local tile_y=cam.y/8 -1
    local x_offset = -cam.x%8-8
    if cam.x % 8 ~= 0 then
        x_offset = x_offset - 8
    end
    local y_offset = -cam.y%8-8
    map(tile_x,tile_y,
        32,18,
        x_offset, y_offset)
end

function draw_bohr(player)
    if math.fmod(player.iframes, 2) == 1 then
        return
    end
    -- draw head
    spr(SPRITE_BOHR_HEAD,
        player.x-cam.x,
        player.y-cam.y-8, -- saved position is feet but we need to use position for head
        BLACK,
        1,
        0,
        0,
        1,
        1)
    --draw body
    local body_datas = SPRITE_BOHR_BODY[player.move_state][player.weapon_state]
    local body_data = body_datas[math.floor(player.spr_counter) % #body_datas + 1]
    local width_offset = body_data.width_offset or 0
    local width = body_data.width or 1
    spr(body_data.sprite,
        player.x-cam.x+width_offset,
        player.y-cam.y,
        BLACK,
        1,
        0,
        0,
        width,
        1)
end

function update_radiation()
    radiation_x = radiation_x + 0.1
    j = 1
    for i = 1, #radiation_particles do
        radiation_particles[j].x = radiation_particles[j].x + radiation_particles[j].speed_x
        radiation_particles[j].y = radiation_particles[j].y + radiation_particles[j].speed_y
        if radiation_particles[j].x > radiation_particles[j].end_x then
            del(radiation_particles, radiation_particles[j])
            j = j - 1
        end
        j = j + 1
    end
    while #radiation_particles < NUM_RADIATION_PARTICLES do
        add(radiation_particles, new_radiation_particle())
    end
end

function new_radiation_particle()
    local y = math.random() * HEIGHT
    local end_y = math.min(math.max(y + math.random() * 50 - 25, 0), HEIGHT)
    return {
        x=radiation_x,
        y=y,
        end_x=radiation_x + 32,
        end_y=end_y,
        speed_x=math.random() * 32 / 60,
        speed_y=(end_y - y) / 60,
        color=math.floor(math.random() * 16),
    }
end

function draw_radiation()
    spr(SPRITE_RADIATION_2, radiation_x - HEIGHT - cam.x, cam.y, BLACK, 17, 0, 0, 1, 1)
    spr(SPRITE_RADIATION_1, radiation_x - HEIGHT - cam.x - 2, cam.y, BLACK, 17, 0, 0, 1, 1)

    for i = 1, NUM_RADIATION_PARTICLES do
        rect(
            radiation_particles[i].x-cam.x,
            radiation_particles[i].y-cam.y,
            1,
            1,
            radiation_particles[i].color
        )
    end
end

function draw_particles()
    for _, particle in ipairs(particles) do
        rect(particle.x-cam.x,
             particle.y-cam.y,
             2,
             2,
             RED)
    end
end

function draw_wave()
    if not wave.firing then
        return
    end
    local samples = 240
    local amp = 6
    local freq = 120
    local center = wave.y

    local i_f = 240/freq
    local wave_dx = 240/samples
    sine_x = 0 - t % 240
    for x=240, wave.x-cam.x, -wave_dx do
        line(x,         center-math.sin((sine_x)   /i_f)*amp,
             x+wave_dx, center-math.sin((sine_x+wave_dx)/i_f)*amp,
             7)
        sine_x = sine_x - wave_dx
    end
end

function update_players()
    handle_input()
    update_weapons()

    check_radiation_collision(playerA)
    check_radiation_collision(playerB)

    update_iframes(playerA)
    update_iframes(playerB)
    if playerA.dead then
        game_over()
    end
    if playerB.dead then
        game_over()
    end

    playerA.spr_counter = playerA.spr_counter + PLAYER_ANIMATION_MOVE_SPEED
    playerB.spr_counter = playerB.spr_counter + PLAYER_ANIMATION_MOVE_SPEED
end

function update_iframes(entity)
    entity.iframes = math.max(entity.iframes - 1, 0)
end

function check_radiation_collision(player)
    if player.x < radiation_x then
        kill_entity(player)
    end
end

function kill_entity(entity)
    -- TODO: Add death animation
    entity.dead = true
end

function update_weapons()
    for _, player in ipairs({playerA, playerB}) do
        if player.firing then
            if player.fire_mode == FIRE_PARTICLE then
                player.weapon_state = PLAYER_WEAPON_STATE_FIRE_PARTICLE
                if player.particle_timer == 0 then
                    shoot_particle(player.x, player.y)
                    player.particle_timer = PARTICLE_SHOOT_INTERVAL
                end
            elseif player.fire_mode == FIRE_WAVE then
                player.weapon_state = PLAYER_WEAPON_STATE_FIRE_WAVE
                wave.firing = true
                wave.x = player.x + 8
                wave.y = player.y
            end
        else
            player.weapon_state = PLAYER_WEAPON_STATE_FIRE_NO
            wave.firing = false
        end
    player.particle_timer = math.max(0, player.particle_timer-1) -- count down once each frame
    end
    for _, particle in ipairs(particles) do
        particle.x = particle.x + PARTICLE_SPEED
    end
end

function shoot_particle(playerX, playerY)
    x = playerX + 8
    y = playerY + 4
    particles[#particles+1] = {x=x,y=y, bbox=bounding_box({})}
end

function handle_input()
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
    else
        playerA.move_state = PLAYER_STATE_STAND
        playerB.move_state = PLAYER_STATE_STAND
    end
    playerA.tileX = math.floor(playerA.x/8)
    playerA.tileY = math.floor(playerA.y/8)
    playerB.tileX = math.floor(playerB.x/8)
    playerB.tileY = math.floor(playerB.y/8)
    for _, player in ipairs({playerA, playerB}) do
        if btnp(BUTTON_Z) then
            player.begin_firing = true  -- to avoid firing right after starting the level
        end
        if player.begin_firing and btn(BUTTON_Z) then
            player.firing = true
        else
            player.firing = false
        end
    end
    -- Switch weapon fire mode
    if btnp(BUTTON_X) then
        temp = playerA.fire_mode
        playerA.fire_mode = playerB.fire_mode
        playerB.fire_mode = temp
    end
    check_tile_effects(playerA)
    check_tile_effects(playerB)
end

function update_camera()
    local player_midpoint = (playerA.x + playerB.x) / 2
    local cam_x_min = math.max(120, player_midpoint) - 120
    cam.x = math.min(cam_x_min, CAMERA_MAX)
end

function movePlayer(player, dx, dy, dir)
    entity = player
    player.move_state = PLAYER_STATE_MOVE
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
    return fget(tile_id, TILE_SOLID)
end

function check_tile_effects(player)
    tile_id = mget(player.tileX, player.tileY)
    if fget(tile_id, TILE_DEADLY) then
        hurt_entity(player)
    elseif fget(tile_id, TILE_WINNING) then
        victory()
    end
end

function hurt_entity(entity)
    if entity.iframes > 0 then
        return
    end

    entity.iframes = entity.iframes_max
    sfx(SFX_HURT)
    entity.health = entity.health - 1

    if entity.health == 0 then
        kill_entity(entity)
    end
end

function victory()
    trace("VICTORY!")
    state = STATE_VICTORY
    victory_time = t
end

function game_over()
    trace("GAME OVER!")
    state = STATE_GAME_OVER
end

function spawn_cat(tile_x,tile_y)
    local new_cat = {
        sprite=SPRITE_CAT_CLOSED,
        x=tile_x*8,
        y=tile_y*8,
        tileX=tile_x,
        tileY=tile_y,
        speed=PLAYER_SPEED,
        flip=1,
        tile_width=2,
        tile_height=2,
        bbox=bounding_box({}),
        health=2,
        sfxs={hurt=SFX_HURT},
        dead=false,
        iframes=0,
        iframes_max=30,
    }
    enemies_cat[#enemies_cat+1]=new_cat
end

-- birds are spawned at random tile to the right of the screen
function spawn_bird()
    local x = cam.x + WIDTH
    local tile_y = math.random(15)
    local new_bird = {
        sprite=SPRITE_BIRD1,
        x=x,
        y=tile_y*8,
        tileX=x//8,
        tileY=tile_y,
        speed=PLAYER_SPEED,
        flip=1,
        tile_width=1,
        tile_height=1,
        bbox=bounding_box({}),
        health=1,
        sfxs={hurt=SFX_HURT},
        dead=false,
        iframes=0,
        iframes_max=30,
    }
    enemies_bird[#enemies_bird+1]=new_bird
end

function draw_enemies()
  for _, cat in ipairs(enemies_cat) do
      draw_enemy(cat)
  end
  for _, bird in ipairs(enemies_bird) do
      draw_enemy(bird)
  end
end

function draw_enemy(enemy)
    if math.fmod(enemy.iframes, 2) == 1 then
        return
    end
    spr(enemy.sprite,
        enemy.x-cam.x,
        enemy.y-cam.y,
        BLACK,
        1,
        enemy.flip,
        0,
        enemy.tile_width,
        enemy.tile_height)
end

function update_enemies()
  for id, cat in ipairs(enemies_cat) do
      update_cat(cat, id)
  end
  for id, bird in ipairs(enemies_bird) do
      update_bird(bird, id)
  end
end

function check_weapon_collision(enemy)
    enemy_bbox = abs_bbox(enemy)
    for _, particle in ipairs(particles) do
        if entity_collision(enemy, particle) then
            hurt_entity(enemy)
        end
    end
    wave_bbox = {x_min=wave.x, x_max=240+cam.x, y_min=wave.y-3, y_max=wave.y+3}
    if intersect(wave.x, 240+cam.x, wave.y-3, wave.y+3,
                 enemy_bbox.nw.x, enemy_bbox.ne.x, enemy_bbox.nw.y, enemy_bbox.sw.y) then
        hurt_entity(enemy)
    end
end

function update_cat(cat, id)
    -- TODO: Something better for the cats to do...
    if t % 60 == 0 then
        if cat.sprite == SPRITE_CAT_CLOSED then
            cat.sprite = SPRITE_CAT_OPEN
        else
            cat.sprite = SPRITE_CAT_CLOSED
        end
    end
    check_weapon_collision(cat)
    if cat.dead then
        del(enemies_cat, cat)
    end
    update_iframes(cat)
end

-- generic collision box relative to upper left pixel
function bounding_box(values_table)
  setmetatable(values_table,{__index={x_min=1, x_max=6, y_min=1, y_max=6}})
  local x_min, x_max, y_min, y_max =
     values_table[1] or values_table.x_min,
     values_table[2] or values_table.x_max,
     values_table[3] or values_table.y_min,
     values_table[4] or values_table.y_max
  return {x_min=x_min, x_max=x_max, y_min=y_min, y_max=y_max}
end

function intersect(x1a,x1b,y1a,y1b, x2a,x2b,y2a,y2b)
    return x1a < x2b and
           x2a < x1b and
           y1a < y2b and
           y2a < y1b
end

function entity_collision(this, that)
  local this_bbox = abs_bbox(this)
  local that_bbox = abs_bbox(that)
  return intersect(this_bbox.nw.x, this_bbox.ne.x, this_bbox.nw.y, this_bbox.sw.y,
                   that_bbox.nw.x, that_bbox.ne.x, that_bbox.nw.y, that_bbox.sw.y)
end

-- Bounding box in absolute coordinates
function abs_bbox(entity)
  -- Corners are named north-west, north-east, etc.
  return {nw={x=math.floor(entity.x + entity.bbox.x_min + 0.5), y=math.floor(entity.y + entity.bbox.y_min + 0.5)},
          ne={x=math.floor(entity.x + entity.bbox.x_max + 0.5), y=math.floor(entity.y + entity.bbox.y_min + 0.5)},
          sw={x=math.floor(entity.x + entity.bbox.x_min + 0.5), y=math.floor(entity.y + entity.bbox.y_max + 0.5)},
          se={x=math.floor(entity.x + entity.bbox.x_max + 0.5), y=math.floor(entity.y + entity.bbox.y_max + 0.5)}}
end
function update_bird(bird, id)
    -- TODO: Something better for the birds to do...
    if t % 20 == 0 then
        if bird.sprite == SPRITE_BIRD1 then
            bird.sprite = SPRITE_BIRD2
        else
            bird.sprite = SPRITE_BIRD1
        end
    end
    bird.x = bird.x-1
    if bird.x < cam.x then
        del(enemies_bird, bird)
    end
    check_weapon_collision(bird)
    if bird.dead then
        del(enemies_bird, bird)
    end
    update_iframes(bird)
end

-- <TILES>
-- 003:9999999999a999999a9a9999999999999999999999999a999999a9a999999999
-- 004:4444444444444444444444444444444444444444444444444444444444444444
-- 016:00000000eeeeeeeeddddddddccccccccccccccccddddddddeeeeeeee00000000
-- 048:fffffffffdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfddddddd
-- 049:ffffffffdddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 050:ffffffffdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddf
-- 051:fffffffffddddddffddddddffddddddffddddddffddddddffddddddffddddddf
-- 052:ffffffffdddddddddddddddddddddddddddddddedddddddedddddddfdddddddf
-- 053:ffffffffddddddddddddddddddddddddedddddddedddddddfdddddddfddddddd
-- 054:dddddddddddddddddddddddddddddddddddddddedddddddedddddddfdddddddf
-- 055:ddddddddddddddddddddddddddddddddedddddddedddddddfdddddddfddddddd
-- 064:fdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfddddddd
-- 065:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 066:dddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddf
-- 067:fddddddffddddddffddddddffddddddffddddddffddddddffddddddffddddddf
-- 068:fffffffffdddddddfdddddddfdddddddfddddddefddddddefddddddffddddddf
-- 069:ffffffffdddddddfdddddddfdddddddfeddddddfeddddddffddddddffddddddf
-- 070:dddddddfdddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 071:fddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 080:fdddddddfdddddddfdddddddfdddddddfeeeeeeefeeeeeeeffffffffffffffff
-- 081:ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeffffffffffffffff
-- 082:dddddddfdddddddfdddddddfdddddddfeeeeeeefeeeeeeefffffffffffffffff
-- 083:fddddddffddddddffddddddffddddddffeeeeeeffeeeeeefffffffffffffffff
-- 084:fddddddffdddddddfdddddddfdddddddfeeeeeeefeeeeeeeffffffffffffffff
-- 085:fddddddfdddddddfdddddddfdddddddfeeeeeeefeeeeeeefffffffffffffffff
-- 096:fffffffffdddddddfdddddddfdddddddfeeeeeeefeeeeeeeffffffffffffffff
-- 097:ffffffffddddddddddddddddddddddddeeeeeeeeeeeeeeeeffffffffffffffff
-- 098:ffffffffdddddddfdddddddfdddddddfeeeeeeefeeeeeeefffffffffffffffff
-- 099:fffffffffddddddffddddddffddddddffeeeeeeffeeeeeefffffffffffffffff
-- 100:dddddddfddddddddddddddddddddddddeeeeeeeeeeeeeeeeffffffffffffffff
-- 101:fdddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeffffffffffffffff
-- </TILES>

-- <SPRITES>
-- 000:002c2200002c2200222c2222cccccccc222c2222222c2222022c22200cc00cc0
-- 004:000000000000aaa0000aaaa0000aaa9000aa99000aa900000a9a000000090000
-- 005:0000200000002200000022200002211100221000022100000212000000010000
-- 019:00ffef000fefefe0ef4444f00e4e4e40044a4a40044433400442244000444400
-- 032:00004444000044440000444400004444000044440000444f000044443333333f
-- 033:4444000044440000444400004444000044440000f444000044440000fcfc3333
-- 035:0ffc9cf0fffe9efffffe9efffffefeff4ffffff40ffffff00ff00ff022200222
-- 036:0ffc9cf0fffe9eff0fff9aaa0ffff4940fffff900ffffff00ff00ff022200222
-- 037:000000000aa00000aaaa00009aa9000009900000000000000000000000000000
-- 039:0ffc9cf0fffe9efffffe9eff0ffffff00fff4ff00ffffff20ff0002022200000
-- 040:0000000000000000000000000000000020000000000000000000000000000000
-- 041:0ffc9cf0fffe9eff0fff9aaa0ffff4940fffff900ffffff20ff0002022200000
-- 042:0ffc9cf0fffe9eff0fff92220ffff4140fffff100ffffff20ff0002022200000
-- 048:0000000000000000000000000000000000000000000000000000000400000044
-- 049:0000000000000000000000000000000000000000000000000000300040003000
-- 050:0000800000008800000088000008888008888884000000000000000000000000
-- 051:0000000000000000000888800888888400088800000880000000800000000000
-- 052:0ffc9cf0fffe9eff0fff92220ffff4140fffff100ffffff00ff00ff022200222
-- 053:0020000002200000222000000120000000100000000000000000000000000000
-- 054:0000000000000000000000000000000400000000000000000000000000000000
-- 055:0ffc9cf0fffe9efffffe9efffffefef002fffff002fffff000200ff000000222
-- 056:0000000004000000f00000000000000000000000000000000000000000000000
-- 057:0ffc9cf0fffe9eff0fff9aaa0ffff49402ffff9002fffff000200ff000000222
-- 058:0ffc9cf0fffe9eff0fff92220ffff41402ffff1002fffff000200ff000000222
-- 064:0000444400444444004444440004444f000444f400004444000044ff333333ff
-- 065:4403000044f30f0044ffff004ff2f2f04ffffff0ffff1ff0ffffff00fffc0fc0
-- 096:6666666666666666666666666666666666666666666666666666666666666666
-- 097:7777777777777777777777777777777777777777777777777777777777777777
-- 112:02c0220022c22220ccccccc002c2220000c22000000200000000000000000000
-- </SPRITES>

-- <MAP>
-- 000:631515151515157363151515151515151515151515151515151515151515157363151515151515151515157363151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151573
-- 001:240000000000000424000000000000000000003030000000000000000000000424000000000000000000000424000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 002:240000000000000424000000000000000000003030000000000000000000000424000000000000000000000424000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 003:240000000000000424000000000000000000003030000000000000000000000424000000000000000000000424000000000313131313230000000003131313132300000000031313131323000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 004:240000000000000525000000000323000000003030000000000323000000000525000000000323000000000525000000000414141414240000000004141414142400000000041414141424000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 005:240000000000000000000000000424000000000000000000000424000000000000000000000424000000000000000000000515151515250000000005151515152500000000051515151525000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 006:240000000000000000000000000424000000000000000000000424000000000000000000000424000000000000000000003030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 007:240000000000000000000000000424000000000000000000000424000000000000000000000525000000000000000000003030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 008:240101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 009:240000000000000000000000000424000000000000000000003030000000000000000000000000000000000000000000000000000000000000000000000000000000000000303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 010:240000000000000000000000000424000000000000000000003030000000000000000000000000000000000000000000000000000000000000000000000000000000000000303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 011:240000000000000000000000000424000000000000000000003030000000000000000000000000000000000000000000000313131313230000000003131313132300000000031313131323000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 012:240000000000000323000000000525000000003030000000003030000000000313131313131313131313131323000000000414141414240000000004141414142400000000041414141424000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 013:240000000000000424000000000000000000003030000000000000000000000414141414141414141414141424000000000515151515250000000005151515152500000000051515151525000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 014:240000000000000424000000000000000000003030000000000000000000000414141414141414141414141424000000000000000000000000000030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 015:240000000000000424000000000000000000003030000000000000000000000414141414141414141414141424000000000000000000000000000030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004004
-- 016:641313131313137464131313131313131313131313131313131313131313137414141414141414141414141464131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131374
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
-- 000:100000001000200030004000500060006000600070007000800080009000900090009000900090009000900090009000900090009000900090009000307000f40000
-- 001:110001001100210031004100510061006100610071007100810081009100910091009100910091009100910091009100910091009100910091009100304000f40000
-- 002:120002001200220032004200520062006200620072007200820082009200920092009200920092009200920092009200920092009200920092009200307000f40000
-- 003:130003001300230033004300530063006300630073007300830083009300930093009300930093009300930093009300930093009300930093009300209000f40000
-- 004:20590038200a500c9000e000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000004000000304
-- 005:150005001500250035004500550065006500650075007500850085009500950095009500950095009500950095009500950095009500950095009500304000f40000
-- 006:160006001600260036004600560066006600660076007600860086009600960096009600960096009600960096009600960096009600960096009600300000f40000
-- 007:170007001700270037004700570067006700670077007700870087009700970097009700970097009700970097009700970097009700970097009700304000f40000
-- 008:38002800380048005800580068006800780078008800880098009800a800a800a800a800a800a800a800a800a800a800a800a800a800a800a800a800307000f40000
-- 009:190009001900290039004900590069006900690079007900890089009900990099009900990099009900990099009900990099009900990099009900307000f40000
-- 012:24590438240a540c9400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400204000000304
-- 013:44597438c40af40cf400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400205000000304
-- 016:030003200340037003000320034003700300032003400370030003200340037003000320034003700300032003400370030003200340037003000370405000000f00
-- 017:07000700070007000720072007200740074007400740077007700770077007000700070007000720072007200740074007400740077007700770077050b000000f00
-- 018:01000100012001200140014001700170010001000100010001000100010001000100010001000100010001000100010001000100010001000100010030b000000800
-- 019:010001000110011001400140017001700100010001000100010001000100010001000100010001000100010001000100010001000100010001000100407000000800
-- 020:000000000070007000e000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040b000000600
-- 021:000010002020402060708070a0e0d0e0f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f00040b000000800
-- 022:000010002010401060708070a0f0d0f0f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f00030b000000800
-- 034:0200120032007200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200307000000000
-- 035:03000300230043007300a300d300e300e300e300e300e300e300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300307000000000
-- 039:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000305000000000
-- 048:440324050406040604070407040614043402540e640d740b840aa40ab409c408d408e408e408e408f408f408f408f408f408f408f408f408f408f408200000000000
-- </SFX>

-- <PATTERNS>
-- 000:800034000000000000000000000000000000000830000830000030000830000030000000000000000000000830000830800034000000000000000830800034000000000000000000000000000000000000000000000000000000000000000000600034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400034000000000000000000000000000000000000000000f00032000000000000000000000000000000000000000000
-- 001:f00034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f00034000000000000000000f00034000000000000000000000000000000000000000000000000000000000000000000d00034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b00034000000000000000000000000000000000000000000a00034000000000000000000000000000000000000000000
-- 002:8fc168000000b00068000000b00068000000d00068000000d00068000000f0006800000060006a00000080006a000000800068000000b00068000000b00068000000d00068000000d00068000000f0006800000060006a00000080006a000000000000000000000000000000a0006a00000060006a000000d0006800000000000000000000000000000000000000000080006a00000040006a000000b0006800000000000000000070006a000000f00068000000a00068000000000000000000
-- 003:0ad100800058000000b00058000000b00058000000d00058000000d00058000000f0005800000060005a00000080005a000000800058000000b00058000000b00058000000d00058000000d00058000000f0005800000060005a00000080005a000000000000000000000000000000a0005a00000060005a000000d0005800000000000000000000000000000000000000000080005a00000040005a000000b0005800000000000000000070005a000000f00058000000a00058000000000000
-- 004:b00034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400036000000000000000000000000000000000000000000f00034000000000000000000000000000000000000000000800034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800034000000000000000000800034000000000000000000000000000000000000000000000000000000000000000000
-- 005:600036000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800038000000000000000000000000000000000000000000b0003800000000000000000000000000000000000000000040003a000000000000000000f00038000000600038000000000000000000600038000000800038000000800038000000f00034000000000000000000f00034000000000000000000000000000000000000000000000000000000000000000000
-- 006:ffc168000000000000000000b0006800000060006a000000000000000000f00068000000b00068000000f00068000000f00068000000000000000000b0006800000060006a000000000000000000f00068000000b00068000000f0006800000040006a000000000000000000f00068000000d00068000000000000000000f00068000000d00068000000b00068000000800068000000000000000000b0006800000040006a000000000000000000f00068000000d00068000000f00068000000
-- 007:0ad100f00058000000000000000000b0005800000060005a000000000000000000f00058000000b00058000000f00058000000f00058000000000000000000b0005800000060005a000000000000000000f00058000000b00058000000f0005800000040005a000000000000000000f00058000000d00058000000000000000000f00058000000d00058000000b00058000000800058000000000000000000b0005800000040005a000000000000000000f00058000000d00058000000f00058
-- 008:ffc168000000000000000000b0006800000060006a000000000000000000f00068000000b00068000000f00068000000f00068000000000000000000b0006800000060006a000000000000000000f00068000000b00068000000f0006800000040006a000000000000000000f00068000000d00068000000000000000000f00068000000d00068000000b000680000004fc16a4ad15a4fc16a4ad15a4fc16a4ad15a4fc16a4ad15a6fc16a6ad15a6fc16a6ad15a6fc16a6ad15a6fc16a6ad15a
-- 009:0ad100f00058000000000000000000b0005800000060005a000000000000000000f00058000000b00058000000f00058000000f00058000000000000000000b0005800000060005a000000000000000000f00058000000b00058000000f0005800000040005a000000000000000000f00058000000d00058000000000000000000f00058000000d00058000000b000588ff1c00000008000c00000008000c00000008000c0000000400040000000400040b000d28000c08000c08000c08000c0
-- 010:ffc168fad158000000000000bfc168bad1586fc16a6ad15a000000000000ffc168fad158bfc168bad158ffc168fad158ffc168fad158000000000000bfc168bad1586fc16a6ad15a000000000000ffc168fad158bfc168bad158ffc168fad1584fc16a4ad15a000000000000ffc168fad158dfc168dad158000000000000ffc168fad158dfc168dad158bfc168bad1588fc1688ad158000000000000bfc168bad1584fc16a4ad15a000000000000ffc168fad158dfc168dad158ffc168fad158
-- 011:ffc168fad158000000000000bfc168bad1586fc16a6ad15a000000000000ffc168fad158bfc168bad158ffc168fad158ffc168fad158000000000000bfc168bad1586fc16a6ad15a000000000000ffc168fad158bfc168bad158ffc168fad1584fc16a4ad15a000000000000ffc168fad158dfc168dad158000000000000ffc168fad158dfc168dad158bfc168bad1584fc16a4ad15a4fc16a4ad15a4fc16a4ad15a4fc16a4ad15a6fc16a6ad15a6fc16a6ad15a6fc16a6ad15a6fc16a6ad15a
-- 012:4000400000000000000000008000c00000000000000000004000400000004000400000008000c0000000b000d20000004000400000000000000000008000c00000000000000000004000400000004000400000008000c0000000b000d20000004000400000000000000000008000c00000000000000000004000400000004000400000008000c00000000000000000004000400000000000000000008000c0000000000000000000400040b000d28000c0b000d2400040b000d28000c0b000d2
-- 013:8fc168000000b00068000000b00068000000d00068000000d00068000000f0006800000060006a00000080006a000000800068000000b00068000000b00068000000d00068000000d00068000000f0006800000060006a00000080006a0000000fc1000eb1000da1000c91000b81000a7100096100085100074100063100052100041100030100020100010100000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:0ad100800058000000b00058000000b00058000000d00058000000d00058000000f0005800000060005a00000080005a000000800058000000b00058000000b00058000000d00058000000d00058000000f0005800000060005a00000080005a0ad10009c10008b10007a100069100058100047100036100025100014100003100002100001100000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:400036000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600036000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:b00036000000000000000000800036000000b00036000000000000000000000000000000000000000000000000000000800036000000000000000000000000000000000000000000b00036000000000000000000000000000000000000000000d00036000000000000000000a00036000000d00036000000000000000000000000000000000000000000000000000000a00036000000000000000000000000000000000000000000d00036000000000000000000000000000000000000000000
-- 017:f33186033100044100044100b551860661006771880881000991000aa100fbb1860cc100bdd1860ee100fff186000000f00086000000000000000000b00086000000600088000000000000000000f00086000000b00086000000f00086000000f00086000000000000000000d00086000000600088000000000000000000f00086000000d00086000000f00086000000f00086000000000000000000d00086000000600088000000000000000000f00086000000d00086000000f00086000000
-- 018:f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000d00034000000d00034000000d00034000000f00034000000000000000000000000000000f00034000000000000000000
-- 019:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060007a000000f00078000000a0007800000060007a000000f00078000000a0007800000060007a000000fff1780ee1000dd1000cc1000bb1000aa100099100088100077100066100055100044100033100022100011100000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 020:f00084000000600086000000a00086000000000000000000000000000000000000000000000000000000000000000000d00086000000000000000000000000000000c00086000000000000000000000000000000b00086000000000000000000f00084000000600086000000a00086000000000000000000000000000000000000000000000000000000000000000000d00086000000000000000000000000000000f00086000000000000000000000000000000f00086000000000000000000
-- 021:600036000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800038000000000000000000000000000000000000000000b0003800000000000000000000000000000000000000000040003a000000000000000000f00038000000600038000000000000000000600038000000800038000000800038000000f00034000000000000000000f00034000000410188000000621188000000632188000000643188000000654188000000
-- 022:f00084000000600086000000a00086000000000000000000000000000000600086000000f00084000000000000000000d00084000000000000000000000000000000f00084000000000000000000000000000000000000000000000000000000800086000000800086000000800086000000800086000000800086000000800086000000800086000000800086000000a00086000000800086000000600086000000f00084000000000000000000000000000000000000000000000000000000
-- 023:f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000d00034000000d00034000000d00034000000d00034000000d00034000000d00034000000d00034000000d00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000
-- 024:000000000000000000000000f00067000000f00067000000000000000000f00067000000f0006700000000000000000060007a000000f00078000000a0007800000060007a000000f00078000000a0007800000060007a000000fff1780cc100099100066100033100000100dff157000000d00057000000000000000000d00057000000d00057000000000000000000a00078000000d00078000000f0007800000060007a0000000000000ff1000cc100099100066100033100000100000000
-- 025:f00084000000600086000000a00086000000000000000000000000000000600086000000f00084000000000000000000d00084000000000000000000000000000000f00084000000000000000000000000000000000000000000000000000000600086000000500086000000f00084000000600086000000500086000000f00084000000600086000000500086000000800086000000b00086000000f00086000000b00086000000400088000000f00086000000800088000000600088000000
-- 026:000000000000000000000000f00067000000f00067000000000000000000f00067000000f00067000000000000000000f00078000000000000000000b0007800000060007a000000000000000000f00078000000b00078000000f00078000000d00078000000000000000000d00057000000d00057000000000000000000d00057000000d0005700000000000000000080007a000000b0007a00000080007a000000f00078000000b00078000000000000000000000000000000000000000000
-- 027:f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000f00034000000d00034000000d00034000000d00034000000d00034000000b00034000000b00034000000b00034000000b00034000000a00034000000a00034000000a00034000000a00034000000a00034000000a00034000000a00034000000a00034000000
-- 028:400036000000400036000000400036000000400036000000400036000000400036000000400036000000400036000000400036000000400036000000400036000000400036000000400036000000400036000000400036000000400036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000
-- 029:800036000000800036000000800036000000800036000000800036000000800036000000800036000000800036000000800036000000800036000000800036000000800036000000800036000000800036000000800036000000800036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000600036000000800036000000800036000000800036000000800036000000
-- 030:f0007800000060007a00000000000000000000000000000000000000000000000000000000000000000000000000000080007a00000060007a00000000000000000000000000000000000000000000000000000000000000000000000000000060007a00000080007a000000000000000000000000000000000000000000000000000000000000000000000000000000a0007a000000b0007a000000000000000000000000000000b0007a000000b0007a000000b0007a000000b0007a000000
-- 031:f00086000000600088000000b00086000000600088000000a00088000000600088000000f00086000000600088000000f00086000000600088000000b00086000000600088000000a00088000000600088000000f00086000000600088000000f00086000000600088000000d00086000000600088000000a00088000000b00088000000a00088000000800088000000800088000000600088000000600088000000800088000000a00088000000a00088000000a00088000000a00088000000
-- 032:f0007800000060007a000000000000000000000000000000a0007a000000a0007a000000a0007a000000a0007a00000080007a00000060007a000000000000000000000000000000a0007a000000b0007a000000a0007a00000080007a00000060007a000000000000000000000000000000000000000000f0007800000060007a00000080007a000000a0007a000000d0007ad0007ad0007ad0007ad0007ad0007ad0007ad0007af0007af0007af0007af0007af0007af0007af0007af0007a
-- 033:f00086000000600088000000b00086000000600088000000a00088000000600088000000f00086000000600088000000f00086000000600088000000b00086000000600088000000a00088000000600088000000f00086000000d00086000000b00086000000a00088000000a00088000000a00088000000a00088000000a00088000000a00088000000a00088000000d00088000000d00088000000d00088000000d00088000000f00088000000f00088000000f00088000000f00088000000
-- 034:800036000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600036000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 035:f00086000000000000000000b00086000000600088000000000000000000f00086000000b00086000000f00086000000f00086000000000000000000b00086000000600088000000000000000000f00086000000b00086000000f00086000000f00086000000000000000000d00086000000600088000000000000000000f00086000000d00086000000f00086000000f00086000000000000000000d00086000000600088000000000000000000f00086000000d00086000000f00086000000
-- 036:f00036000000000000000000b00036000000f00036000000000000000000000000000000000000000000000000000000b00036000000000000000000000000000000000000000000f00036000000000000000000000000000000000000000000d00036000000000000000000a00036000000d00036000000000000000000000000000000000000000000000000000000d00036000000000000000000000000000000000000000000400038000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:180000180ec3180ec3180301581702581982581b43585c430542533694633155533155538567538d6a53dd7063e58263200000
-- 001:054253369463000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <FLAGS>
-- 000:00101020400000000000000000000000101010000000000000000000000000001010100000000000000000000000000010101010101010100000000000000000101010101010101000000000000000001010101010100000000000000000000010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </FLAGS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

