module tracking_module(
	input clk4mhz,
	input csync,
	input vsync,
	input isTarget,
	input [8 : 0] lineCount,
	input [8 : 0] columnCount,
	input en,
	input xCounterEn,
	output reg azResult,
	output reg elResult
    );

	wire [2 : 0] threshold;
	// wire [4 : 0] lineThreshold;
	wire targetLineCtrEn;
	wire targetColumnCtrEn;
	// wire xCounterEn;
	wire [8 : 0] numLine;
	wire [8 : 0] numColumn;
	reg [8 : 0] targetLineCenter;
	reg [8 : 0] targetColumnCenter;

	assign threshold = 5'd5;
	// assign lineThreshold = 5'd5;

	// enDetector columnCounterEn(.clk(csync), .en(xCounterEn));
	// enDetector lineCounterEn(.clk(vsync), .en(en));
	counter targetColumnCtr(.clk(clk4mhz), .en(isTarget), .reset(~isTarget | ~xCounterEn), .cnt(numColumn));
	counter targetLineCtr(.clk(csync), .en((numColumn > columnThreshold)), .reset(~(numColumn > columnThreshold) | ~en), .cnt(numLine));
	always@(clk4mhz) begin
		if((numColumn > threshold)) begin
			targetColumnCenter = columnCount - (numColumn / 2);
		end
	end
	always@(csync) begin
		if((numLine > threshold)) begin
			targetLineCenter = lineCount - (numLine / 2);
		end
	end
	always@(vsync) begin
		if (~vsync) begin
			azResult = (targetColumnCenter < 120);
			elResult = (targetLineCenter < 131);
		end
	end
endmodule
