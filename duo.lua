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

-- entity states
ENTITY_STATE_STILL = 1
ENTITY_STATE_MOVE = 2
ENTITY_STATE_START_MOVING = 3
ENTITY_STATE_FROZEN = 4
ENTITY_STATE_TELEPORTING = 5
PLAYER_WEAPON_STATE_FIRE_NO = 1
PLAYER_WEAPON_STATE_FIRE_WAVE = 2
PLAYER_WEAPON_STATE_FIRE_PARTICLE = 3

-- sprites
SPRITE_MENU_CAT_CLOSED = 272
SPRITE_MENU_CAT_OPEN = 304
SPRITE_MENU_BOHR = 275

SPRITE_ENTANGLED_BLOCK_A = 120
SPRITE_ENTANGLED_BLOCK_B = 121
SPRITE_BREAK_BLOCK_INTACT = 136
SPRITE_BREAK_BLOCK_CRACKED = 137
SPRITE_BLOCK_DISAPPEARED = 354
SPRITE_DANSK = 256
SPRITE_RADIATION_1 = 352
SPRITE_RADIATION_2 = 353
SPRITE_HEART = 368
SPRITE_PARTICLE_GUN = 261
SPRITE_WAVE_GUN = 260
SPRITE_WARNING = 340
SPRITE_Z_KEY = 343
SPRITE_X_KEY = 375
SPRITE_CARROT = {[ENTITY_STATE_MOVE] = {{sprite=416},
                                        {sprite=416, rotation=90},
                                        {sprite=416, rotation=180},
                                        {sprite=416, rotation=270}}}

SPRITE_MISSILE = {[ENTITY_STATE_MOVE] = {{sprite=407},
                                         {sprite=407},
                                         {sprite=407},
                                         {sprite=407}}}

SPRITE_CAT = {
    [ENTITY_STATE_STILL] = {{sprite=272, width=2, height=2, height_offset=-8}},
    [ENTITY_STATE_MOVE] = {{sprite=304, width=2, height=2, height_offset=-8}},
}
SPRITE_BIRD = {
    [ENTITY_STATE_MOVE] = {{sprite=306}, {sprite=307}},
}
SPRITE_RABBIT = {
    [ENTITY_STATE_STILL] = {{sprite=400}},
    [ENTITY_STATE_MOVE] = {{sprite=401}},
}

SPRITE_BOSS = {
    [ENTITY_STATE_STILL] = {{sprite=371, width=4, height=4}},
    [ENTITY_STATE_MOVE] = {{sprite=371, width=4, height=4}},
    [ENTITY_STATE_FROZEN] = {{sprite=435, width=4, height=4}},
    [ENTITY_STATE_TELEPORTING] = {
        {sprite=448, width=1, height=1, width_offset=12, height_offset=12}
    },
}

SPRITE_BOHR_HEAD = 275
SPRITE_BOHR_BODY = {
    [ENTITY_STATE_STILL] = {
        [PLAYER_WEAPON_STATE_FIRE_NO] = {{sprite=291}},
        [PLAYER_WEAPON_STATE_FIRE_PARTICLE] = {{sprite=308, width=2}},
        [PLAYER_WEAPON_STATE_FIRE_WAVE] = {{sprite=292, width=2}}
    },
    [ENTITY_STATE_MOVE] = {
        [PLAYER_WEAPON_STATE_FIRE_NO] = {{sprite=294, width=3, width_offset=-8},
                                         {sprite=310, width=3, width_offset=-8}},
        [PLAYER_WEAPON_STATE_FIRE_PARTICLE] = {{sprite=299, width=2}, {sprite=315, width=2}},
        [PLAYER_WEAPON_STATE_FIRE_WAVE] = {{sprite=297, width=2}, {sprite=313, width=2}}
    }
}

SPRITE_BOHR_DEATH = {
    {sprite=301, height=2},
    {sprite=302, height=2},
    {sprite=303, height=2},
    {sprite=333, height=2},
    {sprite=334, height=2},
    {sprite=335, height=2},
    {sprite=365, height=2},
    {sprite=366, height=2},
    {sprite=367, height=2},
    {sprite=397, height=2},
    {sprite=398, height=2},
}

SPRITE_KAMELASA = {
    {sprite=378, height=2, width=3, flip=0},
    {sprite=426, height=2, width=3, flip=0},
    {sprite=474, height=2, width=3, flip=0},
    {sprite=426, height=2, width=3, flip=1},
    {sprite=378, height=2, width=3, flip=1},
    {sprite=445, height=2, width=3, flip=1},
    {sprite=424, height=2, width=3, flip=0},
    {sprite=445, height=2, width=3, flip=0},
}

-- sound effects
SFX_HURT = 48
SFX_ENEMY_HURT = 49
SFX_SHOOT_PARTICLE = 50
SFX_SWITCH_WEAPON = 51
SFX_DEATH = 52
SFX_BLOCK = 53
SFX_MISSILE = 54

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
STATE_INIT = 0
STATE_MENU = 1
STATE_GAME = 2
STATE_GAME_OVER = 3
STATE_GAME_STARTING = 4
STATE_VICTORY = 5

-- other
PLAYER_SPEED = 1
CAT_SPEED = 0.5
BIRD_SPEED = 1
VICTORY_WAIT_FRAMES = 300
FIRE_PARTICLE = 1
FIRE_WAVE = 2
PARTICLE_SHOOT_INTERVAL = 60
PARTICLE_SPEED = 2
NUM_RADIATION_PARTICLES = 256
MAX_HEALTH = 5
PLAYER_ANIMATION_MOVE_SPEED = 0.1
BIRD_ANIMATION_MOVE_SPEED = 0.05
MAX_SWITCHING_WEAPONS_TIME = 60
ENTANGLED_BLOCK_A = 120
ENTANGLED_BLOCK_B = 121
LEVELS = {{x_tile_min=0, x_tile_max=239, y_tile_min=0, y_tile_max=16}}
MAX_DEATH_COUNTER = 120
LEVELS = {{x_tile_min=0, x_tile_max=239, y_tile_min=0, y_tile_max=16,
           block_pair_a={{tile_x=14,tile_y=1},{tile_x=14,tile_y=15}},}
         }


-- level entities
LEVEL_1_ENTITIES = {
    bird_spawn_rate=60,
    camera={x=000, y=000},
    players={
        {x=028, y=014},
        {x=028, y=112},
    },
    cats={
        {x=017, y=005},
        {x=022, y=002},
        {x=038, y=014},
        {x=038, y=006},
        {x=052, y=009},
        {x=052, y=001},
        {x=062, y=009},
        {x=062, y=001},
        {x=073, y=006},
        {x=069, y=006},
        {x=082, y=003},
        {x=082, y=011},
        {x=104, y=013},
        {x=103, y=006},
        {x=106, y=001},
        {x=113, y=005},
        {x=118, y=002},
        {x=130, y=002},
        {x=130, y=010},
        {x=143, y=004},
        {x=143, y=012},
        {x=157, y=006},
        {x=157, y=014},
        {x=168, y=001},
        {x=168, y=009},
        {x=179, y=006},
        {x=179, y=014},
        {x=192, y=006},
        {x=192, y=009},
        {x=195, y=010},
        {x=195, y=113},
        {x=201, y=006},
        {x=204, y=006},
        {x=207, y=006},
        {x=207, y=013},
        {x=207, y=010},
        {x=227, y=014},
        {x=227, y=006},
        {x=223, y=014},
        {x=235, y=004},
        {x=234, y=011},
    },
    blocks={
        {x=086, y=004},
        {x=086, y=012},
        {x=120, y=001},
        {x=120, y=002},
        {x=120, y=003},
        {x=120, y=004},
        {x=120, y=005},
        {x=120, y=006},
        {x=120, y=007},
        {x=198, y=013},
        {x=198, y=014},
        {x=198, y=015},
        {x=199, y=013},
        {x=199, y=014},
        {x=199, y=015},
        {x=210, y=013},
        {x=210, y=014},
        {x=210, y=015},
        {x=211, y=013},
        {x=211, y=014},
        {x=211, y=015},
        {x=232, y=001},
        {x=232, y=009},
        {x=229, y=015},
        {x=229, y=007},
        {x=226, y=001},
        {x=226, y=009},
    },
    rabbits={{x=016,y=002}},
}

LEVEL_2_ENTITIES = {
    bird_spawn_rate=300,
    camera={x=000, y=136},
    players={
        {x=028, y=176},
        {x=028, y=232},
    },
    cats={
         {x=043, y=023},
         {x=137, y=021},
         {x=137, y=028},
         {x=146, y=030},
         {x=121, y=023},
         {x=204, y=028},
     },
     blocks={},
     rabbits={
         {x=199, y=022},
     },
}

LEVEL_ENTITIES = {
    LEVEL_1_ENTITIES,
    LEVEL_2_ENTITIES,
}

------ GLOBAL VARIABLES ----------
t = 0
victory_time=0
state = STATE_INIT
rabbit_id_counter = 0

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
    if state == STATE_INIT then
        music(02)
        state = STATE_MENU
    elseif state == STATE_MENU then
        update_menu()
        draw_menu()
    elseif state == STATE_INSTRUCTIONS then
        update_instructions()
        draw_instructions()
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
    t = t + 1
end

function update_instructions()
    if t > 420 or btnp(BUTTON_Z) then
        state = STATE_GAME_STARTING
    end
end

function update_menu()
    if btnp(BUTTON_Z) then
        start_instructions()
        current_level = 1
    elseif btnp(BUTTON_X) then
        start_instructions()
        current_level = 2
    end
end

function start_instructions()
    music()
    state = STATE_INSTRUCTIONS
    t = 0
end

function draw_menu()
    cls(BLACK)
    spr(SPRITE_MENU_BOHR,0,40,BLACK,6,0,0,1,2)
    spr(SPRITE_MENU_BOHR,192,40,BLACK,6,1,0,1,2)
    spr(SPRITE_MENU_CAT_OPEN,64,88,BLACK,3,0,0,2,2)
    spr(SPRITE_MENU_CAT_CLOSED,128,88,BLACK,3,1,0,2,2)
    print_centered("The Boring World", 10, ORANGE, false, 2)
    print_centered("of Niels Bohr", 30, ORANGE, false, 2)
    print_centered("Based on a true story", 50, ORANGE)
    print_centered("Press Z to start", 75, ORANGE)
end

