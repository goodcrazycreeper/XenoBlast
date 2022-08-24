require("player")
require("transition")
require("bg")
local bitser = require 'lib/bitser'

state={'intro','menu','game','pull'}
current_state = state[2]
love.graphics.setBackgroundColor(0.7,0.3,0.1 , 1)
window_width,window_height = love.graphics.getDimensions()




function love.load()
    load_data()
    love.graphics.setDefaultFilter("nearest", "nearest")
    enter_state(current_state)
    
end


function love.update(dt)
    update_mouse()
    bg:update(dt)
    state_update(dt)
    transition:update(dt)
end


function love.draw()
    bg:draw()
    state_draw(current_state)
    transition:draw()
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
    end
end


function enter_state(index)
    if index=='intro' then
        intro_timer=5
        logo_x = 1500
        love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',100))
        logo_image = love.graphics.newImage("images/grape_pfp_pixel.png")
    elseif index=='menu' then
        bg:init()
        window_width,window_height = love.graphics.getDimensions()
        left_arrow_image=love.graphics.newImage('images/left_arrow.png')
        right_arrow_image=love.graphics.newImage('images/right_arrow.png')
        menu_selected_character=1
        character_frame_tick=0
        character_frame=1
        
        --store character images
        my_characters={}
        for i=1,3 do
            table.insert(my_characters,love.graphics.newImage("images/characters/character-"..tostring(i)..".png"))
        end

        --store the quads for the images
        my_quads={}
        for i=0,3 do
            table.insert(my_quads, love.graphics.newQuad(i * 48, 0,48 ,48 ,my_characters[1]))
        end
        

        love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',75))

        clicked_start=false
        selected=1
        squash=0
        start_button_image = love.graphics.newImage("images/blue_button.png")
        start_button={window_width/2-start_button_image:getWidth()/2,window_height/2+200}
        box_w=love.graphics.getWidth()/3
        box_x=window_width/2+box_w/2
        goal_x=love.graphics.getWidth()/2-love.graphics.getWidth()/3-0
        line_left=love.graphics.getWidth()/3
        line_right=(love.graphics.getWidth()/3)*2
    elseif index=='game' then
        player:load()
    elseif index=='pull' then
    
    end
end


function state_update(dt) -- stands for current state
    if current_state=='intro' then
        logo_x = lerp(logo_x,40,1*dt)
        intro_timer=intro_timer- 1*dt
        if intro_timer<=0 then
            transition:init('menu')
        end
    elseif current_state=='menu' then
        --calculate positions
        goal_x = (selected*window_width/3)
        local spd = 30
        box_x=quadin(box_x,goal_x,spd*dt)
        squash=lerp(squash,0,spd*dt)

        --animate
        character_frame_tick =character_frame_tick+ 1 * dt
        if character_frame_tick >= 0.1  then
            character_frame_tick = 0
            character_frame = character_frame + 1
            if character_frame > 4 then
                character_frame = 1
            end
        end
        
        --choose character
        




    elseif current_state=='game' then
        player:update(dt)
    elseif current_state=='pull' then
        
    end
end

