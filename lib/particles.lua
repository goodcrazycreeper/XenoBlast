particles={}
body_particle={}
spawn_particle={}
function make_particle(x,y,dx,dy,color,life,size,da,ds)
    local particle = {

    x = x,
    y = y,
    dx = dx,
    dy = dy,
    life = life,
    size= size,
    first=true,
    color=color,


    update = function(self)
        
        self.x = self.x + self.dx * global_dt
        self.y = self.y + self.dy * global_dt
        self.life = self.life - global_dt
        self.size = self.size + ds * global_dt
        self.color[4] = self.color[4] + da * global_dt
        if self.first then
            self.first = false
        end

    end,

    draw = function(self)
        love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.color[4])

        love.graphics.circle('fill',self.x,self.y,self.size)
    end
    }

    table.insert(particles,particle)

end

function make_body_particle(x,y,dx,dy,image)
    local particle = {

        x = x,
        y = y,
        dx = dx,
        dy = dy,
        first = true,
        image = love.graphics.newImage(image),
        frame_lerper = 3,
        frame=3,
        quads = reverse(my_quads),
        life=1,
    
        update = function(self)
            if self.first then
                self.dx ,self.dy = normalize(self.dx,self.dy)
                self.first = false
                flux.to(self,0.5,{dx=0,dy=0,frame_lerper=0}):ease('quadout')
                flux.to(self,0.5,{life=0}):ease('quadout'):delay(10)
            end
            self.frame = math.floor(self.frame_lerper)
            self.x = self.x + self.dx * global_dt * 200
            self.y = self.y + self.dy * global_dt * 200
            --self.x = self.x + 10 * global_dt
            --self.y = self.y + 10 * global_dt
        end,
    
        draw = function(self)
            love.graphics.setColor(1,1,1,self.life)
            love.graphics.draw(self.image,self.quads[self.frame+1],self.x,self.y)
        end
        }
    
        table.insert(body_particle,particle) 
end

function make_spawner_particle(x,y,type)
    local spawner = {

        x = x,
        y = y,
        type=type,
        first = true,
        life=10,
    
        update = function(self)
            if self.first then
                self.first = false
                flux.to(self,1,{life=0}):ease('elasticout'):delay(1)
            end
        end,
    
        draw = function(self)
            love.graphics.setColor(1,0.6,0.6,1)
            love.graphics.circle('fill',self.x+24,self.y+24,self.life*2+3)
            love.graphics.setColor(1,0.3,0.3,1)
            love.graphics.circle('fill',self.x+24,self.y+24,self.life*2)
        end
        }
    
        table.insert(spawn_particle,spawner) 
end

function update_particles()
    for i,v in ipairs(spawn_particle) do
        v:update()
        if v.life<=0 then
            make_enemy(v.x,v.y,v.type)
            table.remove(spawn_particle,i)
        end
    end
    for i,v in ipairs(body_particle) do
        v:update()
        if v.life<=0 then
            table.remove(body_particle,i)
        end
    end
    for i,v in ipairs(particles) do
        v:update()
        
        if v.life<=0 then
            table.remove(particles,i)
        end
    end
end

function draw_particles()
    for i,v in ipairs(body_particle) do
        v:draw()
    end
    for i,v in ipairs(spawn_particle) do
        v:draw()
    end
    for i,v in ipairs(particles) do
        v:draw()
    end
end

function round(num) return math.floor(num+0.5) end


function reverse(t)
    local r={}
    for i=#t,1,-1  do
        table.insert(r,t[i])
    end
    return r
end