


// TWO DIFFERENT METHOD 
// BOTH WORKS 


/*
/////////////////////////////////////////////////////////////
///////////////////// bit synchronizer //////////////////////
/////////////////////////////////////////////////////////////

module BIT_SYNC # ( 
   parameter NUM_STAGES =3 ,
	 parameter BUS_WIDTH 
)(
input    wire                      CLK,
input    wire                      RST,
input    wire    [BUS_WIDTH-1:0]   ASYNC,
output   reg     [BUS_WIDTH-1:0]   SYNC
);


reg   [NUM_STAGES-1:0] sync_reg [BUS_WIDTH-1:0] ;

integer  I ;
					 
//----------------- Multi flop synchronizer --------------

always @(posedge CLK or negedge RST)
 begin
  if(!RST)      // active low
   begin
     for (I=0; I<BUS_WIDTH; I=I+1)
      sync_reg[I] <= 'b0 ;
   end
  else
   begin
    for (I=0; I<BUS_WIDTH; I=I+1)
     sync_reg[I] <= {sync_reg[I][NUM_STAGES-2:0],ASYNC[I]};   // {SYNC,sync_reg} <= {sync_reg[NUM_STAGES-1:0],ASYNC};
   end  
 end


always @(*)
 begin
  for (I=0; I<BUS_WIDTH; I=I+1)
    SYNC[I] = sync_reg[I][NUM_STAGES-1] ; 
 end  

endmodule
*/
module BIT_SYNC  #(parameter BUS_WIDTH,NUM_STAGES)
	(
		input wire  [BUS_WIDTH-1:0] ASYNC,
		input wire CLK,RST,
		output reg   [BUS_WIDTH-1:0] SYNC
	);
    integer i ;
	reg  [NUM_STAGES-1:0] Multi_FlipFlop [BUS_WIDTH-1:0] ;
	//assign SYNC = Multi_FlipFlop[NUM_STAGES-1] ;
	
	always@(posedge CLK or negedge RST)
	 begin
		if(!RST)
		 begin
			Multi_FlipFlop <= 'b0;
			SYNC <= 'b0;
		 end
		else
		 begin
			Multi_FlipFlop [0] <= ASYNC;
			for( i = 0 ; i <(NUM_STAGES-1) ; i = i+1 )
				Multi_FlipFlop [i+1] <= Multi_FlipFlop[i];
				
			//SYNC <= Multi_FlipFlop[NUM_STAGES-1];
		 end
	 end
	 always @(*)
	  begin
		SYNC <= Multi_FlipFlop[NUM_STAGES-1];
	  end  
	 
	 
	 
endmodule
