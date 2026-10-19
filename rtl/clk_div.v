`timescale 1ns / 1ps

module clk_div #(
    parameter CLK_FREQ = 75_000_000,
    parameter OUT_FREQ = 1
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);

    localparam COUNT_MAX = (CLK_FREQ / (2 * OUT_FREQ)) - 1;

    reg [31:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == COUNT_MAX) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule