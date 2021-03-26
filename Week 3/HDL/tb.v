









module tb();
  parameter N = 32;
    
  wire [N-1:0] H,S,V;
  wire val_out;
  reg [7:0] R,G,B;
  reg val_in, clk, i_clk, i_start, rst_n;
  
  RGBtoHSV inst(
    .o_H(H),
    .o_S(S),
    .o_V(V),
    .val_out(val_out),
    .i_R(R),
    .i_G(G),
    .i_B(B),
    .val_in(val_in),
    .clk(clk),
    .i_clk(i_clk),
    .i_start(i_start),
    .rst_n(rst_n)
    );  
  
  reg [N-1:0] binary[0:43437];
  integer out;
  integer j = 0; // pointer memory
  
   
  initial begin
    $readmemb("binary.txt",binary);
    #1 rst_n <= 0;
    #1 rst_n <= 1; 
    #8 R <= 8'd0;
    G <= 8'd0;
    B <= 8'd0;
    clk <= 0;
    i_clk <= 0;
    i_start <= 0;
    out = $fopen("out.txt","w");
    
    forever #1 i_clk = !i_clk;
  end
  
  integer i = 0;
  
  always @(*)
    begin
      if (i_clk == 1)
        i = i + 1;
      else
        if (i == 0)
          begin
            RGBinput();
            val_in <= 1;
            clk <= 1;
            i_start <= 1;
            #2 val_in <= 0;
            clk <= 0;
            i_start <= 0;
            j = j + 3;
          end
        else
          if (i == 47)
            i = 0;
    end
    
    
  task RGBinput();
    begin  
      R = binary[j];
      G = binary[j+1];
      B = binary[j+2];
    end
  endtask
 
endmodule


