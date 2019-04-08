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

	wire en;
	wire xCounterEn;
	// wire compResult;
	// wire compResultColumn;
	wire isCrossHair;
	wire [9 : 0] lineCount;
	wire [9 : 0] columnCount;
	// wire [9 : 0] lineUpperThreshold;
	// wire [9 : 0] lineLowerThreshold;
	// wire [9 : 0] columnUpperThreshold;
	// wire [9 : 0] columnLowerThreshold;

	assign lineLowerThreshold = 10'd125;
	assign lineUpperThreshold = 10'd131;
	assign columnLowerThreshold = 10'd116;
	assign columnUpperThreshold = 10'd125;

	assign io[27] = vsync;
    assign io[28] = burst;
    assign io[29] = field;
    assign io[30] = csync;

	enDetector lineCounterEn(.clk(vsync), .en(en));
	enDetector columnCounterEn(.clk(csync), .en(xCounterEn));
	counter lineCounter(.clk(csync), .en(en), .reset(~en), .cnt(lineCount));
	counter columnCounter(.clk(clk4mhz), .en(xCounterEn), .reset(~xCounterEn), .cnt(columnCount));
	// comp lineComp(.i1(lineCount), .t1(lineLowerThreshold), .t2(lineUpperThreshold), .result(compResult));
	// comp columnComp(.i1(columnCount), .t1(columnLowerThreshold), .t2(columnUpperThreshold), .result(compResultColumn));

	assign isCrossHair = (((lineCount >= 10'd123) && (lineCount <= 10'd 133) && (columnCount >= 120) && (columnCount <= 121))
						|| ((lineCount >= 10'd127) && (lineCount <= 10'd 129) && (columnCount >= 115) && (columnCount <= 125)));


	assign led[0] = 1;
	assign led[1] = 1;
	// assign gate_w = ~io[31] ^ (compResult & compResultColumn);
	assign gate_w = ~io[31] ^ isCrossHair;
	assign gate_b = ~io[32];
	assign io[33] = 0;
endmodule
