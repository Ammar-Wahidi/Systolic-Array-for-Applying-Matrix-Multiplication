//=========================================================================
// Engineer:      Ammar Ahmed Wahidi
// Project:       Systolic Array for Matrix Multiplication
// Organization:  STMicroelectronics – AI Accelerators Hands-on HW Design
// Module Name:   PE (Processing Element)
// Date:          July 2025
// Description:   Multiply-Accumulate unit for systolic array architecture
//=========================================================================

// ==========================
// Processing Element (PE) for Systolic Array
// Performs Multiply-Accumulate (MAC) operation
// For each clock cycle:
//   - Multiplies input values a and b
//   - Adds the result to internal accumulator
//   - Stores current a and b values to pass to neighbors
// Outputs:
//   - a_right: pass current 'a' to the right PE
//   - b_down : pass current 'b' to the bottom PE
//   - c_out  : current accumulated partial product
// ==========================
module PE #(parameter DATAWIDTH = 16 , N_SIZE = 5)
(clk,rst_n,count,a,b,a_right,b_down,c_out);

localparam  N_TICKS         = 3 * N_SIZE - 2                    ;   // Total ticks to process full matrix
localparam  COUNTER_SIZE    = $clog2(N_TICKS+1)                 ;   // Counter width

input                                   clk         ;
input                                   rst_n       ;
input               [COUNTER_SIZE-1:0]  count       ;
input   signed      [DATAWIDTH-1:0]     a           ;   // Input A from left
input   signed      [DATAWIDTH-1:0]     b           ;   // Input B from top
output  signed      [DATAWIDTH-1:0]     a_right     ;   // Output A to right neighbor
output  signed      [DATAWIDTH-1:0]     b_down      ;   // Output B to bottom neighbor                  
output  signed      [2*DATAWIDTH-1:0]   c_out       ;   // Output result 

wire    signed      [2*DATAWIDTH-1:0]   a_mul_b     ;   // a * b
wire    signed      [2*DATAWIDTH-1:0]   add_out     ;   // a * b + acc
reg     signed      [DATAWIDTH-1:0]     a_reg       ;   // Register to hold 'a' for propagation
reg     signed      [DATAWIDTH-1:0]     b_reg       ;   // Register to hold 'b' for propagation
reg     signed      [2*DATAWIDTH-1:0]   acc         ;   // Accumulator 


assign      a_mul_b     =   a       *   b           ;   // Multiply a and b
assign      add_out     =   a_mul_b +   acc         ;   // Add product to accumulator

// ==========================
// Accumulator Register
// Reset at N_TICKS to clear old computation
// ==========================
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
        acc     <=  0                   ;
    else if (count == N_TICKS)
        acc     <=  0                   ;
    else
        acc     <=  add_out             ;
end

// ==========================
// Register Inputs for Pipelining
// a and b are stored to propagate to neighbors
// ==========================
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        a_reg     <=  0                   ;
        b_reg     <=  0                   ;   
    end
    else
    begin
        a_reg     <=  a                   ;
        b_reg     <=  b                   ;   
    end
end

// ==========================
// Outputs
// Propagate values and return accumulated result
// ==========================
assign      a_right    =   a_reg            ;
assign      b_down     =   b_reg            ;
assign      c_out      =   add_out          ;



    
endmodule