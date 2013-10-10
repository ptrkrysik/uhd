

module catcap_ddr_cmos
  (input data_clk,
   input reset,
   input mimo,
   input rx_frame,
   input [11:0] rx_d,
   output rx_clk, output rx_strobe,
   output reg [11:0] i0, output reg [11:0] q0,
   output reg [11:0] i1, output reg [11:0] q1);
   
   //IBUFGDS #(.IOSTANDARD("LVDS_33"), .DIFF_TERM("TRUE")) 
   //clkbuf (.O(ssclk), .I(ssclk_p), .IB(ssclk_n));

   wire [11:0] i,q;
   wire frame_0, frame_1;
   
   genvar 	 z;
   
   generate
      for(z = 0; z < 12; z = z + 1)
	begin : gen_pins
	   IDDR2 #(.DDR_ALIGNMENT("C0")) iddr2
	     (.Q0(q[z]), .Q1(i[z]), .C0(data_clk), .C1(~data_clk),
	      .CE(1'b1), .D(rx_d[z]), .R(1'b0), .S(1'b0));
	end
   endgenerate
   IDDR2 #(.DDR_ALIGNMENT("C0")) iddr2_frame
     (.Q0(frame_0), .Q1(frame_1), .C0(data_clk), .C1(~data_clk),
      .CE(1'b1), .D(rx_frame), .R(1'b0), .S(1'b0));

   reg frame_d1, frame_d2;
   always @(posedge data_clk)
     if(reset)
       { frame_d2, frame_d1 } <= 0;
     else if(~mimo)
       { frame_d2, frame_d1 } <= { frame_1, 1'b0 };
     else
       { frame_d2, frame_d1 } <= { frame_d1, frame_1 };
   
   assign rx_strobe = frame_d2;

   reg [11:0] i_del, q_del;
   always @(posedge data_clk)
     if(mimo)
       if(frame_0)
	 begin
	    i_del <= i;
	    q_del <= q;
	 end
       else
	 begin
	    i1 <= i;
	    q1 <= q;
	    i0 <= i_del;
	    q0 <= q_del;
	 end
     else
       begin
	  i0 <= i;
	  q0 <= q;
	  i1 <= i;
	  q1 <= q;
       end
   assign rx_clk = data_clk;
   
endmodule // catcap_ddr_cmos
