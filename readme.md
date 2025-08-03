# 16-Bit Processor in SystemVerilog

This repository contains the SystemVerilog implementation of a 16-bit processor. The design is intended for synthesis on an FPGA and includes a full datapath, a finite-state machine (FSM) control unit, memory, and I/O interfaces.

## 📝 Table of Contents
- [Features](#-features)
- [Hardware-Architecture](#-hardware-architecture)
- [File-Structure](#-file-structure)
- [Instruction-Set-Architecture-ISA](#-instruction-set-architecture-isa)
- [Memory-and-I-O](#-memory-and-i-o)
- [How-to-Use](#-how-to-use)
- [Dependencies](#-dependencies)

## ✨ Features
- **16-bit Datapath**: All registers and data buses are 16 bits wide.
- **Instruction Set**: Implements key instructions including arithmetic, logical, control flow, and memory access operations.
- **FSM Control Unit**: A multi-cycle control unit that decodes instructions and orchestrates the datapath.
- **On-Chip Memory**: Utilizes a Xilinx Block RAM IP core for program and data storage.
- **I/O Interfacing**:
    - **Input**: 16 switches, `run`, `continue`, and `reset` buttons.
    - **Output**: 16 LEDs and two 4-digit 7-segment displays for debugging and data visualization.

## 🛠️ Hardware Architecture
The processor follows a classic Von Neumann architecture, with a centralized CPU that communicates with memory and I/O devices.

### CPU Core (`cpu.sv`)
The CPU is the heart of the system and is composed of two main parts:

1.  **Datapath**: The datapath consists of all the hardware that processes data. This includes:
    * **Register File (`main_reg.sv`)**: Eight 16-bit general-purpose registers (R0-R7).
    * **ALU (`alu.sv`)**: The Arithmetic Logic Unit performs `ADD`, `AND`, and `NOT` operations.
    * **Program Counter (PC)**: A 16-bit register that holds the address of the next instruction to be fetched.
    * **Instruction Register (IR)**: Holds the currently executing instruction.
    * **Memory Address Register (MAR)**: Holds the address for memory read/write operations.
    * **Memory Data Register (MDR)**: Temporarily stores data being read from or written to memory.
    * **Multiplexers**: Used throughout the datapath to select data sources for registers and functional units (e.g., `databus_mux.sv`, `pc_mux.sv`).

2.  **Control Unit (`control.sv`)**: This is a finite-state machine that interprets the opcode from the `IR` and generates all the necessary control signals to operate the datapath. It dictates the sequence of operations for fetching, decoding, and executing instructions over multiple clock cycles.

### Memory System (`memory.sv`)
- The processor uses an on-chip memory, implemented with a Xilinx Block RAM IP core (`blk_mem_gen_0.xci`).
- Upon reset, the memory is initialized with a program defined in the `memContents` function within `types.sv`.
- For simulation, a behavioral model (`test_memory.sv`) is used.

### I/O Bridge (`cpu_to_io.sv`)
This module handles communication between the CPU and the physical I/O on the FPGA. It maps specific memory addresses to I/O devices:
- Reading from `16'hFFFF` accesses the 16 slide switches.
- Writing to `16'hFFFF` updates the main 7-segment hex displays.

## 📁 File Structure
The project files are organized as follows:


.
├── sources/
│   ├── alu.sv
│   ├── control.sv
│   ├── cpu.sv
│   ├── databus_mux.sv
│   ├── main_reg.sv
│   ├── memory.sv
│   ├── processor_top.sv  # Top-level module for synthesis
│   └── ...               # Other source files
├── sim/
│   └── testbench_1.sv    # Primary testbench for simulation
├── constraints/
│   └── top.xdc           # Pin constraints for the FPGA board
└── ip/
└── blk_mem_gen_0.xci # Configuration for the Block RAM IP


## 💻 Instruction Set Architecture (ISA)
The processor implements the following instructions:

| Opcode | Mnemonic | Description                               |
| :----: | :------: | :---------------------------------------- |
| `0001` | `ADD`    | Add two numbers (register or immediate).  |
| `0101` | `AND`    | Bitwise AND two numbers.                  |
| `1001` | `NOT`    | Bitwise NOT a register value.             |
| `0000` | `BR`     | Branch conditionally based on NZP flags.  |
| `1100` | `JMP`    | Jump to an address in a register.         |
| `0100` | `JSR`    | Jump to a subroutine.                     |
| `0110` | `LDR`    | Load data from memory into a register.    |
| `0111` | `STR`    | Store data from a register into memory.   |
| `1101` | `PSE`    | Pause execution (custom instruction).     |


## 🎛️ Memory and I/O
- **Memory**: The main memory space is used for storing instructions and data.
- **I/O Mapping**:
    - **Switches**: Memory Address `0xFFFF` (Read)
    - **HEX Displays**: Memory Address `0xFFFF` (Write)

## 🚀 How to Use

### Simulation
1.  Open the project in Xilinx Vivado.
2.  Set `testbench_1.sv` as the top-level simulation module.
3.  Run the behavioral simulation. The testbench will initialize the processor, load a program, and run it. You can observe the internal signals like `pc`, `ir`, and the register file contents in the waveform viewer.

### Synthesis and Implementation
1.  Set `processor_top.sv` as the top-level synthesis module.
2.  Ensure the `top.xdc` constraints file is included in the project to correctly map the I/O to your FPGA board's pins.
3.  Run the Synthesis, Implementation, and Generate Bitstream steps in Vivado.
4.  Use the Vivado Hardware Manager to program the FPGA with the generated bitstream.

## 📦 Dependencies
- **Xilinx Vivado** (or a compatible Verilog simulator and synthesis tool).
