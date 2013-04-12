--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:16:01 04/11/2013
-- Design Name:   
-- Module Name:   /home/alam/Xilinx/projects/Watchdog/watchdog_tb.vhd
-- Project Name:  Watchdog
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: watchdog
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
 
ENTITY watchdog_tb IS
END watchdog_tb;
 
ARCHITECTURE behavior OF watchdog_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT watchdog
    PORT(
         sysRst : IN  std_logic;
         sysClk : IN  std_logic;
         wr : IN  std_logic;
         dataIn : IN  std_logic_vector(7 downto 0);
         resetOut : OUT  std_logic;
         debugStates : OUT  std_logic_vector(1 downto 0);
         debugDivider : OUT  std_logic;
         debugFlag : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal sysRst : std_logic := '0';
   signal sysClk : std_logic := '0';
   signal wr : std_logic := '0';
   signal dataIn : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal resetOut : std_logic;
   signal debugStates : std_logic_vector(1 downto 0);
   signal debugDivider : std_logic;
   signal debugFlag : std_logic;

   -- Clock period definitions
   constant sysClk_period : time := 10 ns;
 
	signal localRst: std_logic;
 
BEGIN
	sysRst<=( resetOut or localRst);
	
	-- Instantiate the Unit Under Test (UUT)
   uut: watchdog PORT MAP (
          sysRst => sysRst,
          sysClk => sysClk,
          wr => wr,
          dataIn => dataIn,
          resetOut => resetOut,
          debugStates => debugStates,
          debugDivider => debugDivider,
          debugFlag => debugFlag
        );

   -- Clock process definitions
   sysClk_process :process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		localRst<='1';
      wait for 100 ns;	
		localRst<='0';

      wait for sysClk_period*10;

      -- insert stimulus here  
		
		wdtWriteCmdSeq(sysClk,CMD_ON,wr,dataIn,15 ns );
		wait for 300 ns;
		
		
		-- restart timer with TIME0 timeout --
		wdtWriteCmdSeq(sysClk,CMD_TIME1,wr,dataIn,15 ns);
		wait for 60 ns;
		
		wdtWriteCmdSeq(sysClk,CMD_ON,wr,dataIn,15 ns );
		wait for 500 ns;	
	
		-- restart timer with TIME0 timeout but with a restart --
		wdtWriteCmdSeq(sysClk,CMD_TIME1,wr,dataIn,15 ns);
		wait for 60 ns;
		
		wdtWriteCmdSeq(sysClk,CMD_ON,wr,dataIn,15 ns );
		wait for 100 ns;	

		wdtWriteCmdSeq(sysClk,CMD_RESTART,wr,dataIn,15 ns);		
		wait for 100 ns;
		
      wait;
   end process;

END;
