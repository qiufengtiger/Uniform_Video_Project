module enDetector(
	input clk,
	output reg en
    );
	always @(clk) begin
		if(~clk) begin
			en = 1;
		end
		else begin
			en = 0;
		end
	end


endmodule
