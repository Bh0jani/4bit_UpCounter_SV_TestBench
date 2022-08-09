package cou_pkg;
   int number_of_transactions=1;

  `include "cou_trans.sv"
  `include "cou_gen.sv"
  `include "cou_write_bfm.sv"
  `include "cou_write_mon.sv"
  `include "cou_read_mon.sv"
  `include "cou_model.sv"
  `include "cou_sb.sv"
  `include "cou_env.sv"
endpackage
