class cou_gen;
  cou_trans gen_trans;			//gen_trans handle of class type cou_trans
  cou_trans data2send;			//data2send handle of class type cou_trans

  mailbox #(cou_trans) gen2wr;	//mailboxes for Generator to Write BFM
 
 //Constructor 
  function new(mailbox #(cou_trans) gen2wr);
    this.gen_trans=new;
    this.gen2wr=gen2wr;
  endfunction: new

  // Virtual task start
  virtual task start();
    fork
      begin
        for(int i=0; i<number_of_transactions;i++)
          begin			
            assert(gen_trans.randomize());
              data2send=new gen_trans;
                gen2wr.put(data2send);
          end
      end
    join_none
  endtask: start
  
endclass: cou_gen