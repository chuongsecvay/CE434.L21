
module cmax #(
  parameter N = 32
  )
  (
  output signR,
  output signG,
  output signB,
  output [N-1:0] cmax,
  input [N-1:0] R,
  input [N-1:0] G,
  input [N-1:0] B
  );
  
  wire [N-1:0] tmp0;
  wire S0,S1;
  
  comparator cmp0(GT0,LT0,EQ0,R,G);
  comparator cmp1(GT1,LT1,EQ1,tmp0,B);
  mux21 mux0(tmp0,R,G,S0);
  mux21 mux1(cmax,tmp0,B,S1);
  or (S0,GT0,LT0);
  or (S1,GT1,LT1);
  
  assign signR = (GT0 && GT1) || (EQ0 && GT1) || (GT0 && EQ1) || (EQ0 && EQ1),
  signG = (LT0 && GT1) || (EQ0 && GT1) || (LT0 && EQ1) || (EQ0 && EQ1),
  signB = (LT0 && LT1) || (GT0 && EQ1) || (LT0 && EQ1) || (EQ0 && EQ1);
  
  
endmodule

