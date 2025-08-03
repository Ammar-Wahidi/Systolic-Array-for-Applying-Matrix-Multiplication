//=========================================================================
// Engineer:      Ammar Ahmed Wahidi
// Project:       Systolic Array for Matrix Multiplication
// Organization:  STMicroelectronics – AI Accelerators Hands-on HW Design
// Module Name:   systolic_array (Top Module)
// Date:          July 2025
// Description:   Top-level RTL implementation of NxN systolic array for
//                parallel matrix multiplication using Verilog
//=========================================================================

// ==========================
// systolic_array (Top Module)
// This module instantiates an NxN grid of Processing Elements (PEs)
// to perform matrix multiplication using a systolic array architecture.
// Inputs:
//   - matrix_a_in: inputs one row of matrix A per clock cycle
//   - matrix_b_in: inputs one column of matrix B per clock cycle
//   - valid_in: asserts when inputs are valid
//   - clk/rst_n: synchronous clock and asynchronous active-low reset
// Outputs:
//   - matrix_c_out: the computed row of the output matrix C
//   - valid_out: asserts when output is valid
// Internal components:
//   - Controller: generates valid/sel/count control signals
//   - mux_out: selects the correct row of result matrix for output
// ==========================
module  systolic_array      #(parameter DATAWIDTH = 8, N_SIZE = 3)     (
input                               clk                         ,
input                               rst_n                       ,
input                               valid_in                    ,
input   [DATAWIDTH-1:0]             matrix_a_in  [N_SIZE-1:0]   , // Array of cols {a_in[31],a_in[21],a_in[11]}
input   [DATAWIDTH-1:0]             matrix_b_in  [N_SIZE-1:0]   , // Array of rows {b_in[13],b_in[12],b_in[11]} 
output                              valid_out                   ,
output  [2*DATAWIDTH-1:0]           matrix_c_out [N_SIZE-1:0]     
);

// ==========================
// Local Parameters
// ==========================
localparam       N_SEL           =   $clog2(N_SIZE)                             ;   // Number of bits needed to select among N_SIZE options (used for mux/select logic)
localparam       NUM_OF_REGS     =   ((N_SIZE-1)*N_SIZE)/2                      ;   // Total number of intermediate registers required for data shifting in triangular reg logic
localparam       N_TICKS         =   3 * N_SIZE - 2                             ;   // Total number of clock cycles required for full computation in the systolic array
localparam       COUNTER_SIZE    =   $clog2(N_TICKS+1)                          ;   // Bit-width required for a counter that counts up to N_TICKS

// ==========================
// Internal Signals Declaration
// ==========================
wire    [DATAWIDTH-1:0]             down                [N_SIZE+1][N_SIZE]      ;
wire    [DATAWIDTH-1:0]             right               [N_SIZE][N_SIZE+1]      ;
wire    [DATAWIDTH-1:0]             reg1_down           [N_SIZE]                ;
wire    [DATAWIDTH-1:0]             reg1_right          [N_SIZE]                ;
wire    [2*DATAWIDTH-1:0]           c                   [1:N_SIZE*N_SIZE]       ;
wire    [N_SEL-1:0]                 sel                                         ;
wire    [2*DATAWIDTH*N_SIZE-1:0]    o_mux                                       ;
wire    [COUNTER_SIZE-1:0]          count                                       ;    

reg     [DATAWIDTH-1:0]             a_in_reg            [N_SIZE]                ;       
reg     [DATAWIDTH-1:0]             b_in_reg            [N_SIZE]                ;         
reg     [DATAWIDTH-1:0]             regb                [1:NUM_OF_REGS]         ;
reg     [DATAWIDTH-1:0]             rega                [1:NUM_OF_REGS]         ;
reg     [2*DATAWIDTH*N_SIZE-1:0]    matrix_c_out_array  [N_SIZE]                ;                  

// ==========================
// Assign first inputs to pipeline registers
// ==========================
assign  reg1_down   [0] = b_in_reg  [0][DATAWIDTH-1:0]                          ;
assign  reg1_right  [0] = a_in_reg  [0][DATAWIDTH-1:0]                          ;

genvar  i           ;
genvar  k           ;
genvar  j           ;
genvar  l           ;
genvar  i_in        ;
genvar  i_depth     ;
genvar  i_ina       ;
genvar  i_deptha    ;
genvar  t           ;
genvar  m           ;

// ==========================
// Register input matrices row-wise and column-wise
// ==========================
generate;
    for (i = 0 ; i<N_SIZE ; i=i+1)
    begin 
        always @(posedge clk or negedge rst_n)
        begin
            if (~rst_n)
            begin
                a_in_reg[i]    <=  0             ;
                b_in_reg[i]    <=  0             ;
            end
            else if (valid_in)
            begin
                a_in_reg[i]    <=  matrix_a_in[i]   ;
                b_in_reg[i]    <=  matrix_b_in[i]   ;
            end
            else 
            begin
                a_in_reg[i]     <= 0   ;
                b_in_reg[i]     <= 0   ;
            end
        end
    end
