// Interface block
interface cou_if(input bit clock);
  logic [3:0] data_in;
  logic [3:0] data_out;
  logic rst;
  logic load;

  //Write BFM clocking block  
  clocking wr_drv_cb@(posedge clock);
    default input #1 output #1;
    output data_in;
    output load;
    output rst;
  endclocking: wr_drv_cb
 
  //Read minitor clocking block
  clocking rd_mon_cb@(posedge clock);
    default input #1 output #1;
    input data_out;
  endclocking: rd_mon_cb

  //write monitor clocking block
  clocking wr_mon_cb@(posedge clock);
    default input #1 output #1;
    input rst;
    input load;
    input data_in;
  endclocking: wr_mon_cb

  //Write BFM modport
  modport WR_BFM (clocking wr_drv_cb);

  //Write monitor modport
  modport WR_MON (clocking wr_mon_cb);

  //Read Monitor modport
  modport RD_MON (clocking rd_mon_cb);    

endinterface: cou_if

