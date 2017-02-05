----------------------------------------------------------------------------------
-- Company :         HEIA-FR
-- Engineer :        Cyril Vallélian & Gilles Waeber
-- Module Name :     Pipes_pos - Behavioral
-- Project Name :    Flappy Bird
-- Target Devices :  Spartan6
-- Description :     Calculate pipes position
-- Date :            2016-06-19
-- Version :         1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.local.ALL;

entity Pipes_pos is
    Port ( game_state : in STD_LOGIC_VECTOR(1 downto 0);
			  enable : in STD_LOGIC;
			  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
			  score : in  STD_LOGIC_VECTOR(9 downto 0);
			  btn_left : in  STD_LOGIC;
			  pipe_a_x : out STD_LOGIC_VECTOR(9 downto 0);
			  pipe_a_h_top : out STD_LOGIC_VECTOR(8 downto 0);
			  pipe_a_h_bottom : out STD_LOGIC_VECTOR(8 downto 0);
			  pipe_b_x : out STD_LOGIC_VECTOR(9 downto 0);
			  pipe_b_h_top : out STD_LOGIC_VECTOR(8 downto 0);
	        pipe_b_h_bottom : out STD_LOGIC_VECTOR(8 downto 0));
end Pipes_pos;

architecture Behavioral of Pipes_pos is
	
	signal steps        : integer range 0 to STEPS_PIPE_MAX_c := 0;
	signal index        : integer range 0 to NB_OF_PIPES_c-1 := 0;   		              -- index of the A pipe
	signal pipes_x      : t_pipes_x := pipes_x_o;                    		              -- original list of pipes pos
	signal pipes_top    : t_pipes_h := pipes_top_o;
	signal pipes_bottom : t_pipes_h := pipes_bottom_o;
	signal random       : integer range RANDOM_MIN_c to RANDOM_MAX_c := RANDOM_MIN_c;  -- random for pipes height
	signal space        : integer range SPACE_MIN_c to SPACE_MAX_c := SPACE_MAX_c;     -- space between pipes height
	signal score_s      : integer range 0 to 1000 := 0;
	
