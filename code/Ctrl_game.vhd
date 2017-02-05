----------------------------------------------------------------------------------
-- Company :         HEIA-FR
-- Engineer :        Cyril Vallélian & Gilles Waeber
-- Module Name :     Ctrl_game - Behavioral
-- Project Name :    Flappy Bird
-- Target Devices :  Spartan6
-- Description :     Game controller
-- Date :            2016-06-10
-- Version :         1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ctrl_game is
    Port ( btn_left : in  STD_LOGIC;
           btn_right : in  STD_LOGIC;
           game_finished : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           game_state : out  STD_LOGIC_VECTOR (1 downto 0));
end Ctrl_game;

architecture Behavioral of Ctrl_game is

	type etats is (Start_menu, Start_game, Game, End_Game);
	signal etat_present, etat_futur : etats;

begin

	-- 1 : calcul des etats futurs
	combi_etat_futur : process(etat_present, btn_left, btn_right, game_finished)
	begin
	
		case etat_present is
		
			when Start_menu =>
				if btn_left = '1' then
					etat_futur <= Start_game;
				else
					etat_futur <= Start_menu;
				end if;
				
			when Start_game =>
				if btn_left = '1' then
					etat_futur <= Game;
				else
					etat_futur <= Start_game;
				end if;
				
			when Game =>
				if btn_right = '1' then
					etat_futur <= Start_game;
				elsif game_finished = '1' then
					etat_futur <= End_game;
				else
					etat_futur <= Game;
				end if;
				
			when End_game =>
				if btn_right ='1' then
					etat_futur <= Start_game;
				else
					etat_futur <= End_game;
				end if;
	
			when others => etat_futur <= Start_game;
		
		end case;
		
	end process combi_etat_futur;

	-- 2 : registre bascules
	registre : process(clk, rst)
	begin
		
		if rst = '1' then
			etat_present <= Start_menu;
		elsif rising_edge(clk) then
			etat_present <= etat_futur;
		end if;
	
	end process registre;

	-- 3 : calcul des sorties
	combi_sorties : process(etat_present)
	begin
	
		case etat_present is
		
			when Start_menu => game_state <= "00";
			when Start_game => game_state <= "01";
			when Game       => game_state <= "10";
			when End_Game   => game_state <= "11";
			when others     => game_state <= "00";
			
		end case;
		
	end process combi_sorties;

end Behavioral;

