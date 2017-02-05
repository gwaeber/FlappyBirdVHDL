force -freeze sim:/Score/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/Score/game_state 10 0
force -freeze sim:/Score/rst 0 0
force -freeze sim:/Score/enable 0 0
force -freeze sim:/Score/pipe_a_x 1001011000‬ 0
run
run
run
force -freeze sim:/Score/enable 1 0
run
run
run
run
run
run
force -freeze sim:/Score/pipe_a_x ‭0110010000‬ 0
run
run
run
run
run
run
run
force -freeze sim:/Score/pipe_a_x ‭0100011000‬ 0
run
run
run
run
run
run
run
run
force -freeze sim:/Score/pipe_a_x ‭0011111010‬ 0
run
run
run
run
run
run
run
force -freeze sim:/Score/pipe_a_x ‭0100011000‬ 0
run
run
run
run
force -freeze sim:/Score/game_state 11 0
run
run
run
run
run
force -freeze sim:/Score/game_state 01 0
run
run
run
run
run