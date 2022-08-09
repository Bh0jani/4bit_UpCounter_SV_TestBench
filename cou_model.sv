// Refrence Model class
class cou_model;
  cou_trans mon_data1;			//mon_data1 handle of class type cou_trans
  cou_trans mon_data2;			//mon_data2 handle of class type cou_trans

  logic [3:0] ref_data;			

  mailbox #(cou_trans) wr2rm;	//mailboxes for Write Moniotr to Refrence Model
  mailbox #(cou_trans) rd2rm;	//mailbox for Read Monitor to Refrence model
  mailbox #(cou_trans) rm2sb;	//mailbox for Refrence model to Scoreboard

    cou_trans rm_data;			//handle for 'rm_data' for cou_trans

  //Constructor
  function new(mailbox #(cou_trans) wr2rm,
               mailbox #(cou_trans) rd2rm,
               mailbox #(cou_trans) rm2sb);
    this.wr2rm=wr2rm;
    this.rd2rm=rd2rm;
    this.rm2sb=rm2sb;
  endfunction: new
  
  //Task counter function
  task cou_fun(cou_trans mon_data1);
    begin
      if(mon_data1.rst)
        ref_data<=0;
      else if(mon_data1.load)
        ref_data<=mon_data1.data;
      else if(ref_data>=16)
        ref_data<=0;
      else
        ref_data <= ref_data+1;
    end
  endtask

  //Task start      
  virtual task start();
    fork
      begin
        fork
          begin
            forever 
              begin
                wr2rm.get(mon_data1);
                cou_fun(mon_data1);                
                mon_data1.data_out = ref_data;
                rm2sb.put(mon_data1);
              end
          end
        join
      end
    join_none
  endtask: start

endclass:cou_model