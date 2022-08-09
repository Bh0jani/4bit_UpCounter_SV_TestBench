class cou_env;
  virtual cou_if.WR_BFM wr_if;			// Write BFM modport virtual interface Instantiation
  virtual cou_if.WR_MON wrmon_if;		// Write monitor modport virtual interface Instantiation
  virtual cou_if.RD_MON rdmon_if;		// Read monitor modport virtual interface Instantiation

  mailbox #(cou_trans) gen2wr=new();	//mailbox for Generate to Write bfm
  mailbox #(cou_trans) wr2rm=new();		//mailbox for Write monitor to Refrence model
  mailbox #(cou_trans) rd2rm=new();		//mailbox for Read Monitor to Refrence model
  mailbox #(cou_trans) rd2sb=new();		//mailbox for Read Monitor to Scoreboard
  mailbox #(cou_trans) rm2sb=new();		//mailbox for Refrence model to Scoreboard
	
  cou_gen gen;							//handle for generator
  cou_write_bfm wr_bfm;					//handle for write bfm
  cou_write_mon wr_mon;					//handle for write monitor
  cou_read_mon rd_mon;					//handle for read monitor
  cou_model model;						//handle for refrence model
  cou_sb sb;							//handle for scoreboard

  //Constructor 
  function new(virtual cou_if.WR_BFM wr_if,
    		   virtual cou_if.WR_MON wrmon_if,
			   virtual cou_if.RD_MON rdmon_if);
    this.wr_if = wr_if;
    this.wrmon_if = wrmon_if;
    this.rdmon_if = rdmon_if;
  endfunction : new
	
  //Task build		
  task build;
    gen = new(gen2wr);
    wr_bfm = new(wr_if,gen2wr);
    wr_mon = new(wrmon_if,wr2rm);
    rd_mon = new(rdmon_if,rd2rm,rd2sb);
    model= new(wr2rm, rd2rm,rm2sb);
    sb= new(rm2sb,rd2sb);
  endtask : build

  //Reset DUT
  task reset_dut();
    begin
      @(wr_if.wr_drv_cb);
      wr_if.wr_drv_cb.rst<=1;
      @(wr_if.wr_drv_cb);
      wr_if.wr_drv_cb.rst<=0;
    end
  endtask : reset_dut

  //Task start
  task start;
    gen.start();
    wr_bfm.start();
    wr_mon.start();
    rd_mon.start();
    model.start();
    sb.start();
  endtask : start

  //Task stop
  task stop();
    wait(sb.DONE.triggered);
  endtask : stop 

  //Task run
  task run();
    reset_dut();
    start();
    stop();
    sb.report();
  endtask : run
  
endclass : cou_env