# Systolic Array for Applying Matrix Multiplication
This repository contains a parameterized SystemVerilog implementation of an N_SIZE x N_SIZE systolic array designed for efficient matrix multiplication, The design includes a configurable array size (`N_SIZE`) and data width (`DATAWIDTH`). The design supports configurable data widths and includes RTL code, a comprehensive testbench, and a detailed report with architecture diagrams, simulation waveforms, and logs. The architecture is scalable, synchronized with clock and reset signals, and optimized for high-performance applications such as AI accelerators.

---

## About

Language: `SystemVerilog`

Features: Scalable `N_SIZE`, configurable `data width`, clock/reset synchronization, pipelined architecture

Documentation: Includes a report with diagrams, waveforms, and logs

---

## 📁 Directory Structure

```text
Systolic-Array-for-Applying-Matrix-Multiplication/
├── README.md
├── Doc/
│   ├── file.log
│   └── Systolic Array for Applying Matrix Multiplication.pdf
├── MATLAB Matrix Mul (NXN)/
│   └── matlabmatrixmul.m
├── RTL/
│   ├── Controller.sv
│   ├── matrix_sep.sv
│   ├── mux_out.sv
│   ├── PE.sv
│   └── systolic_array.sv
└── Testbench/
    ├── PE_tb.sv
    └── systolic_array_tb.sv
