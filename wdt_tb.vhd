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
use work.wdt.all;

package wdt_tb is

-- Declare functions and procedure

	procedure wdtWriteByte( signal 	sysclk: 	in  std_logic;
	                        constant b:      	in  std_logic_vector(7 downto 0);
									signal 	wr: 	  	out std_logic; 	
									signal 	data:		out std_logic_vector(7 downto 0) );


	procedure wdtWriteCmdSeq(  signal 	sysclk: 	in  std_logic;
										constant b:      	in  std_logic_vector(7 downto 0);
										signal 	wr: 	  	out std_logic; 	
										signal 	data:		out std_logic_vector(7 downto 0);
										constant delay:	time);

end wdt_tb;



package body wdt_tb is


	procedure wdtWriteByte( signal 	sysclk: 	in  std_logic;
	                        constant b:      	in  std_logic_vector(7 downto 0);
									signal 	wr: 	  	out std_logic; 	
									signal 	data:		out std_logic_vector(7 downto 0) ) is  	
	begin		
			 
			wait until falling_edge(sysclk);
			data<=b;
			wr<='1';
			
			wait until falling_edge(sysclk);
			wr<='0';
			
	end wdtWriteByte;
	
	

	procedure wdtWriteCmdSeq(  signal 	sysclk: 	in  std_logic;
										constant b:      	in  std_logic_vector(7 downto 0);
										signal 	wr: 	  	out std_logic; 	
										signal 	data:		out std_logic_vector(7 downto 0);
										constant delay:	time ) is  	
	begin
			
			wdtWriteByte(sysclk,LOCKBYTE0,wr,data);
			wait for delay; 
			
			wdtWriteByte(sysclk,LOCKBYTE1,wr,data);
			wait for delay;
			
			wdtWriteByte(sysclk,b,wr,data);
			
			
	end wdtWriteCmdSeq;
 
end wdt_tb;
