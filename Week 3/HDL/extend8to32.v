// extend 8 bits to 32 bits fixed point

module extend8to32#(
  parameter Q = 15,
  parameter N = 32
  )
  (
    output [N-1:0] Out,
    input [7:0] In
    );
  
  assign Out = {1'b0,8'b00000000,In,15'b000000000000000};
  
  
endmodule

