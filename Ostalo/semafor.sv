`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
module semafor(
    input clk,
    input reset_n,
    input [1:0] Sel_in,
    output [2:0] RGB_A,
    output [2:0] RGB_B
    );

    typedef enum {YELLOW, RED, GREEN, YELLOWM} tSTATE;

    tSTATE sSTATE_A;
    tSTATE sNEXT_STATE_A; 
    tSTATE sSTATE_B;
    tSTATE sNEXT_STATE_B;

    reg [6:0] sCNT;

    reg [2:0] RGB_A_temp;
    reg [2:0] RGB_B_temp;

    always @(posedge clk, reset_n) begin

        if(reset_n == 1'b0) begin
            sNEXT_STATE_A <= YELLOW;
            sNEXT_STATE_B <= YELLOW;
            RGB_A_temp <= 3'b010;
            RGB_B_temp <= 3'b010; 
            sCNT <= 0;
        end
        else begin
            if(sCNT == 74) begin
                sCNT <= 0;
            end
            else begin
                sCNT <= sCNT + 1;
            end
            
            sSTATE_A <= sNEXT_STATE_A;
            sSTATE_B <= sNEXT_STATE_B;
        end
    end

    always @(sSTATE_A, sSTATE_B, Sel_in, sCNT) begin

        case(sSTATE_A)

            YELLOW: begin
                if((Sel_in == 2'b00 || Sel_in == 2'b01 || Sel_in == 2'b10) && sCNT == 7) begin
                     RGB_A_temp = 3'b010;
                     sNEXT_STATE_A = RED;
                end
            end

            RED: begin
                if((Sel_in == 2'b00 && sCNT == 37) || (Sel_in == 2'b01 && sCNT == 27) || (Sel_in == 2'b10 && sCNT == 47)) begin
                    RGB_A_temp = 3'b100;
                    sNEXT_STATE_A = YELLOWM;
                end
            end

            YELLOWM: begin 
                if((Sel_in == 2'b00 && sCNT == 44) || (Sel_in == 2'b01 && sCNT == 34) || (Sel_in == 2'b10 && sCNT == 54)) begin
                     RGB_A_temp = 3'b010;
                     sNEXT_STATE_A = GREEN;
                end
            end

            GREEN: begin
                if((Sel_in == 2'b00 && sCNT == 74) || (Sel_in == 2'b01 && sCNT == 74) || (Sel_in == 2'b10 && sCNT == 74)) begin
                     RGB_A_temp = 3'b0001;
                     sNEXT_STATE_A = YELLOW;
                end
            end

        endcase

        case(sSTATE_B)

            YELLOW: begin
                if((Sel_in == 2'b00 || Sel_in == 2'b01 || Sel_in == 2'b10) && sCNT == 7) begin
                     RGB_B_temp = 3'b010;
                     sNEXT_STATE_B = GREEN;
                end
            end

            RED: begin
                if((Sel_in == 2'b00 && sCNT == 74) || (Sel_in == 2'b01 && sCNT == 74) || (Sel_in == 2'b10 && sCNT == 74)) begin
                    RGB_B_temp = 3'b100;
                    sNEXT_STATE_B = YELLOW;
                end
            end

            YELLOWM: begin 
                if((Sel_in == 2'b00 && sCNT == 44) || (Sel_in == 2'b01 && sCNT == 34) || (Sel_in == 2'b10 && sCNT == 54)) begin
                     RGB_B_temp = 3'b010;
                     sNEXT_STATE_B = RED;
                end
            end

            GREEN: begin
                if((Sel_in == 2'b00 && sCNT == 37) || (Sel_in == 2'b01 && sCNT == 27) || (Sel_in == 2'b10 && sCNT == 47)) begin
                     RGB_B_temp = 3'b0001;
                     sNEXT_STATE_B = YELLOWM;
                end
            end

        endcase

    end

    assign RGB_A = RGB_A_temp;
    assign RGB_B = RGB_B_temp;

endmodule
