module cpld_toplevel(
	input vsync,
	input burst,
	input field,
	input csync,
	input clk4mhz,
	inout [33 : 27] io,
	output az,
	output el,
	output gate_b,
	output gate_w,
	output [1 : 0] led
	);

	wire isCrosshair;
	wire azResult;
	wire elResult;
	wire isBright;
	wire [9 : 0] lineCount;
	wire [9 : 0] columnCount;

	assign io[27] = vsync;
    assign io[28] = burst;
    assign io[29] = field;
    assign io[30] = csync;
	assign video = io[33];

	crosshair_module cm(.vsync(vsync), .csync(csync), .clk4mhz(clk4mhz), .isCrosshair(isCrosshair), .lineCount(lineCount), .columnCount(columnCount));
	tracking_module tm(.clk(clk4mhz), .azResult(azResult), .elResult(elResult));

	// test
	assign isBright = ((lineCount >= 25) && (lineCount <= 30) && (columnCount >= 25) && (columnCount <= 30));

	assign gate_w = ~io[31] ^ isCrosshair;
	assign gate_b = ~io[32];

	assign led[0] = isBright;
	assign led[1] = 1;

	assign az = azResult;
	assign el = elResult;

	//empty io
endmodule