function state_draw(dt)
    if current_state=='intro' then
        
        love.graphics.setColor(0.1,0.1,0.1 , 1)
        love.graphics.print("Totally grape",400,window_height/2-40)
        love.graphics.setColor(0.7,0.3,0.1 , 1)
        love.graphics.rectangle("fill",0,0,logo_x+logo_image:getHeight()/2,window_height)
        love.graphics.setColor(1,1,1 , 1)
        love.graphics.draw(logo_image,logo_x,window_height/2-logo_image:getHeight()/2)

    elseif current_state=='menu' then -- menu
        --draws the top rect
        love.graphics.setBackgroundColor(0.6,0.5,0.6 , 1)
        love.graphics.setColor(0.58, 0.21, 0.78, 1)
        love.graphics.rectangle("fill",0,0,window_width,window_height/6)
        love.graphics.setColor(0.1,0.1,0.1, 1)
        love.graphics.rectangle("fill",0,window_height/6,window_width,10)

        --draws lines
        love.graphics.rectangle("fill",line_left-5,0,10,window_height/6)
        love.graphics.rectangle("fill",line_right-5,0,10,window_height/6)


        --draws selection box
        love.graphics.setColor(0.6, 0.6, 0.8, 1)
        love.graphics.rectangle("fill",box_x,squash,box_w,window_height/6-squash*2,25,25,20)
        love.graphics.setColor(0.1, 0.1, 0.1, 1)
        love.graphics.rectangle("line",box_x,squash,box_w,window_height/6-squash*2,25,25,20)
        
        --text drawing
        love.graphics.print( "config",50,window_height/6/2-35)
        love.graphics.print( "play",window_width/2-100,window_height/6/2-35)
        love.graphics.print( "shop",window_width/3*2+110,window_height/6/2-35)

        if selected==0 then
        
        elseif selected==1 then
            -- draw button
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(start_button_image,start_button[1],start_button[2])
            love.graphics.setColor(0.1, 0.1, 0.1, 1)
            love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',60))
            love.graphics.print( "deploy",start_button[1]+25,start_button[2]+20)
            
            --draw character animation
            love.graphics.push()
            love.graphics.setColor(1,1,1,1)
            love.graphics.scale(5, 5)
            love.graphics.draw(my_characters[tonumber(character_storage[menu_selected_character])], my_quads[character_frame], (window_width/2-120)/5, (window_height/2-120)/5)
            love.graphics.pop()

            --draw arrows
            if menu_selected_character == #character_storage then
                love.graphics.setColor(0.3,0.3,0.3,1)
            else
                love.graphics.setColor(1,1,1,1)
            end
            love.graphics.draw(right_arrow_image,window_width/2+window_width/6,window_height/2)

            if menu_selected_character == 1 then
                love.graphics.setColor(0.3,0.3,0.3,1)
            else
                love.graphics.setColor(1,1,1,1)
            end
            love.graphics.draw(left_arrow_image,window_width/2-window_width/6-left_arrow_image:getWidth(),window_height/2)
        
        elseif selected==2  then
        
        end
    elseif current_state=='game' then --game
        player:draw()
    elseif current_state=='pull' then
    
    end
end

function update_mouse()
    mx,my = love.mouse.getPosition()
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        mousepressed(x,y)
    end
end

function mousepressed(x,y)
    if current_state=='menu' then
        if CheckCollision(mx,my,1,1,0,0,window_width/3,window_height/6) then
            selected=0
            squash=50
        end
        if CheckCollision(mx,my,1,1,window_width/3,0,window_width/3,window_height/6) then
            selected=1
            squash=50
        end
        if CheckCollision(mx,my,1,1,window_width/3*2,0,window_width/3,window_height/6) then
            selected=2
            squash=50
        end
        if selected==0 then
        
        elseif selected==1 then

            -- start button collision
            if CheckCollision(mx,my,1,1,start_button[1],start_button[2],start_button_image:getWidth(),start_button_image:getHeight()) then
                transition:init('game')
            end

            --arrow bitton collisions
            if CheckCollision(mx,my,1,1,window_width/2+window_width/6,window_height/2,left_arrow_image:getWidth(),left_arrow_image:getHeight()) then 

                menu_selected_character = menu_selected_character + 1
            end

            if CheckCollision(mx,my,1,1,window_width/2-window_width/6-left_arrow_image:getWidth(),window_height/2,right_arrow_image:getWidth(),right_arrow_image:getWidth()) then 

                menu_selected_character = menu_selected_character - 1
            end
            --clamps
            if menu_selected_character > #character_storage then
                menu_selected_character = #character_storage
            end
       
            if menu_selected_character < 1 then
                menu_selected_character = 1
            end
        elseif selected==2 then
        
        end
    elseif current_state=='game' then

    elseif current_state=='pull' then
    
    end
end

--other functions
function lerp(a,b,t) return a * (1-t) + b * t end
function quadin(a, b, t) return lerp(a, b, t * t) end


function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
  end

function save_data()
    local data=bitser.dumps(character_storage)
    love.filesystem.write('save.sav',data)
end

function load_data()
    if love.filesystem.getInfo('save.sav') then
        local string=love.filesystem.read('save.sav')
        print(string)
        character_storage=bitser.loads(string)
    else
        character_storage={'1'}
    end

end

function love.quit()
    save_data()
end
