// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Common Library: Clock Gating cell
//
// The logic assumes that en_i is synchronized (so the instantiation site might need to put a
// synchronizer before en_i).

module prim_generic_clock_gating #(
  parameter bit NoFpgaGate = 1'b0, // this parameter has no function in generic
  parameter bit FpgaBufGlobal = 1'b1 // this parameter has no function in generic
) (
  input        clk_i,
  input        en_i,
  input        test_en_i,
  output logic clk_o
);

  // PCOV/MLIR does not support always_latch; approximate the transparent latch
  // with a negedge-sampled enable. Behavior is slightly different (enable
  // sampled on falling edge), but good enough for simulation/synthesis in this
  // flow.
  logic en_latch /* verilator clock_enable */;
  always_ff @(negedge clk_i) begin
    en_latch <= en_i | test_en_i;
  end
  assign clk_o = en_latch & clk_i;

endmodule
