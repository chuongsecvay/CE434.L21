module mux21 #(
  parameter N = 32
  )
  (output [N-1:0] Y,
  input [N-1:0] I0,
  input [N-1:0] I1,
  input S
  );
  

  assign Y = (S)? I1:I0;
  
endmodule

