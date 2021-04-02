module cmin #(
  parameter N = 32
  )
  (
  output [N-1:0] cmin,
  input [N-1:0] R,
  input [N-1:0] G,
  input [N-1:0] B
  );
   
  wire [N-1:0] tmp0;
  wire S0,S1;
  
  comparator cmp0(GT0,LT0,EQ0,R,G);
  comparator cmp1(GT1,LT1,EQ1,tmp0,B);
  mux21 mux0(tmp0,G,R,S0);
  mux21 mux1(cmin,B,tmp0,S1);
  
  assign S0 = LT0 || EQ0,
  S1 = LT1 || EQ1;
  
endmodule

