----------------------------------------------------------------------------------
-- Company :         HEIA-FR
-- Engineer :        Cyril Vallélian & Gilles Waeber
-- Module Name :     Local
-- Project Name :    Flappy Bird
-- Target Devices :  Spartan6
-- Description :     Local package for global constants
-- Date :            2016-06-20
-- Version :         1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package local is
   
	-- VGA
	Constant N_HMAX_c                   : integer := 1056;
	Constant N_VMAX_c                   : integer := 628;
	Constant N_HLINES_c                 : integer := 800;
	Constant N_HFP_c                    : integer := 840;
	Constant N_HSP_c                    : integer := 968;
	Constant N_VLINES_c                 : integer := 600;
	Constant N_VFP_c                    : integer := 601;
	Constant N_VSP_c                    : integer := 605;

	-- Flappy_pos
	constant FLAPPY_Y_MAX_c             : integer := N_VLINES_c;
	constant FLAPPY_Y_START_POS_c       : integer := 320;
	constant FLAPPY_X_POS_c             : integer := 280;
	constant FLAPPY_SIZE_c              : integer := 40;
	constant NB_OF_INCR_MAX_c           : integer := 60;
	constant STEPS_FLAPPY_MAX_c         : integer := 150000;
	
	-- Score
	constant SCORE_MAX_C                : integer := 999;
	
	-- Pipes_pos
	constant NB_OF_PIPES_c              : integer := 3;
	constant PIPE_WIDTH_c               : integer := 100;
	constant STEPS_PIPE_MAX_c           : integer := 150000;
	
	constant RANDOM_MIN_c               : integer := 100;	
	constant RANDOM_MAX_c               : integer := 400;
	constant SPACE_MIN_c                : integer := 120;
	constant SPACE_MAX_c                : integer := 200;
	constant SPACE_MODULO_c             : integer := 5;
	constant SPACE_REDUCTION_STEP_c     : integer := 10;
	constant SPACE_NB_OF_DEC_c          : integer := ((SPACE_MAX_c-SPACE_MIN_c)/SPACE_REDUCTION_STEP_c);
	
	type     t_pipes_h is array(0 to NB_OF_PIPES_c-1) of integer range 0 to RANDOM_MAX_c;
	type     t_pipes_x is array(0 to NB_OF_PIPES_c-1) of integer range 0 to 2500;
	signal   pipes_top_o                : t_pipes_h := (200, 150, 300);
	signal   pipes_bottom_o             : t_pipes_h := (200, 250, 100);
	signal   pipes_x_o                  : t_pipes_x := (1500, 2000, 2500);
	constant PIPE_LAST_POS              : integer := 1500;

	-- Crashing_test
	constant FLAPPY_CRASH_ADJ_TOP_c     : integer := 6;
	constant FLAPPY_CRASH_ADJ_c         : integer := 4;
	
	-- Display
	constant HEADER_SIZE_c              : integer := 30;
	constant HEADER_SCORE_WIDTH_c       : integer := 110;
	constant HEADER_SCORE_SHIFT_c       : integer := 5;
	constant HEADER_SCORE_D_WIDTH_c     : integer := 20;
	constant HEADER_SCORE_D1_c          : integer := (HEADER_SCORE_SHIFT_c + HEADER_SCORE_WIDTH_c);
	constant HEADER_SCORE_D2_c          : integer := (HEADER_SCORE_D1_c + (HEADER_SCORE_D_WIDTH_c-1));
	constant HEADER_SCORE_D3_c          : integer := (HEADER_SCORE_D2_c + (HEADER_SCORE_D_WIDTH_c-1));
	
	constant HEADER_TITLE_LEFT_c        : integer := 325;
	constant HEADER_TITLE_RIGHT_c       : integer := 475;
	
	constant HEADER_SCOREMAX_POS_c      : integer := 555;
	constant HEADER_SCOREMAX_WIDTH_c    : integer := 180;
	constant HEADER_SCOREMAX_D1_c       : integer := (HEADER_SCOREMAX_POS_c + HEADER_SCOREMAX_WIDTH_c);
	constant HEADER_SCOREMAX_D2_c       : integer := (HEADER_SCOREMAX_D1_c + (HEADER_SCORE_D_WIDTH_c-1));
	constant HEADER_SCOREMAX_D3_c       : integer := (HEADER_SCOREMAX_D2_c + (HEADER_SCORE_D_WIDTH_c-1));
	
	constant GAME_BEGIN_TEXT_WIDTH_c    : integer := 255;
	constant GAME_BEGIN_TEXT_HEIGHT_c   : integer := 30;
	constant GAME_BEGIN_TEXT_POS_H_c    : integer := 273;
	constant GAME_BEGIN_TEXT_POS_V_c    : integer := 420;
	
	constant GAME_END_TEXT_WIDTH_c      : integer := 280;
	constant GAME_END_TEXT_HEIGHT_c     : integer := 30;
	constant GAME_END_TEXT_POS_H_c      : integer := 440;
	constant GAME_END_TEXT_POS_V_c      : integer := 220;
	
	constant BACKGROUND_WIDTH_c         : integer := 400;
	constant BACKGROUND_HEIGHT_c        : integer := 60;
	
	constant MENU_START_LOGO_WIDTH_c    : integer := 325;
	constant MENU_START_LOGO_HEIGHT_c   : integer := 65;
	constant MENU_START_LOGO_POS_H_c    : integer := 75;
	constant MENU_START_LOGO_POS_V_c    : integer := 50;
	
	constant MENU_START_FLAPPY_SIZE_c   : integer := 40;
	constant MENU_START_FLAPPY_POS_H_c  : integer := 360;
	constant MENU_START_FLAPPY_POS_V_c  : integer := 260;
	
	constant MENU_START_INST_WIDTH_c    : integer := 125;
	constant MENU_START_INST_HEIGHT_c   : integer := 65;
	constant MENU_START_INST_POS_H_c    : integer := 540;
	constant MENU_START_INST_POS_V_c    : integer := 280;
	
	constant MENU_START_TEXT_WIDTH_c    : integer := 240;
	constant MENU_START_TEXT_HEIGHT_c   : integer := 30;
	constant MENU_START_TEXT_POS_H_c    : integer := 160;
	constant MENU_START_TEXT_POS_V_c    : integer := 500;
	
	constant COLOR_BLUE  : STD_LOGIC_VECTOR(7 downto 0) := x"5b";
	constant COLOR_GREEN : STD_LOGIC_VECTOR(7 downto 0) := x"74";
	constant COLOR_GREY  : STD_LOGIC_VECTOR(7 downto 0) := x"b6";
	
end local;
