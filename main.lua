require('player')
require('transition')
require('bg')
require('conf')
require('enemy')
require('state_update')
require('state_draw')
require('crosshair')

require('lib/particles')
require('projectiles')
local bitser = require 'lib/bitser'
flux = require 'lib/flux'



state={'intro','menu','game','pull'}
current_state = state[2]
love.graphics.setBackgroundColor(0.7,0.3,0.1 , 1)
window_width = 1280
window_height = 720
full=false

sounds={}
sounds.menu_music = love.audio.newSource('sounds/menu_music.mp3', 'stream')
sounds.menu_music:setLooping(true)
sounds.laser_fire_sound = love.audio.newSource('sounds/laser.wav', 'static')
sounds.select_sound = love.audio.newSource('sounds/select.wav', 'static')
sounds.start_game_sound = love.audio.newSource('sounds/start_game.mp3', 'static')
sounds.buzz = love.audio.newSource('sounds/buzz.mp3', 'static')

--src1:setVolume(0.9) -- 90% of ordinary volume
--src1:setPitch(0.5) -- one octave lower
--src2:setVolume(0.7)

cam={100,0}


function love.load()

    sounds.menu_music:play()
    load_data()
    selected=1
    selection_box={x=window_width/2-window_width/3/2,w=window_width/3}
    math.randomseed(os.time())
    
    love.mouse.setVisible(true)
    

    --[[
    for i=2, 8 do 
        table.insert(character_storage,tostring(i))
    end
    --]]

    love.graphics.setDefaultFilter('nearest', 'nearest')
    enter_state(current_state)
    config={}
    
end

function love.update(dt)
    flux.update(dt)
    global_dt=dt
    scale_x,scale_y = love.graphics.getWidth()/1280,love.graphics.getHeight()/720
    window_width = 1280
    window_height = 720
    update_mouse()
    bg:update(dt)
    state_update(dt)
    transition:update(dt)
end


function love.draw()
    love.graphics.push()
    love.graphics.scale(scale_x,scale_y)
    bg:draw()
    state_draw(current_state)
    transition:draw()



    draw_crosshair()
    love.graphics.pop()
    love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',16))
    love.graphics.print('Current FPS: '..tostring(love.timer.getFPS()), 10, 10)
end

function switch_state(state)
    exit_state(current_state)
    current_state=state
    enter_state(current_state)
end

function exit_state(index)
    if index=='intro' then
    
    elseif index=='menu' then
        bg:stop()
    elseif index=='game' then
    
    elseif index=='pull' then
        selected=2
        flux.to(selection_box, 0.4, { x = selected*window_width/3}):ease('elasticout') 
    end
end


