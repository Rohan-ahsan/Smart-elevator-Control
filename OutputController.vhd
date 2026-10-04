library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OutputController is port 
( 
	  floor_bits : in STD_LOGIC_VECTOR(1 downto 0);
	  alarm_sig : in STD_LOGIC;
	  floor_leds : out STD_LOGIC_VECTOR(3 downto 0);
	  alarm_physical : out STD_LOGIC
);
end OutputController;

architecture Behavioral of OutputController is
begin

    alarm_physical <= alarm_sig;
    process(floor_bits)
	 
    begin
        case floor_bits is
            when "00" => floor_leds <= "0001";
            when "01" => floor_leds <= "0010";
            when "10" => floor_leds <= "0100";
            when "11" => floor_leds <= "1000";
            when others => floor_leds <= "0000";
        end case;
    end process;
end Behavioral;