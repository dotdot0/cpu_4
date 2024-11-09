module tb_cpu;

    // Testbench signals
    reg clk;
    reg reset;
    wire [3:0] acc;

    // Instantiate the CPU module
    cpu uut (
        .clk(clk),
        .reset(reset),
        .acc(acc)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Apply reset
        #10 reset = 0;

        // Test NOP (No operation)
        $display("Test NOP");
        uut.memory[0] = 4'b0000;  // NOP instruction
        #10;

        // Test LOAD instruction (loading a constant into ACC)
        $display("Test LOAD");
        uut.memory[1] = 4'b0001;  // LOAD opcode
        uut.memory[2] = 4'b0011;  // Operand: constant 3
        #10;
        if (acc != 4'b0011) $display("LOAD failed. Expected ACC = 3, got ACC = %b", acc);

        // Test ADD instruction (ACC = R0 + R1)
        $display("Test ADD");
        uut.memory[3] = 4'b0010;  // ADD opcode
        uut.memory[4] = 4'b0101;  // Operand: address 5, R1 = 5
        uut.memory[5] = 4'b0101;  // Operand: value 5
        #10;
        if (acc != 4'b0110) $display("ADD failed. Expected ACC = 6, got ACC = %b", acc);

        // Test SUB instruction (ACC = R0 - R1)
        $display("Test SUB");
        uut.memory[6] = 4'b0011;  // SUB opcode
        uut.memory[7] = 4'b0110;  // Operand: address 6, R1 = 6
        uut.memory[6] = 4'b0011;  // Operand: value 3
        #10;
        if (acc != 4'b0001) $display("SUB failed. Expected ACC = 1, got ACC = %b", acc);

        // Test AND instruction (ACC = R0 & R1)
        $display("Test AND");
        uut.memory[8] = 4'b0100;  // AND opcode
        uut.memory[9] = 4'b0111;  // Operand: address 7, R1 = 7
        uut.memory[9] = 4'b0011;  // Operand: value 3
        #10;
        if (acc != 4'b0011) $display("AND failed. Expected ACC = 3, got ACC = %b", acc);

        // Test OR instruction (ACC = R0 | R1)
        $display("Test OR");
        uut.memory[10] = 4'b0101;  // OR opcode
        uut.memory[11] = 4'b0010;  // Operand: address 8, R1 = 2
        uut.memory[11] = 4'b1100;  // Operand: value 12
        #10;
        if (acc != 4'b1110) $display("OR failed. Expected ACC = 14, got ACC = %b", acc);

        // Test STORE instruction (store ACC to memory)
        $display("Test STORE");
        uut.memory[12] = 4'b0110;  // STORE opcode
        uut.memory[13] = 4'b0001;  // Operand: memory address 1
        #10;
        if (uut.memory[1] != 4'b1110) $display("STORE failed. Expected memory[1] = 14, got memory[1] = %b", uut.memory[1]);
        $display("PC: %b", uut.PC);
        // Test JMP instruction (jump to address)
        $display("Test JMP");
        uut.PC = 4'b0000;
        $display("PC: %b", uut.PC);
        uut.memory[14] = 4'b0111;  // JMP opcode
        uut.memory[15] = 4'b0010;  // Operand: jump address 2
        #10;
        if (uut.PC != 4'b0010) $display("JMP failed. Expected PC = 2, got PC = %b", uut.PC);

        // End simulation
        $finish;
    end

endmodule
