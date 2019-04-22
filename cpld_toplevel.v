module cpld_toplevel(
	input vsync,
	input burst,
	input field,
	input csync,
	input clk4mhz,
	inout [33 : 27] io,
	// inout [32 : 31] io,
	output az,
	output el,
	output gate_b,
	output gate_w,
	output reg [1 : 0] led
	);

	wire isCrosshair;
	// wire azResult;
	// wire elResult;
	wire isTarget;
	wire [8 : 0] lineCount;
	wire [8 : 0] columnCount;
	wire en;
	wire xCounterEn;

	//we can possibly only store half of the rows/ columns
	// wire [8 : 0] numLine;
	reg [8 : 0] numColumn;
	reg targetDetected;
	reg refreshed;
	reg [8 : 0] targetLine;
	reg [8 : 0] targetColumn;
	reg azOut;
	reg elOut;

	// assign io[27] = vsync;
 //    assign io[28] = burst;
 //    assign io[29] = field;
 //    assign io[30] = csync;
	// assign video = io[33];

	counter lineCounter(.clk(csync), .en(~vsync), .reset(vsync), .cnt(lineCount));
	counter columnCounter(.clk(clk4mhz), .en(~csync), .reset(csync), .cnt(columnCount));

	//test
	// assign isTarget = ((lineCount >= 110) && (lineCount <= 116) && (columnCount >= 140) && (columnCount <= 147));
	assign isTarget = io[27] & io[28];

	always @(posedge clk4mhz) begin
	//counter
		if(~vsync) begin
			refreshed <= 1;
			//reset target counter when the line ends
			if(csync)begin
				numColumn <= 0;
			end
			else begin
				if(~isTarget) begin
					//within limit
					if((numColumn > 1) && (numColumn < 8) && ~targetDetected) begin
						targetDetected <= 1;
						targetColumn <= columnCount;
						targetLine <= lineCount;
						numColumn <= 0;
					end
					//fix the flashing issue
					//i don't know why
					else if((numColumn > 8) && ~targetDetected) begin
						targetDetected <= 0;
						targetColumn <= 0;
						targetLine <= 0;
						numColumn <= 0;
					end
					//beyond limit
					else begin
						targetDetected <= targetDetected;
						targetColumn <= targetColumn;
						targetLine <= targetLine;
						numColumn <= 0;
					end
				end
				//increment
				else begin
					targetDetected <= targetDetected;
					targetColumn <= targetColumn;
					targetLine <= targetLine;
					numColumn <= numColumn + 1'd1;
				end
			end	
		end
		//need to utilize here
		else begin
			if(refreshed == 1) begin
				refreshed <= 0;
				if(targetDetected == 1)begin
					// azOut[0] <= (targetColumn < 120);
					led[0] <= (targetColumn < 120);
					azOut <= (targetColumn < 120);
					led[1] <= (targetLine < 131);
					elOut <= (targetLine < 131);
				end
				else begin
					// azOut[0] <= 0;
					led[0] <= 0;
					azOut <= 0;
					led[1] <= 0;
					elOut <= 0;
				end
				// led[0] <= io[27];
				// led[1] <= io[28];
			end
			// if(refreshed == 1) begin
			// 	refreshed <= 0;
			// 	if(targetDetected == 1)begin
			// 		// elOut[0] <= (targetLine < 131);
			// 		led[1] <= (targetLine < 131);
			// 	end
			// 	else begin
			// 		// elOut[0] <= 0;
			// 		led[1] <= 0;
			// 	end
			// end
			targetDetected <= 0;
			targetColumn <= 0;
			targetLine <= 0;
		end
	end

	assign gate_w = ~io[31] ^ (((lineCount >= 10'd123) && (lineCount <= 10'd 133) && (columnCount >= 120) && (columnCount <= 121))
						|| ((lineCount >= 10'd127) && (lineCount <= 10'd 129) && (columnCount >= 116) && (columnCount <= 125)));
	assign gate_b = ~io[31];
	assign io[29] = azOut;
	assign io[30] = elOut;

	// assign led[0] = azOut[0];
	// assign led[1] = elOut[0];
	// always @(negedge vsync) begin
	// 	led[0] <= azOut[0];
	// 	led[1] <= elOut[0];
	// end
	// assign az = azResult;
	// assign el = elResult;

	//empty io
endmodule
