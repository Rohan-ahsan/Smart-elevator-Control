library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity StateSegDecoder is port (
    state_bits : in  STD_LOGIC_VECTOR(2 downto 0);
    seg_out    : out STD_LOGIC_VECTOR(6 downto 0)  -- gfedcba
);
end StateSegDecoder;

architecture Behavioral of StateSegDecoder is
begin
    process(state_bits)
    begin
        -- Active LOW: 0 = segment ON, 1 = segment OFF
        -- Mapping: g f e d c b a (bits 6 downto 0)
        case state_bits is
            when "000" => seg_out <= "1111001";  -- I: e,f,g off | a,b,c,d on (Alternative neat 'I')
            when "001" => seg_out <= "1000001";  -- U: a,g off   | b,c,d,e,f on
            when "010" => seg_out <= "0100001";  -- d: a,f off   | b,c,d,e,g on
            when "011" => seg_out <= "1000000";  -- O: g off     | a,b,c,d,e,f on
            when "100" => seg_out <= "1000110";  -- C: b,c,g off | a,d,e,f on
            when "101" => seg_out <= "0000110";  -- E: b,c off   | a,d,e,f,g on
            when others =>seg_out <= "1111111";  -- All off
        end case;
    end process;
end Behavioral;