begin

	score_s <= to_integer(unsigned(score));
	
	
	-- Random for pipes height
	process(clk, rst)
	begin
		
		if rst = '1' then
			random <= RANDOM_MIN_c;
		elsif rising_edge(clk) then
			if(random = RANDOM_MAX_c) then
				random <= RANDOM_MIN_c;
			else
				random <= random + 1;
				if(btn_left = '1') then
					random <= (random * 27) mod 49;
				end if;
			end if;
		end if;
		
	end process;
	
	
	-- Diminuer espace entre les tuyaux en fonction du score
	process(clk, rst)
	begin
		
		if rst = '1' then
			space <= SPACE_MAX_c;
		elsif rising_edge(clk) then
			
			if enable = '1' and game_state = "10" then
				
				if ((score_s mod SPACE_MODULO_c) = 0) and ((score_s/SPACE_MODULO_c) <= SPACE_NB_OF_DEC_c) then
					space <= SPACE_MAX_c - ((score_s/SPACE_MODULO_c)*SPACE_REDUCTION_STEP_c);
				end if;
				
			elsif game_state = "00" or game_state = "01" then
				space <= SPACE_MAX_c;
			end if;
			
		end if;
		
	end process;
	
	-- Compteur de paliers pour un déplacement
	process(clk, rst)
	begin
		
		if rst = '1' then
			steps <= 0;
		elsif rising_edge(clk) then
		
			if enable = '1' and game_state = "10" then
			
				if steps = STEPS_PIPE_MAX_c then
					steps <= 0;
				else
					steps <= steps + 1;
				end if;
			
			end if;
			
		end if;
	
	end process;
	
	
	
	-- Calcul des nouvelles positions
	process(clk, rst)
	begin
		
		if rst = '1' then
			
			pipes_x <= pipes_x_o;
			pipes_top    <= pipes_top_o;
			pipes_bottom <= pipes_bottom_o;
			
		elsif rising_edge(clk) then
			
			if enable = '1' and game_state = "10" then

				if steps = STEPS_PIPE_MAX_c then
					
					for i in 0 to (NB_OF_PIPES_c-1) loop
						
						if pipes_x(i) > 0 then
							pipes_x(i) <= pipes_x(i) - 1;
						else
							-- first pipe has reached left border of the screen, move it to the end with new heights
							pipes_x(i) <= PIPE_LAST_POS;
							pipes_top(i) <= random;
							pipes_bottom(i) <= N_VLINES_c - (random + space);
						end if;
						
					end loop;
					
				end if;
				
			elsif game_state = "00" or game_state = "01" then
			
				pipes_x      <= pipes_x_o;
				pipes_top    <= pipes_top_o;
				pipes_bottom <= pipes_bottom_o;
			
			end if;
			
		end if;
		
	end process;
	
	
	-- Calcul de l'index
	process(clk, rst)
	begin
		
		if rst = '1' then
			
			index <= 0;
			
		elsif rising_edge(clk) then
			
			if enable = '1' and game_state = "10" then

				if steps = STEPS_PIPE_MAX_c then
					
					if pipes_x(index) = 0 then
						if index = (NB_OF_PIPES_c-1) then
							index <= 0;
						else
							index <= index + 1;
						end if;
					end if;
					
				end if;
			
			elsif game_state = "00" or game_state = "01" then
				
				index <= 0;
				
			end if;
			
		end if;
		
	end process;
	
	
	-- Sortie des tuyaux A et B
	pipe_a_x        <= std_logic_vector(to_unsigned(pipes_x(index), 10))     when ((game_state = "10" or game_state = "11") and pipes_x(index) <= N_HLINES_c+PIPE_WIDTH_c) else (others=>'0');
	pipe_a_h_top    <= std_logic_vector(to_unsigned(pipes_top(index), 9))    when ((game_state = "10" or game_state = "11") and pipes_x(index) <= N_HLINES_c+PIPE_WIDTH_c) else (others=>'0');
	pipe_a_h_bottom <= std_logic_vector(to_unsigned(pipes_bottom(index), 9)) when ((game_state = "10" or game_state = "11") and pipes_x(index) <= N_HLINES_c+PIPE_WIDTH_c) else (others=>'0');
	
	pipe_b_x        <= std_logic_vector(to_unsigned(pipes_x(0), 10))     when ((game_state = "10" or game_state = "11") and pipes_x(0) <= N_HLINES_c+PIPE_WIDTH_c and index = (NB_OF_PIPES_c-1)) else std_logic_vector(to_unsigned(pipes_x(index+1), 10))     when ((game_state = "10" or game_state = "11") and pipes_x(index+1) <= N_HLINES_c+PIPE_WIDTH_c) else (others=>'0');
	pipe_b_h_top    <= std_logic_vector(to_unsigned(pipes_top(0), 9))    when ((game_state = "10" or game_state = "11") and pipes_x(0) <= N_HLINES_c+PIPE_WIDTH_c and index = (NB_OF_PIPES_c-1)) else std_logic_vector(to_unsigned(pipes_top(index+1), 9))    when ((game_state = "10" or game_state = "11") and pipes_x(index+1) <= N_HLINES_c+PIPE_WIDTH_c) else (others=>'0');
	pipe_b_h_bottom <= std_logic_vector(to_unsigned(pipes_bottom(0), 9)) when ((game_state = "10" or game_state = "11") and pipes_x(0) <= N_HLINES_c+PIPE_WIDTH_c and index = (NB_OF_PIPES_c-1)) else std_logic_vector(to_unsigned(pipes_bottom(index+1), 9)) when ((game_state = "10" or game_state = "11") and pipes_x(index+1) <= N_HLINES_c+PIPE_WIDTH_c) else (others=>'0');
							 	
end Behavioral;
