----------------------------------------------------------------------------------
-- Company :         HEIA-FR
-- Engineer :        Cyril Vallélian & Gilles Waeber
-- Module Name :     VGA - Behavioral
-- Project Name :    Flappy Bird
-- Target Devices :  Spartan6
-- Description :     VGA driver/controller
-- Date :            2016-04-15
-- Version :         1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.local.ALL;

entity VGA is
	 Generic( HMAX_c : integer := N_HMAX_c;
				 VMAX_c : integer := N_VMAX_c;
				 HLINES_c : integer := N_HLINES_c;
				 HFP_c : integer := N_HFP_c;
				 HSP_c : integer := N_HSP_c;
				 VLINES_c : integer := N_VLINES_c;
				 VFP_c : integer := N_VFP_c;
				 VSP_c : integer := N_VSP_c );
    Port ( pixel_clk, rst : in  STD_LOGIC;
           enable, HS, VS, blank : out  STD_LOGIC;
			  hcount : out STD_LOGIC_VECTOR(10 downto 0);
			  vcount : out STD_LOGIC_VECTOR(9 downto 0));
end VGA;

architecture Behavioral of VGA is
	
	signal hcount_s : integer range 0 to HMAX_c;
	signal vcount_s : integer range 0 to VMAX_c;
	signal HS_s : STD_LOGIC;
	signal VS_s : STD_LOGIC;
	signal blank_s : STD_LOGIC;
	
begin

	-- Pixel counter
	pixel_counter : process (pixel_clk, rst)
		
	begin
		if rst = '1' then
		
			hcount_s <= 0;
		
		elsif rising_edge(pixel_clk) then
			
			if hcount_s < HMAX_c then
				hcount_s <= hcount_s + 1;
			else
				hcount_s <= 0;
			end if;
			
		end if;
			
	end process pixel_counter;
	
	
	-- Line counter
	line_counter : process (pixel_clk, rst)
		
	begin
		if rst = '1' then
		
			vcount_s <= 0;
		
		elsif rising_edge(pixel_clk) then
			
			if hcount_s = HMAX_c then
				if vcount_s < VMAX_c then
					vcount_s <= vcount_s + 1;
				else
					vcount_s <= 0;
				end if;
			end if;
			
		end if;
			
	end process line_counter;
	
	
	-- HS
	hs_proc : process (pixel_clk)
	begin
		if rising_edge(pixel_clk) then
		
			if ((hcount_s >= HFP_c) and (hcount_s < HSP_c)) then
				HS_s <= '1';
			else
				HS_s <= '0';
			end if;
			
		end if;
	end process hs_proc;
	
	
	-- VS
	vs_proc : process (pixel_clk)
	begin
		if rising_edge(pixel_clk) then
		
			if ((vcount_s >= VFP_c) and (vcount_s < VSP_c)) then
				VS_s <= '1';
			else
				VS_s <= '0';
			end if;
			
		end if;
	end process vs_proc;
	
	
	-- blank
	blank_proc : process (pixel_clk)
	begin
		if rising_edge(pixel_clk) then
		
			if ((hcount_s < HLINES_c) and (vcount_s < VLINES_c)) then
				blank_s <= '0';
			else
				blank_s <= '1';
			end if;
			
		end if;
	end process blank_proc;
	
	
	-- Signaux sortie
	enable <= '1' when (hcount_s = 0 AND vcount_s = 0);
	hcount <= STD_LOGIC_VECTOR(to_unsigned(hcount_s, 11));
	vcount <= STD_LOGIC_VECTOR(to_unsigned(vcount_s, 10));
	HS <= HS_s;
	VS <= VS_s;
	blank <= blank_s;
	
	
end Behavioral;
