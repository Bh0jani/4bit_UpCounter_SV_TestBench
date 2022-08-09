class cou_sb;
  event DONE;
  int data_verified = 0;
  string str;
  
  cou_trans rm_data;				//rm_data handle of class type cou_trans
  cou_trans rcvd_data;				//rcvd_data handle of class type cou_trans
  cou_trans cov_data;				//cov_data handle of class type cou_trans
  
  mailbox #(cou_trans) rm2sb;  		//mailbox for ref model to scoreboard
  mailbox #(cou_trans) rdmon2sb;    //mailbox for read monitor to scoreboard

  //coverage group
  covergroup mem_coverage;
    option.per_instance=1;
    
    DATAIN : coverpoint cov_data.data {
               bins LOW     = {[0:5]};
               bins MID      = {[6:9]};
               bins HIGH    = {[10:15]};
               }
      
    LOAD : coverpoint cov_data.load {
             bins LD  = {1};
             }

    DATAINxLOAD: cross DATAIN,LOAD;  
  endgroup : mem_coverage

   //Constructor
  function new(mailbox #(cou_trans) rm2sb,
               mailbox #(cou_trans) rdmon2sb);
    this.rm2sb = rm2sb;
    this.rdmon2sb = rdmon2sb;
    mem_coverage = new();
  endfunction: new

  //Task start 
  task start();
    fork
      while(1)
        begin
          rm2sb.get(rm_data);
          rdmon2sb.get(rcvd_data);
          check(str);
          $display(str);
          data_verified++;
          if(data_verified==(number_of_transactions+2))
            ->DONE;
        end
    join_none
  endtask: start

  virtual task check(output string st);
    if(rm_data.data_out!=rcvd_data.data_out)
      begin
        st="WRONG OUTPUT";
        $display(st);
        $finish;
      end
    else
      st="SUCESSFULLY COMPARED";
            cov_data=rm_data;
      mem_coverage.sample();
  endtask

  function void report();
    $display("------------------- SCOREBOARD REPORT -----------------\n ");
    $display(" %0d Read Data Verified \n",
                   data_verified);
    $display(" ----------------------------------------------------- \n ");
  endfunction: report

endclass:cou_sb