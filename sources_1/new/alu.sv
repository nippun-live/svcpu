`timescale 1ns / 1ps

module alu(input logic [15:0] d0,
            input logic [15:0] d1,
            input logic [1:0] select,
            output logic [15:0] dout
);
            
always_comb begin
dout = 16'b0;
    if (select == 2'b00) begin 
        dout = d0 + d1; //ADD
    end
    else if (select == 2'b01) begin 
         dout = d0 & d1; //AND
    end
    else if (select == 2'b10) begin 
         dout = ~d0; //NOT
    end
    else if (select == 2'b11) begin 
         dout = d0;
    end
    else begin
         dout = 16'b0;
    end
end
endmodule