class cou_write_bfm;
  virtual cou_if.WR_BFM wr_if;			//write bfm modport virtual interface Instantiation

  cou_trans data2duv;					//data2duv handle of class type cou_trans

  mailbox #(cou_trans) gen2wr;  		//mailbox for generator to write driver
 
 //Constructor
  function new(virtual cou_if.WR_BFM wr_if,
        mailbox #(cou_trans) gen2wr);
    this.wr_if=wr_if;
    this.gen2wr=gen2wr;
  endfunction: new

  virtual task drive();
    @(wr_if.wr_drv_cb);
      wr_if.wr_drv_cb.data_in<=data2duv.data;
      wr_if.wr_drv_cb.rst<=data2duv.rst;
      wr_if.wr_drv_cb.load<=data2duv.load;    
  endtask : drive
  
  virtual task start();
    fork
      forever
        begin
          gen2wr.get(data2duv);
          drive();
        end
    join_none
  endtask: start

endclass: cou_write_bfm
