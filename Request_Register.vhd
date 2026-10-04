library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Request_Register is port
( 
	  clk              : in STD_LOGIC;
	  reset            : in STD_LOGIC;
	  btn_press        : in STD_LOGIC_VECTOR (3 downto 0);
	  floor_reached    : in STD_LOGIC_VECTOR (1 downto 0);
	  clear_req        : in STD_LOGIC;
	  pending_requests : out STD_LOGIC_VECTOR (3 downto 0)
);
end Request_Register;

architecture Behavioral of Request_Register is
    signal reg : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                null; 
                
            else
                reg <= reg or btn_press;
                
                if clear_req = '1' then
                    case floor_reached is
                        when "00" => reg(0) <= '0';
                        when "01" => reg(1) <= '0';
                        when "10" => reg(2) <= '0';
                        when "11" => reg(3) <= '0';
                        when others => null;
                    end case;
                end if;
            end if;
        end if;
    end process;

    pending_requests <= reg;
end Behavioral;