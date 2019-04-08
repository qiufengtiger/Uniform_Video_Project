//no longer used
module pulseToLevel(
	input clk,
	input reset,
	input d,
	output reg q,
	output reg started
    );

	// reg started;
	always @(posedge clk) begin
		if(reset) begin
			q = 0;
			started = 0;			
		end
		else if(~started) begin
			q = d;
			started = 1;
		end
		else begin
			q = q;
			started = started;
		end
	end

endmodule
