force -freeze sim:/Pipes_pos/game_state 10 0
force -freeze sim:/Pipes_pos/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/Pipes_pos/rst 0 0
force -freeze sim:/Pipes_pos/enable 0 0
run
run
run
force -freeze sim:/Pipes_pos/enable 1 0
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
run
run
run
run
run