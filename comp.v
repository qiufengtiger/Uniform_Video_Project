// result = 1 if t1 <= i1 <= t2
// result = 0 otherwise 
//no longer used
module comp(
	input [9 : 0] i1,
	input [9 : 0] t1,
	input [9 : 0] t2,
	output result
    );
	assign result = ((i1 <= t2) && (i1 >= t1));
	// if((i1 <= t2) && (i1 >= t1))
	// 	result <= 1'b1;
	// else
	// 	result <= 1'b0; 


endmodule
