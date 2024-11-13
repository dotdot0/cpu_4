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

       $readmemb("program.bin", uut.memory); 

        //#270; 
        #305;
        wakeup = 0;

        #20

        wakeup = 0;
       
        #300
        $display("Entering sleep state...");   
        $finish;
    end
endmodule




























