


function make_enemy(type)
    local enemy = {
    quads = my_quads,
    x = 100,
    y = 100,
    walk_timer = 1,
    speed=50,
    hp=10,
    sprite=1,
    image=love.graphics.newImage('images/characters/character-6.png'),
    dist={0,0},

    update = function(self)
        self.walk_timer = self.walk_timer + 1 * global_dt
        if self.walk_timer >=0.1 then
            self.walk_timer=0
            self.sprite = self.sprite + 1
            if self.sprite > 4 then
                self.sprite = 1
            end
        end

        self.dist.x=self.x-player.x
        self.dist.y=self.y-player.y
        self.dist.x,self.dist.y = normalize(self.dist.x,self.dist.y)
        self.x = self.x - self.dist.x * self.speed * global_dt
        self.y = self.y - self.dist.y * self.speed * global_dt
    end,

    draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(self.image, self.quads[self.sprite], self.x, self.y)
    end
    }


    table.insert(enemies,enemy)

end

function update_enemies()
    for i=1, #enemies do
        enemies[i]:update()
    end
end

function draw_enemies()
    for i=1, #enemies do
        enemies[i]:draw()
    end
end