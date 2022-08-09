class cou_write_mon;
  virtual cou_if.WR_MON wrmon_if;		//write monitor modport virtual interface Instantiation

  cou_trans data2rm;					//data2rm handle of class type cou_trans

  mailbox #(cou_trans) mon2rm;			//mailbox for write monitor to ref model
  
 //Constructor
  function new(virtual cou_if.WR_MON wrmon_if,
        mailbox #(cou_trans) mon2rm);
    this.wrmon_if=wrmon_if;
    this.mon2rm=mon2rm;
    this.data2rm=new;
  endfunction: new


  task monitor();
    @(wrmon_if.wr_mon_cb)
    if (!wrmon_if.rst) begin
      data2rm.load= wrmon_if.wr_mon_cb.load;
      data2rm.rst =  wrmon_if.wr_mon_cb.rst;
      data2rm.data= wrmon_if.wr_mon_cb.data_in;
      data2rm.display("DATA FROM WRITE MONITOR");
      mon2rm.put(data2rm);
    end
  endtask
  
  task start();
    fork
      forever
        begin
          monitor();           
        end
    join_none
  endtask: start

endclass:cou_write_mon
