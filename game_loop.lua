
function start_game()
    enemy_list = {}

    for i=0 , math.random(90,100) do
        table.insert(enemy_list,math.random(level))
    end
end

function update_spawn()
    for i=#enemy_list, 1, -1 do
        make_spawner_particle(math.random(224,1000),math.random(224,1000),enemy_list[i])
        table.remove(enemy_list,i)
    end
end

function game_menu()
    
end