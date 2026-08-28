	component jtag_bridge_system is
		port (
			capture_buffer_0_conduit_end_data_in    : in std_logic_vector(7 downto 0) := (others => 'X'); -- data_in
			capture_buffer_0_conduit_end_data_valid : in std_logic                    := 'X';             -- data_valid
			clk_clk                                 : in std_logic                    := 'X';             -- clk
			reset_reset_n                           : in std_logic                    := 'X'              -- reset_n
		);
	end component jtag_bridge_system;

	u0 : component jtag_bridge_system
		port map (
			capture_buffer_0_conduit_end_data_in    => CONNECTED_TO_capture_buffer_0_conduit_end_data_in,    -- capture_buffer_0_conduit_end.data_in
			capture_buffer_0_conduit_end_data_valid => CONNECTED_TO_capture_buffer_0_conduit_end_data_valid, --                             .data_valid
			clk_clk                                 => CONNECTED_TO_clk_clk,                                 --                          clk.clk
			reset_reset_n                           => CONNECTED_TO_reset_reset_n                            --                        reset.reset_n
		);

