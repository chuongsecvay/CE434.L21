

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
  integer i = 0;
   
  initial begin
    $readmemb("binary.txt",binary);
    
    #1 rst_n <= 0;
    #1 rst_n <= 1;
    #6 i_clk = 0;
    out = $fopen("out.txt","w");
    
    forever #2 i_clk = !i_clk;
  end
  
  always @(posedge i_clk)
    begin
      if (i == 47)
        begin
          i <= 0;
          val_in <= 1;
          clk <= 1;
          i_start <= 1'b1;
          j <= j + 3;
          RGBinput();
        end
      else
        begin
          i <= i + 1;
          val_in <= 0;
          i_start <= 1'b0;
          clk <= 1'b0;
       	end
    end
    
  task RGBinput();
    begin  
      R = binary[j];
      G = binary[j+1];
      B = binary[j+2];
    end
  endtask
  
  always @(posedge val_out)
    begin
      if(j>9)
        begin
          $fwrite(out,"%d\t",H[30:15]);
          $fwrite(out,"%d\t",S[30:15]);
          $fwrite(out,"%d\n",V[30:15]);
        end
    end
    
     
endmodule


