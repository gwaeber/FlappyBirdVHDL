force -freeze sim:/Flappy_pos/game_state 10 0
force -freeze sim:/flappy_pos/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/Flappy_pos/rst 0 0
force -freeze sim:/Flappy_pos/enable 0 0
run
run
run
force -freeze sim:/Flappy_pos/enable 1 0
force -freeze sim:/Flappy_pos/btn_left 0 0
run
run
run
run
run
force -freeze sim:/Flappy_pos/btn_left 1 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run