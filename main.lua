require("player")
require("transition")

state={'intro','menu','game'}
current_state = state[1]
love.graphics.setBackgroundColor(0.7,0.3,0.1 , 1)
window_width,window_height = love.graphics.getDimensions()


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    enter_state(current_state)
    
    
end


function love.update(dt)

    update_mouse()
    state_update(dt)

    transition:update(dt)
end


function love.draw()
    state_draw(current_state)
    
    transition:draw()
end



function switch_state(state)
    exit_state(current_state)
    current_state=state
    enter_state(current_state)
    
    
end

function exit_state(index)
    if index==1 then
    
    elseif index==2 then
    
    elseif index==3 then
    
    elseif index==4 then
    
    end
end

function state_update(dt) -- stands for current state
    if current_state=='intro' then
        logo_x = lerp(logo_x,40,1*dt)
        intro_timer=intro_timer- 1*dt
        print(intro_timer)
        if intro_timer<=0 then
            transition:init('menu')
        end
    elseif current_state=='menu' then
        --calculate positions
        goal_x = (selected*window_width/3)
        local spd = 30
        box_x=quadin(box_x,goal_x,spd*dt)
        squash=lerp(squash,0,spd*dt)
    
    elseif current_state=='game' then
        player:update(dt)
    elseif current_state=='' then
        
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
        love.graphics.line(0,window_height/6,window_width,window_height/6)

        --draws lines
        love.graphics.line(line_left,0,line_left,window_height/6)
        love.graphics.line(line_right,0,line_right,window_height/6)


        --draws selection box
        love.graphics.setColor(0.6, 0.6, 0.8, 1)
        love.graphics.rectangle("fill",box_x,squash,box_w,window_height/6-squash*2)
        love.graphics.setColor(0.1, 0.1, 0.1, 1)
        love.graphics.rectangle("line",box_x,squash,box_w,window_height/6-squash*2)
        
        --text drawing
        love.graphics.print( "play",window_width/2-100,window_height/6/2-35)
        love.graphics.print( "shop",window_width/3*2+110,window_height/6/2-35)

    elseif current_state=='game' then --game
        player:draw()
    elseif current_state=='' then
    
    end
end



function enter_state(index)
    if index=='intro' then
        intro_timer=5
        logo_x = 1500
        love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',100))
        logo_image = love.graphics.newImage("images/grape_pfp_pixel.png")
    elseif index=='menu' then
        selected=1
        window_width,window_height = love.graphics.getDimensions()
        love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',75))
        squash=0
        selected=1
        
        box_w=love.graphics.getWidth()/3
        box_x=window_width/2+box_w/2
        goal_x=love.graphics.getWidth()/2-love.graphics.getWidth()/3-0
        line_left=love.graphics.getWidth()/3
        line_right=(love.graphics.getWidth()/3)*2
    elseif index=='game' then
        player:load()
    elseif index==3 then
    
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
        print('click in menu',selected)
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
    elseif current_state=='game' then
    elseif current_state=='' then
    
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