module crosshair_module(
	input vsync,
	input csync,
	input clk4mhz,
	output isCrosshair
    );

	wire en;
	wire xCounterEn;
	wire [9 : 0] lineCount;
	wire [9 : 0] columnCount;

	//enable counters at the rising edge
	enDetector lineCounterEn(.clk(vsync), .en(en));
	enDetector columnCounterEn(.clk(csync), .en(xCounterEn));
	//x & y counters
	counter lineCounter(.clk(csync), .en(en), .reset(~en), .cnt(lineCount));
	counter columnCounter(.clk(clk4mhz), .en(xCounterEn), .reset(~xCounterEn), .cnt(columnCount));

	//determine if it is in the range of the crosshair
	assign isCrosshair = (((lineCount >= 10'd123) && (lineCount <= 10'd 133) && (columnCount >= 120) && (columnCount <= 121))
						|| ((lineCount >= 10'd127) && (lineCount <= 10'd 129) && (columnCount >= 116) && (columnCount <= 125)));


endmodule
