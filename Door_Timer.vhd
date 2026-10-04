library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Door_Timer is port 
( 
	  clk : in STD_LOGIC;
	  reset_timer : in STD_LOGIC;
	  restart_timer : in STD_LOGIC;
	  timer_done : out STD_LOGIC
);
end Door_Timer;

architecture Behavioral of Door_Timer is
    signal count : integer range 0 to 7 := 0;
	 
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset_timer = '1' or restart_timer = '1' then
                count <= 0;
            elsif count < 5 then 
                count <= count + 1;
            end if;
        end if;
    end process;
    
    timer_done <= '1' when count >= 4 else '0';
end Behavioral;