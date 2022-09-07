
function start_game()
    
    rectangle_lerper=0
    ship_dropped=false

    begin_timer=3

    enemy_list = {}
    starting_enemies = math.random(40,50)
    starting_enemies= 2
    for i=0 , starting_enemies do
        local rnd = math.random(4)
        if rnd == 1 then
            table.insert(enemy_list,level) 
        else
            table.insert(enemy_list,math.random(level))
        end
    end
end

function update_spawn()
    begin_timer = begin_timer - global_dt
    spawn_timer = spawn_timer - global_dt
    if spawn_timer <=0 then
        spawn_timer = 0.15 + math.random(5)/10
        if  #enemy_list>1 then
            make_spawner_particle(math.random(100,1600),math.random(100,1600),enemy_list[#enemy_list-1])
            table.remove(enemy_list,#enemy_list-1)
        end
    end
    if #enemies == 0 and #enemy_list == 1 and not ship_dropped and begin_timer <= 0 then
        ship_dropped = true
        ship:make()
    end
end

function update_game()
    rectangle_lerper = lerp(rectangle_lerper,window_width * #enemies/starting_enemies,5*global_dt)
end

function game_ui()
    love.graphics.setColor(1,0.5,0.5,1)
    love.graphics.rectangle('fill',0,window_height-15,rectangle_lerper,15)
    love.graphics.setColor(1,0.3,0.3,1)
    love.graphics.rectangle('fill',0,window_height-15,window_width * #enemies/starting_enemies,15)
    love.graphics.setColor(0.2,0.2,0.2,1)
    love.graphics.print('Enemies',10,window_height-15)
end

ship={x=-1000,y=-1000,image = love.graphics.newImage('images/ship.png'),inside=false }

function ship:make()
    local goal_x = math.random(200,1500)
    local goal_y = math.random(100,1500)

    self.inside = false
    self.x = goal_x
    self.y = -800
    self.switched = true
    
    self.image = love.graphics.newImage('images/ship.png')
    self.back = love.graphics.newImage('images/ship_back.png') 
    
    
    flux.to(self,2,{y=goal_y}):delay(1):ease('quadout')
end

function ship:update()
    --make_particle(x,y,dx,dy,color,life,size,da,ds)
    local col = math.random(10)/10
    --make_particle(self.x+10+math.random(self.image:getWidth()-10),self.y+self.image:getHeight()-20,0,math.random(30),{col*2,col,col,1},1,10,0,0)
    
    if math.sqrt((self.x-player.x+self.image:getWidth()/2)^2+(self.y-player.y+self.image:getHeight()/2)^2) <=230 then
        draw_e = true
        if not self.inside then
            if love.keyboard.isDown('e') then
                self.inside = true
                self.cam={self.x-window_width/2+self.image:getWidth()/2,self.y-window_height/2+self.image:getHeight()/2}
                flux.to(self,3,{y=-1000}):delay(1):ease('quadin')
                
            end
        end
    else
        draw_e = false
    end

    if self.inside then
        cam[1]=self.cam[1]
        cam[2]=self.cam[2]
        make_particle(self.x+10+math.random(self.image:getWidth()-10),self.y+self.image:getHeight()-20,0,math.random(30),{col*5,col,col,1},1,10,0,0)
        player.x = self.x+self.image:getWidth()/2
        player.y = self.y+50
    end

    if self.switched and self.y <= -900 then
        self.switched = false
        transition:init('game')
        print('transition!')
    end


end
   
function ship:draw()
    if draw_e then
        love.graphics.setColor(0.2,0.2,0.2,1)
        love.graphics.print('press E',player.x-30,player.y-50)
    end
    love.graphics.setColor(1,1,1,1)
    
    love.graphics.draw(self.image,self.x,self.y)
end
    
