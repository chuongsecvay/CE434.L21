
module d_flipflop(
    output reg Q,
    input D,
    input clk,
    input rst_n
    );
    
    
    always @(posedge clk or negedge rst_n)
      if (!rst_n)
        Q <= 32'd0;
      else
        Q <= D;    
        
endmodule
