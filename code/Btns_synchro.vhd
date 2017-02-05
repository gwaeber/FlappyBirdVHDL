----------------------------------------------------------------------------------
-- Company :         HEIA-FR
-- Engineer :        Cyril Vallélian & Gilles Waeber
-- Module Name :     Btns_synchro - Behavioral
-- Project Name :    Flappy Bird
-- Target Devices :  Spartan6
-- Description :     Synchronize inputs buttons with clock signal
-- Date :            2016-05-10
-- Version :         1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Btns_synchro is
    Port ( btn_left_unsync : in  STD_LOGIC;
           btn_right_unsync : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           btn_left : out  STD_LOGIC;
           btn_right : out  STD_LOGIC);
end Btns_synchro;

architecture Behavioral of Btns_synchro is

	type etats is (btns_no_imp, btn_left_imp, btn_left_imp_cont, btn_right_imp, btn_right_imp_cont);
	
	signal etat_present, etat_futur : etats;
	
begin
	
	
	
	-- 1 : calcul des etats futurs
	combi_etat_futur : process(etat_present, btn_left_unsync, btn_right_unsync)
	begin
	
		case etat_present is
		
			when btns_no_imp =>
				if btn_right_unsync = '1' then
					etat_futur <= btn_right_imp;
				elsif btn_left_unsync = '1' then
					etat_futur <= btn_left_imp;
				else
					etat_futur <= btns_no_imp;
				end if;
			
			when btn_right_imp =>
				if btn_right_unsync = '1' then
					etat_futur <= btn_right_imp_cont;
				else
					etat_futur <= btns_no_imp;
				end if;
			
			when btn_right_imp_cont =>
				if btn_right_unsync = '1' then
					etat_futur <= btn_right_imp_cont;
				else
					etat_futur <= btns_no_imp;
				end if;
			
			when btn_left_imp =>
				if btn_right_unsync = '1' then
					etat_futur <= btn_right_imp;
				elsif btn_left_unsync = '1' then
					etat_futur <= btn_left_imp_cont;
				else
					etat_futur <= btns_no_imp;
				end if;
			
			when btn_left_imp_cont =>
				if btn_right_unsync = '1' then
					etat_futur <= btn_right_imp;
				elsif btn_left_unsync = '1' then
					etat_futur <= btn_left_imp_cont;
				else
					etat_futur <= btns_no_imp;
				end if;
			
			when others => etat_futur <= btns_no_imp;
		
		end case;
		
	end process combi_etat_futur;
	
	
	-- 2 : registre bascules
	registre : process(clk, rst)
	begin
		
		if rst = '1' then
			etat_present <= btns_no_imp;
		elsif rising_edge(clk) then
			etat_present <= etat_futur;
		end if;
	
	end process registre;
	
	
	-- 3 : calcul des sorties
	combi_sorties : process(etat_present)
	begin
					
		case etat_present is
			
			when btns_no_imp =>
				btn_left <= '0';
				btn_right <= '0';
			when btn_left_imp =>
				btn_left  <= '1';
				btn_right <= '0';
			when btn_left_imp_cont =>
				btn_left <= '0';
				btn_right <= '0';
			when btn_right_imp =>
				btn_left <= '0';
				btn_right <= '1';
			when btn_right_imp_cont =>
				btn_left <= '0';
				btn_right <= '0';
			when others =>
				btn_left <= '0';
				btn_right <= '0';
			
		end case;
		
	end process combi_sorties;
	

end Behavioral;
