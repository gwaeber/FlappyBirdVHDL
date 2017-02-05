force -freeze sim:/Btns_synchro/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/Btns_synchro/rst 1 0
force -freeze sim:/Btns_synchro/btn_left_unsync 0 0
force -freeze sim:/Btns_synchro/btn_right_unsync 0 0
run
run
force -freeze sim:/Btns_synchro/rst 0 0
run
run
run
run
force -freeze sim:/Btns_synchro/btn_left_unsync 1 0
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
force -freeze sim:/Btns_synchro/btn_right_unsync 1 0
run
run
run
run
run
run
run
run
