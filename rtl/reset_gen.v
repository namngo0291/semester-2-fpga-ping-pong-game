`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2026 05:23:53 PM
// Design Name: 
// Module Name: reset_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reset_gen (
    input  wire clk,
    input  wire resetn,
    input  wire locked,
    output wire rst_n
);

    reg [1:0] sync;

    wire rst_n_raw = resetn & locked;

    always @(posedge clk or negedge rst_n_raw) begin
        if (!rst_n_raw)
            sync <= 2'b00;
        else
            sync <= {sync[0], 1'b1};
    end

    assign rst_n = sync[1];

endmodule