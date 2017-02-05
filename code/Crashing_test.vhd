----------------------------------------------------------------------------------
-- Company :         HEIA-FR
-- Engineer :        Cyril Vallélian & Gilles Waeber
-- Module Name :     Crashing_test - Behavioral
-- Project Name :    Flappy Bird
-- Target Devices :  Spartan6
-- Description :     Calculate if flappy crashed
-- Date :            2016-06-19
-- Version :         1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.local.ALL;

entity Crashing_test is
    Port ( game_state : in  STD_LOGIC_VECTOR (1 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  enable : in  STD_LOGIC;
           flappy_y : in  STD_LOGIC_VECTOR (9 downto 0);
           pipe_a_x : in  STD_LOGIC_VECTOR (9 downto 0);
           pipe_a_h_top : in  STD_LOGIC_VECTOR (8 downto 0);
           pipe_a_h_bottom : in  STD_LOGIC_VECTOR (8 downto 0);
           game_finished : out  STD_LOGIC);
end Crashing_test;

architecture Behavioral of Crashing_test is
	
	
	-- flappy
	signal flappy_y_s : integer;
	-- pipes
	signal pipe_a_x_s        : integer range 0 to (2**(pipe_a_x'LENGTH));
	signal pipe_a_h_top_s    : integer range 0 to (2**(pipe_a_h_top'LENGTH));
	signal pipe_a_h_bottom_s : integer range 0 to (2**(pipe_a_h_bottom'LENGTH));
	
begin
	
	-- flappy
	flappy_y_s <= to_integer(unsigned(flappy_y));
	-- pipes
	pipe_a_x_s        <= to_integer(unsigned(pipe_a_x));
	pipe_a_h_top_s    <= to_integer(unsigned(pipe_a_h_top));
	pipe_a_h_bottom_s <= to_integer(unsigned(pipe_a_h_bottom));
	
	
	process(clk, rst)
		
		variable flappy_v_top    : integer range 0 to N_HLINES_c;
		variable flappy_v_bottom : integer range 0 to N_HLINES_c;
		variable flappy_h_right  : integer range 0 to N_VLINES_c;
		
	begin
		
		if rst = '1' then
			
			game_finished <= '0';
			
		elsif rising_edge(clk) then
		
			if game_state = "10" then
				
				-- flappy values
				flappy_v_top    := flappy_y_s - (FLAPPY_SIZE_c/2) + FLAPPY_CRASH_ADJ_TOP_c;
				flappy_v_bottom := flappy_y_s + (FLAPPY_SIZE_c/2) - FLAPPY_CRASH_ADJ_c;
				flappy_h_right  := FLAPPY_X_POS_c + (FLAPPY_SIZE_c/2) - FLAPPY_CRASH_ADJ_c;
			
				-- Crash avec le sol
				if (flappy_v_bottom + FLAPPY_CRASH_ADJ_c = N_VLINES_c) then
					game_finished <= '1';
				
				-- Crash with pipe face
				elsif ( flappy_h_right >= (pipe_a_x_s-PIPE_WIDTH_c) and 
				        flappy_h_right < (pipe_a_x_s+FLAPPY_SIZE_c) and
						  (flappy_v_top = pipe_a_h_top_s or flappy_v_bottom = (N_VLINES_c-pipe_a_h_bottom_s)) ) then 
					game_finished <= '1';
				
				-- Crash with pipe side
				elsif (flappy_h_right = (pipe_a_x_s-PIPE_WIDTH_c) and (flappy_v_top < pipe_a_h_top_s or flappy_v_bottom > (N_VLINES_c-pipe_a_h_bottom_s)) ) then
					game_finished <= '1';
					
				else
					game_finished <= '0';
				end if;
				
				
			else
			
				game_finished <= '0';
			
			end if;
			
		end if;
	
	end process;
	
	
end Behavioral;
