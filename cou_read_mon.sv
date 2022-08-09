class cou_read_mon;
  virtual cou_if.RD_MON rdmon_if;		//Read monitor modport virtual interface Instantiation

  cou_trans data2rm,data2sb;			//data2rm & data2sb handle of class type cou_trans

  mailbox #(cou_trans) mon2rm;			//mailbox for Read monitor to Refrence Model
  mailbox #(cou_trans) mon2sb;			//mailbox for Read monitor to Scoreboard
  
  //Constructor
  function new(virtual cou_if.RD_MON rdmon_if,
               mailbox #(cou_trans) mon2rm,
               mailbox #(cou_trans) mon2sb);
    this.rdmon_if=rdmon_if;
    this.mon2rm=mon2rm;
    this.mon2sb=mon2sb;
    this.data2rm=new;
  endfunction: new

  //Task monitor
  task monitor();
    @(rdmon_if.rd_mon_cb);
    begin
      data2rm.data_out= rdmon_if.rd_mon_cb.data_out;
      data2rm.display("DATA FROM READ MONITOR");
    end
  endtask
  
  //Task start  
  task start();
    fork
      forever
        begin
          monitor(); 
          data2sb= new data2rm;
          mon2rm.put(data2rm);
          mon2sb.put(data2sb);
        end
    join_none
  endtask: start

endclass:cou_read_mon