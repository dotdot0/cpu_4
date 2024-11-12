module cpu (
    input wire clk,         // Clock signal
    input wire reset,       // Reset signal
    output wire [3:0] acc   // Output the value of accumulator register
);

    reg [3:0] PC;           // Program Counter
    reg [7:0] IR;           // Instruction Register (8-bit wide)
    reg [3:0] R0, R1;       // General purpose registers
    reg [3:0] ACC;          // Accumulator
    reg [3:0] memory [0:15];// Simple 4-bit memory for instructions
    reg [3:0] data_memory [0:15]; // Data memory
    reg [3:0] alu_out;      // Output of ALU
    reg [3:0] opcode, operand;
    reg [1:0] state;        // State variable for FSM

    // States for instruction cycle
    parameter FETCH = 2'b00, DECODE = 2'b01, EXECUTE = 2'b10;

    // ALU Logic
    always @(*) begin
        case(opcode)
            4'b0010: alu_out = R0 + R1;  // ADD
            4'b0011: alu_out = R0 - R1;  // SUB
            4'b0100: alu_out = R0 & R1;  // AND
            4'b0101: alu_out = R0 | R1;  // OR
            4'b0111: alu_out = ~(R0 ^ R1); //XNOR
            default: alu_out = 4'b0000;  // Default NOP
        endcase
    end

    // Control Unit FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 4'b0000;
            ACC <= 4'b0000;
            IR <= 8'b00000000;
            state <= FETCH;
        end else begin
            case (state)
                FETCH: begin
                    
                    IR <= {memory[PC + 1], memory[PC]};  // Fetch instruction
                    PC <= PC + 2;                        // Increment PC by 2
                    state <= DECODE;
                end
                DECODE: begin
                    opcode <= IR[3:0];      // Decode the opcode
                    operand <= IR[7:4];     // Decode the operand
                    state <= EXECUTE;
                end
                EXECUTE: begin
                    case (opcode)
                        4'b0000: state <= FETCH;  // NOP: go back to fetch
                        4'b0001: begin            // LOAD constant to ACC
                            ACC <= operand;
                            state <= FETCH;
                        end
                        4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0111: begin  // ALU operations
                            R0 <= data_memory[0];
                            R1 <= data_memory[1];  // Assume second register holds data for now
                            @(posedge clk) begin ACC <= alu_out;
                            end
                            state <= FETCH;

                        end
                        4'b0110: begin            // STORE ACC to memory
                            data_memory[operand] <= ACC;
                            state <= FETCH;
                        end
                        4'b0111: begin            // JMP to address
                            PC <= operand;
                            state <= FETCH;
                        end
                        default: state <= FETCH;  // Unknown opcode
                    endcase
                end
            endcase
        end
    end

    assign acc = ACC;  // Output the current value of ACC

endmodule
