----------------------------------------------------------------------------------
-- Company :         HEIA-FR
-- Engineer :        Cyril Vallélian & Gilles Waeber
-- Module Name :     Display - Behavioral
-- Project Name :    Flappy Bird
-- Target Devices :  Spartan6
-- Description :     Display all graphical elements
-- Date :            2016-06-18
-- Version :         1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.local.ALL;
use work.local_display.ALL;

entity Display is
    Port ( game_state : in  STD_LOGIC_VECTOR (1 downto 0);
			  hcount : in STD_LOGIC_VECTOR(10 downto 0);
			  vcount : in STD_LOGIC_VECTOR(9 downto 0);
			  blank : in STD_LOGIC;
           score : in  STD_LOGIC_VECTOR (9 downto 0);
			  score_record : in  STD_LOGIC_VECTOR (9 downto 0);
           flappy_y : in  STD_LOGIC_VECTOR (9 downto 0);
			  flappy_state : in STD_LOGIC_VECTOR (1 downto 0);
           pipe_a_x : in  STD_LOGIC_VECTOR (9 downto 0);
           pipe_a_h_top : in  STD_LOGIC_VECTOR (8 downto 0);
           pipe_a_h_bottom : in  STD_LOGIC_VECTOR (8 downto 0);
           pipe_b_x : in  STD_LOGIC_VECTOR (9 downto 0);
           pipe_b_h_top : in  STD_LOGIC_VECTOR (8 downto 0);
           pipe_b_h_bottom : in  STD_LOGIC_VECTOR (8 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;			  
           red : out  STD_LOGIC_VECTOR (2 downto 0);
           green : out  STD_LOGIC_VECTOR (2 downto 0);
           blue : out  STD_LOGIC_VECTOR (1 downto 0));
end Display;

architecture Behavioral of Display is

	-- global
	signal color_s  : STD_LOGIC_VECTOR(7 downto 0);
	signal hcount_s : integer range 0 to N_HMAX_c;
	signal vcount_s : integer range 0 to N_VMAX_c;
	-- flappy
	signal flappy_y_s : integer range 0 to FLAPPY_Y_MAX_c;
	-- pipes
	signal pipe_a_x_s        : integer range 0 to (2**(pipe_a_x'LENGTH));
	signal pipe_a_h_top_s    : integer range 0 to (2**(pipe_a_h_top'LENGTH));
	signal pipe_a_h_bottom_s : integer range 0 to (2**(pipe_a_h_bottom'LENGTH));
	signal pipe_b_x_s        : integer range 0 to (2**(pipe_b_x'LENGTH));
	signal pipe_b_h_top_s    : integer range 0 to (2**(pipe_b_h_top'LENGTH));
	signal pipe_b_h_bottom_s : integer range 0 to (2**(pipe_b_h_bottom'LENGTH));
	-- score
	signal score_s           : integer range 0 to 1000;
	signal score_record_s    : integer range 0 to 1000;
	-- background
	signal d_background_addr : STD_LOGIC_VECTOR(14 downto 0);
	signal d_background_s    : STD_LOGIC_VECTOR(7 downto 0);
	
	COMPONENT d_background
	  PORT (
		 clka : IN STD_LOGIC;
		 addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	-- menu start
	signal d_menu_start_logo_addr : STD_LOGIC_VECTOR(14 downto 0);
	signal d_menu_start_inst_addr : STD_LOGIC_VECTOR(13 downto 0);
	signal d_menu_start_text_addr : STD_LOGIC_VECTOR(12 downto 0);
	signal d_menu_start_logo_s    : STD_LOGIC_VECTOR(7 downto 0);
	signal d_menu_start_inst_s    : STD_LOGIC_VECTOR(7 downto 0);
	signal d_menu_start_text_s    : STD_LOGIC_VECTOR(7 downto 0);
	
	COMPONENT d_menu_start_logo
	  PORT (
		 clka : IN STD_LOGIC;
		 addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	COMPONENT d_menu_start_inst
	  PORT (
		 clka : IN STD_LOGIC;
		 addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	COMPONENT d_menu_start_text
	  PORT (
		 clka : IN STD_LOGIC;
		 addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	
	
	
begin

   -- background
	d_background_addr <= STD_LOGIC_VECTOR(to_unsigned((hcount_s/2 mod BACKGROUND_WIDTH_c) + (((vcount_s-(N_VLINES_c-BACKGROUND_HEIGHT_c*2))/2 mod BACKGROUND_HEIGHT_c) * BACKGROUND_WIDTH_c), 15));
	
	d_background_comp : d_background
	port map(
		  clka => clk,
        addra => d_background_addr,
	     douta => d_background_s
	);
	
	
	
	-- display addr
	d_menu_start_logo_addr <= STD_LOGIC_VECTOR(to_unsigned(((hcount_s-MENU_START_LOGO_POS_H_c)/2 mod MENU_START_LOGO_WIDTH_c) + (((vcount_s-MENU_START_LOGO_POS_V_c)/2 mod MENU_START_LOGO_HEIGHT_c) * MENU_START_LOGO_WIDTH_c), 15));
	d_menu_start_inst_addr <= STD_LOGIC_VECTOR(to_unsigned(((hcount_s-MENU_START_INST_POS_H_c)/2 mod MENU_START_INST_WIDTH_c) + (((vcount_s-MENU_START_INST_POS_V_c)/2 mod MENU_START_INST_HEIGHT_c) * MENU_START_INST_WIDTH_c), 14));
	d_menu_start_text_addr <= STD_LOGIC_VECTOR(to_unsigned(((hcount_s-MENU_START_TEXT_POS_H_c)/2 mod MENU_START_TEXT_WIDTH_c) + (((vcount_s-MENU_START_TEXT_POS_V_c)/2 mod MENU_START_TEXT_HEIGHT_c) * MENU_START_TEXT_WIDTH_c), 13));
	
	
	-- display comp
	d_menu_start_logo_comp : d_menu_start_logo
	port map(
		  clka => clk,
        addra => d_menu_start_logo_addr,
	     douta => d_menu_start_logo_s
	);
	
	d_menu_start_inst_comp : d_menu_start_inst
   port map(
        clka => clk,
        addra => d_menu_start_inst_addr,
        douta => d_menu_start_inst_s
   );
	
	d_menu_start_text_comp : d_menu_start_text
   port map(
        clka => clk,
        addra => d_menu_start_text_addr,
        douta => d_menu_start_text_s
   );
	

	
	
	-- global
	hcount_s <= to_integer(unsigned(hcount));
	vcount_s <= to_integer(unsigned(vcount));
	-- flappy
	flappy_y_s <= to_integer(unsigned(flappy_y));
	-- pipes
	pipe_a_x_s <= to_integer(unsigned(pipe_a_x));
	pipe_a_h_top_s <= to_integer(unsigned(pipe_a_h_top));
	pipe_a_h_bottom_s <= to_integer(unsigned(pipe_a_h_bottom));
	pipe_b_x_s <= to_integer(unsigned(pipe_b_x));
	pipe_b_h_top_s <= to_integer(unsigned(pipe_b_h_top));
	pipe_b_h_bottom_s <= to_integer(unsigned(pipe_b_h_bottom));
	-- score
	score_s <= to_integer(unsigned(score));
	score_record_s <= to_integer(unsigned(score_record));
	
	
	draw : process(hcount_s, vcount_s, game_state, rst)
	
		variable flappy_vcount_min : integer range 0 to N_VLINES_c;
		variable flappy_vcount_max : integer range 0 to N_VLINES_c;
		variable flappy_hcount_min : integer range 0 to N_HLINES_c;
		variable flappy_hcount_max : integer range 0 to N_HLINES_c;
		variable flappy_v_index    : integer range 0 to FLAPPY_SIZE_c;
		variable flappy_h_index    : integer range 0 to FLAPPY_SIZE_c;
		variable digit_1, digit_2, digit_3 : integer range 0 to 9;
		variable digit_1_max, digit_2_max, digit_3_max : integer range 0 to 9;
		
	begin
		
		color_s <= COLOR_BLUE;
	
		if rst='1' then
		
			color_s <= COLOR_BLUE;
		
		-- State : menu
		elsif game_state = "00" then
			
			-- draw logo
			if (vcount_s >= MENU_START_LOGO_POS_V_c and vcount_s < (MENU_START_LOGO_POS_V_c+MENU_START_LOGO_HEIGHT_c*2) and hcount_s >= MENU_START_LOGO_POS_H_c and hcount_s < (MENU_START_LOGO_POS_H_c+MENU_START_LOGO_WIDTH_c*2)) then
				color_s <= d_menu_start_logo_s;
				
			-- draw flappy
			elsif (vcount_s >= MENU_START_FLAPPY_POS_V_c and vcount_s < (MENU_START_FLAPPY_POS_V_c+MENU_START_FLAPPY_SIZE_c*2) and hcount_s >= MENU_START_FLAPPY_POS_H_c and hcount_s < (MENU_START_FLAPPY_POS_H_c+MENU_START_FLAPPY_SIZE_c*2)) then
				color_s <= d_flappy((hcount_s-MENU_START_FLAPPY_POS_H_c)/2, (vcount_s-MENU_START_FLAPPY_POS_V_c)/2);
			
			-- draw instructions
			elsif (vcount_s >= MENU_START_INST_POS_V_c and vcount_s < (MENU_START_INST_POS_V_c+MENU_START_INST_HEIGHT_c*2) and hcount_s >= MENU_START_INST_POS_H_c and hcount_s < (MENU_START_INST_POS_H_c+MENU_START_INST_WIDTH_c*2)) then
				color_s <= d_menu_start_inst_s;
				
			-- draw start text
			elsif (vcount_s >= MENU_START_TEXT_POS_V_c and vcount_s < (MENU_START_TEXT_POS_V_c+MENU_START_TEXT_HEIGHT_c*2) and hcount_s >= MENU_START_TEXT_POS_H_c and hcount_s < (MENU_START_TEXT_POS_H_c+MENU_START_TEXT_WIDTH_c*2)) then
				color_s <= d_menu_start_text_s;
				
			end if;
			
			
		-- State : start game / game / end game
		elsif game_state = "01" or game_state = "10" or game_state = "11" then
		   	
			-- drawing values
			flappy_vcount_min := flappy_y_s - (FLAPPY_SIZE_c/2);
			flappy_vcount_max := flappy_y_s + (FLAPPY_SIZE_c/2);
			flappy_hcount_min := FLAPPY_X_POS_c - (FLAPPY_SIZE_c/2);
			flappy_hcount_max := FLAPPY_X_POS_c + (FLAPPY_SIZE_c/2);
			
			flappy_v_index := vcount_s-flappy_vcount_min;
			flappy_h_index := hcount_s-flappy_hcount_min;
				
			digit_1     := score_s/100;
			digit_2     := (score_s/10) mod 10;
			digit_3     := score_s mod 10;
			digit_1_max := score_record_s/100;
			digit_2_max := (score_record_s/10) mod 10;
			digit_3_max := score_record_s mod 10;
			
			
			-- draw header and score
			if (vcount_s <= HEADER_SIZE_c) then
				
				-- score
				if(hcount_s >= HEADER_SCORE_SHIFT_c and hcount_s <= (HEADER_SCORE_WIDTH_c + HEADER_SCORE_SHIFT_c) ) then
					color_s <= d_score((hcount_s-HEADER_SCORE_SHIFT_c), (vcount_s));
				-- score digit 1
				elsif(hcount_s >= HEADER_SCORE_D1_c and hcount_s < HEADER_SCORE_D2_c) then
					case digit_1 is
						when 0 => color_s <= d_digit_0((hcount_s-HEADER_SCORE_D1_c), (vcount_s));
						when 1 => color_s <= d_digit_1((hcount_s-HEADER_SCORE_D1_c), (vcount_s));
						when 2 => color_s <= d_digit_2((hcount_s-HEADER_SCORE_D1_c), (vcount_s));
						when 3 => color_s <= d_digit_3((hcount_s-HEADER_SCORE_D1_c), (vcount_s));
						when 4 => color_s <= d_digit_4((hcount_s-HEADER_SCORE_D1_c), (vcount_s));
						when 5 => color_s <= d_digit_5((hcount_s-HEADER_SCORE_D1_c), (vcount_s));
						when 6 => color_s <= d_digit_6((hcount_s-HEADER_SCORE_D1_c), (vcount_s));
						when 7 => color_s <= d_digit_7((hcount_s-HEADER_SCORE_D1_c), (vcount_s));
						when 8 => color_s <= d_digit_8((hcount_s-HEADER_SCORE_D1_c), (vcount_s));
						when 9 => color_s <= d_digit_9((hcount_s-HEADER_SCORE_D1_c), (vcount_s));
						when others => color_s <= d_digit_0((hcount_s-HEADER_SCORE_D1_c), (vcount_s));
					end case;
				-- score digit 2
				elsif(hcount_s >= HEADER_SCORE_D2_c and hcount_s < HEADER_SCORE_D3_c) then
					case digit_2 is
						when 0 => color_s <= d_digit_0((hcount_s-HEADER_SCORE_D2_c), (vcount_s));
						when 1 => color_s <= d_digit_1((hcount_s-HEADER_SCORE_D2_c), (vcount_s));
						when 2 => color_s <= d_digit_2((hcount_s-HEADER_SCORE_D2_c), (vcount_s));
						when 3 => color_s <= d_digit_3((hcount_s-HEADER_SCORE_D2_c), (vcount_s));
						when 4 => color_s <= d_digit_4((hcount_s-HEADER_SCORE_D2_c), (vcount_s));
						when 5 => color_s <= d_digit_5((hcount_s-HEADER_SCORE_D2_c), (vcount_s));
						when 6 => color_s <= d_digit_6((hcount_s-HEADER_SCORE_D2_c), (vcount_s));
						when 7 => color_s <= d_digit_7((hcount_s-HEADER_SCORE_D2_c), (vcount_s));
						when 8 => color_s <= d_digit_8((hcount_s-HEADER_SCORE_D2_c), (vcount_s));
						when 9 => color_s <= d_digit_9((hcount_s-HEADER_SCORE_D2_c), (vcount_s));
						when others => color_s <= d_digit_0((hcount_s-HEADER_SCORE_D2_c), (vcount_s));
					end case;
				-- score digit 3
				elsif(hcount_s >= HEADER_SCORE_D3_c and hcount_s < (HEADER_SCORE_D3_c + HEADER_SCORE_D_WIDTH_c)) then
					case digit_3 is
						when 0 => color_s <= d_digit_0((hcount_s-HEADER_SCORE_D3_c), (vcount_s));
						when 1 => color_s <= d_digit_1((hcount_s-HEADER_SCORE_D3_c), (vcount_s));
						when 2 => color_s <= d_digit_2((hcount_s-HEADER_SCORE_D3_c), (vcount_s));
						when 3 => color_s <= d_digit_3((hcount_s-HEADER_SCORE_D3_c), (vcount_s));
						when 4 => color_s <= d_digit_4((hcount_s-HEADER_SCORE_D3_c), (vcount_s));
						when 5 => color_s <= d_digit_5((hcount_s-HEADER_SCORE_D3_c), (vcount_s));
						when 6 => color_s <= d_digit_6((hcount_s-HEADER_SCORE_D3_c), (vcount_s));
						when 7 => color_s <= d_digit_7((hcount_s-HEADER_SCORE_D3_c), (vcount_s));
						when 8 => color_s <= d_digit_8((hcount_s-HEADER_SCORE_D3_c), (vcount_s));
						when 9 => color_s <= d_digit_9((hcount_s-HEADER_SCORE_D3_c), (vcount_s));
						when others => color_s <= d_digit_0((hcount_s-HEADER_SCORE_D3_c), (vcount_s));
					end case;
				
				
				-- title
				elsif (hcount_s >= HEADER_TITLE_LEFT_c and hcount_s <= HEADER_TITLE_RIGHT_c) then
					color_s <= d_title((hcount_s-HEADER_TITLE_LEFT_c), (vcount_s));
				
				-- score max
				elsif(hcount_s >= HEADER_SCOREMAX_POS_c and hcount_s < (HEADER_SCOREMAX_POS_c + HEADER_SCOREMAX_WIDTH_c) ) then
					color_s <= d_score_max((hcount_s-HEADER_SCOREMAX_POS_c), (vcount_s));
				-- score max digit 1
				elsif(hcount_s >= HEADER_SCOREMAX_D1_c and hcount_s < HEADER_SCOREMAX_D2_c) then
					case digit_1_max is
						when 0 => color_s <= d_digit_0((hcount_s-HEADER_SCOREMAX_D1_c), (vcount_s));
						when 1 => color_s <= d_digit_1((hcount_s-HEADER_SCOREMAX_D1_c), (vcount_s));
						when 2 => color_s <= d_digit_2((hcount_s-HEADER_SCOREMAX_D1_c), (vcount_s));
						when 3 => color_s <= d_digit_3((hcount_s-HEADER_SCOREMAX_D1_c), (vcount_s));
						when 4 => color_s <= d_digit_4((hcount_s-HEADER_SCOREMAX_D1_c), (vcount_s));
						when 5 => color_s <= d_digit_5((hcount_s-HEADER_SCOREMAX_D1_c), (vcount_s));
						when 6 => color_s <= d_digit_6((hcount_s-HEADER_SCOREMAX_D1_c), (vcount_s));
						when 7 => color_s <= d_digit_7((hcount_s-HEADER_SCOREMAX_D1_c), (vcount_s));
						when 8 => color_s <= d_digit_8((hcount_s-HEADER_SCOREMAX_D1_c), (vcount_s));
						when 9 => color_s <= d_digit_9((hcount_s-HEADER_SCOREMAX_D1_c), (vcount_s));
						when others => color_s <= d_digit_0((hcount_s-HEADER_SCOREMAX_D1_c), (vcount_s));
					end case;
				-- score max digit 2
				elsif(hcount_s >= HEADER_SCOREMAX_D2_c and hcount_s < HEADER_SCOREMAX_D3_c) then
					case digit_2_max is
						when 0 => color_s <= d_digit_0((hcount_s-HEADER_SCOREMAX_D2_c), (vcount_s));
						when 1 => color_s <= d_digit_1((hcount_s-HEADER_SCOREMAX_D2_c), (vcount_s));
						when 2 => color_s <= d_digit_2((hcount_s-HEADER_SCOREMAX_D2_c), (vcount_s));
						when 3 => color_s <= d_digit_3((hcount_s-HEADER_SCOREMAX_D2_c), (vcount_s));
						when 4 => color_s <= d_digit_4((hcount_s-HEADER_SCOREMAX_D2_c), (vcount_s));
						when 5 => color_s <= d_digit_5((hcount_s-HEADER_SCOREMAX_D2_c), (vcount_s));
						when 6 => color_s <= d_digit_6((hcount_s-HEADER_SCOREMAX_D2_c), (vcount_s));
						when 7 => color_s <= d_digit_7((hcount_s-HEADER_SCOREMAX_D2_c), (vcount_s));
						when 8 => color_s <= d_digit_8((hcount_s-HEADER_SCOREMAX_D2_c), (vcount_s));
						when 9 => color_s <= d_digit_9((hcount_s-HEADER_SCOREMAX_D2_c), (vcount_s));
						when others => color_s <= d_digit_0((hcount_s-HEADER_SCOREMAX_D2_c), (vcount_s));
					end case;
				-- score max digit 3
				elsif(hcount_s >= HEADER_SCOREMAX_D3_c and hcount_s < (HEADER_SCOREMAX_D3_c + HEADER_SCORE_D_WIDTH_c)) then
					case digit_3_max is
						when 0 => color_s <= d_digit_0((hcount_s-HEADER_SCOREMAX_D3_c), (vcount_s));
						when 1 => color_s <= d_digit_1((hcount_s-HEADER_SCOREMAX_D3_c), (vcount_s));
						when 2 => color_s <= d_digit_2((hcount_s-HEADER_SCOREMAX_D3_c), (vcount_s));
						when 3 => color_s <= d_digit_3((hcount_s-HEADER_SCOREMAX_D3_c), (vcount_s));
						when 4 => color_s <= d_digit_4((hcount_s-HEADER_SCOREMAX_D3_c), (vcount_s));
						when 5 => color_s <= d_digit_5((hcount_s-HEADER_SCOREMAX_D3_c), (vcount_s));
						when 6 => color_s <= d_digit_6((hcount_s-HEADER_SCOREMAX_D3_c), (vcount_s));
						when 7 => color_s <= d_digit_7((hcount_s-HEADER_SCOREMAX_D3_c), (vcount_s));
						when 8 => color_s <= d_digit_8((hcount_s-HEADER_SCOREMAX_D3_c), (vcount_s));
						when 9 => color_s <= d_digit_9((hcount_s-HEADER_SCOREMAX_D3_c), (vcount_s));
						when others => color_s <= d_digit_0((hcount_s-HEADER_SCOREMAX_D3_c), (vcount_s));
					end case;
				
				else
					color_s <= COLOR_GREY;
				end if;
			
			
		   -- draw pipes
			
			-- pipe A bottom
			elsif (hcount_s >= (pipe_a_x_s-PIPE_WIDTH_c) and hcount_s <= pipe_a_x_s and vcount_s >= (N_VLINES_c-pipe_a_h_bottom_s)) then
				color_s <= COLOR_GREEN;
			
			-- pipe A top
			elsif (hcount_s >= (pipe_a_x_s-PIPE_WIDTH_c) and hcount_s <= pipe_a_x_s and vcount_s <= pipe_a_h_top_s) then
				color_s <= COLOR_GREEN;
			
			-- pipe B bottom
			elsif (hcount_s >= (pipe_b_x_s-PIPE_WIDTH_c) and hcount_s <= pipe_b_x_s and vcount_s >= (N_VLINES_c-pipe_b_h_bottom_s)) then
				color_s <= COLOR_GREEN;
				
			-- pipe B top
			elsif (hcount_s >= (pipe_b_x_s-PIPE_WIDTH_c) and hcount_s <= pipe_b_x_s and vcount_s <= pipe_b_h_top_s) then
				color_s <= COLOR_GREEN;
			
			-- draw flappy
			elsif (vcount_s>=flappy_vcount_min and vcount_s<flappy_vcount_max and hcount_s>=flappy_hcount_min and hcount_s<flappy_hcount_max and ((flappy_state = "00" and d_flappy_decr_bg_status(flappy_h_index, flappy_v_index) = '1') or (flappy_state = "10" and d_flappy_incr_bg_status(flappy_h_index, flappy_v_index) = '1') or (flappy_state = "01" and d_flappy_bg_status(flappy_h_index, flappy_v_index) = '1'))  ) then
				
				if game_state = "11" then
				
					--color_s   <= d_flappy_dead(flappy_h_index, flappy_v_index);								-- flappy dead
					case flappy_state is
						when "00" => color_s   <= d_flappy_dead_decr(flappy_h_index, flappy_v_index);		-- flappy falling
						when "10" => color_s   <= d_flappy_dead_incr(flappy_h_index, flappy_v_index);		-- flappy rising
						when others => color_s <= d_flappy_dead(flappy_h_index, flappy_v_index);			-- flappy normal
					end case;
				
				else
					
					case flappy_state is
						when "00" => color_s   <= d_flappy_decr(flappy_h_index, flappy_v_index);		-- flappy falling
						when "10" => color_s   <= d_flappy_incr(flappy_h_index, flappy_v_index);		-- flappy rising
						when others => color_s <= d_flappy(flappy_h_index, flappy_v_index);				-- flappy normal
					end case;
				
				end if;
				
			-- draw background
			elsif (vcount_s >= (N_VLINES_c-(BACKGROUND_HEIGHT_c*2))) then
				color_s <= d_background_s;
			
			-- draw start game
			elsif (game_state = "01" and vcount_s >= GAME_BEGIN_TEXT_POS_V_c and vcount_s < (GAME_BEGIN_TEXT_POS_V_c+GAME_BEGIN_TEXT_HEIGHT_c) and hcount_s >= GAME_BEGIN_TEXT_POS_H_c and hcount_s < (GAME_BEGIN_TEXT_POS_H_c+GAME_BEGIN_TEXT_WIDTH_c)) then
				color_s <= d_start_game_text((hcount_s-GAME_BEGIN_TEXT_POS_H_c), (vcount_s-GAME_BEGIN_TEXT_POS_V_c));

			end if;

			
		else
		
			color_s <= COLOR_BLUE;
		
		end if;
		
	end process;
	
	red   <= color_s(7 downto 5) when blank='0' else "000";
	green <= color_s(4 downto 2) when blank='0' else "000";
	blue  <= color_s(1 downto 0) when blank='0' else "00";

end Behavioral;