endgenerate

// ==========================
// Instantiate N_SIZE x N_SIZE Processing Elements (PEs)
// Each PE receives:
// - one input from the left (a  = right[k][j])
// - one input from the top  (b  = down[k][j])
// - passes its 'a' value to the right neighbor (a_right)
// - passes its 'b' value to the bottom neighbor (b_down)
// - outputs partial result c_out to be collected later
// 'count' is broadcast to all PEs for timing control
// ==========================
generate;

    // Feed first row and column of systolic array
    for (l=0;l<N_SIZE;l=l+1)
    begin
        assign  down    [0][l] = reg1_down  [l]     ; 
        assign  right   [l][0] = reg1_right [l]     ; 
    end

    for (k=0;k<N_SIZE;k=k+1)
    begin
        for (j=0;j<N_SIZE;j=j+1)
        begin
            PE #(DATAWIDTH,N_SIZE) PE (
            .clk(clk)                       ,
            .rst_n(rst_n)                   ,
            .count(count)                   ,
            .a(right[k][j])                 ,
            .b(down [k][j])                 ,
            .a_right(right[k][j+1])         ,
            .b_down(down [k+1][j])          ,
            .c_out(c[(j+k*N_SIZE)+1])
            );
        end
    end
endgenerate

// ==========================
// Pipeline for matrix_b data into reg1_down
// ==========================
generate;
for (i_in=1;i_in<=N_SIZE-1;i_in=i_in+1)
begin
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n)
        begin
            regb    [(((i_in-1)*i_in)/2)+1] <= 0                                ;
        end
        else
        begin
            regb    [(((i_in-1)*i_in)/2)+1] <= b_in_reg [i_in][DATAWIDTH-1:0]   ;
        end
    end
    if(i_in>1)
    begin
        for(i_depth=(((i_in-1)*i_in)/2)+2;i_depth<((((i_in-1)*i_in)/2)+1)+i_in;i_depth=i_depth+1)
        begin
            always @(posedge clk or negedge rst_n)
            begin
                if (~rst_n)
                begin
                    regb    [i_depth] <= 0                      ;
                end
                else
                begin
                    regb    [i_depth] <= regb   [i_depth-1]     ;
                end
            end 
        end
    end
    assign reg1_down    [1] = regb  [1]                         ;
    if(i_in>1)
    begin
        assign reg1_down    [i_in] = regb   [(((i_in-1)*i_in)/2)+1+i_in-1]  ;
    end
end
endgenerate

// ==========================
// Pipeline for matrix_a data into reg1_right
// ==========================
generate;
for (i_ina=1;i_ina<=N_SIZE-1;i_ina=i_ina+1)
begin
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n)
        begin
            rega[(((i_ina-1)*i_ina)/2)+1] <= 0;
        end
        else
        begin
            rega[(((i_ina-1)*i_ina)/2)+1] <= a_in_reg[i_ina][DATAWIDTH-1:0];
        end
    end
    if(i_ina>1)
    begin
        for(i_deptha=(((i_ina-1)*i_ina)/2)+2;i_deptha<((((i_ina-1)*i_ina)/2)+1)+i_ina;i_deptha=i_deptha+1)
        begin
            always @(posedge clk or negedge rst_n)
            begin
                if (~rst_n)
                begin
                    rega[i_deptha] <= 0;
                end
                else
                begin
                    rega[i_deptha] <= rega[i_deptha-1];
                end
            end 
        end
    end
    assign reg1_right[1] = rega[1]  ;
    if(i_ina>1)
    begin
        assign reg1_right[i_ina] = rega[(((i_ina-1)*i_ina)/2)+1+i_ina-1]  ;
    end
end
endgenerate

// ==========================
// Pack the output results from 'c' into matrix_c_out_array
// ==========================
generate
    for (t = 0; t < N_SIZE; t = t + 1) begin : pack_c_row
        for (m = 0; m < N_SIZE; m = m + 1) begin : pack_bits
            // Compute the correct bit slice in the output bus
            localparam int out_idx = (N_SIZE - 1 - m) * 2 * DATAWIDTH;
            localparam int c_idx   = t * N_SIZE + m + 1;  // since c[1] to c[N]

            assign matrix_c_out_array   [t][out_idx +: 2*DATAWIDTH] = c[c_idx]  ;
        end
    end
endgenerate

// Instantiate Controller
Controller #(DATAWIDTH,N_SIZE) CU (
.clk(clk)                       ,
.rst_n(rst_n)                   ,
.valid_in(valid_in)             ,
.valid_out(valid_out)           ,
.sel(sel)                       ,
.count_out(count)       
);

// Output MUX for result row selection
mux_out #(2*DATAWIDTH*N_SIZE,N_SIZE) MUX (
.in(matrix_c_out_array)         ,
.sel(sel)                       ,
.out(o_mux)
);

matrix_sep #(DATAWIDTH,N_SIZE) matrix_out_sep (
.matrix_c_unsep(o_mux)          ,
.matrix_c_out_sep(matrix_c_out)
);

endmodule 