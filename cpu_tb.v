`timescale 1ns/1ps

module tb_cpu;
    // Signal declarations
    reg clk;                  // Clock signal
    reg reset;                // Reset signal
    wire [3:0] acc;           // Accumulator output from CPU module

    // Instantiate the CPU module under test (UUT)
    cpu uut (
        .clk(clk),
        .reset(reset),
        .acc(acc)
    );

    // Clock generation: 10 ns period (50 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Enable GTKWave dump file generation
        $dumpfile("cpu_test.vcd");   // Specify the .vcd file name
        $dumpvars(0, tb_cpu);        // Record all variables in the tb_cpu module

        // Enhanced Monitor Statement for Readability
        $monitor("Time = %0dns | PC = %h | ACC (Accumulator) = %h | IR (Instruction) = %h | Operand = %b | Opcode = %b | R0 = %b | R1 = %b | ALU Output = %b",
                 $time, uut.PC, acc, uut.IR, uut.operand, uut.opcode, uut.R0, uut.R1, uut.alu_out);

        // Initialize the reset signal
        reset = 1;                     // Activate reset
        #10;
        reset = 0;                     // Release reset

        // Memory Initialization
        // Data memory: Storing immediate data values
        uut.data_memory[0] = 4'b0100;  // LOAD VALUE TO R0 (RO = 0100 (4 IN DECIMAL) )
        uut.Data_PC = 0;
        uut.data_memory[1] = 4'b0010;  // LOAD VALUE TO R1 
        uut.Data_PC = 1;
        // Instruction memory: Loading a series of instructions
        // Format: [Opcode, Operand]
        uut.memory[0] = 4'b0001;  // LOAD VALUE TO DATA MEMORY (Opcode for LOAD)
        uut.memory[1] = 4'b0011;  

        uut.memory[2] = 4'b0010;  // ADD instruction (Opcode for ADD)
        uut.memory[3] = 4'b0000;  

        uut.memory[4] = 4'b0101;  // OR instruction
        uut.memory[5] = 4'b0000;  

        uut.memory[6] = 4'b0011;  // SUB instruction
        uut.memory[7] = 4'b0000;  

        uut.memory[8] = 4'b0100;  // AND instruction
        uut.memory[9] = 4'b0000;  

        uut.memory[10] = 4'b0111; // XNOR instruction
        uut.memory[11] = 4'b0000; 

        // Run the simulation for a sufficient time to observe instruction execution
        #400;

        // End simulation
        $finish;
    end
endmodule
