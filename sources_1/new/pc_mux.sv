`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2024 10:53:56 PM
// Design Name: 
// Module Name: pc_mux
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


module pc_mux(
    input logic [15:0] din_PC, din_Bus, din_Adder, 
    input logic [1:0] select,
    output logic [15:0] dout);
always_comb
begin
dout = 16'b0000;
 if (select == 2'b00 )
    begin
    dout = din_PC;
    end
                    
else if (select == 2'b01 )
    begin
    dout = din_Bus;
    end
                    
else if (select == 2'b10 )
    begin
    dout = din_Adder;
    end
else 
    begin
    dout = 16'b0;
    end
end
    
endmodule