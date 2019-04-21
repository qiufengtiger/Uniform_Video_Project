module counter(
	input clk,
	input en,
	input reset,
	output reg [8 : 0] cnt
    );

	always @(posedge clk)
		if(reset)
			cnt <= 0;
		else if(en)
			cnt <= cnt + 1'd1;
endmodule
