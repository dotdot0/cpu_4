module cpu (
    input wire clk,         // Clock signal
    input wire reset,       // Reset signal
    output wire [3:0] acc   // Output the value of accumulator register
);

    reg [3:0] PC;           // Program Counter
    reg [7:0] IR;           // Instruction Register (8-bit wide)
    reg [3:0] R0, R1;       // General purpose registers
    reg [3:0] ACC;          // Accumulator
    reg [3:0] memory [0:15];// Simple 4-bit memory
    reg [3:0] alu_out;      // Output of ALU
    reg [3:0] opcode, operand;

    // ALU Logic
    always @(*) begin
        case(opcode)
            4'b0010: alu_out = R0 + R1;  // ADD
            4'b0011: alu_out = R0 - R1;  // SUB
            4'b0100: alu_out = R0 & R1;  // AND
            4'b0101: alu_out = R0 | R1;  // OR
            default: alu_out = 4'b0000;  // Default NOP
        endcase
    end

    // Control Unit Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 4'b0000;  // Reset program counter
        end else begin
            IR <= memory[PC];  // Fetch instruction (8 bits)
            opcode <= IR[7:4]; // Decode the upper 4 bits as opcode
            operand <= IR[3:0]; // Decode the lower 4 bits as operand
            
            case(opcode)
                4'b0000: PC <= PC + 1;  // NOP: No operation, just increment PC
                4'b0001: begin          // LOAD constant to ACC
                    ACC <= operand;    // Load operand to ACC
                    PC <= PC + 1;
                end
                4'b0010, 4'b0011, 4'b0100, 4'b0101: begin  // ALU operations
                    R0 <= ACC;        // Store current ACC in R0
                    R1 <= memory[PC + 1];  // Load next memory value to R1
                    ACC <= alu_out;   // Update ACC with ALU output
                    PC <= PC + 2;     // Move PC to next instruction
                end
                4'b0110: begin  // STORE ACC to memory
                    memory[operand] <= ACC;  // Store ACC at memory address (operand)
                    PC <= PC + 1;
                end
                4'b0111: begin  // JMP to address
                    PC <= operand;  // Jump to the address specified by the operand
                end
                default: PC <= PC + 1;  // Unrecognized opcode, skip
            endcase
        end
    end

    assign acc = ACC;  // Output the current value of ACC

endmodule
