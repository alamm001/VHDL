--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package wdt is

	-- These are the bytes that make up the unlock feed sequence --
	constant LOCKBYTE0: 	 std_logic_vector( 7 downto 0 ):="11110000";	
	constant LOCKBYTE1: 	 std_logic_vector( 7 downto 0 ):="00001111";
	
	
	-- These are the valid commands --
	constant CMD_OFF:		 std_logic_vector( 7 downto 0 ):="10110000";
	constant CMD_ON:		 std_logic_vector( 7 downto 0 ):="10110001";
	
	constant CMD_RESTART: std_logic_vector( 7 downto 0 ):="11000000"; 
	
	constant CMD_TIME0:   std_logic_vector( 7 downto 0 ):="11100000";
	constant CMD_TIME1:   std_logic_vector( 7 downto 0 ):="11100001";
	constant CMD_TIME2:   std_logic_vector( 7 downto 0 ):="11100010";
	constant CMD_TIME3:   std_logic_vector( 7 downto 0 ):="11100011";

	-- Clocks within which the feed sequence must complete --
	constant FEED_TIMEOUT: integer := 12;
	
 
	-- amount of time (in system clocks) reset is asserted --	
	constant RESET_TIME:	integer := 20;


end wdt;

