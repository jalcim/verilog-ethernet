`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * Generic ODDR module
 */
module oddr #
(
    parameter WIDTH = 1
)
(
    input  wire             clk,

    input  wire [WIDTH-1:0] d1,
    input  wire [WIDTH-1:0] d2,

    output wire [WIDTH-1:0] q
);

/*

Provides a consistent output DDR flip flop across multiple FPGA families
              _____       _____       _____       _____
    clk  ____/     \_____/     \_____/     \_____/     \_____
         _ ___________ ___________ ___________ ___________ __
    d1   _X____D0_____X____D2_____X____D4_____X____D6_____X__
         _ ___________ ___________ ___________ ___________ __
    d2   _X____D1_____X____D3_____X____D5_____X____D7_____X__
         _____ _____ _____ _____ _____ _____ _____ _____ ____
    d    _____X_D0__X_D1__X_D2__X_D3__X_D4__X_D5__X_D6__X_D7_

*/

    reg [WIDTH-1:0] d_reg_1 = {WIDTH{1'b0}};
    reg [WIDTH-1:0] d_reg_2 = {WIDTH{1'b0}};

    reg [WIDTH-1:0] q_reg = {WIDTH{1'b0}};

    always @(posedge clk) begin
        d_reg_1 <= d1;
        d_reg_2 <= d2;
    end

    always @(posedge clk) begin
        q_reg <= d1;
    end

    always @(negedge clk) begin
        q_reg <= d_reg_2;
    end

    assign q = q_reg;

endmodule

`resetall
