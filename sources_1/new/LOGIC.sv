module LOGIC_NZP (
    input  logic        Clk,
    input  logic        LD_CC,
    input  logic        LD_LOGIC,
    input  logic [15:0] data_in,
    input  logic [2:0]  IR_11to9,
    output logic        BEN_out
);

    logic [2:0] NZP;      // 3-bit register for N (bit 2), Z (bit 1), P (bit 0)
    logic [2:0] NZP_next;
    logic BEN_next;

    // Combinational logic for NZP
    always_comb begin
        if (data_in == 16'b0)
            NZP_next = 3'b010;      // Z=1, N=0, P=0
        else if (data_in[15])
            NZP_next = 3'b100;      // N=1, Z=0, P=0
        else
            NZP_next = 3'b001;      // P=1, N=0, Z=0
    end

    // Combinational logic for BEN
    assign BEN_next = (IR_11to9[2] & NZP[2]) |  // N
                      (IR_11to9[1] & NZP[1]) |  // Z
                      (IR_11to9[0] & NZP[0]);   // P

    // Sequential logic for NZP and BEN registers
    always_ff @(posedge Clk) begin
        if (LD_CC)
            NZP <= NZP_next;
            BEN_out <= BEN_next;
        if (LD_LOGIC)
            BEN_out <= BEN_next;
    end

endmodule