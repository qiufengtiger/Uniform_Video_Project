module cpld_toplevel(
	input vsync,
	input burst,
	input field,
	input csync,
	input clk4mhz,
	input gclk2,
	inout [33 : 27] io,
	// inout [32 : 31] io,
	output gate_b,
	output gate_w,
	output [1 : 0] led
	);

	wire isTarget;
	wire [8 : 0] lineCount;
	wire [8 : 0] columnCount;

	//we can possibly only store half of the rows/ columns
	// wire [8 : 0] numLine;
	reg [5 : 0] numColumn;
	reg targetDetected;
	reg refreshed;
	reg [8 : 0] targetLine;
	reg [8 : 0] targetColumn;
	reg azOut;
	reg elOut;
	reg azSpeed;
	reg elSpeed;
	reg azScanDir;
	reg elScanDir;
	// assign io[27] = vsync;
 //    assign io[28] = burst;
 //    assign io[29] = field;
 //    assign io[30] = csync;
	// assign video = io[33];

	counter lineCounter(.clk(csync), .en(~vsync), .reset(vsync), .cnt(lineCount));
	counter columnCounter(.clk(clk4mhz), .en(~csync), .reset(csync), .cnt(columnCount));

	//test
	// assign isTarget = ((lineCount >= 110) && (lineCount <= 116) && (columnCount >= 140) && (columnCount <= 147));
	assign isTarget = ~/*gclk2*/io[27]/* & io[28]*/;

	always @(posedge clk4mhz) begin
	//counter
		if(~vsync) begin
		// if(~field) begin
			refreshed <= 1;
			//reset target counter when the line ends
			if(csync)begin
				numColumn <= 0;
			end
			else begin
				if(~isTarget) begin
					//within limit
					if((numColumn > 0) && (numColumn < 5) && ~targetDetected) begin
						targetDetected <= 1;
						targetColumn <= columnCount;
						targetLine <= lineCount;
						numColumn <= 0;
					end
					//fix the flashing issue
					//i don't know why
					else if((numColumn > 5) && ~targetDetected) begin
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
				if(targetDetected == 1) begin
					azOut <= (targetColumn < 120);
					elOut <= (targetLine < 131);
					azSpeed <= ((targetColumn < 92) || (targetColumn > 148));
					elSpeed <= ((targetLine < 100) || (targetLine > 160));
				end
				else begin
					azOut <= /*azScanDir;*/0;
					elOut <= /*elScanDir;*/0;
					azSpeed <= 1;
					elSpeed <= 1;
				end
			end
			targetDetected <= 0;
			targetColumn <= 0;
			targetLine <= 0;
		end
	end

	// always @(posedge isMarginX) begin
	// 	if(targetDetected) begin
	// 		azScanDir <= 0;
	// 	end
	// 	else begin
	// 		azScanDir <= ~azScanDir;	
	// 	end
	// end
	// always @(posedge isMarginY) begin
	// 	if(targetDetected) begin
	// 		elScanDir <= 0;
	// 	end
	// 	else begin
	// 		elScanDir <= ~elScanDir;	
	// 	end
	// end

	assign gate_w = ~io[31] ^ (((lineCount >= 10'd123) && (lineCount <= 10'd 133) && (columnCount >= 120) && (columnCount <= 121))
						|| ((lineCount >= 10'd127) && (lineCount <= 10'd 129) && (columnCount >= 116) && (columnCount <= 125)));
	assign gate_b = ~io[31];
	assign io[29] = azOut;
	assign io[30] = elOut;
	assign io[32] = azSpeed;
	assign io[33] = elSpeed;
	// assign io[32] = 1;
	// assign io[33] = 1;

	assign led[0] = isTarget;
	// assign led[1] = isTarget;
endmodule