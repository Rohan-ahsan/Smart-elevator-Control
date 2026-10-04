library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SEC is port ( 
        clk            : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        emergency      : in  STD_LOGIC;
        bell           : in  STD_LOGIC;
        door_btn       : in  STD_LOGIC;
        btn_press      : in  STD_LOGIC_VECTOR (3 downto 0);
        floor_leds     : out STD_LOGIC_VECTOR (3 downto 0);
        door_open_led  : out STD_LOGIC;
        alarm_physical : out STD_LOGIC;
        seven_seg      : out STD_LOGIC_VECTOR (6 downto 0);
		  state_seg      : out STD_LOGIC_VECTOR (6 downto 0)
    );
end SEC;

architecture Structural of SEC is

    signal s_pending_reqs  : STD_LOGIC_VECTOR(3 downto 0);
    signal s_current_floor : STD_LOGIC_VECTOR(1 downto 0);
    signal s_clear_req     : STD_LOGIC;
    signal s_move_up       : STD_LOGIC;
    signal s_move_down     : STD_LOGIC;
    signal s_reset_timer   : STD_LOGIC;
    signal s_restart_timer : STD_LOGIC;
    signal s_door_is_open  : STD_LOGIC;
    signal s_timer_done    : STD_LOGIC;
    signal s_alarm_sig     : STD_LOGIC;
	 signal s_state_bits    : STD_LOGIC_VECTOR(2 downto 0);

begin

    door_open_led <= s_door_is_open;

    U1: entity work.Request_Register
        port map (
            clk => clk, reset => reset, btn_press => btn_press,
            floor_reached => s_current_floor, clear_req => s_clear_req,
            pending_requests => s_pending_reqs
        );

    U2: entity work.FloorCounter
        port map (
            clk => clk, reset => reset, move_up => s_move_up,
            move_down => s_move_down, current_floor => s_current_floor
        );

    U3: entity work.Door_Timer
        port map (
            clk => clk, reset_timer => s_reset_timer,
            restart_timer => s_restart_timer, timer_done => s_timer_done
        );

    -- Update U4 to link the state signal
    U4: entity work.FSM_Controller
        port map (
            clk => clk, reset => reset, emergency_stop => emergency,
            bell => bell, door_btn => door_btn, pending_reqs => s_pending_reqs,
            current_floor => s_current_floor, timer_done => s_timer_done,
            clear_req => s_clear_req, move_up => s_move_up, move_down => s_move_down,
            reset_timer => s_reset_timer, restart_timer => s_restart_timer, 
            door_status => s_door_is_open, alarm_out => s_alarm_sig,
            state_out => s_state_bits -- HOOK UP THE NEW PORT HERE
        );

    U5: entity work.OutputController
        port map (
            floor_bits => s_current_floor, alarm_sig => s_alarm_sig,
            floor_leds => floor_leds, alarm_physical => alarm_physical
        );

    U6: entity work.SevenSegDecoder
        port map (
            floor_bits => s_current_floor,
            seg_out    => seven_seg
        );

    U7: entity work.StateSegDecoder
        port map (
            state_bits => s_state_bits,
            seg_out    => state_seg
        );

end Structural;