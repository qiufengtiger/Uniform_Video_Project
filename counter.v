module counter(
	input clk,
	input reset,
	input en,
	output reg [9 : 0] cnt
    );

	always @(posedge clk)
		if(reset)
			cnt <= 0;
		else if(en)
			cnt <= cnt + 1'b1;
endmodule
