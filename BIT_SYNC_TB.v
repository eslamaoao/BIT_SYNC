/*`timescale 1ns/1ps

module BIT_SYNC_TB ();




/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter CLK_PERIOD 	= 100 ; 
parameter BUS_WIDTH_TB  = 1 ; 
parameter NUM_STAGES_TB = 3 ;

/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////

reg ASYNC_TB;
reg RST_TB;
reg CLK_TB;
wire SYNC_TB ; 




initial
  begin
  initialize() ;
  reset ();
  #50
  ASYNC_TB  = 1'b1  ;
  #(3*CLK_PERIOD);
  #1;
  if (SYNC_TB == ASYNC_TB) /////////////////// 3 stages means 3 flipflop means latency 3 clock cycles
	$display ("test case succeeded");
 else
	$display ("test case failed");
  
  #1000;
  $stop;
  
  
  
  end


/////////////// Signals Initialization //////////////////

task initialize ;
  begin
	CLK_TB    = 1'b0  ;
	RST_TB    = 1'b1  ;    
	ASYNC_TB  = 1'b0  ;
  end
endtask

///////////////////////// RESET /////////////////////////

task reset ;
 begin
  #(CLK_PERIOD)
  RST_TB  = 'b0;           // rst is activated
  #(CLK_PERIOD)
  RST_TB  = 'b1;
  #(CLK_PERIOD) ;
 end
endtask


///////////////////// Clock Generator //////////////////

always #(CLK_PERIOD/2) CLK_TB = ~CLK_TB ;




// Design Instaniation
BIT_SYNC #(.BUS_WIDTH(BUS_WIDTH_TB), .NUM_STAGES(NUM_STAGES_TB) ) DUT 
(
.ASYNC(ASYNC_TB),
.CLK(CLK_TB),           
.RST(RST_TB),           
.SYNC(SYNC_TB)   
);


endmodule 
*/
module BIT_SYNC_TB ();
 
parameter NUM_STAGES_TB = 3 ;
parameter BUS_WIDTH_TB  = 1 ; 

reg                           CLK_TB     ;
reg                           RST_TB     ;
reg      [BUS_WIDTH_TB-1:0]   ASYNC_TB   ;
wire     [BUS_WIDTH_TB-1:0]   SYNC_TB    ;



////////// Initial Block ////////
initial
begin

CLK_TB = 1'b0 ;
RST_TB = 1'b1 ;
ASYNC_TB = 'b0 ;

#7 
RST_TB = 1'b0 ;    

#8 
RST_TB = 1'b1 ; 

#13    
ASYNC_TB = 'b101;


#100 ;
$stop ;
    
end  

////////// Clock Generation /////////

always #5 CLK_TB = ! CLK_TB ;

///////////// Instantiation ///////////
					 
BIT_SYNC  # ( .NUM_STAGES(NUM_STAGES_TB) , .BUS_WIDTH(BUS_WIDTH_TB) )  DUT
(
.CLK(CLK_TB),
.RST(RST_TB),
.ASYNC(ASYNC_TB),
.SYNC(SYNC_TB)
);

endmodule
