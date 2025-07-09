# 4-Bit CPU with Assembler
Overview

This project implements a 4-bit CPU in Verilog, complete with a testbench and an integrated assembler. The assembler simplifies the process of creating testbenches by allowing you to write instructions in a file and automatically generating a testbench for simulation.
Features

    4-Bit CPU: Fully functional CPU designed in Verilog.
    Assembler: Converts high-level assembly-like instructions into testbench-compatible format.
    Automated Testbench Generation: No need to manually write testbenches; simply define instructions in a file.
    Simulation: Use GTKWave to simulate the CPU and visualize outputs.

Usage
1. Write Instructions

Create a file (e.g., instructions.txt) with the instructions and opcodes for the CPU.
2. Generate Testbench

Run the assembler script to generate a testbench:

python assembler.py instructions.txt

This will output a testbench (e.g., cpu_testbench.v).
3. Simulate

Run the generated testbench in a Verilog simulator like GTKWave to observe the CPU's behavior:

# Example with a simulator
vvp cpu_testbench

Then, load the output in GTKWave to analyze signals.
Requirements

    Verilog Tools: Any Verilog simulator (e.g., ModelSim, Icarus Verilog).
    GTKWave: For waveform visualization.
    Python: To run the assembler.

Project Structure

    ├── cpu.v              # 4-bit CPU Verilog implementation
    ├── cpu_testbench.v    # Testbench for simulation
    ├── assembler.py       # Assembler script
    ├── instructions.txt   # Example instruction file
    ├── README.md          # Project documentation

Example Instruction File

    LOAD R1, 0x3
    ADD R1, R2
    SUB R1, R2
    AND R1, R2
    OR R1, R2
    XNOR R1, R2
    WRITE 0x5, R1
    SLEEP

Future Enhancements

    Support for additional opcodes and instructions.
    Interactive assembler with error handling.
    Enhanced visualization for complex simulations.

Happy simulating! 🚀
