

// Ammar Ahmed Wahidi
module systolic_array_tb();
parameter DATAWIDTH =16;
parameter  N_SIZE=4;
  reg                               clk                         ;
  reg                               rst_n                       ;
  reg                               valid_in                    ;
  reg signed  [DATAWIDTH-1:0]      matrix_a_in [N_SIZE-1:0]           ;
  reg signed  [DATAWIDTH-1:0]      matrix_b_in [N_SIZE-1:0]           ;  
  wire                              valid_out                   ;
  wire signed [2*DATAWIDTH-1:0]    matrix_c_out [N_SIZE-1:0]          ;
  
  systolic_array#(DATAWIDTH,N_SIZE) sa(clk,rst_n,valid_in,matrix_a_in,matrix_b_in,valid_out,matrix_c_out);
  
  initial clk=0;
  always #20 clk=~clk; // TCLK = 40
  int i;
  initial 
    begin
      rst_n = 0;
      matrix_a_in[0]=0;
      matrix_a_in[1]=0;
      matrix_a_in[2]=0;
      matrix_a_in[3]=0;
      matrix_b_in[0]=0;
      matrix_b_in[1]=0;
      matrix_b_in[2]=0;
      matrix_b_in[3]=0;
      valid_in = 0;
      #60;
      rst_n = 1 ;
      valid_in=1;
      matrix_a_in[0]=4;
      matrix_a_in[1]=6;
      matrix_a_in[2]=6;
      matrix_a_in[3]=6;
      matrix_b_in[0]=3;
      matrix_b_in[1]=2;
      matrix_b_in[2]=454;
      matrix_b_in[3]=76;

      $display("Column 1 of Matrix A:");
      $display("a11 = %0d", matrix_a_in[0]);
      $display("a21 = %0d", matrix_a_in[1]);
      $display("a31 = %0d", matrix_a_in[2]);
      $display("a41 = %0d", matrix_a_in[3]);

      $display("Row 1 of Matrix B:");
      $display("b11 = %0d", matrix_b_in[0]);
      $display("b12 = %0d", matrix_b_in[1]);
      $display("b13 = %0d", matrix_b_in[2]);
      $display("b14 = %0d", matrix_b_in[3]);
      #40;
      valid_in=1;
      matrix_a_in[0]=34;
      matrix_a_in[1]=4;
      matrix_a_in[2]=4;
      matrix_a_in[3]=7;
      matrix_b_in[0]=54;
      matrix_b_in[1]=7;
      matrix_b_in[2]=856;
      matrix_b_in[3]=0;

      $display("Column 2 of Matrix A:");
      $display("a12 = %0d", matrix_a_in[0]);
      $display("a22 = %0d", matrix_a_in[1]);
      $display("a32 = %0d", matrix_a_in[2]);
      $display("a42 = %0d", matrix_a_in[3]);

      $display("Row 2 of Matrix B:");
      $display("b21 = %0d", matrix_b_in[0]);
      $display("b22 = %0d", matrix_b_in[1]);
      $display("b23 = %0d", matrix_b_in[2]);
      $display("b24 = %0d", matrix_b_in[3]);
      #40;
      valid_in=1;
      matrix_a_in[0]=0;
      matrix_a_in[1]=32;
      matrix_a_in[2]=3;
      matrix_a_in[3]=8;
      matrix_b_in[0]=0;
      matrix_b_in[1]=0;
      matrix_b_in[2]=0;
      matrix_b_in[3]=56;

      $display("Column 3 of Matrix A:");
      $display("a13 = %0d", matrix_a_in[0]);
      $display("a23 = %0d", matrix_a_in[1]);
      $display("a33 = %0d", matrix_a_in[2]);
      $display("a43 = %0d", matrix_a_in[3]);

      $display("Row 3 of Matrix B:");
      $display("b31 = %0d", matrix_b_in[0]);
      $display("b32 = %0d", matrix_b_in[1]);
      $display("b33 = %0d", matrix_b_in[2]);
      $display("b34 = %0d", matrix_b_in[3]);
      #40;
      valid_in=1;
      matrix_a_in[0]=23;
      matrix_a_in[1]=65;
      matrix_a_in[2]=5;
      matrix_a_in[3]=4;
      matrix_b_in[0]=34;
      matrix_b_in[1]=3;
      matrix_b_in[2]=3;
      matrix_b_in[3]=3;

      $display("Column 4 of Matrix A:");
      $display("a14 = %0d", matrix_a_in[0]);
      $display("a24 = %0d", matrix_a_in[1]);
      $display("a34 = %0d", matrix_a_in[2]);
      $display("a44 = %0d", matrix_a_in[3]);

      $display("Row 4 of Matrix B:");
      $display("b41 = %0d", matrix_b_in[0]);
      $display("b42 = %0d", matrix_b_in[1]);
      $display("b43 = %0d", matrix_b_in[2]);
      $display("b44 = %0d", matrix_b_in[3]);
      #40;
      valid_in = 0;
      
      wait(valid_out);
      for (i=1;i<N_SIZE+1;i++)
      begin
      @(negedge clk);
      $display("row %0d of Matrix C:",i);
      $display("c%0d1 = %0d",i, matrix_c_out[3]);
      $display("c%0d2 = %0d",i, matrix_c_out[2]);
      $display("c%0d3 = %0d",i, matrix_c_out[1]);
      $display("c%0d4 = %0d",i, matrix_c_out[0]);
      end
      #40;
      valid_in=1;
      matrix_a_in[0]=-3;
      matrix_a_in[1]=32;
      matrix_a_in[2]=43;
      matrix_a_in[3]=-3;
      matrix_b_in[0]=32;
      matrix_b_in[1]=4;
      matrix_b_in[2]=56;
      matrix_b_in[3]=9;

      $display("Column 1 of Matrix A:");
      $display("a11 = %0d", matrix_a_in[0]);
      $display("a21 = %0d", matrix_a_in[1]);
      $display("a31 = %0d", matrix_a_in[2]);
      $display("a41 = %0d", matrix_a_in[3]);

      $display("Row 1 of Matrix B:");
      $display("b11 = %0d", matrix_b_in[0]);
      $display("b12 = %0d", matrix_b_in[1]);
      $display("b13 = %0d", matrix_b_in[2]);
      $display("b14 = %0d", matrix_b_in[3]);
      #40;
      valid_in=1;
      matrix_a_in[0]=-32;
      matrix_a_in[1]=4;
      matrix_a_in[2]=4;
      matrix_a_in[3]=-3;
      matrix_b_in[0]=8;
      matrix_b_in[1]=7;
      matrix_b_in[2]=6;
      matrix_b_in[3]=54;

      $display("Column 2 of Matrix A:");
      $display("a12 = %0d", matrix_a_in[0]);
      $display("a22 = %0d", matrix_a_in[1]);
      $display("a32 = %0d", matrix_a_in[2]);
      $display("a42 = %0d", matrix_a_in[3]);

      $display("Row 2 of Matrix B:");
      $display("b21 = %0d", matrix_b_in[0]);
      $display("b22 = %0d", matrix_b_in[1]);
      $display("b23 = %0d", matrix_b_in[2]);
      $display("b24 = %0d", matrix_b_in[3]);
      #40;
      valid_in=1;
      matrix_a_in[0]=-4;
      matrix_a_in[1]=54;
      matrix_a_in[2]=3;
      matrix_a_in[3]=43;
      matrix_b_in[0]=76;
      matrix_b_in[1]=56;
      matrix_b_in[2]=8;
      matrix_b_in[3]=7;

      $display("Column 3 of Matrix A:");
      $display("a13 = %0d", matrix_a_in[0]);
      $display("a23 = %0d", matrix_a_in[1]);
      $display("a33 = %0d", matrix_a_in[2]);
      $display("a43 = %0d", matrix_a_in[3]);

      $display("Row 3 of Matrix B:");
      $display("b31 = %0d", matrix_b_in[0]);
      $display("b32 = %0d", matrix_b_in[1]);
      $display("b33 = %0d", matrix_b_in[2]);
      $display("b34 = %0d", matrix_b_in[3]);
      #40;
      valid_in=1;
      matrix_a_in[0]=332;
      matrix_a_in[1]=65;
      matrix_a_in[2]=3;
      matrix_a_in[3]=32;
      matrix_b_in[0]=65;
      matrix_b_in[1]=76;
      matrix_b_in[2]=7;
      matrix_b_in[3]=8;

      $display("Column 4 of Matrix A:");
      $display("a14 = %0d", matrix_a_in[0]);
      $display("a24 = %0d", matrix_a_in[1]);
      $display("a34 = %0d", matrix_a_in[2]);
      $display("a44 = %0d", matrix_a_in[3]);

      $display("Row 4 of Matrix B:");
      $display("b41 = %0d", matrix_b_in[0]);
      $display("b42 = %0d", matrix_b_in[1]);
      $display("b43 = %0d", matrix_b_in[2]);
      $display("b44 = %0d", matrix_b_in[3]);
      #40;
      valid_in = 0;
      
      wait(valid_out);
      for (i=1;i<N_SIZE+1;i++)
      begin
      @(negedge clk);
      $display("row %0d of Matrix C:",i);
      $display("c%0d1 = %0d",i, matrix_c_out[3]);
      $display("c%0d2 = %0d",i, matrix_c_out[2]);
      $display("c%0d3 = %0d",i, matrix_c_out[1]);
      $display("c%0d4 = %0d",i, matrix_c_out[0]);
      end
      #40;
      $stop;
    end
  
  
  
endmodule