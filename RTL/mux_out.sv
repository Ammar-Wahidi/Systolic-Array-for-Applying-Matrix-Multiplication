//=========================================================================
// Engineer:      Ammar Ahmed Wahidi
// Project:       Systolic Array for Matrix Multiplication
// Organization:  STMicroelectronics – AI Accelerators Hands-on HW Design
// Module Name:   mux_out
// Date:          July 2025
// Description:   Multiplexer to select one row of the output matrix C 
//                based on the control signal from the Controller
//=========================================================================

// ==========================
// mux_out Module
// A parameterized multiplexer used to select one of N_SIZE input rows 
// of the result matrix and output it.
// Inputs:
//   - in[N_SIZE]: Array of N input rows (e.g., rows of matrix C)
//   - sel: Select signal from Controller (log2(N_SIZE) bits)
// Output:
//   - out: Selected row passed to matrix_c_out
// ==========================
module mux_out #(
    parameter DATAWIDTH = 160,              // Width of default each input (e.g. 5 × 2 × 16)
    parameter N_SIZE = 5                    // Number of default rows in matrix C
)(
    input      [DATAWIDTH-1:0] in [N_SIZE] ,   // Array of N inputs, each WIDTH bits
    input      [$clog2(N_SIZE)-1:0] sel    ,   // Selector
    output reg [DATAWIDTH-1:0] out             // Output
);

    // Combinational multiplexer logic
    always_comb begin
        out = '0;               // default
        if (sel < N_SIZE)
            out = in[sel];
    end

endmodule
