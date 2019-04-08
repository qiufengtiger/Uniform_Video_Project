module cpld_toplevel(
	input vsync,
	input burst,
	input field,
	input csync,
	input clk4mhz,
	inout [33 : 27] io,
	output gate_b,
	output gate_w,
	output [1 : 0] led
	);

	wire isCrosshair;

	assign io[27] = vsync;
    assign io[28] = burst;
    assign io[29] = field;
    assign io[30] = csync;
	assign led[0] = 1;
	assign led[1] = 1;

	crosshair_module cm(.vsync(vsync), .csync(csync), .clk4mhz(clk4mhz), .isCrosshair(isCrosshair));

	assign gate_w = ~io[31] ^ isCrosshair;
	assign gate_b = ~io[32];
	assign io[33] = 0;
endmodule
