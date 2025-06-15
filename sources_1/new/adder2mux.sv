`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2024 07:03:46 PM
// Design Name: 
// Module Name: adder2mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adder2mux( 
    input logic [15:0] d0,
    input logic [15:0] d1,
    input logic [15:0] d2,
    input logic [15:0] d3,
    input logic [1:0] select,
    output logic [15:0] dout
    );
always_comb begin
dout = 16'b0000;
 if (select == 2'b00 )
    begin
    dout = d0;
    end
                    
else if (select == 2'b01 )
    begin
    dout = d1;
    end
                    
else if (select == 2'b11 )
    begin
    dout = d2;
    end
else if (select == 2'b10 )
    begin
    dout = d3;
    end
else 
    begin
    dout = 16'b0;
    end
end
endmodule
