
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////

module adder(
    input [7:0] A_in,
    input [7:0] B_in,
    input Sel_in,
    output [8:0] Rez_out
    );

    reg [7:0] B_comp;
    reg [7:0] A_comp;
    reg [8:0] Rez_temp;

    always @(B_in) begin
        
        if(B_in[7] == 1)
            B_comp = {1'b1, (~(B_in[6:0]) + 1)};
        else
            B_comp = B_in;
    end

    always @(A_comp, B_comp, Sel_in) begin

        if(Sel_in == 0)
            Rez_temp = {1'b0, A_comp} + {1'b0, B_comp};
        else
            Rez_temp = {1'b0, A_comp} - {1'b0, B_comp};
    end

    always @(A_in) begin

       A_comp = A_in;

    end
    
    assign Rez_out = Rez_temp;



endmodule
