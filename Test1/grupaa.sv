
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////

module grupaa(
	input iCLK,
	input iRST,
	input iEN,
	input [2:0] iDEC,
	output oGREAT,
	output [3:0] oCNTP,
	output [3:0] oCNTN
    );
	 
	reg [7:0] sDEC;
	reg [7:0] sREG;
	reg [7:0] sSHIFT;
	reg oGREAT_temp;
	reg sENP;
	reg sENN;
	reg [3:0] oCNTP_temp;
	reg [3:0] oCNTN_temp;
	
// Decoder
	always @(iDEC) begin
	
		if(iDEC == 3'b000) begin
			sDEC = 8'b00000001; 
		end
		else if(iDEC == 3'b001) begin
			sDEC = 8'b00000010; 
		end
		else if(iDEC == 3'b010) begin
			sDEC = 8'b00000100; 
		end
		else if(iDEC == 3'b011) begin
			sDEC = 8'b00001000; 
		end
		else if(iDEC == 3'b100) begin
			sDEC = 8'b00010000; 
		end
		else if(iDEC == 3'b101) begin
			sDEC = 8'b00100000; 
		end
		else if(iDEC == 3'b110) begin
			sDEC = 8'b01000000; 
		end
		else begin
			sDEC = 8'b10000000; 
		end
	
	end
	
// Registar

	always @(posedge iCLK, posedge iRST) begin
	
		if (iRST == 1) begin
			sREG <= 0;
		end
		else begin
			sREG <= sDEC;
		end
		
	end
	
	
// Pomerac

	always @(sREG) begin
		
		sSHIFT = {sREG[7], sREG[7], sREG[7], sREG[6:2]};
	
	end
	
// > 3
	always @(sSHIFT) begin
	
		if (sSHIFT > 3) begin
			oGREAT_temp = 1'b1;
		end
		else begin
			oGREAT_temp = 1'b0;
		end
	end

	
// Parnost

	always @(sREG) begin
	
		if (sREG[0] == 1'b0) begin
			sENP = 1;
			sENN = 0;
		end
		else begin
			sENN = 1;
			sENP = 0;
		end
	end
	
// Brojac parnih

	always @(posedge iCLK, posedge iRST) begin
	
		if(iRST == 1) begin
			oCNTP_temp <= 0;
		end
		else begin
		
			if(sENP == 1) begin
				oCNTP_temp <= oCNTP_temp + 1;
			end
		end
	end
	
// Brojac neparnih

	always @(posedge iCLK, posedge iRST) begin
	
		if(iRST == 1) begin
			oCNTN_temp <= 0;
		end
		else begin
		
			if(sENN == 1) begin
				oCNTN_temp <= oCNTN_temp + 1;
			end
		end
	end
	
	assign oGREAT = oGREAT_temp;
	assign oCNTP = oCNTP_temp;
	assign oCNTN = oCNTN_temp;
	

endmodule
