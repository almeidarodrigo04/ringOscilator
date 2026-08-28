
module jtag_bridge_system (
	clk_clk,
	reset_reset_n,
	capture_buffer_0_conduit_end_data_in,
	capture_buffer_0_conduit_end_data_valid);	

	input		clk_clk;
	input		reset_reset_n;
	input	[7:0]	capture_buffer_0_conduit_end_data_in;
	input		capture_buffer_0_conduit_end_data_valid;
endmodule
