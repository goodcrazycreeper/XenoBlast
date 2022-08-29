

player={}

function player:load()
    self.x=1000
    self.y=1000
    self.sprite=1
    self.maxhp=10
    self.speed=150
    self.hp=10
    self.walking=false
    self.character=menu_selected_character
    self.Image=love.graphics.newImage("images/characters/character-"..tostring(self.character)..".png")
    self.weaponImage=love.graphics.newImage("images/weapons/"..tostring(self.character)..".png")
    self.quads={}
    self.angle=0
    self.walk_timer=1
    self.scale_x=1
    self.particle_timer=0
    self.primary_reload=0

    for i=0,3 do
		table.insert(self.quads, love.graphics.newQuad(i * 48, 0,48 ,48 ,self.Image))
	end
end

function player:update(dt)
    self.primary_reload = self.primary_reload - dt
    self:animate(dt)
    self:input(dt)
    
end

function player:animate(dt)

    self.scale_x=-sign(self.x-(cam[1]+mx))
    if love.keyboard.isDown('w', 'a', 's', 'd') then
        self.walking = true
    else
        self.walking = false
    end
    if self.walking then

        self.particle_timer = self.particle_timer - dt
        if self.particle_timer <=0 then
            self.particle_timer = 0.05
            local color = math.random(1,5)/10        
            --(x,y,dx,dy,type,speed)
            make_particle(self.x+math.random(10,38)-24,self.y+48+math.random(-5,5),0,0,{color,color,color,1},0.5,10,-0.5,-5,0)
        end

        self.walk_timer = self.walk_timer + 1*dt
        if self.walk_timer >=0.1 then
            self.walk_timer=0
            self.sprite = self.sprite + 1
            if self.sprite > 4 then
                self.sprite = 1
            end
        end
    else
        self.sprite=2
    end
end


function player:input(dt)
    local vec={x=0,y=0}
    if love.keyboard.isDown("w") then
        vec.y = vec.y - 1
    end
    if love.keyboard.isDown("a") then
        vec.x = vec.x - 1
    end
    if love.keyboard.isDown("s") then
        vec.y = vec.y + 1
    end
    if love.keyboard.isDown("d") then
        vec.x = vec.x + 1
    end
    vec.x,vec.y=normalize(vec.x,vec.y)
    self:move(vec.x,vec.y, dt)
end

function player:move(x,y,dt)
    self.x = self.x + x * dt * self.speed
    self.y = self.y + y * dt * self.speed
end

function player:draw()
    love.graphics.push()

        love.graphics.setColor(1,1,1,1)
        local delta_x = cam[1]+mx-40 - self.x+24
        local delta_y = cam[2]+my-40 - self.y+24
        self.angle = math.atan2(delta_y, delta_x)
        if sign(self.angle)==-1 then
            love.graphics.draw(self.weaponImage,self.x, self.y+30,   self.angle  ,1,should_rotate(self.angle),-15,9)
        end
        love.graphics.draw(self.Image, self.quads[self.sprite], self.x, self.y,0,self.scale_x,1,24,0)
        if sign(self.angle)==1 then
            love.graphics.draw(self.weaponImage,self.x, self.y+30,   self.angle  ,1,should_rotate(self.angle),-15,9)
        end
        
        
    love.graphics.pop()
end

function player_left_click()
    if player.primary_reload <= 0 then
        local delta_x = cam[1]+mx-40 - player.x
        local delta_y = cam[2]+my-40 - player.y
        if player.character == 1 then
            make_projectile(player.x-24,player.y,delta_x,delta_y,1,1000)
            player:set_primary_reload()
        elseif player.character == 2 then
    
        end
    end
end

function player_right_click()

end


function normalize(x,y)
    local v = {x,y}
    local m = math.sqrt(v[1]*v[1]+v[2]*v[2])
    
    if v[1] ~= 0 then
        v[1] = v[1]/m
    end
    if v[2] ~= 0 then
        v[2] = v[2]/m
    end
    return v[1],v[2]
end

function player:set_primary_reload()

    if self.character==1 then
        self.primary_reload=0.2
    elseif self.character==2 then
        self.primary_reload=0.3
    end

end