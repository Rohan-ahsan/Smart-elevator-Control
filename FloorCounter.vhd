library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FloorCounter is port (
    clk           : in  STD_LOGIC;
    reset         : in  STD_LOGIC;
    move_up       : in  STD_LOGIC;
    move_down     : in  STD_LOGIC;
    current_floor : out STD_LOGIC_VECTOR(1 downto 0)
);
end FloorCounter;

architecture Behavioral of FloorCounter is
    signal count      : unsigned(1 downto 0) := "00";
    signal clk_div    : integer range 0 to 25000000 := 0;
    signal slow_tick  : std_logic := '0';
begin

    -- Clock divider
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                clk_div   <= 0;
                slow_tick <= '0';
            elsif clk_div = 24999999 then
                clk_div   <= 0;
                slow_tick <= '1';   -- one-cycle pulse every 1 second
            else
                clk_div   <= clk_div + 1;
                slow_tick <= '0';
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                count <= "00";
            elsif slow_tick = '1' then
                if move_up = '1' and count < 3 then
                    count <= count + 1;
                elsif move_down = '1' and count > 0 then
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;

    current_floor <= std_logic_vector(count);
end Behavioral;