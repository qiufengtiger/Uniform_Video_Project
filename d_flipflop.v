// This module is used in order to avoid the use of reg
// Original design by Prof. Nadovich
//no longer used
module d_flipflop(
	input clk,
	input reset,
	input d,
	output reg q
    );
	always @(posedge clk)
	if(reset) begin
		q <= 0;
	end
	else begin
		q <= d;
	end

endmodule
