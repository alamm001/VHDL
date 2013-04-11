----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:34:43 04/03/2013 
-- Design Name: 
-- Module Name:    wdt_timer - Behavioral 
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

use work.wdt.all;

entity wdt_timer is

    Port ( 
			  dbDivider: out STD_LOGIC;	
			  dbFlag: out STD_LOGIC;
				
			  sysRst  : in  STD_LOGIC;
           sysClk  : in  STD_LOGIC;
           enabled : in  STD_LOGIC;
           restart : in  STD_LOGIC;
			  resetOut: out STD_LOGIC;
           timeoutSel : in  STD_LOGIC_VECTOR (1 downto 0));
			  
	-- state machine states --		  
	constant WDT_IDLE:		integer := 0;
	constant WDT_RUNNING:	integer := 1;
	constant WDT_TIMEOUT:	integer := 2;

	-- These are the preset timeout divider values --
	constant TIMEOUT0:	integer:=1;
	constant TIMEOUT1:	integer:=10;
	constant TIMEOUT2:	integer:=100;
	constant TIMEOUT3:	integer:=1000;

	constant DIVIDER_COUNT:	integer:=1;

end wdt_timer;

architecture Behavioral of wdt_timer is
	
	signal curState: integer := WDT_IDLE;
	
	signal timeoutValue: integer := TIMEOUT0;
	
	signal dividedClk:	STD_LOGIC;
	signal timeOutFlag: 	STD_LOGIC:='0';
	
begin
	
	dbDivider <=  dividedClk;
	dbFlag <= timeoutFlag;
	
	with timeoutSel select timeoutValue <= TIMEOUT0 when "00",
														TIMEOUT1 when "01",
														TIMEOUT2 when "10",
														TIMEOUT3 when "11",	
														TIMEOUT0 when others;
		
		
		
-- divide the system clock down to usuable rate. --
-- this is what drives the timeout counter		 --
		
divider:process( sysRst, sysClk)

	variable dividerCounter: integer := 0;
	
begin
	
	if( rising_edge(sysClk) ) then

		if( sysRst = '1' ) then	
			dividerCounter:= 0;
			dividedClk<='0';
		
		else
		
			if( dividerCounter >= DIVIDER_COUNT ) then
				dividerCounter := 0;
				dividedClk<='1';
			else
				dividerCounter := dividerCounter+1;
				dividedClk<='0';
			end if;
	
		end if;
		
	end if;

end process;


setState: process( sysRst, sysClk)

	variable timeoutCounter: integer :=1;

begin

	if( falling_edge(sysClk) ) then
		
		if(sysRst='1') then
			curState <= WDT_IDLE;
			timeoutCounter:=1;
		else

			-- Handle a timer reset outside the state machine. --
			--if 'restart' signal asserted, reset the timeoutCounter --
			
			if( restart='1' ) then
					timeoutCounter:=1;
			end if;					

			
			-- Handle state machine  --	
			case curState is
			
				when WDT_IDLE 	 =>
						
						-- switch to running state if 'enabled' signal is assrted --
						if( enabled='1' ) then
							curState <= WDT_RUNNING;
						else
							curState <= WDT_IDLE;
						end if;	
							
							
				when WDT_RUNNING =>
												 
						-- return to idle state if "enabled" is clear --
						if( enabled='0' ) then
								curState <= WDT_IDLE;
						else		
--								-- test for timeout --
--								if( timeoutCounter > timeoutValue ) then 
--									curState<=WDT_TIMEOUT;
--								else
--									  -- increment timeout counter --
--									  if( dividedClk='1' ) then
--											timeoutCounter:=timeoutCounter+1;
--									  end if;			
--								end if;

								if( dividedClk='1' ) then
										timeoutCounter:=timeoutCounter+1;
								end if;			
	
								if( timeoutCounter >= timeoutValue ) then 
									curState<=WDT_TIMEOUT;
								end if;	
								
						end if;
						
						
				when WDT_TIMEOUT =>
						curState <= WDT_TIMEOUT;
						
				when others =>
						curState <= WDT_TIMEOUT;
						
			end case;
		
		
		end if;
	
	end if;

end process;

outputs: process(sysClk,sysRst)
begin

	if( rising_edge(sysClk) ) then
		
		if(sysRst='1') then
				timeoutFlag<='0';
		else

			-- Handle state machine  --	
			case curState is
				when 	WDT_IDLE=>	
						timeoutFlag <= '0';
						
				when 	WDT_RUNNING=>
						timeoutFlag	<=	'0';
						
				when	WDT_TIMEOUT=>
						timeoutFlag	<= '1';
						
				when 	others=>
						timeoutFlag <= '0';
				end case;

		end if;
	
	end if;		

end process;

-- Asserts the resetOut for RESET_TIME clock cycles 
-- This process does not respond to a system reset and 
-- will assert the resetOut as long as clock cycles 
-- drive the resetCounter.
--	RESET_TIME is defined in pckage wdt 

resetAssert: process( sysClk )
	variable resetCounter: integer := 0;
	
begin

	if( falling_edge( sysClk) ) then
		
		-- start the reset timer if timeOutFlag is set or
		-- continue counting if resetCounter has already 
		-- started.
		
		if( timeOutFlag = '1' or resetCounter /= 0 ) then
			
			resetCounter := resetCounter+1;
			resetOut<='1';
			
			-- test if RESET_TIME satisfied --
			if( resetCounter = RESET_TIME ) then
				resetCounter := 0;
				resetOut		 <= '0';	
			end if;	
		
		else
				-- no timeout has occured --
				resetCounter:=0;
				resetOut<='0';
		
		end if;
	
	end if;
	
end process;


end Behavioral;

