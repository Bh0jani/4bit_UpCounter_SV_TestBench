// Include class test.sv
`include "test.sv"
module top();
  parameter cycle = 10;			
  reg clock;
  cou_if DUV_IF(clock);        	//Interface Instantiation

  test test_h;					//test_h handle of class test

  UpCounter_4bit COU (.clk      (clock),
                      .data_in  (DUV_IF.data_in),
                      .data_out  (DUV_IF.data_out),
                      .rst         (DUV_IF.rst),
                      .load        (DUV_IF.load)
                      ); 

  initial
    begin
      test_h = new(DUV_IF, DUV_IF, DUV_IF);
      test_h.build_and_run();
    end

  //Clock Generation
  initial
    begin
      clock=1'b0;
      forever #(cycle/2) clock=~clock;
    end
endmodule
