class cou_trans;
  rand bit[3:0] data;
  rand bit rst;
  rand bit load;
  logic [3:0] data_out;
 
  static int trans_id;
  static int no_of_rst_trans;
  static int no_of_load_trans;
  static int no_of_inc_trans;

  constraint VALID_RST {rst dist{0:=95, 1:=5};}
  constraint VALID_LOAD {load dist{0:=95, 1:=35};}
  constraint VALID_DATA {data inside {[0:15]};}

  //post randomize
  function void post_randomize();
    trans_id++;
    if(this.rst==1)
      no_of_rst_trans++;
    if(this.rst==0 && this.load==1)
      no_of_load_trans++;
    if(this.rst==0 && this.load==0 )
      no_of_inc_trans++;
    this.display("\tRANDOMIZED DATA");

  endfunction:post_randomize

  function void display(input string message);
    $display("================================================");
    $display("%s",message);
    if(message=="\tRANDOMIZED DATA")
      begin
        $display("\t_________________________");
        $display("\tTransaction No. %d",trans_id);
        $display("\trst Transaction No. %d", no_of_rst_trans);
        $display("\tload Transaction No. %d", no_of_load_trans);
        $display("\tinc Transaction No. %d", no_of_inc_trans);
        $display("\t_________________________");
      end
    $display("\trst=%d, load=%d",rst,load);
    $display("\tData_in=%d",data);
    $display("\tData_out= %d",data_out);
    $display("================================================");
  endfunction: display

  function bit compare (input cou_trans rcv,output string message);
    compare='0;
    begin
      if (this.data_out != rcv.data_out)
        begin
          $display($time);
            message="--------- DATA MISMATCH ---------";
            return(0);
        end
    
        begin
          message=" SUCCESSFULLY COMPARED";
          return(1);
        end
    end
  endfunction : compare

endclass:cou_trans
