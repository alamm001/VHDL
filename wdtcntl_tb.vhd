--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:30:58 04/10/2013
-- Design Name:   
-- Module Name:   /home/alam/Xilinx/projects/Watchdog/wdtcntl_tb.vhd
-- Project Name:  Watchdog
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: wdtcntl
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.wdt.all;
USE work.wdt_tb.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY wdtcntl_tb IS
END wdtcntl_tb;
 
ARCHITECTURE behavior OF wdtcntl_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT wdtcntl
    PORT(
         debug : OUT  std_logic_vector(1 downto 0);
         sysclk : IN  std_logic;
         sysRst : IN  std_logic;
         wr : IN  std_logic;
         dataIn : IN  std_logic_vector(7 downto 0);
         restart : OUT  std_logic;
         timerEnb : OUT  std_logic;
         timerSel : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal sysclk : std_logic := '0';
   signal sysRst : std_logic := '0';
   signal wr : std_logic := '0';
   signal dataIn : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal debug : std_logic_vector(1 downto 0);
   signal restart : std_logic;
   signal timerEnb : std_logic;
   signal timerSel : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant sysclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: wdtcntl PORT MAP (
          debug => debug,
          sysclk => sysclk,
          sysRst => sysRst,
          wr => wr,
          dataIn => dataIn,
          restart => restart,
          timerEnb => timerEnb,
          timerSel => timerSel
        );

   -- Clock process definitions
   sysclk_process :process
   begin
		sysclk <= '0';
		wait for sysclk_period/2;
		sysclk <= '1';
		wait for sysclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		sysRst<='1';
      wait for 100 ns;	
		sysRst<='0';
      wait for sysclk_period*10;



		-- -------------- Test Timeout Values ------------- -- 

--		wdtWriteCmdSeq(sysClk,CMD_TIME3,wr,dataIn,10 ns );
--		wait for 40 ns;

--		wdtWriteCmdSeq(sysClk,CMD_TIME2,wr,dataIn,10 ns );
--		wait for 40 ns;

--		wdtWriteCmdSeq(sysClk,CMD_TIME1,wr,dataIn,10 ns );
--		wait for 40 ns;

--		wdtWriteCmdSeq(sysClk,CMD_TIME0,wr,dataIn,10 ns );
--		wait for 40 ns;
			
			
		-- ----------------- Test WDT on/off --------------- -- 
						
		wdtWriteCmdSeq(sysClk,CMD_ON,wr,dataIn,10 ns );
		wait for 60 ns;
				
		wdtWriteCmdSeq(sysClk,CMD_OFF,wr,dataIn, 10 ns	);
		wait for 60 ns;
		
		
		-- ------------------ Test Restart ------------------ -- 
		
--		wdtWriteCmdSeq(sysClk,CMD_RESTART,wr,dataIn,10 ns );
--		wait for 60 ns;


		-- ------------------- Test Lockout ------------------ -- 

		-- invalid first byte
--		wdtWriteByte(sysClk,UNLOCK1,wr,dataIn);
--		wdtWriteByte(sysClk,UNLOCK1,wr,dataIn);
--		wdtWriteByte(sysClk,CMD_RESTART,wr,dataIn);

		
		-- invalid second byte
--		wdtWriteByte(sysClk,LOCKBYTE0,wr,dataIn);
--		wdtWriteByte(sysClk,LOCKBYTE0,wr,dataIn);
--		wdtWriteByte(sysClk,CMD_RESTART,wr,data);


		-- ------------------- Test Timeout ------------------ -- 

		wdtWriteCmdSeq(sysClk,CMD_RESTART,wr,dataIn, 60 ns );
		wait for 60 ns;

		wdtWriteCmdSeq(sysClk,CMD_RESTART,wr,dataIn, 40 ns );
		wait for 60 ns;

		
		wait for 100 ns;
      wait;
   end process;

END;
