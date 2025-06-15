`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2024 12:09:31 AM
// Design Name: 
// Module Name: 2to1_mux
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


module mux_2to1 #(parameter width = 16)
(   input logic [width-1:0] d0, d1,
    input logic select,
    output logic [width-1:0] dout);
always_comb begin
    if(select)
        dout = d1;
    else
        dout = d0;
end
endmodule