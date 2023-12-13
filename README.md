# MIPS Hardware-Scheduled Pipeline Processor

> [!NOTE]
> To read in-depth about this processor's design and implementation, [check out my portfolio](http://localhost:4000/posts/MIPSProcessorTechnical/#51-design).

## About
5 stage pipelined processor featuring hazard prevention techniques with details present in my [technical description](http://localhost:4000/posts/MIPSProcessorTechnical/#51-design). The design, components, and tests were all made from scratch, and this implementation aimed to optimize performance through pipeline strategies and hazard mitigation compared to my [single-cycle processor design](https://github.com/jamesminardi/mips-single-cycle-processor).

## Project Structure
* `mips`: MIPS assembly program tests
* `src`: Source code of the pipelined processor
* `test`: Test benches for individual VHDL components


### Software Branch
The `software` branch features a software-scheduled design that does not include any hazard mitigation techniques. Thus any data or control hazards must be resolved using software no ops. This design was implemented first before the hardware-scheduled design.


## Pipeline Stages
1. Instruction Fetch (IF)
2. Instruction Decode (ID)
3. Execute (EX)
4. Memory (MEM)
5. Write Back (WB)

## Features
* **Hazard Detection**
  * Component that identifies hazards and inserts stalls where necessary
* **Data Forwarding**
  * Component that resolves hazards by forwarding data through the pipeline
