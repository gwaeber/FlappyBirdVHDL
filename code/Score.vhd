----------------------------------------------------------------------------------
-- Company :         HEIA-FR
-- Engineer :        Cyril Vallélian & Gilles Waeber
-- Module Name :     Score - Behavioral
-- Project Name :    Flappy Bird
-- Target Devices :  Spartan6
-- Description :     Calculate score
-- Date :            2016-06-18
-- Version :         1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.local.ALL;

entity Score is
    Port ( game_state : in  STD_LOGIC_VECTOR (1 downto 0);
           enable : in  STD_LOGIC;
           pipe_a_x : in  STD_LOGIC_VECTOR (9 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           score : out  STD_LOGIC_VECTOR (9 downto 0);
			  score_record: out STD_LOGIC_VECTOR (9 downto 0));
end Score;

architecture Behavioral of Score is

	signal pipe_a_x_s : integer range 0 to (2**(pipe_a_x'LENGTH));
	signal score_s : integer range 0 to 1000 := 0;
	signal score_record_s : integer range 0 to 1000 := 0;

begin

	pipe_a_x_s <= to_integer(unsigned(pipe_a_x));
	
	-- Calcul du score
	process(clk, rst)
	begin
		
		if rst = '1' then
		
			score_s <= 0;
			score_record_s <= 0;
			
		elsif rising_edge(clk) then
			
			if enable = '1' then
				if game_state = "10" then
				
					-- Test incrémentation score
					if(pipe_a_x_s = (FLAPPY_X_POS_c - (FLAPPY_SIZE_c/2)+1)) then
					
						if score_s = SCORE_MAX_C then
							score_s <= 0;
						else
							score_s <= score_s + 1;
						end if;
						
					end if;

				elsif game_state = "00" or game_state = "01" then
				
					-- Reset du score lors du redemarrage de la partie
					score_s <= 0;
					
				elsif game_state = "11" then
				
					if(score_s > score_record_s) then
						score_record_s <= score_s;
					end if;
				
				end if;
			
			end if;
			
		end if;
		
	end process;
	
	
	score <= std_logic_vector(to_unsigned(score_s, 10));
	score_record <= std_logic_vector(to_unsigned(score_record_s, 10));

end Behavioral;