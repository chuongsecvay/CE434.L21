
  module Selector #(
  parameter N = 32
  )
  (
    output [N-1:0] a,
    output [N-1:0] b,
    output [N-1:0] c,
    output sign_delta,
    input [N-1:0] R,
    input [N-1:0] G,
    input [N-1:0] B,
    input [N-1:0] delta,
    input signR,
    input signG,
    input signB 
    );
    
  wire [N-1:0] tmpa0,tmpa1;
  wire [N-1:0] tmpb0,tmpb1;
  wire [N-1:0] tmpc0,tmpc1;  
    
  assign sign_delta = (delta == 32'd0)? 1:0;
    
  mux21 muxa1(
    .Y(a),
    .I0(tmpa1),
    .I1(G),
    .S(signR)
    );
  
  mux21 muxa2(
    .Y(tmpa1),
    .I0(tmpa0),
    .I1(B),
    .S(signG)
    );
    
  mux21 muxa3(
    .Y(tmpa0),
    .I0(32'dx),
    .I1(R),
    .S(signB)
    );
    
  mux21 muxb1(
    .Y(b),
    .I0(tmpb1),
    .I1({1'b1,B[N-2:0]}),
    .S(signR)
    );
  
  mux21 muxb2(
    .Y(tmpb1),
    .I0(tmpb0),
    .I1({1'b1,R[N-2:0]}),
    .S(signG)
    );
    
  mux21 muxb3(
    .Y(tmpb0),
    .I0(32'dx),
    .I1({1'b1,G[N-2:0]}),
    .S(signB)
    );
    
  mux21 muxc1(
    .Y(c),
    .I0(tmpc1),
    .I1({1'b0,16'd6,15'd0}),
    .S(signR)
    );
  
  mux21 muxc2(
    .Y(tmpc1),
    .I0(tmpc0),
    .I1({1'b0,16'd2,15'd0}),
    .S(signG)
    );
    
  mux21 muxc3(
    .Y(tmpc0),
    .I0(32'dx),
    .I1({1'b0,16'd4,15'd0}),
    .S(signB)
    );
  
    
endmodule
