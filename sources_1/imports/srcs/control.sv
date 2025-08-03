//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Given Code - Incomplete ISDU for SLC-3
// Module Name:    Control - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//    Revised 07-25-2023
//    Xilinx Vivado
//	  Revised 12-29-2023
// 	  Spring 2024 Distribution
// 	  Revised 6-22-2024
//	  Summer 2024 Distribution
//	  Revised 9-27-2024
//	  Fall 2024 Distribution
//------------------------------------------------------------------------------

module control (   
    input logic         clk, 
    input logic         reset,
    
    input logic [15:0]  ir,
    input logic         ben,

    input logic         continue_i,
    input logic         run_i,
        
    output logic        ld_mar,
    output logic        ld_mdr,
    output logic        ld_ir,
    output logic        ld_ben,
    output logic        ld_cc,
    output logic        ld_reg,
    output logic        ld_pc,
    output logic        ld_led,
                        
    output logic [1:0]  select_db,       
    output logic [2:0]  sr2reg_select,
                        
    output logic [1:0]  pcmux,
    output logic        drmux,
    output logic        sr1mux,
    output logic        sr2mux,
    output logic        addr1mux,
    output logic [1:0]  addr2mux,
    output logic [1:0]  aluk,
    output logic        mio_en,
        
    output logic        mem_mem_ena, 
    output logic        mem_wr_ena  
);

    logic [3:0] opcode;

    enum logic [4:0] {  
        halted, 
        pause_ir1,
        pause_ir2, 
        s_18, 
        s_33_1, s_33_2, s_33_3,
        s_35, 
        s_32,
        s_00, //BR
        s_01, //ADD
        s_04, //JSR
        s_05, //AND
        s_06, //LDR
        s_07, //STR
        s_09, //NOT
        s_12, //JMP
        s_16_1, s_16_2, s_16_3,
        s_21,
        s_22, 
        s_23,
        s_25_1, s_25_2, s_25_3,
        s_27
    } state, state_nxt;   // Internal state logic

    always_ff @ (posedge clk)
    begin
        if (reset) 
            state <= halted;
        else 
            state <= state_nxt;
    end

    assign opcode = ir[15:12]; 
   
    always_comb
    begin 
        // Default control signal values
        ld_mar = 1'b0;
        ld_mdr = 1'b0;
        ld_ir = 1'b0;
        ld_ben = 1'b0;
        ld_cc = 1'b0;
        ld_reg = 1'b0;
        ld_pc = 1'b0;
        ld_led = 1'b0;
         
        select_db = 2'b00;
        sr2reg_select = 2'b00;
        aluk = 2'b00;
         
        pcmux = 2'b00;
        drmux = 1'b0;
        sr1mux = 1'b0;
        sr2mux = 1'b0;
        addr1mux = 1'b0;
        addr2mux = 2'b00;
        mio_en = 1'b0;
         
        mem_mem_ena = 1'b0;
        mem_wr_ena = 1'b0;

        // Assign relevant control signals based on current state
        case (state)
            halted: ; 
            s_18 : 
                begin 
                    //gate_pc = 1'b1;
                    select_db = 2'b01;
                    ld_mar = 1'b1;
                    pcmux = 2'b00;
                    ld_pc = 1'b1;
                end
            s_33_1, s_33_2 : 
                begin
                    mem_mem_ena = 1'b1;
                    mio_en = 1'b1;
                    //ld_mdr = 1'b1;
                end
            s_33_3 :
                begin
                mem_mem_ena = 1'b1;
                mio_en = 1'b1;
                ld_mdr = 1'b1;
                end
            s_35 : 
                begin 
                    //gate_mdr = 1'b1;
                    select_db = 2'b11;
                    ld_ir = 1'b1;
                end
            pause_ir1, pause_ir2: 
                ld_led = 1'b1; 
            s_32 : 
                ld_ben = 1'b1;
            s_01 : 
                begin 
                    sr2mux = ir[5];
                    sr2reg_select = ir[2:0];
                    aluk = 2'b00;
                    //gate_alu = 1'b1;
                    select_db = 2'b10;
                    ld_reg = 1'b1;
                    ld_cc = 1'b1;
                    sr1mux = 1'b1; //?
                    drmux = 1'b0;
                end
            s_05:
                begin
                    sr2mux = ir[5];
                    sr2reg_select = ir[2:0];
                    aluk = 2'b01;
                    //gate_alu = 1'b1;
                    select_db = 2'b10;
                    ld_reg = 1'b1;
                    ld_cc = 1'b1;
                    sr1mux = 1'b1;
                    drmux = 1'b0;
                end
            s_09:
                begin
                    aluk = 2'b10;
                    //gate_alu = 1'b1;
                    select_db = 2'b10;
                    drmux = 1'b0;
                    ld_reg = 1'b1;
                    ld_cc = 1'b1;
                    sr1mux = 1'b1;
                end
            s_00: ; // BR
            s_22:
                begin
                    addr1mux = 1'b0;
                    addr2mux = 2'b00;
                    ld_pc = 1'b1;
                    pcmux = 2'b10;
                end
            s_12 : // JMP
                begin
                    sr1mux = 1'b1;
                    aluk = 2'b11;
                    pcmux = 2'b10; 
                    //????
                    ld_pc = 1'b1;
                    //gate_alu = 1'b1;
                    select_db = 2'b10;
                    addr1mux = 1'b1;
                    addr2mux = 2'b10;
                end
            s_04 : // JSR
                begin
                    //gate_pc = 1'b1;
                    select_db = 2'b01;
                    drmux = 1'b1;
                    ld_reg = 1'b1;
                end
            s_21 :
                begin
                    addr1mux = 1'b0;
                    addr2mux = 2'b11;
                    pcmux = 2'b10;
                    ld_pc = 1'b1;
                end
            s_06 :  // LDR
                begin
                    sr1mux = 1'b1;
                    addr1mux = 1'b1;
                    addr2mux = 2'b01;
                    //gate_marmux = 1'b1;
                    select_db = 2'b00;
                    ld_mar = 1'b1;
                end
            s_25_1, s_25_2 : 
                begin
                    mem_mem_ena = 1'b1;
                    mio_en = 1'b1;
                    
                end
            s_25_3 :
                begin
                mem_mem_ena = 1'b1;
                mio_en = 1'b1;
                ld_mdr = 1'b1;
                end
            s_27 :
                begin
                    //gate_mdr = 1'b1;
                    select_db = 2'b11;
                    ld_reg = 1'b1;
                    drmux = 1'b0;
                    ld_cc = 1'b1;
                    sr1mux = 1'b1;
                end
            s_07 : // STR
                begin
                    sr1mux = 1'b1;
                    addr1mux = 1'b1;
                    addr2mux = 2'b01;
                    //gate_marmux = 1'b1;
                    select_db = 2'b00;
                    ld_mar = 1'b1;
                end
            s_23 : 
                begin
                    ld_mdr = 1'b1;
                    mio_en = 1'b0;
                    //gate_alu = 1'b1;
                    select_db = 2'b10;
                    aluk = 2'b11;
                    sr1mux = 1'b0;
                end 
            s_16_1, s_16_2, s_16_3 : 
                begin
                    mem_mem_ena = 1'b1;
                    mem_wr_ena = 1'b1;
                    //gate_mdr = 1'b1;
                    select_db = 2'b11;
                end
            default : ;
        endcase
    end 

    always_comb
    begin
        // Default next state is staying at current state
        state_nxt = state;

        unique case (state)
            halted : 
                if (run_i) 
                    state_nxt = s_18;
            s_18 : 
                state_nxt = s_33_1;
            s_33_1 :                 
                state_nxt = s_33_2;   
            s_33_2 :
                state_nxt = s_33_3;
            s_33_3 : 
                state_nxt = s_35;
            s_35 : 
                state_nxt = s_32;
            pause_ir1 : 
                if (continue_i) 
                    state_nxt = pause_ir2;
            pause_ir2 : 
                if (~continue_i)    
                    state_nxt = s_18;
            s_32 : 
                case(opcode)
                    4'b0001 : state_nxt = s_01; // ADD
                    4'b0101 : state_nxt = s_05; // AND
                    4'b1001 : state_nxt = s_09; // NOT
                    4'b0000 : state_nxt = s_00; // BR
                    4'b1100 : state_nxt = s_12; // JMP
                    4'b0100 : state_nxt = s_04; // JSR
                    4'b0110 : state_nxt = s_06; // LDR
                    4'b0111 : state_nxt = s_07; // STR
                    4'b1101 : state_nxt = pause_ir1; // PSE
                    default : state_nxt = s_18;
                endcase
            s_01, s_05, s_09 : 
                state_nxt = s_18;
            s_00 : // BR
                begin
                if (ben == 1'b0)
                state_nxt = s_18;
                else 
                state_nxt =  s_22;
                end
            s_22, s_12 : 
                state_nxt = s_18;
            s_04 : // JSR
                state_nxt = s_21;
            s_21 :
                state_nxt = s_18;
            s_06 : // LDR
                state_nxt = s_25_1;
            s_25_1 :
                state_nxt = s_25_2;
            s_25_2 :
                state_nxt = s_25_3;
            s_25_3 :
                state_nxt = s_27;        
            s_27 :
                state_nxt = s_18;
            s_07 : // STR
                state_nxt = s_23;
            s_23 :
                state_nxt = s_16_1;
            s_16_1 :
                state_nxt = s_16_2;
            s_16_2 :
                state_nxt = s_16_3;
            s_16_3 :
                state_nxt = s_18;
            default :;
        endcase
    end
    
endmodule