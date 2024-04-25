# Parallel-Prefix_adders
Some parallel prefix adders in vhdl language (Kogge–Stone adder in vhdl is implemented in kog_stn_adder.vhd, and Sklansky adder in vhdl is implemented by sklansky_adder.vhd .)

This adder implementation works for summands of bit lengths of powers of 2. The "Generic ( N : integer:=8);" should be suitably edited to generate the vhdl code for the desired bit length. For example, if the summands are of bit length 16, this line should read : "Generic ( N : integer:=16);"
There is no carry-in for this adder, and the carry out bit generated is present as the most significant bit in the final result.
