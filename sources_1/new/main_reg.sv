module main_reg(
    input logic load,
    input logic Reset,
    input logic Clk,
    input logic [15:0] din,
    input logic [2:0]  SR1_select, SR2_select, DR_select,
    output logic [15:0] sr1out, sr2out
);

    // Unpacked array of packed logic for registers
    logic [15:0] registers [8];

    // Read operations - combinational
    always_comb begin
        // Source Register 1 MUX
        sr1out = registers[SR1_select];
        
        // Source Register 2 MUX
        sr2out = registers[SR2_select];
    end

    // Write operation - sequential
    always_ff @(posedge Clk) begin
        if (Reset) begin
            // Reset all registers to 0
            for (int i = 0; i < 8; i++) begin
                registers[i] <= 16'h0000;
            end
        end
        else if (load) begin
            // Write to the destination register
            registers[DR_select] <= din;
        end
    end

    // Simulation-only: initial block to initialize registers
    // synthesis translate_off
    initial begin
        for (int i = 0; i < 8; i++) begin
            registers[i] = 16'h0000;
        end
    end
    // synthesis translate_on

endmodule