// comparator 32bits

module comparator #(
  parameter N = 32
  )
  (
  output GT,
  output LT,
  output EQ,
  input [N-1:0] A,
  input [N-1:0] B
  );
  
  assign GT = A > B,
  LT = A < B,
  EQ = A == B;
  
endmodule

