library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_Controller is port ( 
        clk            : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        emergency_stop : in  STD_LOGIC;
        bell           : in  STD_LOGIC;
        door_btn       : in  STD_LOGIC;
        pending_reqs   : in  STD_LOGIC_VECTOR(3 downto 0);
        current_floor  : in  STD_LOGIC_VECTOR(1 downto 0);
        timer_done     : in  STD_LOGIC;
        clear_req      : out STD_LOGIC;
        move_up        : out STD_LOGIC;
        move_down      : out STD_LOGIC;
        reset_timer    : out STD_LOGIC;
        restart_timer  : out STD_LOGIC;
        door_status    : out STD_LOGIC;
        alarm_out      : out STD_LOGIC;
		  state_out      : out STD_LOGIC_VECTOR(2 downto 0)
);
end FSM_Controller;

architecture Behavioral of FSM_Controller is
    type state_type is (IDLE, UP, DOWN, DOOR_OPEN, DOOR_CLOSE, EMERGENCY);
    signal state, next_state : state_type;
    
    signal curr_floor_int : integer range 0 to 3;
    signal req_above      : std_logic;
    signal req_below      : std_logic;
    signal emergency_active : std_logic := '0';
    
    signal dir_up, next_dir_up : std_logic := '1'; 
begin

    curr_floor_int <= to_integer(unsigned(current_floor));

    process(curr_floor_int, pending_reqs)
    begin
        case curr_floor_int is
            when 0 => if pending_reqs(3 downto 1) /= "000" then req_above <= '1'; else req_above <= '0'; end if;
            when 1 => if pending_reqs(3 downto 2) /= "00"  then req_above <= '1'; else req_above <= '0'; end if;
            when 2 => if pending_reqs(3) = '1'             then req_above <= '1'; else req_above <= '0'; end if;
            when others => req_above <= '0';
        end case;

        case curr_floor_int is
            when 3 => if pending_reqs(2 downto 0) /= "000" then req_below <= '1'; else req_below <= '0'; end if;
            when 2 => if pending_reqs(1 downto 0) /= "00"  then req_below <= '1'; else req_below <= '0'; end if;
            when 1 => if pending_reqs(0) = '1'             then req_below <= '1'; else req_below <= '0'; end if;
            when others => req_below <= '0';
        end case;
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            emergency_active <= '0';
            dir_up <= '1';
            alarm_out <= '0';
				
        elsif rising_edge(clk) then
            state <= next_state;
            dir_up <= next_dir_up;
            
            if emergency_stop = '1' and state /= IDLE then 
                emergency_active <= '1';
            elsif state = DOOR_CLOSE then
                emergency_active <= '0';
            end if;

            if emergency_active = '1' and bell = '1' then
                alarm_out <= '1'; 
            elsif next_state = DOOR_CLOSE then
                alarm_out <= '0';
            end if;
            
        end if;
    end process;

    process(state, pending_reqs, curr_floor_int, timer_done, emergency_stop, door_btn, req_above, req_below, dir_up)
    begin
        next_state <= state;
        next_dir_up <= dir_up;
        move_up <= '0'; 
        move_down <= '0';
        clear_req <= '0'; 
        reset_timer <= '0';
        restart_timer <= '0'; 
        door_status <= '0';

        case state is
		  
            when IDLE =>                     
                if pending_reqs /= "0000" then
                    if pending_reqs(curr_floor_int) = '1' then 
                        next_state <= DOOR_OPEN;
                        reset_timer <= '1';
                    
                    elsif dir_up = '1' and req_above = '1' then
                        next_state <= UP;
                    elsif dir_up = '0' and req_below = '1' then
                        next_state <= DOWN;
                    
                    elsif req_above = '1' then
                        next_dir_up <= '1';
                        next_state <= UP;
                    elsif req_below = '1' then
                        next_dir_up <= '0';
                        next_state <= DOWN;
                    end if;
                end if;

            when UP =>
                next_dir_up <= '1';
                if emergency_stop = '1' then 
                    next_state <= EMERGENCY;
						  
                elsif pending_reqs(curr_floor_int) = '1' then 
                    next_state <= DOOR_OPEN;
                    reset_timer <= '1';
						  
                else 
                    move_up <= '1';
                end if;

            when DOWN =>
                next_dir_up <= '0';
                if emergency_stop = '1' then 
                    next_state <= EMERGENCY;
						  
                elsif pending_reqs(curr_floor_int) = '1' then 
                    next_state <= DOOR_OPEN;
                    reset_timer <= '1';
						  
                else 
                    move_down <= '1';
                end if;

            when DOOR_OPEN =>
                door_status <= '1';
                clear_req <= '1';
                
                if door_btn = '1' or emergency_stop = '1' then 
                    restart_timer <= '1'; 
                    next_state <= DOOR_OPEN;
                elsif timer_done = '1' then 
                    next_state <= DOOR_CLOSE;
                    reset_timer <= '1'; 
                else
                    next_state <= DOOR_OPEN;
                end if;

            when DOOR_CLOSE =>
                if emergency_stop = '1' then 
                    next_state <= EMERGENCY;
                elsif door_btn = '1' then  
                    next_state <= DOOR_OPEN;
                    reset_timer <= '1';
                elsif pending_reqs /= "0000" then
                    if pending_reqs(curr_floor_int) = '1' then 
                        next_state <= DOOR_OPEN;
                        reset_timer <= '1';
                    
                    elsif dir_up = '1' and req_above = '1' then next_state <= UP;
                    elsif dir_up = '0' and req_below = '1' then next_state <= DOWN;
                    elsif req_above = '1' then 
                        next_dir_up <= '1';
                        next_state <= UP;
                    elsif req_below = '1' then 
                        next_dir_up <= '0';
                        next_state <= DOWN;
                    else next_state <= IDLE;
                    end if;
                else 
                    next_state <= IDLE;
                end if;

            when EMERGENCY =>
                next_state <= DOOR_OPEN; 
                reset_timer <= '1';

            when others => 
                next_state <= IDLE;
					 
        end case;
    end process;
	 
	 -- Assign binary values starting from 0 up to 5 for your 6 states
    state_out <= "000" when state = IDLE else
                 "001" when state = UP else
                 "010" when state = DOWN else
                 "011" when state = DOOR_OPEN else
                 "100" when state = DOOR_CLOSE else
                 "101" when state = EMERGENCY else
                 "000";
end Behavioral;