`timescale 1ns / 1ps

module grupaa_tb;

	// Inputs
	reg iCLK=1'b0;
	reg iRST=1'b1;
	reg iEN;
	reg [2:0] iDEC;

	// Outputs
	wire oGREAT;
	wire [3:0] oCNTP;
	wire [3:0] oCNTN;


	// Instantiate the Unit Under Test (UUT)
	grupaa uut (
		.iCLK(iCLK), 
		.iRST(iRST), 
		.iEN(iEN), 
		.iDEC(iDEC),
		.oCNTP(oCNTP),
		.oCNTN(oCNTN)
	);

	initial begin
		// Initialize Inputs
		iRST = 1;
		iEN = 0;
		iDEC = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		iRST = 0;
		iEN = 1;
		iDEC = 3'b010;
		
		#180;
		
		iDEC = 3'b000;
		
		#180;
		
		iRST = 1;
		
		#100;
		
		iRST = 0;
		
		iDEC = 3'b111;
		
		#100;
		
		iDEC = 3'b001;
		
		#100;
		

	end
	
	always #10 iCLK = ~iCLK;		

      
endmodule

