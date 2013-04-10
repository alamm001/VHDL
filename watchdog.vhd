

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:25:25 04/10/2013 
-- Design Name: 
-- Module Name:    watchdog - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity watchdog is
    Port ( sysRst : in  STD_LOGIC;
           sysClk : in  STD_LOGIC;
			  wr		: in  STD_LOGIC;
           dataIn : in  STD_LOGIC_VECTOR( 7 downto 0);
			  resetOut: out STD_LOGIC;
				
			  debugStates:	 out	STD_LOGIC_VECTOR( 1 downto 0);
			  debugDivider: out 	STD_LOGIC;
			  debugFlag:	 out	STD_LOGIC );
end watchdog;

architecture Behavioral of watchdog is

signal timeoutSelect: STD_LOGIC_VECTOR( 1 downto 0);
signal timerRestart:	STD_LOGIC;
signal timerEnable:	STD_LOGIC;

component wdtcntl

   Port (	
			  debug: out STD_LOGIC_VECTOR( 1 downto 0 );  
			  sysclk : in  STD_LOGIC;
           sysRst  : in  STD_LOGIC;
           
			  wr   : in  STD_LOGIC;
           dataIn : in  STD_LOGIC_VECTOR (7 downto 0);
           
			  restart : out  STD_LOGIC;
           timerEnb : out  STD_LOGIC;
           timerSel : out  STD_LOGIC_VECTOR (1 downto 0)); 
	
end component;


component wdt_timer

  Port (   dbDivider: out STD_LOGIC;	
			  dbFlag: out STD_LOGIC;
				
			  sysRst  : in  STD_LOGIC;
           sysClk  : in  STD_LOGIC;
           enabled : in  STD_LOGIC;
           restart : in  STD_LOGIC;
			  resetOut: out STD_LOGIC;
           timeoutSel : in  STD_LOGIC_VECTOR (1 downto 0));
			  
end component;

begin

	controller: wdtcntl	 port map(debugStates,sysClk,sysRst,wr,dataIn,
									timerRestart,timerEnable,timeoutSelect );
									
	timer:		wdt_timer port map(debugDivider,debugFlag,sysRst,sysClk,
									timerEnable,timerRestart,resetOut,timeoutSelect);

end Behavioral;

