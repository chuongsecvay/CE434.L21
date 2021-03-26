module RGBtoHSV#(
  parameter N = 32
  )
  (
    output reg [N-1:0] o_H,
    output reg [N-1:0] o_S,
    output reg [N-1:0] o_V,
    output reg val_out,
    input [7:0] i_R,
    input [7:0] i_G,
    input [7:0] i_B,
    input val_in,
    input clk,
    input i_clk,
    input i_start,
    input rst_n
    );
  
  reg [7:0] R,G,B;
  
  wire [N-1:0] H,S,V;
  wire [N-1:0] Rf,Gf,Bf;  // fixed point, stage 0 
  wire [N-1:0] cmax,cmin;  
  wire [N-1:0] a,b,c,delta;
  wire sign_delta;
  wire [N-1:0] a_1,b_1,c_1,cmax_1,delta_1; // stage 1
  wire sign_delta_1;
  wire [N-1:0] result_sub, result_div0, result_div1;    
  wire [N-1:0] cmax_2,c_2,result_div0_2,result_div1_2; // stage 2
  wire sign_delta_2;
  wire [N-1:0] result_adder, result_mult, over, over_H;
  
  //assign val_out = val_o;
    
  always @(val_in or H)
	begin
		if(val_in == 1)
			begin
				R = i_R;
				G = i_G;
				B = i_B;
				val_out = 0;
			end
		else
			begin
				o_H = H;
				o_S = S;
				o_V = V;
				val_out = 1;
			end
	end
  
  
  extend8to32 inst_fixedpoint[2:0](
    .Out({Rf,Gf,Bf}),
    .In({R,G,B})
    );

  cmax inst_cmax(
    .signR(signR),
    .signG(signG),
    .signB(signB),
    .cmax(cmax),
    .R(Rf),
    .G(Gf),
    .B(Bf)
    );
    
  cmin inst_cmin(
    .cmin(cmin),
    .R(Rf),
    .G(Gf),
    .B(Bf)
    );
  
  adder #(15,32) inst_subtactor0(
    .a(cmax),
    .b({1'b1,cmin[30:0]}),
    .c(delta)
    );
  
  Selector inst_selector(
    .a(a),
    .b(b),
    .c(c),
    .sign_delta(sign_delta),
    .R(Rf),
    .G(Gf),
    .B(Bf),
    .delta(delta),
    .signR(signR),
    .signG(signG),
    .signB(signB) 
    );
  
  register32 inst_register32bits_1[4:0](  //stage 1
    .Q({a_1,b_1,c_1,cmax_1,delta_1}),
    .D({a,b,c,cmax,delta}),
    .clk(clk),
    .rst_n(rst_n)
    );
  d_flipflop inst_dff_1(   // stage signal delta
    .Q(sign_delta_1),
    .D(sign_delta),
    .clk(clk),
    .rst_n(rst_n)
    );
  
  adder #(15,32) inst_subtactor1(
    .a(a_1),
    .b({1'b1,b_1[30:0]}),
    .c(result_sub)
    );
  
  div inst_div0 (
		.i_dividend(result_sub), 
		.i_divisor(Delta), 
		.i_start(i_start), 
		.i_clk(i_clk), 
		.o_quotient_out(result_div0), 
		.o_complete(), 
		.o_overflow()
	);
	
  div inst_div1 (
		.i_dividend(Delta), 
		.i_divisor(Cmax), 
		.i_start(i_start), 
		.i_clk(i_clk), 
		.o_quotient_out(result_div1), 
		.o_complete(), 
		.o_overflow()
	);
  
  register32 inst_register32bits_2[3:0](  //stage 2
    .Q({cmax_2,c_2,result_div0_2,result_div1_2}),
    .D({cmax_2,c_1,result_div0,result_div1}),
    .clk(clk),
    .rst_n(rst_n)
    );
  d_flipflop inst_dff_2(   // stage signal delta
    .Q(sign_delta_2),
    .D(sign_delta_1),
    .clk(clk),
    .rst_n(rst_n)
    );
  
  adder #(15,32) inst_adder(
    .a(result_div0_2),
    .b(c_2),
    .c(result_adder)
    );
    
  mult inst_multiplier (
		.i_multiplicand(result_adder), 
		.i_multiplier({17'd60,15'b0}), // result_mult = 60* result_adder
		.i_start(i_start), 
		.i_clk(i_clk), 
		.o_result_out(result_mult), 
		.o_complete(), 
		.o_overflow()
	);
  
  assign over_H = ( result_mult > 360 )? over : result_mult ;
  
  adder #(15,32) inst_subtactor2(
    .a(result_mult),
    .b({1'b1,16'd360,15'b0}),
    .c(over)
    );
  
  assign H = (sign_delta_2)? 32'd0 : over_H;
  assign S = (cmax_2 == 32'd0)? 32'd0 : result_div1_2;
  assign V = cmax_2;
  

  
endmodule
