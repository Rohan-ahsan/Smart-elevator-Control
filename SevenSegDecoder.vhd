library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenSegDecoder is port (
    floor_bits : in  STD_LOGIC_VECTOR(1 downto 0);
    seg_out    : out STD_LOGIC_VECTOR(6 downto 0)  -- gfedcba
);
end SevenSegDecoder;

architecture Behavioral of SevenSegDecoder is
begin
    process(floor_bits)
    begin
        -- Active LOW: 0 = segment ON, 1 = segment OFF
        -- Encoding: g f e d c b a  (bits 6 downto 0)
        case floor_bits is
            when "00" => seg_out <= "1000000";  -- 0: abcdef on,  g off
            when "01" => seg_out <= "1111001";  -- 1: bc on,      rest off
            when "10" => seg_out <= "0100100";  -- 2: abdeg on,   cf off
            when "11" => seg_out <= "0110000";  -- 3: abcdg on,   ef off
            when others => seg_out <= "1111111"; -- all off
        end case;
    end process;
end Behavioral;