function enter_state(index)
    if index=='intro' then
        intro_timer=5
        logo_x = 1500
        love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',100))
        logo_image = love.graphics.newImage('images/ui/grape_pfp_pixel.png')
    elseif index=='menu' then
        make_crosshair()
        level = 2
        rectangle_alpha=1
        character_info={
            {'Astro','Can do a dodge roll and has a \'pew pew\' gun.'},
            {'Pun Chi','Can realease a powerful punching barrage on enemies. Uses fists to fight.'},
            {'Nerd Ghost','Can Teleport anywhere on screen. Enemies near take damage. Throw various school related items that have different effects. (peirce, aoe, higher damage)'},
            {'Mancy','Can revive enemies into helpers with a necromancy ring. Shoots a dark orb projectile'},
            {'Pop Star','Shoots a star shaped bubble that does AOE damage around itself on impact. Blast sound waves in a cone to damage enemies.'},
            {'s','s'},
            {'Country Xeno','xyz'},
            {'',''},
            {'',''},
            {'',''},
        }

        empty = love.graphics.newImage('images/ui/empty_upgrade.png')
        full = love.graphics.newImage('images/ui/full_upgrade.png')

        circle_icon = love.graphics.newImage('images/ui/black_circle.png')
        icons={love.graphics.newImage('images/ui/attack_icon.png'),love.graphics.newImage('images/ui/health_icon.png'),love.graphics.newImage('images/ui/speed_icon.png')}


        bg:init()

        buy_button={w=400,h=100}
        buy_button.x=window_width/2-buy_button.w/2
        buy_button.y=window_height/4*3-buy_button.h/2

        left_arrow_image=love.graphics.newImage('images/ui/left_arrow.png')
        right_arrow_image=love.graphics.newImage('images/ui/right_arrow.png')
        menu_selected_character=1
        character_frame_tick=0
        character_frame=1
        


        --store character images
        my_character_images={}
        for i=1,8 do
            table.insert(my_character_images,love.graphics.newImage('images/characters/character-'..tostring(i)..'.png'))
        end

        --store the quads for the images
        my_quads={}
        for i=0,3 do
            table.insert(my_quads, love.graphics.newQuad(i * 48, 0,48 ,48 ,my_character_images[1]))
        end
        
        --config variables
        check = love.graphics.newImage('images/ui/check.png')
        fullscreen_box={500,300}


        love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',75))

        clicked_start=false
        
        
        squash=0
        start_button_image = love.graphics.newImage('images/ui/blue_button.png')
        start_button={window_width/2-start_button_image:getWidth()/2-100,window_height/2+200}


        

        goal_x=window_width/2-window_width/3-0
        line_left=window_width/3
        line_right=window_width/3*2
    elseif index=='game' then
        love.graphics.setBackgroundColor(0,0,0,1)
        floor_table = make_floor()
        cam={100,0}
        enemy_quads=my_quads
        player:load()
        enemies={}
        for i=1,100 do
            make_enemy(math.random(1000),math.random(1000))
        end

    elseif index=='pull' then
        shine={alpha=0}
        shine_fx = love.graphics.newImage('images/ui/shine.png')
        
        continue_button = {x=window_width-250,y=window_height-150}

        shine_rot = 0

        colors_table={{0,1,0},{0.2,0.2,1},{1,0,1},{1,1,0},{1,0,0}}


        rarities={{3,6},{2,5},{4,8},{7},{1}}
        chosen_rarity=pick_rarity()
        chosen_pull = rarities[chosen_rarity][math.random(#rarities[chosen_rarity])]

        animated_character={x=window_width/2-(48/2)*3,y=-400,alpha=0,scale_x=1,scale_y=3}
        
        pull_bg_color={r=0.1,g=0.1,b=0.1}

        flux.to(animated_character,0.8,{y=window_height/5*3}):ease('quadin')
        flux.to(animated_character,0.2,{scale_x=5,scale_y=1}):ease('quadinout'):delay(0.8)
        flux.to(animated_character,0.2,{scale_x=3,scale_y=3}):ease('quadinout'):delay(1)

        flux.to(pull_bg_color,1,{r=0.6,g=0.5,b=0.6}):ease('quadinout'):delay(1)
        flux.to(animated_character,1,{alpha=1}):ease('quadinout'):delay(1)

        flux.to(animated_character,0.2,{y=window_height/5*2}):ease('quadinout'):delay(1.2)
        flux.to(animated_character,0.2,{scale_x=6,scale_y=6}):ease('quadinout'):delay(1.2)
        flux.to(shine,0.5,{alpha=1}):ease('quadinout'):delay(1.5)

    end
end






function update_mouse()
    mx , my = love.mouse.getPosition()
    mx = mx / scale_x
    my = my / scale_y
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        mousepressed(x,y)
    end
    if button == 2 then
        right_mousepressed(x,y)
    end
end

function mousepressed(x,y)
    if current_state=='menu' then

        local darkness=0
        if CheckCollision(mx,my,1,1,0,0,window_width/3,window_height/6) then
            if selected ~= 0 then
                rectangle_alpha=darkness

            sounds.select_sound:clone():play()
            end
            selected=0
            flux.to(selection_box, 0.4, { x = selected*window_width/3}):ease('elasticout')
            squash=50

        end 
        if CheckCollision(mx,my,1,1,window_width/3,0,window_width/3,window_height/6) then
            if selected ~= 1 then
                rectangle_alpha=darkness
                sounds.select_sound:clone():play()
            end
            selected=1
            flux.to(selection_box, 0.4, { x = selected*window_width/3}):ease('elasticout')
            squash=50

        end
        if CheckCollision(mx,my,1,1,window_width/3*2,0,window_width/3,window_height/6) then
            if selected ~= 2 then
                rectangle_alpha=darkness
                sounds.select_sound:clone():play()
            end

            
            selected=2
            flux.to(selection_box, 0.4, { x = selected*window_width/3}):ease('elasticout')

            squash=50

        end
        if selected==0 then
            if CheckCollision(mx,my,1,1,fullscreen_box[1],fullscreen_box[2],100,100) then
                full = not full
            end
        elseif selected==1 then

            -- start button collision
            if CheckCollision(mx,my,1,1,start_button[1],start_button[2],start_button_image:getWidth(),start_button_image:getHeight()) then
                sounds.start_game_sound:play()
                transition:init('game')
            end

            --arrow bitton collisions
            if CheckCollision(mx,my,1,1,window_width/2+window_width/6-100,window_height/2,left_arrow_image:getWidth(),left_arrow_image:getHeight()) then 
                menu_selected_character = menu_selected_character + 1
                if menu_selected_character <#character_storage then
                    sounds.select_sound:clone():play()
                    --add tweening later
                else
                    sounds.buzz:clone():play()
                end
            end

            if CheckCollision(mx,my,1,1,window_width/2-window_width/6-left_arrow_image:getWidth()-100,window_height/2,right_arrow_image:getWidth(),right_arrow_image:getWidth()) then 
                menu_selected_character = menu_selected_character - 1
                if menu_selected_character >0 then
                    sounds.select_sound:clone():play()
                    --add tweening later
                else
                    sounds.buzz:clone():play()
                end
            end

            --clamps
            if menu_selected_character > #character_storage then
                menu_selected_character = #character_storage
            end
       
            if menu_selected_character < 1 then
                menu_selected_character = 1
            end
        elseif selected==2 then
            if CheckCollision(mx,my,1,1,buy_button.x,buy_button.y,buy_button.w,buy_button.h) then
                sounds.select_sound:clone():play()
                switch_state('pull')
            end
        end
    elseif current_state=='game' then
        player_left_click()
        
    elseif current_state=='pull' then
        if CheckCollision(mx,my,1,1,continue_button.x,continue_button.y,200,100) then
            switch_state('menu')
        end
    end
end

function right_mousepressed(x,y)
    if current_state=='game' then
        player_right_click()
    end
end

--other functions
function lerp(a,b,t) return a * (1-t) + b * t end
function quadin(a, b, t) return lerp(a, b, t * t) end


function CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
  end

function save_data()
    local t = {character_storage,character_stats}
    local data=bitser.dumps(t)
    love.filesystem.write('save.sav',data)
end

function load_data()
    if love.filesystem.getInfo('save.sav') then
        local string = love.filesystem.read('save.sav')
        local loaded_data = bitser.loads(string)

        character_storage = loaded_data[1]
        character_stats = loaded_data[2]
    else
        character_storage={'1'}
        character_stats={}
        for i=1, 10 do
            table.insert(character_stats,{0,0,0})
        end
    end
end

function love.quit()
    save_data()
end

function draw_menu()
end

function pick_rarity()
    local rnd = math.random(100)
    local rarity = 1
    if rnd >=1 and rnd <= 5 then
        rarity = 5
    elseif rnd >=6 and rnd <= 15 then
        rarity = 4
    elseif rnd >=16 and rnd <= 30 then
        rarity = 3
    elseif rnd >=31 and rnd <= 60 then
        rarity = 2
    elseif rnd >=61 and rnd <= 100 then
        rarity = 1
    end
    return rarity
end

function make_floor()
    tiles={love.graphics.newImage('images/tiles/1.png'),love.graphics.newImage('images/tiles/2.png'),love.graphics.newImage('images/tiles/3.png')}

    floor_table = {}
    for n = 1,8 do
        local t = {}
        for i=1,8 do
            table.insert(t,1)
        end
        table.insert(floor_table,t)
    end
    return floor_table
end

function sign(input)
    if input>0 then
        return 1
    elseif input<0 then
        return -1
    else
        return 0
    end
    return 0
end

function should_rotate(input)
    if input>-1.5 and input <1.5 then
        return 1
    else
        return -1
    end
end

function game_menu()

end

function math.clamp(low, n, high) return math.min(math.max(n, low), high) end