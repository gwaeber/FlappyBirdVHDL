----------------------------------------------------------------------------------
-- Company :         HEIA-FR
-- Engineer :        Cyril Vallélian & Gilles Waeber
-- Module Name :     Flappy_pos - Behavioral
-- Project Name :    Flappy Bird
-- Target Devices :  Spartan6
-- Description :     Calculate Flappy position
-- Date :            2016-06-20
-- Version :         1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.local.ALL;

entity Flappy_pos is
    Port ( enable : in  STD_LOGIC;
			  game_state : in  STD_LOGIC_VECTOR (1 downto 0);
           btn_left : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           flappy_y : out  STD_LOGIC_VECTOR (9 downto 0);
			  flappy_state : out STD_LOGIC_VECTOR (1 downto 0) -- 00 decr, 01 normal, 10 incr, 11 not used
			);
end Flappy_pos;

architecture Behavioral of Flappy_pos is
	
	type etats is (decr, incr);
	
	signal etat_present, etat_futur : etats;
	
	signal flappy_y_s : integer range 0 to FLAPPY_Y_MAX_c := FLAPPY_Y_START_POS_c;
	signal nb_of_incr : integer range 0 to NB_OF_INCR_MAX_c := 0;
	signal steps      : integer range 0 to STEPS_FLAPPY_MAX_c := 0;
	
	
begin
	
	-- Compteur de paliers pour l'incrémentation (saut)
	process(clk, rst)
	begin
		
		if rst = '1' then
			nb_of_incr <= 0;
		elsif rising_edge(clk) then
			
			if enable = '1' and game_state = "10" then
			
				if etat_present = incr then
				
					if nb_of_incr = NB_OF_INCR_MAX_c then
						nb_of_incr <= 0;
					else
						if steps = STEPS_FLAPPY_MAX_c then
							nb_of_incr <= nb_of_incr + 1;
						end if;
					end if;
				
				else
				
					nb_of_incr <= 0;

				end if;
			
			
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
			
				if steps = STEPS_FLAPPY_MAX_c then
					steps <= 0;
				else
					steps <= steps + 1;
				end if;
			
			end if;
			
		end if;
	
	end process;
	
	
	-- Calcul des etats futurs
	combi_etat_futur : process(rst, etat_present, btn_left, nb_of_incr)
	begin
		
		if rst = '1' then
			etat_futur <= decr;
		else
			
			case etat_present is
		
				when decr =>
					if btn_left = '1' then
						etat_futur <= incr;
					else
						etat_futur <= decr;
					end if;
				
				when incr =>
					if nb_of_incr = NB_OF_INCR_MAX_c then
						etat_futur <= decr;
					else
						etat_futur <= incr;
					end if;
				
				when others => etat_futur <= decr;
			
			end case;
			
		end if;
		
	end process combi_etat_futur;
	
	
	-- Registre bascules
	registre : process(clk, rst)
	begin
		
		if rst = '1' then
			etat_present <= decr;
		elsif rising_edge(clk) then
			etat_present <= etat_futur;
		end if;
	
	end process registre;
	
	
	-- Calcul des sorties
	process(clk, rst)
	begin
		
		if rst = '1' then
			
			flappy_y_s   <= FLAPPY_Y_START_POS_c;
			flappy_state <= "00";
			
		elsif rising_edge(clk) then
			
			if enable = '1' and game_state = "10" then
				
				if etat_present = incr then
					
					if steps = STEPS_FLAPPY_MAX_c then
						if flappy_y_s > (FLAPPY_SIZE_c/2) then
							flappy_y_s <= flappy_y_s - 1;
						end if;
					end if;
					
					flappy_state <= "10";
					
				else
				
					if steps = STEPS_FLAPPY_MAX_c then
						if flappy_y_s < (N_VLINES_c-(FLAPPY_SIZE_c/2)) then
							flappy_y_s <= flappy_y_s + 1;
						end if;
					end if;
					
					flappy_state <= "00";
					
				end if;
				
			elsif game_state = "00" or game_state = "01" then
				
				flappy_y_s   <= FLAPPY_Y_START_POS_c;
				flappy_state <= "01";
				
			end if;
			
		end if;
		
	end process;
	
	flappy_y    <= STD_LOGIC_VECTOR(to_unsigned(flappy_y_s, 10));
	
	
end Behavioral;
