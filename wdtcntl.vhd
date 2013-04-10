----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:15:39 03/20/2013 
-- Design Name: 
-- Module Name:    wdtcntl - Behavioral 
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

entity wdtcntl is
    Port (	
			  debug: out STD_LOGIC_VECTOR( 1 downto 0 );  
			  sysclk : in  STD_LOGIC;
           sysRst  : in  STD_LOGIC;
           
			  wr   : in  STD_LOGIC;
           dataIn : in  STD_LOGIC_VECTOR (7 downto 0);
           
			  restart : out  STD_LOGIC;
           timerEnb : out  STD_LOGIC;
           timerSel : out  STD_LOGIC_VECTOR (1 downto 0));

				-- Clocks within which the feed sequence must complete --
				constant FEED_TIMEOUT: integer := 12;
	
end wdtcntl;

architecture Behavioral of wdtcntl is
	
	-- states and state variables --
	type state is ( IDLE, UNLOCK, CMD, EXEC );
	signal curState: state; 
	
	-- stores the command between states -- 
	signal command:  std_logic_vector( 7 downto 0);

	-- the feed sequence timeout counter is --
	-- active when asserted 					 --
	signal feedTimeoutEnb: 	std_logic;
	signal feedTimeoutFlag:	std_logic;
	
begin

	-- make internal states available for debugging --
	with curState select
		debug <= "00" 	when 	IDLE,
					"01" 	when 	UNLOCK,
					"10"	when	CMD,
					"11"	when	EXEC,
					"00"	when  others;
	


setState: process(sysclk,sysRst) 

begin
		if( rising_edge(sysclk) ) then
		
			if( sysRst='1' ) then			
				curState <= IDLE; 
				command 	<= "00000000"; 

			else				
				
				case curState is 
					when IDLE =>				
								if( wr='1' and dataIn=LOCKBYTE0 ) then
									curState<=UNLOCK;
								else
									curState <= IDLE;
								end if;
								
					when UNLOCK=>
								-- check for feed sequence timeout --
								if( feedTimeoutFlag = '1' ) then	
									curState <= IDLE;
								
								else

									-- handle input data byte --
									if( wr='1') then 
										if( dataIn=LOCKBYTE1 ) then
											curState <= CMD;
										else
											curState <= IDLE;
										end if;	
									else
										curState <= UNLOCK;
									end if;
																
							end if;
							
					when CMD=>
							-- check for feed sequence timeout --
							if( feedTimeoutFlag = '1' ) then	
									curState <= IDLE;
							else	
									--  handle input data --
									if( wr='1' ) then
										command  <= dataIn;
										curState <= EXEC;
									else
										curState <= CMD;
									end if;
									
							end if;
							
					when EXEC=>
								curState <= IDLE;
								
					when others =>  	
								curState <= IDLE;
								
				end case;
				
			end if;
			
		end if;
		
end process;	


setOutput: process(sysclk,sysRst)

begin

		if( rising_edge(sysclk) ) then
		
			if( sysRst='1' ) then
				
			  restart <= '0';
           timerEnb <= '0';
           timerSel <= "00";
			  
			  feedTimeoutEnb <= '0';	 
			
			else
			
				case curState is 
					when IDLE =>				
							restart 		<= '0';
							feedTimeoutEnb 	<= '0';
							
					when UNLOCK=>
							restart  	<= '0';			
							feedTimeoutEnb	<= '1';
							
					when CMD=>
							restart		<= '0';
							feedTimeoutEnb	<='1';
							
					when EXEC=>
					
							-- Decode the command --
							case command is

								when	CMD_ON =>				
									restart			<= '1';
									feedTimeoutEnb	<='0';
									timerEnb			<= '1';
									
								when	CMD_OFF =>
									restart 	<= '1';
									feedTimeoutEnb	<='0';									
									timerEnb	<= '0';
									
								when	CMD_RESTART =>
									restart 	<= '1';
									feedTimeoutEnb	<='0';
										
								when	CMD_TIME0 =>
									restart 	<= '1';
									feedTimeoutEnb	<='0';
									timerSel	<= "00";	
								
								when	CMD_TIME1 =>
									restart 	<= '1';
									feedTimeoutEnb	<='0';
									timerSel	<=	"01";
									
								when	CMD_TIME2 =>
									restart 	<= '1';
									feedTimeoutEnb	<='0';
									timerSel	<=	"10";
									
								when	CMD_TIME3 =>
									restart 	<= '1';
									feedTimeoutEnb	<='0';
									timerSel	<=	"11";
								
								when others =>
									restart			<=	'0';
									feedTimeoutEnb	<=	'0';
							end case;
							
					when others =>  	
							restart 			<= '0';			
							feedTimeoutEnb 	<=	'0';
				end case;
				
			end if;
			
		end if;
		

end process;



cmdFeedTimeout: process( sysclk, sysRst )

	variable feedTimeoutCounter: integer :=0; 
	
begin
	if( rising_edge(sysclk) ) then

		if( sysRst='1' or feedTimeoutEnb='0') then
			feedTimeoutCounter:=0;
			feedTimeoutFlag <= '0';
			
		else	
			
			if( feedTimeoutEnb='1' ) then
					feedTimeoutCounter := feedTimeoutCounter+1;
			end if;
			
			if( feedTimeoutCounter >= FEED_TIMEOUT ) then

					feedTimeoutFlag <= '1';
					feedTimeoutCounter:=0;

			else
					feedTimeoutFlag <='0';
			end if;
			
		end if;
		
	end if;	

end process;


end Behavioral;

