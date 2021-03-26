module register32 #(
  parameter N = 32
  )
  (
    output reg [N-1:0] Q,
    input [N-1:0] D,
    input clk,
    input rst_n
    );
    
    
    always @(posedge clk or negedge rst_n)
      if (!rst_n)
        Q <= 32'd0;
      else
        Q <= D;    
        
endmodule
