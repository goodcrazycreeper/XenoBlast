projectiles={}
function make_projectile(x,y,dx,dy,type,speed)
    local projectile = {

    x = x,
    y = y,
    dx = dx,
    dy = dy,
    life = life,
    size= size,
    speed = speed,
    first = true,
    type = type,
    knockback = 10,
    image=love.graphics.newImage('images/projectiles/'..tostring(type)..'.png'),
    dist={0,0},


    update = function(self)
        if self.first then

            self.dx,self.dy = normalize(self.dx,self.dy)
            self.x = 24 + self.x + self.dx * 50 
            self.y = 24 + self.y + self.dy * 50

            if self.type == 1 then
                self.knockback = 1
                self.damage = 2
            end
            self.first = false
        end
        self.x = self.x + self.dx * global_dt * self.speed
        self.y = self.y + self.dy * global_dt * self.speed
        --make_particle(x,y,dx,dy,color,life,size,da,ds)
        --make_particle(self.x,self.y,0,0,{0.6,0.9,0.3,1},0.1 ,10,-1,-10)
    end,
    draw = function(self)

        love.graphics.setColor(1,1,1,1)
        --love.graphics.rectangle('fill',self.x,self.y,10,10)
        love.graphics.draw(self.image,self.x,self.y,  math.atan2(self.dy,self.dx)  ,1,1,self.image:getWidth()/2,self.image:getHeight()/2)
        if self.first then
            self.first=false
            love.graphics.setColor(1,1,1,1)
            love.graphics.circle('fill',self.x,self.y,20)
        end
    end}





    table.insert(projectiles,projectile)
end

function update_projectiles()
    for i,v in ipairs(projectiles) do
        v:update()
        
    end
end

function draw_projectiles()
    for i,v in ipairs(projectiles) do
        v:draw()
    end
end

function check_projectile_collision()

    t={}
    for i,v in ipairs(projectiles) do
        for o,p in ipairs(enemies) do
            
            if CheckCollision(v.x,v.y,10,10,p.x,p.y,48,48) then
                p.death_dx,p.death_dy=v.dx,v.dy
                p.hp = p.hp - v.damage
                p.invincible = 0.1
                knockback(p,v)
                table.insert(t,i)
            end
        end
    end
    for i = #t, 1,-1 do
        table.remove(projectiles,t[i])
    end
end