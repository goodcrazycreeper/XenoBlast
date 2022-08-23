

player={}

function player:load()
    self.x=10
    self.y=10
    self.sprite=1
    self.maxhp=10
    self.hp=10
    self.walking=false
    self.character=1
    self.Image=love.graphics.newImage("images/characters/character-3.png")
    self.quads={}
    self.walk_timer=1
    for i=0,3 do
		table.insert(self.quads, love.graphics.newQuad(i * 48, 0,48 ,48 ,self.Image))
	end
end

function player:update(dt)
    self:animate(dt)
    self:input()
end

function player:animate(dt)
    if love.keyboard.isDown('w', 'a', 's', 'd') then
        self.walking = true
    else
        self.walking = false
    end
    if self.walking then
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


function player:input()
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
    self:move(vec.x,vec.y)
end

function player:move(x,y)
    self.x = self.x + x
    self.y = self.y + y
end

function player:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.Image, self.quads[self.sprite], self.x, self.y)
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