function draw_kamelasa(x, y)
    local index = 1 + math.floor(((t % 60) / 60) * #SPRITE_KAMELASA)
    local the_sprite = SPRITE_KAMELASA[index]

    local x_offset = 0
    if the_sprite.flip == 1 then
        x_offset = 1
    end

    spr(
        the_sprite.sprite,
        x + x_offset,
        y,
        BLACK,
        1,
        the_sprite.flip,
        0,
        the_sprite.height,
        the_sprite.width
    )
end

function restart()
    t = 0
    -- This is where we set state of players etc. to their initial values
    music(00)

    enemies_cat = {}
    enemies_bird = {}
    enemies_rabbit = {}
    carrots = {}

    switching_weapons = false
    weapon_wave_gun = {x=0, y=0, bbox=bounding_box({})}
    weapon_particle_gun = {x=0, y=0, bbox=bounding_box({})}
    local ax=LEVEL_ENTITIES[current_level].players[1].x
    local ay=LEVEL_ENTITIES[current_level].players[1].y
    local bx=LEVEL_ENTITIES[current_level].players[2].x
    local by=LEVEL_ENTITIES[current_level].players[2].y
    playerA = {
        x=ax,
        y=ay,
        tileX = math.floor(ax/8),
        tileY = math.floor(ay/8),
        speed=PLAYER_SPEED,
        particle_timer=0,
        fire_mode=FIRE_PARTICLE,
        firing=false,
        begin_firing=false,
        health=MAX_HEALTH,
        bbox=bounding_box({}),
        iframes=0,
        weapon_state=PLAYER_WEAPON_STATE_FIRE_NO,
        move_state=ENTITY_STATE_STILL,
        spr_counter = 0,
        iframes_max=60,
        sfxs={hurt={id=SFX_HURT, note='E-3'}},
        dead=false,
        death_counter=0,
    }
    playerB = {
        x=bx,
        y=by,
        tileX = math.floor(bx/8),
        tileY = math.floor(by/8),
        speed=PLAYER_SPEED,
        particle_timer=0,
        fire_mode=FIRE_WAVE,
        firing=false,
        begin_firing=false,
        health=MAX_HEALTH,
        bbox=bounding_box({}),
        iframes=0,
        weapon_state=PLAYER_WEAPON_STATE_FIRE_NO,
        move_state=ENTITY_STATE_STILL,
        spr_counter = 0,
        iframes_max=60,
        sfxs={hurt={id=SFX_HURT, note='E-3'}},
        dead=false,
        death_counter=0,
    }
    state = STATE_GAME
    cam = LEVEL_ENTITIES[current_level].camera
    particles = {}
    wave = {x=0,y=0,firing=false}
    radiation_x = -30
    radiation_particles = {}
    entangled_blocks = {SPRITE_ENTANGLED_BLOCK_A={},SPRITE_ENTANGLED_BLOCK_B={}}
    local pair_a = LEVELS[1].block_pair_a
    block_pair_a = {}
    --block_pair_a = {{x=pair_a[1].tile_x*8, y=pair_a[1].tile_y*8, disappeared=false, wave_shot=false},
    --                {x=pair_a[2].tile_x*8, y=pair_a[2].tile_y*8, disappeared=false, wave_shot=false}}
    local pair_b = LEVELS[1].block_pair_b
    block_pair_b = {}
    if not pair_b == nil then
        block_pair_b = {{x=pair_b[1].tile_x*8, y=pair_b[1].tile_y*8, disappeared=false, wave_shot=false},
                        {x=pair_b[2].tile_x*8, y=pair_b[2].tile_y*8, disappeared=false, wave_shot=false}}
    end
    break_blocks = {}

    boss = new_boss(20, 10)

    spawn_cats()
    spawn_blocks()
    spawn_rabbits()
end

function new_boss(tile_x, tile_y)
    return {
        name=string.format('boss from %d,%d', tile_x, tile_y),
        sprites=SPRITE_BOSS,
        x=tile_x*8,
        y=tile_y*8,
        tileX=tile_x,
        tileY=tile_y,
        --speed=PLAYER_SPEED,
        --flip=1,
        bbox=bounding_box({x_min=8, x_max=24, y_min=8, y_max=24}),
        health=5,
        sfxs={hurt={id=SFX_ENEMY_HURT, note='C#5'}},
        dead=false,
        death_counter=0,
        iframes=0,
        iframes_max=30,
        move_state=ENTITY_STATE_STILL,
        spr_counter=0,
        spr_counter_inc=0.1,
        state_counter=0,
        id=1337,
        dir=DIR_LEFT,
    }
end

function spawn_cats()
    local entities = LEVEL_ENTITIES[current_level]
    local coords = entities.cats
    for _, coord in ipairs(coords) do
        spawn_cat(coord.x, coord.y)
    end
end

function spawn_rabbits()
    local entities = LEVEL_ENTITIES[current_level]
    local coords = entities.rabbits
    for _, coord in ipairs(coords) do
        spawn_rabbit(coord.x, coord.y)
    end
end

function spawn_blocks()
    local entities = LEVEL_ENTITIES[current_level]
    local coords = entities.blocks
    for _, coord in ipairs(coords) do
        spawn_break_block(coord.x, coord.y)
    end
end

function spawn_break_block(tile_x, tile_y)
    add(break_blocks,
        {x=tile_x*8,
         y=tile_y*8,
         cracked=false,
         broken=false,
         bbox=bounding_box({x_min=0, x_max=7, y_min=0, y_max=8})})
end

function update_game_over()
    if btnp(BUTTON_Z) then
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
        state = STATE_INIT
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
    if t % LEVEL_ENTITIES[current_level].bird_spawn_rate == 0 then
        spawn_bird()
    end
    update_radiation()
    --update_entangled_blocks()
    update_break_blocks()
end

function draw_game()
    draw_map()
    --draw_entangled_blocks()
    draw_break_blocks()
    draw_enemies()
    draw_bohr(playerA)
    draw_separator()
    draw_bohr(playerB)
    draw_particles()
    draw_wave()
    draw_radiation()
    draw_weapon_switch()
    draw_health()
    draw_warning()
end

function draw_warning()
    if t > 240 or t % 10 > 5 then
        return
    end
    spr(SPRITE_WARNING, 5, 5, BLACK, 1, 0, 0, 2, 2)
end

function draw_instructions()
    cls(BLACK)

    draw_kamelasa(110, 20)
    print_with_border("Find the kamelasa", 72, 42)

    spr(SPRITE_Z_KEY, 90, 64, BLACK, 1, 0, 0, 2, 2)
    print_with_border("Shoot", 112, 70)

    spr(SPRITE_X_KEY, 68, 94, BLACK, 1, 0, 0, 2, 2)
    print_with_border("Switch weapons", 90, 100)
end

function print_with_border(text, x, y)
    print(text, x-1, y, DARK_GREY, false, 1, false)
    print(text, x, y-1, DARK_GREY, false, 1, false)
    print(text, x+1, y, DARK_GREY, false, 1, false)
    print(text, x, y+1, DARK_GREY, false, 1, false)
    print(text, x, y, WHITE, false, 1, false)
end

function draw_break_blocks()
    for _, block in ipairs(break_blocks) do
        if not block.broken then
            if block.cracked then
                spr(SPRITE_BREAK_BLOCK_CRACKED, block.x - cam.x, block.y, BLACK)
            else
                spr(SPRITE_BREAK_BLOCK_INTACT, block.x - cam.x, block.y, BLACK)
            end
        end
    end
end
function draw_entangled_blocks()
    for _, block in ipairs(block_pair_a) do
        if block.disappeared then
            spr(SPRITE_BLOCK_DISAPPEARED, block.x - cam.x, block.y, BLACK, 1, 0, 0, 1, 1)
        elseif block.wave_shot then
            rect(block.x - cam.x - 1, block.y - 1, 10, 10, WHITE)
            spr(SPRITE_ENTANGLED_BLOCK_A, block.x - cam.x, block.y, BLACK, 1, 0, 0, 1, 1)
        else
            spr(SPRITE_ENTANGLED_BLOCK_A, block.x - cam.x, block.y, BLACK, 1, 0, 0, 1, 1)
        end
    end
    for _, block in ipairs(entangled_blocks.SPRITE_ENTANGLED_BLOCK_B) do
        if block.disappeared then
            spr(SPRITE_BLOCK_DISAPPEARED, block.x - cam.x, block.y, BLACK, 17, 0, 0, 1, 1)
        end
    end
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
    if player.dead then
        local index = 1 + math.floor(
            ((MAX_DEATH_COUNTER - player.death_counter - 1) / MAX_DEATH_COUNTER) *
            #SPRITE_BOHR_DEATH
        )
        local death_sprite = SPRITE_BOHR_DEATH[index]
        spr(
            death_sprite.sprite,
            player.x-cam.x,
            player.y-cam.y-8,
            BLACK,
            1,
            0,
            0,
            1,
            death_sprite.height
        )
        return
    end

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
    radiation_x = radiation_x + 0.2
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
    spr(SPRITE_RADIATION_2, radiation_x - HEIGHT - cam.x, 0, BLACK, 17, 0, 0, 1, 1)
    spr(SPRITE_RADIATION_1, radiation_x - HEIGHT - cam.x - 2, 0, BLACK, 17, 0, 0, 1, 1)

    for i = 1, NUM_RADIATION_PARTICLES do
        rect(
            radiation_particles[i].x-cam.x,
            radiation_particles[i].y,
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
             3,
             3,
             ORANGE)
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
        line(x,         center-math.sin((sine_x)   /i_f)*amp - cam.y,
             x+wave_dx, center-math.sin((sine_x+wave_dx)/i_f)*amp - cam.y,
             LIGHT_BLUE)
        sine_x = sine_x - wave_dx
    end
end

function update_players()
    handle_input()
    update_weapons()

    for _, player in ipairs({playerA, playerB}) do
        check_radiation_collision(player)
        check_enemy_collision(player)
        update_iframes(player)
        if player.dead then
            player.death_counter = math.max(player.death_counter - 1, 0)
            if player.death_counter == 0 then
                sfx(SFX_DEATH, 'D-5', -1, 1, 15, -1)
                game_over()
            end
        end
        player.spr_counter = player.spr_counter + PLAYER_ANIMATION_MOVE_SPEED
    end

    update_weapon_switch()
end

function check_enemy_collision(player)
    for _, cat in ipairs(enemies_cat) do
        if entity_collision(player, cat) then
            hurt_entity(player)
        end
    end
    for _, bird in ipairs(enemies_bird) do
        if entity_collision(player, bird) then
            hurt_entity(player)
        end
    end
    for _, rabbit in ipairs(enemies_rabbit) do
        if entity_collision(player, rabbit) then
            hurt_entity(player)
        end
    end
end

function update_weapon_switch()
    if not switching_weapons then
        return
    end

    local player_p
    local player_w
    if playerA.fire_mode == FIRE_PARTICLE then
        player_p = playerA
        player_w = playerB
    else
        player_p = playerB
        player_w = playerA
    end

    weapon_follow(weapon_particle_gun, player_w)
    weapon_follow(weapon_wave_gun, player_p)

    if entity_collision(player_p, weapon_wave_gun) and 
       entity_collision(player_w, weapon_particle_gun)  then
        temp = playerA.fire_mode
        playerA.fire_mode = playerB.fire_mode
        playerB.fire_mode = temp
        switching_weapons = false
    end
end

function weapon_follow(weapon, player)
    local norm_x = (player.x - weapon.x) / WIDTH
    local norm_y = (player.y - weapon.y) / HEIGHT
    local dir = math.atan2(norm_y, norm_x)
    local dx = math.cos(dir) * 1.5
    local dy = math.sin(dir) * 1.5
    weapon.x = weapon.x + dx
    weapon.y = weapon.y + dy
end

function draw_weapon_switch()
    if not switching_weapons then
        return
    end

    spr(SPRITE_PARTICLE_GUN, weapon_particle_gun.x - cam.x, weapon_particle_gun.y - cam.y, BLACK)
    spr(SPRITE_WAVE_GUN, weapon_wave_gun.x - cam.x, weapon_wave_gun.y - cam.y, BLACK)
end

function update_iframes(entity)
    entity.iframes = math.max(entity.iframes - 1, 0)
end

function check_radiation_collision(player)
    if player.x < radiation_x then
        kill_entity(player)
    end
end

function update_carrot(carrot)
    carrot.spr_counter = carrot.spr_counter + carrot.spr_counter_inc
    local dx, dy = getdxdy(carrot.speed, carrot.dir)
    carrot.x = carrot.x + dx
    carrot.y = carrot.y + dy

    carrot.state_timeout = carrot.state_timeout + 1

    if is_entity_by_solid(carrot, carrot.dir, 0) or carrot.state_timeout <= 0 then
        --del(carrots, carrot)
    end

    for _, player in ipairs({playerA, playerB}) do
        if entity_collision(player, carrot) then
            hurt_entity(player)
            del(carrots, carrot)
        end
    end
end

function spawn_carrot(rabbit)
    add(carrots,
        {x=rabbit.x,
         y=rabbit.y,
         dir=rabbit.dir,
         sprites=SPRITE_CARROT,
         spr_counter=0,
         spr_counter_inc=0.1,
         bbox=bounding_box{_, x_min=2, x_max=4, y_min=2, y_max=4},
         state_timeout=0,
         speed=1,
         iframes=0,
         move_state=ENTITY_STATE_MOVE,
         name="carrot",
     })
end
function update_rabbit(rabbit)
    local player = player_to_attack(rabbit)
    rabbit.spr_counter = rabbit.spr_counter + rabbit.spr_counter_inc

    if rabbit.move_state == ENTITY_STATE_MOVE then
        rabbit.state_timeout = rabbit.state_timeout - 1
        if rabbit.state_timeout <= 0 or is_entity_next_to_solid(rabbit, rabbit.dir) then
            rabbit.move_state = ENTITY_STATE_STILL
        if near(player, rabbit) then
            rabbit.state_timeout = 10
        else
            rabbit.state_timeout = 20 + math.floor(math.random(40))
        end
        end
        local dx, dy = getdxdy(rabbit.speed, rabbit.dir)
        moveEntity(rabbit, dx, dy, rabbit.dir)

        if in_camera(rabbit) and
           near_on_any_dimension(player, rabbit) and
           not has_active_carrot(rabbit) then
            rabbit.move_state = ENTITY_STATE_STILL
            spawn_carrot(rabbit)
            --sfx(c_sfx_throw_carrot)
            rabbit.state_timeout = 20 + math.floor(math.random(40))
        end
    elseif rabbit.move_state == ENTITY_STATE_STILL then
        rabbit.state_timeout = rabbit.state_timeout - 1
        if rabbit.state_timeout <= 0 and near(rabbit, player) then
            rabbit.move_state = ENTITY_STATE_START_MOVING
        end
    end
    if rabbit.move_state == ENTITY_STATE_START_MOVING then
        local dir = get_random_direction()
        if near(player, rabbit) then
            dir = get_direction_to_player(rabbit, player)
        end
        if not is_entity_next_to_solid(rabbit, dir) then
            rabbit.move_state = ENTITY_STATE_MOVE
            rabbit.dir = dir
            rabbit.state_timeout = 10
        else
            rabbit.move_state = ENTITY_STATE_STILL
        end
    end
    if inarray(rabbit.dir, {DIR_LEFT, DIR_UP_LEFT, DIR_DOWN_LEFT}) then
        rabbit.flip = 1
    elseif inarray(rabbit.dir, {DIR_RIGHT, DIR_UP_RIGHT, DIR_DOWN_RIGHT}) then
        rabbit.flip = 0
    end
    check_weapon_collision(rabbit)
    if rabbit.dead then
        del(enemies_rabbit, rabbit)
    end
    update_iframes(rabbit)
end
function has_active_carrot(rabbit)
    for _, carrot in ipairs(carrots) do
        if carrot.rabbit == rabbit.id then
            return false--true
        end
    end
end
function next_rabbit_id()
    rabbit_id_ocunter = rabbit_id_counter + 1
    return rabbit_id_counter
end

function get_random_direction()
    local dirs = {DIR_UP, DIR_DOWN, DIR_LEFT, DIR_RIGHT}
    return dirs[math.floor(math.random(4)) + 1]
end

function in_camera(entity)
    -- assume entities are 8x8 pixels
    local x = entity.x + 3
    local y = entity.y + 3
    return cam.x < x and x < cam.x + WIDTH and
           cam.y + 10 < y and y < cam.y + HEIGHT
end
function near(a, b)
    return math.abs(a.x - b.x) + math.abs(a.y - b.y) < 80
end
function near_on_any_dimension(a, b)
    return math.abs(a.x - b.x) < 10 or math.abs(a.y - b.y) < 10
end
function getdxdy(speed, dir)
    local dx = 0
    local dy = 0
    if inarray(dir, {DIR_LEFT, DIR_UP_LEFT, DIR_DOWN_LEFT}) then
        dx = -speed
    elseif inarray(dir, {DIR_RIGHT, DIR_UP_RIGHT, DIR_DOWN_RIGHT}) then
        dx = speed
    end
    if inarray(dir, {DIR_UP, DIR_UP_LEFT, DIR_UP_RIGHT}) then
        dy = -speed
    elseif inarray(dir, {DIR_DOWN, DIR_DOWN_LEFT, DIR_DOWN_RIGHT}) then
        dy = speed
    end
    return dx, dy
end

function kill_entity(entity)
    if not entity.dead then
        entity.dead = true
        entity.death_counter = MAX_DEATH_COUNTER
    end
end

function update_weapons()
    for _, player in ipairs({playerA, playerB}) do
        update_weapons_for_player(player)
    end
    for _, particle in ipairs(particles) do
        particle.x = particle.x + PARTICLE_SPEED
        particle.time_left = particle.time_left - 1
        if particle.time_left == 0 then
            del(particles, particle)
        end
    end
end

function update_weapons_for_player(player)
    if not switching_weapons and player.firing and not player.dead then
        if player.fire_mode == FIRE_PARTICLE then
            player.weapon_state = PLAYER_WEAPON_STATE_FIRE_PARTICLE
            if player.particle_timer == 0 then
                shoot_particle(player.x, player.y)
                player.particle_timer = PARTICLE_SHOOT_INTERVAL
            end
        elseif player.fire_mode == FIRE_WAVE then
            player.weapon_state = PLAYER_WEAPON_STATE_FIRE_WAVE
            wave.firing = true
            wave.x = player.x + 11
            wave.y = player.y
        end
    else
        player.weapon_state = PLAYER_WEAPON_STATE_FIRE_NO
        wave.firing = false
    end
    player.particle_timer = math.max(0, player.particle_timer-1) -- count down once each frame
end

function shoot_particle(playerX, playerY)
    x = playerX + 8
    y = playerY + 1
    particles[#particles+1] = {x=x,y=y, bbox=bounding_box({}), time_left=100}
    sfx(SFX_SHOOT_PARTICLE, 'F-1', -1, 1)
end

function handle_input()
    handle_move_input(playerA)
    handle_move_input(playerB)
    for _, player in ipairs({playerA, playerB}) do
        handle_shooting_input(player)
    end
    -- Switch weapon fire mode
    if btnp(BUTTON_X) and not playerA.dead and not playerB.dead then
        start_switching_weapons()
    end
    check_tile_effects(playerA)
    check_tile_effects(playerB)
end

function handle_move_input(player)
    player.move_state = ENTITY_STATE_MOVE
    if btn(BUTTON_UP) and btn(BUTTON_LEFT) then
        moveEntity(player, -PLAYER_SPEED, -PLAYER_SPEED, DIR_UP_LEFT)
    elseif btn(BUTTON_UP) and btn(BUTTON_RIGHT) then
        moveEntity(player,  PLAYER_SPEED, -PLAYER_SPEED, DIR_UP_RIGHT)
    elseif btn(BUTTON_DOWN) and btn(BUTTON_LEFT) then
        moveEntity(player, -PLAYER_SPEED,  PLAYER_SPEED, DIR_DOWN_LEFT)
    elseif btn(BUTTON_DOWN) and btn(BUTTON_RIGHT) then
        moveEntity(player,  PLAYER_SPEED,  PLAYER_SPEED, DIR_DOWN_RIGHT)
    elseif btn(BUTTON_UP) then
        moveEntity(player,             0, -PLAYER_SPEED, DIR_UP)
    elseif btn(BUTTON_DOWN) then
        moveEntity(player,             0,  PLAYER_SPEED, DIR_DOWN)
    elseif btn(BUTTON_LEFT) then
        moveEntity(player, -PLAYER_SPEED,             0, DIR_LEFT)
    elseif btn(BUTTON_RIGHT) then
        moveEntity(player,  PLAYER_SPEED,             0, DIR_RIGHT)
    else
        player.move_state = ENTITY_STATE_STILL
    end
    player.tileX = math.floor(player.x/8)
    player.tileY = math.floor(player.y/8)
end

function handle_shooting_input(player)
    if player.dead then
        return
    end

    if btnp(BUTTON_Z) then
        player.begin_firing = true  -- to avoid firing right after starting the level
    end
    if player.begin_firing and btn(BUTTON_Z) then
        player.firing = true
    else
        player.firing = false
    end
end

function start_switching_weapons()
    switching_weapons = true
    sfx(SFX_SWITCH_WEAPON, 'C#2', -1, 1)

    local player_p
    local player_w
    if playerA.fire_mode == FIRE_PARTICLE then
        player_p = playerA
        player_w = playerB
    else
        player_p = playerB
        player_w = playerA
    end

    weapon_wave_gun.x = player_w.x
    weapon_wave_gun.y = player_w.y

    weapon_particle_gun.x = player_p.x
    weapon_particle_gun.y = player_p.y
end

function update_camera()
    local player_midpoint = (playerA.x + playerB.x) / 2
    local track_point = player_midpoint + 40
    local cam_x_min = math.max(120, track_point) - 120
    cam.x = math.min(cam_x_min, CAMERA_MAX)
end

function moveEntity(entity, dx, dy, dir)
    if entity.dead or not entity.move_state == ENTITY_STATE_MOVE then
        return
    end
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
    local bbox = abs_bbox(entity)
    if dir == DIR_LEFT then
        left  = is_solid(bbox.nw.x - margin, bbox.nw.y)
             or is_solid(bbox.sw.x - margin, bbox.sw.y)
        return left
    elseif dir == DIR_RIGHT then
        right = is_solid(bbox.ne.x + margin, bbox.ne.y)
             or is_solid(bbox.se.x + margin, bbox.se.y)
        return right
    elseif dir == DIR_UP then
        up    = is_solid(bbox.nw.x, bbox.nw.y - margin)
             or is_solid(bbox.ne.x, bbox.ne.y - margin)
        return up
    elseif dir == DIR_DOWN then
        down  = is_solid(bbox.sw.x, bbox.sw.y + margin)
             or is_solid(bbox.se.x, bbox.se.y + margin)
        return down
    end
end

-- check if pixel coordinate is solid
function is_solid(x, y)
  local tile_x = math.floor(x/8)
  local tile_y = math.floor(y/8)
  return is_tile_solid(tile_x, tile_y) or tile_has_block(tile_x, tile_y)
end

function tile_has_block(tile_x, tile_y)
    for _, block in ipairs(block_pair_a) do
        if block.x == tile_x * 8 and block.y == tile_y * 8 and not block.disappeared then
            return true
        end
    end
    for _, block in ipairs(block_pair_b) do
        if block.x == tile_x * 8 and block.y == tile_y * 8 and not block.disappeared then
            return true
        end
    end
    for _, block in ipairs(break_blocks) do
        if block.x == tile_x * 8 and block.y == tile_y * 8 and not block.broken then
            return true
        end
    end
end

function is_tile_solid(tileX, tileY)
    local tile_id = mget(tileX, tileY)
    return fget(tile_id, TILE_SOLID)
end

function check_tile_effects(player)
    local p_bbox = abs_bbox(player)
    for _, corner in ipairs({p_bbox.nw, p_bbox.ne, p_bbox.sw, p_bbox.se}) do
        local tile_x = math.floor(corner.x / 8)
        local tile_y = math.floor(corner.y / 8)
        tile_id = mget(tile_x, tile_y)
        if fget(tile_id, TILE_DEADLY) then
            hurt_entity(player)
        elseif fget(tile_id, TILE_WINNING) then
            --victory()
        end
    end
end

function hurt_entity(entity)
    if entity.iframes > 0 then
        return
    end

    entity.iframes = entity.iframes_max
    sfx(entity.sfxs.hurt.id, entity.sfxs.hurt.note, -1, 1)
    entity.health = entity.health - 1

    if entity.health == 0 then
        kill_entity(entity)
    end
end

function victory()
    state = STATE_VICTORY
    victory_time = t
end

function game_over()
    state = STATE_GAME_OVER
end

function spawn_cat(tile_x,tile_y)
    local new_cat = {
        name=string.format('cat from %d,%d', tile_x, tile_y),
        sprites=SPRITE_CAT,
        x=tile_x*8,
        y=tile_y*8,
        tileX=tile_x,
        tileY=tile_y,
        speed=PLAYER_SPEED,
        flip=1,
        bbox=bounding_box({x_min=1,
                           x_max=14,
                           y_min=8,
                           y_max=15}),
        health=2,
        sfxs={hurt={id=SFX_ENEMY_HURT, note='C#5'}},
        dead=false,
        death_counter=0,
        iframes=0,
        iframes_max=30,
        move_state=ENTITY_STATE_STILL,
        speed=CAT_SPEED,
        spr_counter=0,
    }
    enemies_cat[#enemies_cat+1]=new_cat
end

-- birds are spawned at random tile to the right of the screen
function spawn_bird()
    local x = cam.x + WIDTH
    local y = cam.y + math.random(15)*8
    local new_bird = {
        name=string.format('bird_from %d,%d', x//8, y//8),
        sprites=SPRITE_BIRD,
        x=x,
        y=y,
        tileX=x//8,
        tileY=y//8,
        speed=PLAYER_SPEED,
        flip=1,
        bbox=bounding_box({}),
        health=1,
        sfxs={hurt={id=SFX_ENEMY_HURT, note='C#5'}},
        dead=false,
        death_counter=0,
        iframes=0,
        iframes_max=30,
        move_state=ENTITY_STATE_MOVE,
        speed=BIRD_SPEED,
        spr_counter=0,
    }
    enemies_bird[#enemies_bird+1]=new_bird
end

function spawn_rabbit(tile_x, tile_y)
    local new_rabbit = {
        name=string.format('rabbit_from %d,%d', tile_x, tile_y),
        sprites=SPRITE_RABBIT,
        x=tile_x*8,
        y=tile_y*8,
        tileX=tile_x,
        tileY=tile_y,
        speed=PLAYER_SPEED,
        flip=1,
        bbox=bounding_box({}),
        health=2,
        sfxs={hurt={id=SFX_ENEMY_HURT, note='C#5'}},
        dead=false,
        death_counter=0,
        iframes=0,
        iframes_max=30,
        move_state=ENTITY_STATE_MOVE,
        spr_counter=0,
        spr_counter_inc=0.1,
        state_timeout=0,
        id=next_rabbit_id(),
        dir=DIR_LEFT,
        iframes_max=30,
    }
    enemies_rabbit[#enemies_rabbit+1]=new_rabbit
end

function draw_enemies()
  for _, cat in ipairs(enemies_cat) do
      draw_enemy(cat)
  end
  for _, bird in ipairs(enemies_bird) do
      draw_enemy(bird)
  end
  for _, rabbit in ipairs(enemies_rabbit) do
      draw_enemy(rabbit)
  end
  draw_boss()
  for _, carrot in ipairs(carrots) do
      draw_enemy(carrot)
  end
end

function draw_enemy(enemy)
    if math.fmod(enemy.iframes, 2) == 1 then
        return
    end
    local body_datas = enemy.sprites[enemy.move_state]
    local body_data = body_datas[math.floor(enemy.spr_counter) % #body_datas + 1]
    local width_offset = body_data.width_offset or 0
    local height_offset = body_data.width_offset or 0
    local width = body_data.width or 1
    local height = body_data.height or 1
    spr(body_data.sprite,
        enemy.x-cam.x+width_offset,
        enemy.y-cam.y+height_offset,
        BLACK,
        1,
        enemy.flip,
        body_data.rotation,
        width,
        height)
end

function update_enemies()
  for id, cat in ipairs(enemies_cat) do
      update_cat(cat, id)
  end
  for id, bird in ipairs(enemies_bird) do
      update_bird(bird, id)
  end
  for _, rabbit in ipairs(enemies_rabbit) do
      update_rabbit(rabbit)
  end
  for _, carrot in ipairs(carrots) do
      update_carrot(carrot)
  end
  update_boss()
end

function update_boss()
    if boss.health == 0 then
        return
    end

    boss.state_counter = boss.state_counter + 1

    if boss.move_state == ENTITY_STATE_STILL then
        if boss.state_counter > 30 then
            if math.random() > 0.8 then
                boss_shoot_missile(0, 0)
                boss_shoot_missile(24, 0.1)
                sfx(SFX_MISSILE, 'C#3', -1, 1, 15, -1)
            elseif math.random() > 0.5 then
                if math.random() > 0.5 then
                    if (boss.y > (HEIGHT/2) and not (boss.y < (8 + HEIGHT/2))) or
                        (boss.y < (HEIGHT/2) and not (boss.y < 8)) then
                        boss.dir = DIR_UP
                        boss.move_state = ENTITY_STATE_MOVE
                    end
                else
                    if (boss.y > (HEIGHT/2) and not (boss.y > (HEIGHT - 40))) or
                        (boss.y < (HEIGHT/2) and not (boss.y > ((HEIGHT/2) - 40))) then
                        boss.dir = DIR_DOWN
                        boss.move_state = ENTITY_STATE_MOVE
                    end
                end
            elseif math.random() > 0.8 then
                boss.move_state = ENTITY_STATE_TELEPORTING
                sfx(SFX_MISSILE, 'C#4', -1, 1, 15, -2)
                if boss.y < ((HEIGHT / 2) - 8) then
                    boss.dir = DIR_DOWN
                else
                    boss.dir = DIR_UP
                end
            end

            boss.state_counter = 0
        end
    elseif boss.move_state == ENTITY_STATE_MOVE then
        if boss.dir == DIR_UP then
            boss.y = boss.y - 0.2
        else
            boss.y = boss.y + 0.2
        end

        if boss.state_counter > 30 then
            boss.move_state = ENTITY_STATE_STILL
            boss.state_counter = 0
            boss.dir = DIR_LEFT
        end
    elseif boss.move_state == ENTITY_STATE_FROZEN then
        if boss.state_counter > 240 then
            boss.move_state = ENTITY_STATE_STILL
        end
    elseif boss.move_state == ENTITY_STATE_TELEPORTING then
        if boss.dir == DIR_UP then
            boss.y = boss.y - 1
        else
            boss.y = boss.y + 1
        end

        if boss.state_counter > 64 then
            boss.move_state = ENTITY_STATE_STILL
            boss.state_counter = 0
            boss.dir = DIR_LEFT
        end
    end

    if boss.move_state == ENTITY_STATE_MOVE or boss.move_state == ENTITY_STATE_STILL then
        if wave_collision(boss) then
            sfx(SFX_HURT, 'F-4', -1, 1, 15, -1)
            boss.move_state = ENTITY_STATE_FROZEN
            boss.state_counter = 0
            boss.dir = DIR_LEFT
        end
    end

    if boss.move_state == ENTITY_STATE_FROZEN then
        if particle_collision(boss) then
            sfx(SFX_HURT, 'F-5', -1, 1, 15, -4)
            boss_shoot_missile(0, -0.6)
            boss_shoot_missile(24, -0.5)
            boss.health = boss.health - 1
            boss.move_state = ENTITY_STATE_TELEPORTING
            boss.state_counter = 0
            if boss.y < ((HEIGHT / 2) - 8) then
                boss.dir = DIR_DOWN
            else
                boss.dir = DIR_UP
            end
        end
    end
end

function boss_shoot_missile(x_offset, speed_offset)
    add(
        carrots,
        {
            x=boss.x + x_offset,
            y=boss.y + 13,
            dir=DIR_LEFT,
            sprites=SPRITE_MISSILE,
            spr_counter=0,
            spr_counter_inc=0.1,
            bbox=bounding_box{_, x_min=2, x_max=4, y_min=2, y_max=4},
            state_timeout=0,
            speed=1 + speed_offset,
            iframes=0,
            move_state=ENTITY_STATE_MOVE,
            name="missile",
        }
    )
end

function draw_boss()
    if boss.health == 0 then
        return
    end
    draw_enemy(boss)
end

function update_break_blocks()
    for _, block in ipairs(break_blocks) do
        if not block.broken and particle_collision(block) then
            sfx(SFX_BLOCK, 'E-1', -1, 1, 15, -1)
            if block.cracked then
                block.broken = true
            else
                block.cracked = true
            end
        end
    end
end

function update_entangled_blocks()
    if #block_pair_a ~= 2 then
        return
    end
    if intersect(wave.x, 240+cam.x, wave.y-4, wave.y+4,
                 block_pair_a[1].x, block_pair_a[1].x+7, block_pair_a[1].y, block_pair_a[1].y+7) then
        block_pair_a[1].wave_shot = true
        block_pair_a[2].disappeared = true
        block_pair_a[2].wave_shot = false
        block_pair_a[1].disappeared = false
    elseif intersect(wave.x, 240+cam.x, wave.y-3, wave.y+3,
                     block_pair_a[2].x, block_pair_a[2].x+7, block_pair_a[2].y, block_pair_a[2].y+7) then
        block_pair_a[2].wave_shot = true
        block_pair_a[1].disappeared = true
        block_pair_a[1].wave_shot = false
        block_pair_a[2].disappeared = false
    else
        block_pair_a[1].disappeared = false
        block_pair_a[2].disappeared = false
        block_pair_a[1].wave_shot = false
        block_pair_a[2].wave_shot = false
    end
end

function check_weapon_collision(enemy)
    if particle_collision(enemy) then
        hurt_entity(enemy)
    end
    if wave_collision(enemy) then
        hurt_entity(enemy)
    end
end

function particle_collision(entity)
    entity_bbox = abs_bbox(entity)
    for _, particle in ipairs(particles) do
        if entity_collision(entity, particle) then
            del(particles, particle)
            return true
        end
    end
end

function wave_collision(entity)
    entity_bbox = abs_bbox(entity)
    return intersect(wave.x, 240+cam.x, wave.y-3, wave.y+3,
                     entity_bbox.nw.x, entity_bbox.ne.x, entity_bbox.nw.y, entity_bbox.sw.y)
end

function update_cat(cat, id)
    if t % 60 == 0 then
        if cat.move_state == ENTITY_STATE_STILL then
            cat.move_state = ENTITY_STATE_MOVE
        else
            cat.move_state = ENTITY_STATE_STILL
        end
    end
    move_towards_player(cat)
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
    bird.spr_counter = bird.spr_counter + BIRD_ANIMATION_MOVE_SPEED
    bird.x = bird.x-BIRD_SPEED
    -- fly outside
    if bird.x < cam.x then
        del(enemies_bird, bird)
    end
    check_weapon_collision(bird)
    if bird.dead then
        del(enemies_bird, bird)
    end
    update_iframes(bird)
end

function player_to_attack(entity)
    if entity.y < cam.y + HEIGHT/2 then
        return playerA
    else
        return playerB
    end
end

function get_direction_to_player(enemy, player)
  if math.abs(player.y - enemy.y) > math.abs(player.x - enemy.x) then
    if player.y > enemy.y then
      return DIR_DOWN
    else
      return DIR_UP
    end
  else
    if player.x > enemy.x then
      return DIR_RIGHT
    else
      return DIR_LEFT
    end
  end
end

function move_towards_player(enemy)
    local player = player_to_attack(enemy)
    -- skip if player too far away
    if math.abs(player.x-enemy.x) > WIDTH/2 then
        return
    end
    local dir = get_direction_to_player(enemy, player)
    local delta = enemy.speed
    if inarray(dir, {DIR_LEFT, DIR_UP}) then
        delta = -enemy.speed
    end
    if not is_entity_next_to_solid(enemy, dir) then
        moveEntity(enemy, delta, delta, dir)
        --trace(string.format('%s move %d in dir %d',enemy.name, delta, dir))
    end
end

-- <TILES>
-- 001:ccddccddccddccddddccddccddccddccccddccddccddccddddccddccddccddcc
-- 003:9999999999a999999a9a9999999999999999999999999a999999a9a999999999
-- 004:4444444444444444444444444444444444444444444444444444444444444444
-- 016:00000000eeeeeeeeddddddddccccccccccccccccddddddddeeeeeeee00000000
-- 038:d3333dcc3d3c3dcc3c3d3cdd3c3d3cdd3d22222c3222222cc3333cddc3dd3cdd
-- 040:ddccddcc1111111132222222322222cc3222ccdc3222cddc3222cdcc3222ccc2
-- 041:ddccddcc1111111122222221cc222221dc222221dc222221c222222122222221
-- 042:00dddd000dccddd0ddcddddddddddddddddddddddddddddd0dddddd000dddd00
-- 048:fffffffffdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfddddddd
-- 049:ffffffffdddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 050:ffffffffdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddf
-- 051:fffffffffddddddffddddddffddddddffddddddffddddddffddddddffddddddf
-- 052:ffffffffdddddddddddddddddddddddddddddddedddddddedddddddfdddddddf
-- 053:ffffffffddddddddddddddddddddddddedddddddedddddddfdddddddfddddddd
-- 054:dddddddddddddddddddddddddddddddddddddddedddddddedddddddfdddddddf
-- 055:ddddddddddddddddddddddddddddddddedddddddedddddddfdddddddfddddddd
-- 056:3222222232222222322222223222222232222222111111110f00000001000000
-- 057:222d222122dcd22122ed22212e22222122222221111111110000000f00000001
-- 058:090eea00a00aa0000aaeea00090e00a0a00eeaa00aaaa000900eea000aaa0aa0
-- 064:fdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfddddddd
-- 065:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 066:dddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddf
-- 067:fddddddffddddddffddddddffddddddffddddddffddddddffddddddffddddddf
-- 068:fffffffffdddddddfdddddddfdddddddfddddddefddddddefddddddffddddddf
-- 069:ffffffffdddddddfdddddddfdddddddfeddddddfeddddddffddddddffddddddf
-- 070:dddddddfdddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 071:fddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 072:df000000df000000df000000df000000df000000df000000df000000df000000
-- 073:ddddddddffffffff000000000000000000000000000000000000000000000000
-- 074:000ee000eeeeeeeeed2ed2eeeddeddeeeeeeeeee000000000000000000000000
-- 080:fdddddddfdddddddfdddddddfdddddddfeeeeeeefeeeeeeeffffffffffffffff
-- 081:ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeffffffffffffffff
-- 082:dddddddfdddddddfdddddddfdddddddfeeeeeeefeeeeeeefffffffffffffffff
-- 083:fddddddffddddddffddddddffddddddffeeeeeeffeeeeeefffffffffffffffff
-- 084:fddddddffdddddddfdddddddfdddddddfeeeeeeefeeeeeeeffffffffffffffff
-- 085:fddddddfdddddddfdddddddfdddddddfeeeeeeefeeeeeeefffffffffffffffff
-- 086:ddddddddddddddddddddddddddddddddeddddddeeddddddefddddddffddddddf
-- 087:fddddddfdddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 088:0cccccc0d0c00c0dd0c55c0dd0c55c0d0c5555c0c555655cc565555c0cccccc0
-- 089:11111111777777777ccc7777cc7cc7cccccc7777ccc777cc77ccc77777777777
-- 090:111111117777777777777777c7ccccc777ccccc7c7c7c7c777c777c777777777
-- 091:11111111777777cc77cc777c7cccc7c77c7777cc7c7777777cccc77777cc7777
-- 092:00000002000000d0000000d000000d00000eed0000effe000efddfe00efddfe0
-- 096:fffffffffdddddddfdddddddfdddddddfeeeeeeefeeeeeeeffffffffffffffff
-- 097:ffffffffddddddddddddddddddddddddeeeeeeeeeeeeeeeeffffffffffffffff
-- 098:ffffffffdddddddfdddddddfdddddddfeeeeeeefeeeeeeefffffffffffffffff
-- 099:fffffffffddddddffddddddffddddddffeeeeeeffeeeeeefffffffffffffffff
-- 100:dddddddfddddddddddddddddddddddddeeeeeeeeeeeeeeeeffffffffffffffff
-- 101:fdddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeffffffffffffffff
-- 105:11111111c1ddccddd1ccddccd1ccddcc111dccddccddccddddccddccddccddcc
-- 106:11111111ccddccddddccddccddccddccccddccddccddccddddccddccddccddcc
-- 107:11111111ccddc1ddddccd1ccddccd1ccccdd111dccddccddddccddccddccddcc
-- 112:222222222222222222222222222222222222222222222222222222222222222d
-- 113:22222222222222222222222222222222222222222222222222222222ffffffff
-- 114:22222222222222222222222222222222222222222222222222222222ffffffff
-- 115:22222222222222222222222222222222222222222222222222222222ffffffff
-- 116:22222222222222222222222222222222222222222222222222222222ffffffff
-- 117:22222222222222222222222222222222222222222222222222222222ffffffff
-- 118:22222222222222222222222222222222222222222222222222222222ffffffff
-- 119:22222222222222222222222222222222222222222222222222222222f2222222
-- 120:d222222f2d2222f222d22f22222dd222222ff22222d22f222d2222f2d222222f
-- 121:d444444f4d4444f444d44f44444dd444444ff44444d44f444d4444f4d444444f
-- 128:2222222d2222222d2222222d2222222d2222222d2222222d2222222d2222222d
-- 129:cccccccc0000cc00c00cc000c00ccc00c00ccccc0000c000cccccccccccccccc
-- 130:cccccccc00c00000ccc00ccc0cc0000c00c00ccc0cc00000cccccccccccccccc
-- 131:ccccccccc00cc0c0c000c0c0c00000c0c00c00c0c00cc0c0cccccccccccccccc
-- 132:cccccccc0cc0c0000c0cc00c00ccc00c0c0cc0000cc0c00ccccccccccccccccc
-- 133:cccccccc0ccc000cc0c00cc0c0c00cc00cc00000c0c00cc0cccccccccccccccc
-- 134:ccccccccc00c00ccc00000ccc00000ccc0c0c0ccc0ccc0cccccccccccccccccc
-- 135:f2222222f2222222f2222222f2222222f2222222f2222222f2222222f2222222
-- 136:022222202dddddd22d3333d22d3333d22d3333d22d3333d22dddddd202222220
-- 137:0f2222202dfdddd22d3f33d22d3f33d22d3f33d22d33f3d22ddddfd2022222f0
-- 144:2222222222222222222222222222222222222222222222222222222222222222
-- 145:22222222222222222222222222222222dfffffffd8888888d8888338d8883883
-- 146:22222222222222222222222222222222ffffffff888888888888888888888888
-- 147:22222222222222222222222222222222ffffffff88888888888888888dddddd8
-- 148:2222222222222222222222222222222dfff2222d88f2222d88f2222d88f2222d
-- 149:222222222222222222222222ffffffff2ccccccc2cccdccc2ccdcccc2cdccccc
-- 150:222222222222222222222222fffff222ccc2f222ccc2f222ccc2f222dcc2f222
-- 151:2222222222222222222222222222222222222222222222222222222222222222
-- 160:2222222222222222222222222222222222222222222222222222222222222222
-- 161:d8888338d888ddddd888ddddd888deddd888deddd888ddddd888ddd8d888dd88
-- 162:888888888888888d8888888d8888888d8888888d888888888888888888888888
-- 163:dd888edddee8e88d888e8888d8e8e888de888e8ddd8888dd8dddddd888dddd88
-- 164:88f2222dd8f2222dd8f2222dd8f2222dd8f2222d88f2222d88f2222d88f2222d
-- 165:2ccccccd2cccccdc2ccccccc2222222222222222222222222ff222222ff22222
-- 166:ccc2f222ccc2f222ccc2f2222222f2222222f2222222f2222222f2222222f222
-- 167:2222222222222222222222222222222222222222222222222222222222222222
-- 176:2222222222222222222222222222222222222222222222222222222222222222
-- 177:2222222222222222222222222222222222222222222222222222222222222222
-- 178:2222222222222222222222222222222222222222222222222222222222222222
-- 179:2222222222222222222222222222222222222222222222222222222222222222
-- 180:2222222d2222222d2222222d2222222d2222222d2222222d2222222222222222
-- 181:2222222222222222222222222222222222222222222222222222222222222222
-- 182:2222f2222222f2222222f2222222f2222222f2222222f2222222222222222222
-- 183:2222222222222222222222222222222222222222222222222222222222222222
-- 224:5555555555555555555555555555555555555555555555555555555555555555
-- 225:6666666666666666666666666666666666666666666666666666666666666666
-- 226:6666666665665666566566566666666666556666655665666566566666666666
-- 227:5555555555555555555dde555ddddde55ddddde5ddddddeedddddddeddddddde
-- 228:4444444444444444444dde444ddddde44ddddde4ddddddeedddddddeddddddde
-- 229:5555555556666655566666656666666666666666566666655666666555666655
-- 230:5555555556666655565266656622666666666666566652655666226555666655
-- 231:5555555555556665556615655666666556566566561651665666666555666655
-- 232:5555555555556665556666655666666556666666566666665666666555666655
-- 234:5555555455555543555554335555433355543333554333335433333343333333
-- 235:4444444433333333333333333333333333333333333333333333333333333333
-- 236:4555555534555555334555553334555533334555333334553333334533333334
-- 237:333333333333333333333333444444444ffffff44fffcff44ffcfff44fcffff4
-- 238:3333333333333333333d4444333d4444333d4444333d4fff333d4ffc333d4fcf
-- 239:3333333333333333444444434444444344444443ffffcf43fffcff43ffffff43
-- 240:4444444444444444444444444444444444444444444444444444444444444444
-- 241:4444444444444344444434344444444444444444443444444343444444444444
-- 242:3333333333333433333343433343333334343333333334333333434333333333
-- 243:5555555555535555555355553333333355535555555355553333333355535555
-- 244:4444444444434444444344443333333344434444444344443333333344434444
-- 245:5553355555533535555333555553f55555533555555335555533335553333335
-- 246:5553355555533555555335555553355555533555555335555533335553333335
-- 247:5553355553533555553335555553355555533555555335555533335553333335
-- 250:4333333343333333433333334333333343333333433333334333333343333333
-- 251:3333333333333333333333333333333333333333333333333333333333333333
-- 252:3333333433333334333333343333333433333334333333343333333433333334
-- 253:4ffffcf44fffcff44ffcfff44ffffff444444444333333333333333333333333
-- 254:333d4444333d4444333d4444333d4444333d4444333d4444333d4444333d4444
-- 255:4444444344444443444444434444434344444443444444434444444344444443
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
-- 042:000000000aa00000aaaa00009aa9000009900000000000000000000000000000
-- 043:0ffc9cf0fffe9eff0fff92220ffff4140fffff100ffffff20ff0002022200000
-- 044:0020000002200000222000000120000000100000000000000000000000000000
-- 045:00ffef000fefefe0efccccf00eccccc00ccfcfc00cccdcc00ccfefc000cccc00
-- 046:000000000000000000cccc000cccccc00ccfcfc00cccdcc00ccfefc000cccc00
-- 047:000000000000000000cc00000ccfc000cfcdcf00ccccec000ccfcc0000ccc000
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
-- 058:000000000aa00000aaaa00009aa9000009900000000000000000000000000000
-- 059:0ffc9cf0fffe9eff0fff92220ffff41402ffff1002fffff000200ff000000222
-- 060:0020000002200000222000000120000000100000000000000000000000000000
-- 061:0cccccc0cc0dc0ccc0cccc0cc00dc00cd0cccc0d000cc00000c00c00ccc00ccc
-- 062:0cccccc0cc0dc0ccc0cccc0cc00dc00cd0cccc0d000cc00000c00c00ccc00ccc
-- 063:00000000000000000cccccc0cc0dc0ccc0cccc0cc00dc00cd0cccc0dcccccccc
-- 064:0000444400444444004444440004444f000444f400004444000044ff333333ff
-- 065:4403000044f30f0044ffff004ff2f2f04ffffff0ffff1ff0ffffff00fffc0fc0
-- 077:00000000000000000000000000cc00000ccfc000cfcdcf00ccccec000ccfcc00
-- 078:0000000000000000000000000000000000cc00000ccfc000cfcdcf00ccccec00
-- 079:000000000000000000000000000000000000000000cc00000ccfc000cfcdcf00
-- 084:0000000f000000f4000000f400000f4400000f440000f4440000f4f4000f4ff4
-- 085:f00000004f0000004f00000044f0000044f00000444f00004f4f00004ff4f000
-- 087:0eeeeeeeeeddddddedddddddedddddddedddddddedddddddedddddddeddfffdd
-- 088:eeeeeee0ddddddeedddddddedddddddedddddddedddddddedddddddeddddddde
-- 093:00ccc00000000000000000000cccccc0cc0dc0ccc0cccc0cc00dc00ccccccccc
-- 094:0ccfcc0000ccc00000000000000000000cccccc0cc0dc0ccc0cccc0ccccccccc
-- 095:ccccfc000ccfcc0000ccc00000000000000000000cccccc0cc0dc0cccccccccc
-- 096:6666666666666666666666666666666666666666666666666666666666666666
-- 097:7777777777777777777777777777777777777777777777777777777777777777
-- 098:0c0c0c0cc00000000000000cc00000000000000cc00000000000000cc0c0c0c0
-- 100:000ffff400f4444f00f4444f0f4444440f44444ff44444fff44444440fffffff
-- 101:4ffff000f4444f00f4444f00444444f0f44444f0ff44444f4444444ffffffff0
-- 103:eddddfddedddfdddeddfddddeddfffddedddddddeeddddddeeeeeeee0eeeeeee
-- 104:dddddddedddddddedddddddedddddddedddddddeddddddeeeeeeeeeeeeeeeee0
-- 109:00000000000000000000000000000000000000000000000000cc00000ccfc000
-- 110:0000000000000000000000000000000000000000000000000000000000cc0000
-- 112:02c0220022c22220ccccccc002c2220000c22000000200000000000000000000
-- 116:0000000000000000000000000000000000000000000000000000c00d00000cdc
-- 117:000000000000000000000000000000000000000000d000000c00c000ccdc0000
-- 119:0eeeeeeeeeddddddedddddddedddddddedddddddedddddddedddddddeddfdfdd
-- 120:eeeeeee0ddddddeedddddddedddddddedddddddedddddddedddddddeddddddde
-- 122:0000000200000023000002330000233200002320000002000000000000000000
-- 123:2200000033200000333200002233200000232000002320000232000023320000
-- 125:cfcdcf00ccccfc000ccfcc0000ccc00000000000000000000cccccc0cccccccc
-- 126:0ccfc000cfcdcf00ccccfc000ccfcc0000ccc0000000000000000000cccccccc
-- 127:00cc00000ccfc000cfcdcf00ccccfc000ccfcc0000ccc00000000000cccccccc
-- 131:000000000000000000000000000000000000000000000000000000770000077f
-- 132:00000ccc0000004400000dd40000042d0000244c000024cf007777447777777e
-- 133:cdccc0004ccd0000dd4cd000244cc000c4422000fc40200044777700d7777770
-- 134:000000000000000000000000000000000000000000000000077000007f770000
-- 135:eddfdfddedddfdddeddfdfddeddfdfddedddddddeeddddddeeeeeeee0eeeeeee
-- 136:dddddddedddddddedddddddedddddddedddddddeddddddeeeeeeeeeeeeeeeee0
-- 138:0000000200000002000000020000000200000000000000000000000000000002
-- 139:3320000032000000320000003200000020000000000000002000000032000000
-- 144:0075550000077550000075250000755500075550006655550007656000007666
-- 145:7555000007755000007525000055550000755550007656000067666600000000
-- 147:000007f7000002770000002200000077000007f70000077f0000007700000000
-- 148:7777777e277ff77e1f77777e102222227011111170077777000777f00077777f
-- 149:d7777777d77ff777d77777f7222222f0111111f077777f0000777f00077777f0
-- 150:77f7000027720000122000001770000077f700007f7700000770000000000000
-- 151:000000000000020000002002022ccc2222ccccc0011ddd220000100100000100
-- 155:2000000000000000000000000000000000000000000000000000000000000000
-- 157:0000000000cc00000ccfc000cfcdcf00ccccfc000ccfcc0000ccc000cccccccc
-- 158:000000000000000000cc00000ccfc000cfcdcf00ccccfc000ccfcc00cccccccc
-- 160:0000000000600000060300000003300000003000000003000000000000000000
-- 164:0070007f00000000000000000000000000000000000000000000000000000000
-- 165:070007f000000000000000000000000000000000000000000000000000000000
-- 168:0000000200000023000000230000002300000023000000020000000200000002
-- 169:2200000033200000332000003320000033200000320000003200000032000000
-- 170:0000000200000023000000230000023300000233000000220000000000000000
-- 171:2200000033200000332000003232000022320000023200002320000033200000
-- 176:0000000040000000049090000490900004909000044444400990099000000000
-- 180:0000000000000000000000000000000000000000000000000000c00d00000cdc
-- 181:000000000000000000000000000000000000000000d000000c00c000ccdc0000
-- 184:0000000200000002000000020000000000000000000000000000000000000002
-- 185:3200000032000000320000002000000000000000000000002000000032000000
-- 186:0000000200000002000000020000000000000000000000000000000000000002
-- 187:3200000032000000320000002000000000000000000000002000000032000000
-- 189:0000000000000002000000230000002300000232000000200000000000000000
-- 190:2200000033200000333200003332000023320000233200003320000033200000
-- 192:0000000000099000009bb90009b99b9009b99b90009bb9000009900000000000
-- 195:000000000000000000000000000000000000000000000000000000aa00000aaf
-- 196:00000ccc000000cc00000ddc00000c2d00002ccc00002ccf00aaaacfaaaaaaae
-- 197:cdccc000cccd0000ddccd0002cccc000ccc22000fcc02000fcaaaa00daaaaaa0
-- 198:0000000000000000000000000000000000000000000000000aa00000afaa0000
-- 199:0000000000006000000600000060000000060000000060000006000000600000
-- 201:2000000000000000000000000000000000000000000000000000000000000000
-- 203:2000000000000000000000000000000000000000000000000000000000000000
-- 205:0000000200000002000000020000000200000000000000000000000000000002
-- 206:3320000032000000320000003200000020000000000000002000000032000000
-- 211:00000afa000002aa00000022000000aa00000afa00000aaf000000aa00000000
-- 212:aaaaaaae2aaffaae1faaaaae10222222a0111111a00aaaaa000aaaf000aaaaaf
-- 213:daaaaaaadaaffaaadaaaaafa222222f0111111f0aaaaaf0000aaaf000aaaaaf0
-- 214:aafa00002aa20000122000001aa00000aafa0000afaa00000aa0000000000000
-- 215:0000000000600000000600000000600000060000006000000006000000006000
-- 218:0000000200000023000000230000002300000023000000020000000200000002
-- 219:2200000033200000332000003320000033200000320000002200000032000000
-- 222:2000000000000000000000000000000000000000000000000000000000000000
-- 228:00a000af00000000000000000000000000000000000000000000000000000000
-- 229:0a000af000000000000000000000000000000000000000000000000000000000
-- 234:0000000200000002000000020000000000000000000000000000000000000002
-- 235:3200000032000000320000002000000000000000000000002000000032000000
-- 251:2000000000000000000000000000000000000000000000000000000000000000
-- </SPRITES>

-- <MAP>
-- 000:631515151515157363151515151515151515151515151515151515151515157363151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515731414146315151515151515151515151515157363151515151515151515151515151515151515151515151515151515151515151515151573631515151515151515151573141414141414141414146315151515151515151515731414141414141414141463151515151515736315151515151515151515736315151515151515151515736315151515151515151515156515151515151515151573
-- 001:241010101010100424101010101010101010101010101010101010101010100424071727374757677710101010101010101010101010101010101010101010101010101010101010101010101010101010101010041414142410101010101010101010101010100525101010101010101010101010101010101010101010101010101010101010101010101004241010101010101010101005731414141414141414632510101010101010101010057314141414141414146325101010101010042410101010101010101010042410101010101010101010042430303030303030101010103410101010101010104004
-- 002:241010101010100424101010101010101010101010101010101010101010100424081828384858687810101010101010101010101010101010101010101010101010101010101010101010101010101010101010041414142410101010101010101010103610101010101010101010101036101010101010101010101010101010101010101010101010101004241010101010101010101010057314141414141463251010101010101010101010100573141414141414632510101010101010042410101010101010101010042410101010101010101010042430303030303030103310103410103310101010104004
-- 003:241010101010100424101010100323101010100323101010101010101010100424091929394959697910101010101010100313131313231010101003131313132310101010031313131323101010101010101010051515152510101010101010101010101010101010101010361010101010101010101010101010101010101010101010101010101010101004241010101030301010101010100573141414146325101010101003131323101010101005731414141463251010101010101010042410101010101010101010042410101010101010101010042430303030303010103410103410103410101010104004
-- 004:2410101010101005251010101004241010101005251010101003231010101004240a1a2a3a4a5a6a7a10101010101010100414141414241010101004141414142410101010041414141424101010101010101010101010101010101010101010101010101010361010101010101010101010101010101010101010101010101006161616162610101010101005251010101003231010101010101005731414632510101010100374141464231010101010057314146325101010101010101010052510101010032310101010052510101010032310101010052530303030303010103410103410103410101010104004
-- 005:2410101010101010101010101004241010101010101010101004241010101005250b1b2b3b4b5b6b7b10101010101010100515151515251010101005151515152510101010051515151525101010101010101010031313132310101010101010103610101010101010101010101010361010101010361010101010101010101030303030303010101010101030301010101004241010101010101010051515251010101010037414141414642310101010100515152510101010101010101010101010101010042410101010101010101010042410101010101010103030303010103410103410103410101010104004
-- 006:241010101010101010101010100424101010101010101010100424101010101010101010101010101010101010101010103030303030301010101010101010101010101010101010101010101010101010101010041414142410101010101010101010331010101010103610101010101010101010101010101010101010303030303030303030301010101010101010101004241010101010101010101010101010101003741414141414146423101010101010101010101010101010101010101010101010042410101010101010101010042410101010101010101010301010103410103510103410101010104004
-- 007:241010101010101010101010100424101010101010101010100424101010101010101010101010101010101010101010103030303030301010101010101010101010101010101010101010101010101010101010041414142410101010101010101010341010101010101010101010101003231010101010101010101030303030303030303030303010101010101010101004241010101010101010101010101010100374141414141414141464231010101010101010101010101010101010101010101010042410101010101010101010042410101010101010101010101010103410101010103410101010104004
-- 008:240101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 009:241010101010100424101010101010101010101010101010101010101010100424071727374757677730303030101010101010101010101010101010101010101010101010303030303030101010101010101010041414142410101010101010303030303030303030051515152530303030303030303030303030301010101010101010101010101010101004241010101010101010101005731414141414141414632510101010101010101030057314141414141414146325101010101010101010101010042410101010101010101010042410101010101030303030303030101010103410101010101010104004
-- 010:241010101010100424101010101010101010103030301010101010101010100424081828384858687830303030101010101010101010101010101010101010101010101010303030303030101010101010101010041414142410101010101010101010101010101010101010101010101010101010103030303030101010101010101010101010101010101004241010101010101010101010057314141414141463251010101010101010101030300573141414141414632530101010101010101010101010042410101010101010101010042410101010101010303030303030103310103410103310101010104004
-- 011:241010101010100424101010100323101010303030303010101010101010100424091929394959697930303010101010100313131313231010101003131313132310101010031313131323101010101010101010051515152510101010101010101010101010101010101010101010101010101010303030303010101010101010101010101010101010101004241010101030301010101010100573141414146325101010101003131323101010303005731414141463253030101010101010101010101010042410101010101010101010042410101010101010103030303010103410103410103410101010104004
-- 012:2410101010101005251010101004241010103030303030301003231010101004240a1a2a3a4a5a6a7a30301010101010100414141414241010101004141414142410101010041414141424101010101010101010101010101010101010101006161616161616161616161616161616161616161616162630101010101010101006161616162610101010101005251010101003231010101010101005731414632510101030300374141464231010103010057314146325303010101010101010032310101010052510101010032310101010052510101010032310103030303010103410103410103410101010104004
-- 013:2410101010101010101010101004241010101030303010101004241010101005250b1b2b3b4b5b6b7b30101010101010100515151573241010101005151515152510101010051515151525101010101010101010031313132310101010101010101010101010101010101010101010101010101010101010101010101010101030303030303010101010361030301010101004241010101010101010051515251010103030037414141414642310101010100515152530301010101010101010042410101010101010101010042410101010101010101010042410103030303010103410103410103410101010104004
-- 014:241010101010101010101010100424101010101010101010100424101010101010101010101010101010101010101010101010101005251010101030303030303010101010101010101010101010101010101010041414142410101010101010101010101010101010101010101010101010101010101010101010101010303030303030303030301010101010101010101004241010101010101010101010101010303003741414141414146423101010101010101010301010101010101010042410101010101010101010042410101010101010101010042410101010301010103410103510103410101010104004
-- 015:241010101010101010101010100424101010101010101010100424101010101010101010101010101010101010101010101010101010101010101030303030303010101010101010101010101010101010101010041414142410101010303030303030303030303030031313132330303030303030101010101010101030303030303030303030303010101010101010101004241010101010101010101010103030300374141414141414141464231010101010101010101010101010101010042410101010101010101010042410101010101010101010042410101010101010103410101010103410101010104004
-- 016:641313131313131313131313137464131313131313131313137464131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313741414146413131313131313131313131313131313741414146413131313131313131313131313131313131313131313131313131313131313131313131374641313131313131313131313131313137414141414141414141414641313131313131313131313131313131313746413131313131313131313746413131313131313131313746413131313131313137513131313137513131313131374
-- 017:631515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151573
-- 018:240e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0eaebeceaebece0e0e0f0f0e2e2e2e2e2e2e0e0e0e0e3e8e8e8e303030303030301f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f0e0e0e3030300e0e3e3e3e3e0e0eaebebebebece0e0e0e0e0e0e0e0e0e0e0e0e0e0f0e0e0e0e0e0e0e6e5e8e6e0e0e0e0e0e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e0e0e0eaebece0e0e0e0e0e0e0e0e0e0e0e0e0e2e2e2e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e30303030303030300e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 019:240e0e0e0e0e0e7e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0edeeefedeeefe0e0e0f0f0e0e0e0e2e0e0e0e0e0e0e3e3e3e3e303030303030301f1f1f1f1f1f1f1f1f1f2f2f2f1f1f1f1f1f4e1f1f1f2f2f1f1f1f1f1f1f1f1f1f1f1f0f0f0e3030300e0e3e3e3e3e0e0eafdebfeefecf0e0e0e0e0e0e0e0e0e0e0e0e0e0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e1e1e1e1e2e2e2e2e2e2e2e1e1e0e0e0e0eafbfcf0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e2e2e0e0e0e0e0e0e3030303030300e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 020:240e0e0e0e0e0e7f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0edfefffdfefff0e0f0f0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e3e303030303030301f1f1f1f1f1f1f1f1f2f2f2f2f2f1f1f1f1f1f1f1f2f2f2f2f1f1f1f1f4e1f1f1f1f1f0e0f0e0e0e0e0e0e0e0e0e0e0e0eafdfbfefffcf0e0e0e0e0e0e0e0e0e0e0e0e0e0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e1e1e1e1e1e1e1e1e1e1e1e0e0e0e0edeeefe0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e2e2e2e2e2e2e2e2e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 021:2440404040404040404040404040404040404040404040404040404040400f0f0f0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0f0f0f0f0f0f0f0f1f1f1f1f1f1f1f1f2f2f2f2f2f1f1f1f1f1f1f1f2f2f2f2f1f1f1f1f1f1f1f1f1f0e0e0f0f0f0f0f0f0f0f0f0f0f0f0f2e2e2e0f0f2e0e0e0e0e0e0e0e0e0e0e0e0e0e0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e3e1e1e1e0e0e0e0e0edfefff0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e2e2e2e1e1e1e1e2e2e2e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 022:24404040404040404040404040404040404040404040404040404040400f0f0f0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0f0f0f0f0f0f0f0f1f1f1f1f1f4e1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f2f2f2f1f1f1f1f1f1f1f1f0e0e0e0e0e6e0e0e0e0e0e0e0e8e3e0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e2e2e2e2e2e2e2e2e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 023:240e0e0e0e0e0e0e0e0e0e0e0e0e0e2e1e1e1e1e2e2e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e3e30303030303030301f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f2f2f2f1f1f1f1f1f1f1f1f0e0e0e0e5e6f8e3e0e0e0e0e7e6e8e8e7e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e303030300e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 024:240e0e0e0e0e0e0e0e0e0e0e0e0e2e2e1e1e1e1e2e2e2e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e3e30303030303030301f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f0e0e0e3e6f3e5f3e0e0e0e0e0e5f3e6f0e0e0e0e7e8e8e0e0e0e0e0e0e0e0e0e0e0e0e0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e303030300e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e3e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 025:243f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f303030303030303030304f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f4f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f04
-- 026:240e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e2e2e2e2e2e2e2e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5e8e3030303030303030302f2f2f2f2f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f2f2f2f2f2f1f1f1f1f1f0e0e0e0e0e8e3e0e0e0e0e0e0e6e0e8e0e0e0e0e7e8e8e0e0e0e0e2e2e2e2e0e0e0e0e0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e3e3e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 027:240e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e2e2e2e2e2e2e2e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5e8e303030303030301f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f4e1f1f1f1f1f1f1f2f2f1f1f1f1f4e1f0e0e0e3e6e5f5e0e0e0e0e0e7e5f8e6f7e0e0e0e8e8e7e0e0e2e2e2e2e2e2e2e0e0e0e0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e3e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 028:244040404040404040400e0e0e0e0eaebeceaebece0e0e0e2e2e2e2e2e0e0e0e0e0e0e0e0e0e30300e0e0e0e0e0e0e0e0e0e0f0f0f0f0f0f0f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f0e0e0e0e7f3e6f0e0e0e0e0e0e8e3e0e0e0e0e0e7e8e8e0e0e2e2e2e2e2e2e2e0e0e0e0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e07172737475767770e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 029:24404040404040404040400e0e6e0edeeefedeeefe0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e3030303030300e0e0e0e0e0e0e0e0f0f0f0f0f0f0f1f1f1f1f1f1f1f1f1f1f1f1f1f1f2f2f2f2f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f0e0e0f0f0f0f0f0f0f0e0e0e0e0e0e0e0e0e0e8e7e8e0e0e0e2e2e2e2e2e2e0e0e0f0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e3e0e0e0e0e0e0e0e0e0e0e0e0e08182838485868780e0e0e0e0e0e0e0e0e0e0e0e1e1e1e1e1e1e1e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 030:240e0e0e0e0e0e0e404040400e6f0edfefffdfefff0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e303030303030306e7e0e0e0e0e0e303030303030301f1f1f1f1f1f1f1f1f1f1f1f2f2f2f2f2f2f2f2f1f1f1f1f1f1f1f1f1f1f1f1f1f1f0e0f0e0e0e0e0e0f0f0f0f0f0f0f0f0f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0f0f0e0e0e0e0e0e0e8e5e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e3030300e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e09192939495969790e0e0e0e0e0e0e0e0e1e1e1e1e2e2e2e1e1e1e1e1e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 031:240e0e0e0e0e0e0e0e4040404040404040404040400f0f0f0f0f0f0f0f0f400e0e0e0e30303030303030307f6f8e5e5e3030303030303030301f1f1f1f1f4e1f1f1f1f1f2f2f2f2f2f2f2f2f2f1f1f1f1f1f4e1f1f1f1f1f1f1f1f0f0f0e3030300e0e3e3e3e3e0e0e0e0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0e0e0e0e0e5e8e5e6f6f8e0e0e0e0e0e0e0e0e0e0e0e0e0e0e30303030300e0e0e0e0e3e0e0e0e0e0e0e0e0e0e0e6e0e0e0e0e0e0a1a2a3a4a5a6a7a0e0e0e0e0e0e0e1e1e1e1e2e2e2e2e2e2e2e1e1e1e1e0e6e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 032:240e0e0e0e0e0e0e0e0e404040404040404040400f0f0f0f0f0f0f0f0f0f40400e0e30303030303030303030303030303030303030303030301f1f1f1f1f1f1f1f1f1f2f2f2f2f2f2f2f2f2f2f1f1f1f1f1f1f1f1f2f2f2f1f1f1f0e8e0e3030300e0e3e3e3e3e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5f0e5f0e0e7f0e0e0e0e0e0e0e0e0e0e8e8e0e3030303030300e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e6f0e0e0e0e0e0b1b2b3b4b5b6b7b0e0e0e0e6e1e1e1e1e1e1e1e1e1e2e2e2e1e1e1e1e1e0e5f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e4004
-- 033:641313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131374
-- 034:000000000000000000000000000000000000000000000000000000000000151515151515151515151515151515151515151515151515151515151523000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 035:00000000000000000000000000000000000000000000000000000000000024101010101095a5b510101010101084a200101010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 036:00000000000000000000000000000000000000000000000000000000000024101010101096a6b610101010101084a300101010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 037:00000000000000000000000000051515151515151515150000000000000024101010101010101010101010101084a400101010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 038:1313138513131395a5b51313231010108400000000000400000000000000241010101010101010101010101010101010101010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 039:061616161616161616161616261010108400000000000400000000000000241010101010101010101010101010101010101010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 040:101010101010101010101010101010108400a200a2000400000000000000241010108292101010106282921010101010101010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 041:101010108292101010101010101010108400a300a3000400000000000000241010628393101010101083931010101010101010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 042:101010628393101010101062101010108400a4c5a4000400000000000000010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 043:1010101010101010101010829210101084000000000004000000000000002410101010101095a5b51010101010101084a20010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 044:1010101010101010101062839310101084000000000004000000000000002410101010101096a6b61010101010101084a30010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 045:061616161616161616161616161616161616161616161500000000000000241010101010101010101010101010101084a40010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 046:000000000000000000000000000000000000000000000000000000000000241010101010101010101010101010101010101010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 047:000000000000000000000000000000000000000000000000000000000000241010101010101010101010101062101010101010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 048:000000000000000000000000000000000000000000000000000000000000241010101010628292101010101082921010101010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 049:000000000000000000000000000000000000000000000000000000000000241010101010108393101010101083931010101010101010101010101034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 050:000000000000000000000000000000000000000000000000000000000000131313131313131313131313131313131313131313131313131313131313000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- 048:440324050406040604070407040614043402540e640d740b840aa40ab409c408d408e408e408e408f408f408f408f408f408f408f408f408f408f408204000000000
-- 049:42032205020602052202620fb200920282028202b202c202d201d20fe20de20be208e208e208e208e208f208f208f208f208f208f208f208f208f208401000000000
-- 050:24030404040514066407740764068404a403c402d400d40ec40cc40bc409d408d408e408f408f408f408f408f408f408f408f408f408f408f408f408005000000000
-- 051:500040002000200020003001400250028000b001b003c006d007d006d006d005e006e007e007e007f007f007f007f007f007f007f007f007f007f007101000000000
-- 052:22e012e012e00270027002700210021002100200020012001200120012001200120012002200220022002200320032003200420062008200d200f200402000000000
-- 053:44033405240614061407340764069403b4028401740154016400840fb40ec40ec40cb40bc40bc40bd40be409f409f408f408f408f408f408f408f408004000000000
-- 054:71025103410511060106010601060105010401021100210e410a61089109b109c108d108d108d108d108e108e108f109f109f109f109f109f109f109201000000000
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
-- 037:b00076000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800076000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 038:f00066000000000000000000000000000000000000000000000000000000000000000000400068000000000000000000f00066000000000000000000000000000000000000000000d00066000000000000000000000000000000000000000000b00066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b00066000000000000000000000000000000000000000000d00066000000000000000000000000000000000000000000
-- 039:600058000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f00056000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 040:600098000000000000000000000000000000f00096000000000000000000000000000000d00096000000000000000000000000000000f00096000000000000000000000000000000000000000000000000000000000000000000600098000000400098000000000000000000000000000000f00096000000000000000000000000000000d00096000000000000000000000000000000b00096000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:180000180ec3180ec3180301581702581982581b43585c430542533694633155533155538567538d6a53dd7063e58263200000
-- 001:054253369463000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:6e98206e98206e986a6e986a000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <FLAGS>
-- 000:00001020400000000000000000000000101010000000001000000000000000001010100000000010000010000000000010101010101010100000100000000000101010101010101000001000000000001010101010101010101010101000000010101010101000000000000000000000101010101010101000000000000000001010101010101010000000000000000010101010101010100000000000000000101010101010101000000000000000001010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010100000001010101000000010101010100000000010101010
-- </FLAGS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

