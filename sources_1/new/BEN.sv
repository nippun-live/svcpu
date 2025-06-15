module BEN(input logic [2:0] IR_11to9,
            input logic LD_BEN,
            input logic [2:0] NZP,
            input logic Clk,
            output logic BEN_out);
            
            logic b;
            assign b = (IR_11to9[2] & NZP[2]) | (IR_11to9[1] & NZP[1]) | (IR_11to9[0] & NZP[0]) ;
             
              
            
            always_ff @(posedge Clk)
            begin
                  if (LD_BEN == 1) begin
                  BEN_out <= b;
                  end
                  else begin
                  BEN_out <= BEN_out;
                  end
            end
        
endmodule