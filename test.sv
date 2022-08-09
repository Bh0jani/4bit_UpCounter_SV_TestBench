// Import counter pakage
import cou_pkg::*;

class test;
    virtual cou_if.WR_BFM wr_if; 			// Write BFM modport virtual interface Instantiation
    virtual cou_if.RD_MON rdmon_if; 		// Read monitor modport virtual interface Instantiation
    virtual cou_if.WR_MON wrmon_if;			// Write monitor modport virtual interface Instantiation
  
    cou_env env;							//env handle of class cou_env

  function new(virtual cou_if.WR_BFM wr_if, 
               virtual cou_if.WR_MON wrmon_if,
               virtual cou_if.RD_MON rdmon_if);
    this.wr_if = wr_if;
    this.wrmon_if = wrmon_if;
    this.rdmon_if = rdmon_if;
    env = new(wr_if,wrmon_if,rdmon_if);
  endfunction

  task build_and_run();
    begin
      if($test$plusargs("TEST1"))
        begin
          number_of_transactions = 150;
          env.build();
          env.run();
          $finish;
        end
    end
  endtask
endclass : test