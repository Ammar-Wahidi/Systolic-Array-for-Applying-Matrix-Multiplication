//=========================================================================
// Engineer:      Ammar Ahmed Wahidi
// Project:       Systolic Array for Matrix Multiplication
// Organization:  STMicroelectronics – AI Accelerators Hands-on HW Design
// Module Name:   Controller
// Date:          July 2025
// Description:   Generates control signals for dataflow synchronization in
//                systolic array (valid_out, count_out, sel)
//=========================================================================

// ==========================
// Controller Module
// Implements a finite state machine (FSM) with a counter that:
//   - Starts on valid input
//   - Generates output valid signal after the pipeline delay
//   - Provides select signal (sel) for mux_out module
//   - Provides global count signal to all PEs
// The module uses a lookup table (LUT) indexed by count to control sel/valid_out
// ==========================
module Controller #(
    parameter DATAWIDTH = 16                                    ,
    parameter N_SIZE = 5
)(clk,rst_n,valid_in,valid_out,sel ,count_out);

    // ==========================
    // Local Parameters and State Definitions
    // ==========================
    localparam  N_TICKS         = 3 * N_SIZE - 2                    ;   // Total ticks to process full matrix
    localparam  START_COUT_TICK = N_SIZE                            ;   // Start collecting outputs
    localparam  END_TICK        = N_TICKS                           ;   // Last tick of operation
    localparam  HALF_COUT_TICK  = (START_COUT_TICK + END_TICK) / 2  ;   // Start of valid_out/assert sel
    localparam  COUNTER_SIZE    = $clog2(N_TICKS+1)                 ;   // Counter width
    localparam  LUT_SIZE        = 2**COUNTER_SIZE                   ;   // Lookup table depth
    localparam  IDLE            = 0                                 ;   // FSM state: Idle
    localparam  ACTIVE          = 1                                 ;   // FSM state: Active

    input                           clk                         ;
    input                           rst_n                       ;
    input                           valid_in                    ;
    output reg                      valid_out                   ;
    output reg [$clog2(N_SIZE)-1:0] sel                         ;
    output [COUNTER_SIZE-1:0]       count_out                   ;

    // ==========================
    // Internal Registers & Wires
    // ==========================
    reg [COUNTER_SIZE-1:0] count        ;
    reg                    state        ;
    reg                    next_state   ;

    // Expose counter to top
    assign count_out = count            ;

    // -------- Counter --------
       // FSM: State transition
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM: Next state logic
    always_comb begin
        case (state)
            IDLE:   next_state = (valid_in) ? ACTIVE : IDLE;
            ACTIVE: next_state = (count == END_TICK-1) ? IDLE : ACTIVE;
            default: next_state = IDLE;
        endcase
    end

    // FSM: Counter logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 0;
        else if (state == IDLE && valid_in)
            count <= 0;
        else if (state == ACTIVE)
            count <= count + 1;
        else 
            count <= 0;
    end

    // -------- Lookup Table --------
    logic   [$clog2(N_SIZE)-1:0]    sel_lut     [LUT_SIZE]   ;
    logic                           valid_lut   [LUT_SIZE]   ;

    genvar i;
    generate
        for (i = 0; i < LUT_SIZE; i = i + 1) begin : gen_sel_valid_table
            if (i >= HALF_COUT_TICK && i <= END_TICK)
            begin
                assign sel_lut[i]   = i - HALF_COUT_TICK    ;
                assign valid_lut[i] = 1'b1                  ;
            end else 
            begin
                assign sel_lut[i]   = '0                    ;
                assign valid_lut[i] = 1'b0                  ;
            end
        end
    endgenerate

    // -------- Output Assignment --------
    always_comb
    begin
        sel        = sel_lut[count]                         ;
        valid_out  = valid_lut[count]                       ;
    end

endmodule


