Synthesis in 45nm: https://tilos-ai-institute.github.io/MacroPlacement/Enablements/NanGate45/

read_verilog apb_downsizer.sv
synth -top apb_downsizer

dfflibmap -liberty Nangate45_typ.lib
abc -liberty Nangate45_typ.lib
write_verilog synth.v
