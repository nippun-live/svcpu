module adder(
    input logic [15:0] d0,
    input logic [15:0] d1,
    output logic [15:0] dout
    );
always_comb begin
dout = d0 + d1;
end
endmodule