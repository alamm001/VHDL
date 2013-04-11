--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:26:05 04/10/2013
-- Design Name:   
-- Module Name:   /home/alam/Xilinx/projects/Watchdog/wdt_timer_tb.vhd
-- Project Name:  Watchdog
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: wdt_timer
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY wdt_timer_tb IS
END wdt_timer_tb;
 
ARCHITECTURE behavior OF wdt_timer_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT wdt_timer
    PORT(
         dbDivider : OUT  std_logic;
         dbFlag : OUT  std_logic;
         sysRst : IN  std_logic;
         sysClk : IN  std_logic;
         enabled : IN  std_logic;
         restart : IN  std_logic;
         resetOut : OUT  std_logic;
         timeoutSel : IN  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal sysRst : std_logic := '0';
   signal sysClk : std_logic := '0';
   signal enabled : std_logic := '0';
   signal restart : std_logic := '0';
   signal timeoutSel : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal dbDivider : std_logic;
   signal dbFlag : std_logic;
   signal resetOut : std_logic;

   -- Clock period definitions
   constant sysClk_period : time := 10 ns;
 
BEGIN
	sysRst <= resetOut;
	
	-- Instantiate the Unit Under Test (UUT)
   uut: wdt_timer PORT MAP (
          dbDivider => dbDivider,
          dbFlag => dbFlag,
          sysRst => sysRst,
          sysClk => sysClk,
          enabled => enabled,
          restart => restart,
          resetOut => resetOut,
          timeoutSel => timeoutSel
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
      wait for 100 ns;	

      wait for sysClk_period*10;

      -- insert stimulus here 
		-- initial conditions ==
		restart<='0';
		enabled<='0';
		timeoutSel<="00";
		wait for 50 ns;
		
		-- turn on timer and wait for timer to reset system --
		wait until rising_edge(sysClk);
		enabled<='1';
		wait until resetOut='1';
		wait for 20 ns;
		wait until rising_edge(sysClk);
		enabled<='0';
		wait until resetOut='0';
		wait for 150 ns;
		
--		wait until rising_edge(sysClk);
--		timeoutSel<="01";
--		enabled<='1';
--		wait until resetOut='1';
--		wait until rising_edge(sysClk);
--		enabled<='0';
--		wait for 150 ns;



      wait;
   end process;

END;
