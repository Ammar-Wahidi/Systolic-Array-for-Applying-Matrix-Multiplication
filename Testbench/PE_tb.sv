module PE_tb #(parameter DATAWIDTH = 8) (
 
);
reg     clk     ;
reg     rst_n   ;
reg       [DATAWIDTH-1:0]     a           ;
reg       [DATAWIDTH-1:0]     b           ;
wire      [DATAWIDTH-1:0]     a_right     ;
wire      [DATAWIDTH-1:0]     a_right1     ;
wire      [DATAWIDTH-1:0]     b_down      ;
wire      [DATAWIDTH-1:0]     b_down1      ;                    
wire      [2*DATAWIDTH-1:0]   c_out0       ;
wire      [2*DATAWIDTH-1:0]   c_out1       ;

PE PE0 (clk,rst_n,a,b,a_right,b_down,c_out0);
PE PE1 (clk,rst_n,a_right,b_down,a_right1,b_down1,c_out1);

initial clk =0 ;
always #5 clk=~clk ;

reg [2*DATAWIDTH-1:0] res;
initial 
begin
    rst_n = 0;
    a=0;
    b=0;
    res=0;
    #10;
    rst_n=1;
    a=0;
    b=0;
    #10;
    a=5;
    b=9;
    #10;
    a=9;
    b=2;
    #10;
    a=3;
    b=1;
    #10;
  $finish;
end
always 
begin
    #10;
    $display("posedge clk-------------------------------");
    $display("a0 = %0d , a0= %0d , a_right0 = %0d , b_down0 = %0d , cout = %0d",PE0.a,PE0.b,a_right,b_down,c_out0);
    $display("a1 = %0d , b1= %0d , a_right1 = %0d , b_down1 = %0d , cout = %0d",PE1.a,PE1.b,a_right1,b_down1,c_out1);
end
endmodule