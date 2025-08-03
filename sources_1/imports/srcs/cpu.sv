//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Given Code - SLC-3 core
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//    Xilinx vivado
//    Revised 07-25-2023 
//    Revised 12-29-2023
//    Revised 09-25-2024
//------------------------------------------------------------------------------

module cpu (
    input   logic        clk,
    input   logic        reset,

    input   logic        run_i,
    input   logic        continue_i,
    output  logic [15:0] hex_display_debug,
    output  logic [15:0] led_o,
   
    input   logic [15:0] mem_rdata,
    output  logic [15:0] mem_wdata,
    output  logic [15:0] mem_addr,
    output  logic        mem_mem_ena,
    output  logic        mem_wr_ena
);


// Internal connections, follow the datapath block diagram and add the additional needed signals
logic ld_mar; 
logic ld_mdr; 
logic ld_ir; 
logic ld_pc; 
logic ld_led;
logic ld_reg;
logic [2:0] nzpout;

logic [1:0] pcmux;
logic [15:0] mdr, mar, pc, ir, alu_out, adder_out;
//nzp connections
logic ben, ldcc, ldlogic;

assign mem_addr = mar;
assign mem_wdata = mdr;


//databus_mux connections
logic [15:0] busmux_out;
logic [1:0] select_databus;
//pc connections
logic [15:0] pcmux_out;
//mdr_mux connections
logic mio_enable;
logic [15:0] mdrmux_out;
//adder connections
logic [15:0] sr1_out, sr2_out;
logic [15:0] adder1_out, adder2_out;
//register connections
logic [2:0] sr1mux_out, drmux_out;
//ALU connections
logic [15:0] sr2mux_out;
logic [1:0] ALUK;
logic adder1select;
logic [1:0] adder2select;
logic sr1select, sr2mux_select, drselect;
logic [2:0] sr2reg_select;


// State machine, you need to fill in the code here as well
// .* auto-infers module input/output connections which have the same name
// This can help visually condense modules with large instantiations, 
// but can also lead to confusing code if used too commonly
control cpu_control (
    .clk (clk), 
    .reset (reset),
    .ir (ir),
    .ben (ben),
    .continue_i (continue_i),
    .run_i (run_i),
    .ld_mar (ld_mar),
    .ld_mdr (ld_mdr),
    .ld_ir (ld_ir),
    .ld_pc (ld_pc),
    .ld_led (ld_led),
    .ld_reg (ld_reg),
    .ld_cc (ldcc),
    .ld_ben (ldlogic),
    .sr2reg_select(sr2reg_select),
    .select_db(select_databus),
    .pcmux (pcmux),
    .mem_mem_ena (mem_mem_ena),
    .mem_wr_ena (mem_wr_ena),
    // Additional control signals for ALU, register file, etc.
    .aluk (ALUK),
    .mio_en (mio_enable),
    .addr2mux (adder2select),
    .addr1mux (adder1select),
    .sr1mux (sr1select),    // Select between IR[11:9] and IR[8:6]
    .sr2mux (sr2mux_select),    // Select between SR2 and immediate
    .drmux (drselect)      // Select between IR[11:9] and R7 (for JSR)
);



assign led_o = ir;
assign hex_display_debug = ir;

load_reg #(.DATA_WIDTH(16)) ir_reg (
    .clk    (clk),
    .reset  (reset),
    .load   (ld_ir),
    .data_i (mdr),
    .data_q (ir)
);

load_reg #(.DATA_WIDTH(16)) pc_reg (
    .clk(clk),
    .reset(reset),
    .load(ld_pc),
    .data_i(pcmux_out),
    .data_q(pc)
);

databus_mux databus( 
    .din_MARMUX (adder_out),
    .din_PC (pc),
    .din_ALU (alu_out),
    .din_MDR (mdr),
    .select(select_databus),
    .dout (busmux_out)
    );
    
pc_mux pcmux1 (
    .din_PC ((pc + 16'b1)),
    .din_Bus (busmux_out),
    .din_Adder (adder_out),
    .select(pcmux), //input:pcmux
    .dout (pcmux_out) );
    
load_reg #(.DATA_WIDTH(16)) MAR (
    .clk(clk),
    .reset(reset),
    .load(ld_mar),
    .data_i(busmux_out),
    .data_q(mar)
);

mux_2to1 #(.width(16)) mdr_mux(
    .d0 (busmux_out),
    .d1 (mem_rdata),
    .select (mio_enable), //Input: mio_enable
    .dout (mdrmux_out)

);

load_reg #(.DATA_WIDTH(16)) MDR (
    .clk(clk),
    .reset(reset),
    .load(ld_mdr),
    .data_i(mdrmux_out),
    .data_q(mdr)
);

mux_2to1 #(.width(16)) adder1_mux(
    .d0 (pc),
    .d1 (sr1_out),
    .select (adder1select), //Input: adder1select
    .dout (adder1_out)

);

adder2mux adder2_mux (
    .d1 ({{10{ir[5]}}, ir[5:0]}),
    .d0 ({{7{ir[8]}}, ir[8:0]}),
    .d2 ({{5{ir[10]}}, ir[10:0]}),
    .d3 (16'b0),
    .select (adder2select), //Input: adder2select
    .dout(adder2_out)
);

adder adder (
    .d0 (adder1_out),
    .d1 (adder2_out),
    .dout (adder_out)
);

main_reg REG_FILE(
    .load(ld_reg), 
    .Reset(reset), 
    .Clk(clk), 
    .din(busmux_out), 
    .SR1_select(sr1mux_out), 
    .SR2_select(sr2reg_select), 
    .DR_select(drmux_out), 
    .sr1out(sr1_out), 
    .sr2out(sr2_out)
);

mux_2to1 #(.width(3)) sr1_mux(
    .d0 (ir[11:9]),
    .d1 (ir[8:6]),
    .select (sr1select), //Input: sr1select
    .dout (sr1mux_out)
);

mux_2to1 #(.width(16)) sr2_mux(
    .d1 ({{11{ir[4]}}, ir[4:0]}),
    .d0 (sr2_out),
    .select (sr2mux_select), //Input: sr2select
    .dout (sr2mux_out)
);

mux_2to1 #(.width(3)) dr_mux(
    .d0 (ir[11:9]),
    .d1 (3'b111),
    .select (drselect), //Input: drselect
    .dout (drmux_out)
);


alu main_alu (
    .d1 (sr2mux_out),
    .d0 (sr1_out),
    .select (ALUK),
    .dout (alu_out)
);

LOGIC_NZP logicnzp(
    .Clk(clk),
    .LD_CC(ldcc),
    .LD_LOGIC(ldlogic),
    .data_in (busmux_out),
    .IR_11to9 (ir[11:9]),
    .BEN_out(ben)
);

            


endmodule