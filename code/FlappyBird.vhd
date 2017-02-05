----------------------------------------------------------------------------------
-- Company :         HEIA-FR
-- Engineer :        Cyril Vallélian & Gilles Waeber
-- Module Name :     FlappyBird - Behavioral
-- Project Name :    Flappy Bird
-- Target Devices :  Spartan6
-- Description :     Flappy Bird game
-- Date :            2016-06-17
-- Version :         1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FlappyBird is
    Port ( btn_left_unsync : in  STD_LOGIC;
           btn_right_unsync : in  STD_LOGIC;
           fpga_clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           HS : out  STD_LOGIC;
           VS : out  STD_LOGIC;
           red : out  STD_LOGIC_VECTOR (2 downto 0);
           green : out  STD_LOGIC_VECTOR (2 downto 0);
           blue : out  STD_LOGIC_VECTOR (1 downto 0));
end FlappyBird;

architecture Behavioral of FlappyBird is
	
	signal blank : STD_LOGIC;
	signal btn_left : STD_LOGIC;
	signal btn_right : STD_LOGIC;
	signal clk : STD_LOGIC;
	signal enable : STD_LOGIC;
	signal flappy_y : STD_LOGIC_VECTOR(9 downto 0);
	signal flappy_state : STD_LOGIC_VECTOR(1 downto 0);
	signal game_state : STD_LOGIC_VECTOR(1 downto 0) := "01";
	signal game_finished : STD_LOGIC;
	signal hcount : STD_LOGIC_VECTOR(10 downto 0);
	signal pipe_a_x : STD_LOGIC_VECTOR(9 downto 0);
	signal pipe_a_h_top : STD_LOGIC_VECTOR(8 downto 0);
	signal pipe_a_h_bottom : STD_LOGIC_VECTOR(8 downto 0);
	signal pipe_b_x : STD_LOGIC_VECTOR(9 downto 0);
	signal pipe_b_h_top : STD_LOGIC_VECTOR(8 downto 0);
	signal pipe_b_h_bottom : STD_LOGIC_VECTOR(8 downto 0);
	signal score : STD_LOGIC_VECTOR(9 downto 0);
	signal score_record : STD_LOGIC_VECTOR(9 downto 0);
	signal vcount : STD_LOGIC_VECTOR(9 downto 0);
	
	component dcm1
	port(
		CLK_IN1  : in  std_logic;
		CLK_OUT1 : out std_logic;
		RESET    : in  std_logic;
		LOCKED   : out std_logic
	);
	
	end component;
	
begin
	

	Btns_synchro : entity work.Btns_synchro (Behavioral)
	port map(
		  btn_right_unsync => btn_right_unsync,
		  btn_left_unsync  => btn_left_unsync,
		  clk => clk,
		  rst => rst,
		  btn_left  => btn_left,
		  btn_right => btn_right
	);
	
	Digital_Clock_Manager : dcm1
	port map(
		  CLK_IN1 => fpga_clk,
		  CLK_OUT1 => clk,
		  RESET  => rst,
		  LOCKED => open
	);
	 
	VGA : entity work.VGA (Behavioral)
	port map(
		  pixel_clk => clk,
		  rst => rst,
		  enable => enable,
		  HS => HS,
		  VS => VS,
		  blank => blank,
		  hcount => hcount,
		  vcount => vcount
	);
	
	Ctrl_game : entity work.Ctrl_game (Behavioral)
	port map(
		  btn_left => btn_left,
		  btn_right => btn_right,
		  game_finished => game_finished,
		  clk => clk,
		  rst => rst,
		  game_state => game_state
	);
	
	Flappy_pos : entity work.Flappy_pos (Behavioral)
	port map(
		  enable => enable,
		  game_state => game_state,
		  btn_left => btn_left,
		  clk => clk,
		  rst => rst,
        flappy_y => flappy_y,
		  flappy_state => flappy_state
	);
	
	Pipes_pos : entity work.Pipes_pos (Behavioral)
	port map( 
		  game_state => game_state,
		  enable => enable,
		  clk => clk,
		  rst => rst,
		  score => score,
		  btn_left => btn_left,
		  pipe_a_x => pipe_a_x,
		  pipe_a_h_top => pipe_a_h_top,
		  pipe_a_h_bottom => pipe_a_h_bottom,
		  pipe_b_x => pipe_b_x,
		  pipe_b_h_top => pipe_b_h_top,
        pipe_b_h_bottom => pipe_b_h_bottom
	);
	
	Score_calc : entity work.Score (Behavioral)
	port map(
		  game_state => game_state,
		  enable => enable,
		  pipe_a_x => pipe_a_x,
		  clk => clk,
		  rst => rst,
		  score => score,
		  score_record => score_record
	);
	
	Crashing_test : entity work.Crashing_test (Behavioral)
	port map(
		  game_state => game_state,
		  clk => clk,
		  rst => rst,
		  enable => enable,
		  flappy_y => flappy_y,
		  pipe_a_x => pipe_a_x,
		  pipe_a_h_top => pipe_a_h_top,
		  pipe_a_h_bottom => pipe_a_h_bottom,
		  game_finished => game_finished
	);
	
	Display : entity work.Display (Behavioral)
	port map(
		  game_state => game_state,
		  hcount => hcount,
		  vcount => vcount,
		  blank => blank,
		  score => score,
		  score_record => score_record,
		  flappy_y => flappy_y,
		  flappy_state => flappy_state,
		  pipe_a_x => pipe_a_x,
		  pipe_a_h_top => pipe_a_h_top,
		  pipe_a_h_bottom => pipe_a_h_bottom,
		  pipe_b_x => pipe_b_x,
		  pipe_b_h_top => pipe_b_h_top,
		  pipe_b_h_bottom => pipe_b_h_bottom,
		  clk => clk,
		  rst => rst,
		  red => red,
		  green => green,
		  blue => blue
	);
	
	
end Behavioral;
