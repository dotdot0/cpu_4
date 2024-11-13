`timescale 1ns/1ps

module tb_cpu;
    
    reg clk;                  
    reg reset;                
    reg wakeup;               // Wakeup signal to exit sleep mode
    wire [3:0] acc;           // Accumulator output from CPU module

    
    cpu uut (
        .clk(clk),
        .reset(reset),
        .wakeup(wakeup),      
        .acc(acc)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    
    initial begin
        
        $dumpfile("cpu_test.vcd");   
        $dumpvars(0, tb_cpu);        

        
        $monitor("Time = %0dns | PC = %h | ACC (Accumulator) = %h | IR (Instruction) = %h | Operand = %b | Opcode = %b | R0 = %b | R1 = %b | ALU Output = %b | State = %b",
                 $time, uut.PC, acc, uut.IR, uut.operand, uut.opcode, uut.R0, uut.R1, uut.alu_out, uut.state);

        
    
        reset = 1;            // Activate reset
        wakeup = 0;           // Initialize wakeup to 0
        #10;
        reset = 0;            // Release reset

       
        // Format: [Opcode, Operand]
        uut.memory[0] = 4'b0001;  // LOAD VALUE 
        uut.memory[1] = 4'b0101;

        uut.memory[2] = 4'b0001;  // LOAD VALUE 
        uut.memory[3] = 4'b0011;  

        uut.memory[4] = 4'b0010;  // ADD instruction 
        uut.memory[5] = 4'b0000;  

        uut.memory[6] = 4'b0011;  // SUB instruction
        uut.memory[7] = 4'b0000;  

        uut.memory[8] = 4'b0100; // AND instruction
        uut.memory[9] = 4'b0000;  

        uut.memory[10] = 4'b0101; // OR instruction
        uut.memory[11] = 4'b0000;

        uut.memory[12] = 4'b0111; // XNOR instruction
        uut.memory[13] = 4'b0000; 

        uut.memory[14] = 4'b1000;  // SLEEP instruction 
        uut.memory[15] = 4'b0000;  

        #270;               

        $display("Entering sleep state...");   
        $finish;
    end
endmodule
