module div_tes(
	output reg [31:0] quotient,
	input [31:0] i_dividend,
	input [31:0] i_divisor
	);
	real dividend, divisor;
	
	always @(*)
		quotient <= dividend / divisor;
	
endmodule