`timescale 1ns / 1ps

module video_timing #(
    parameter H_ACTIVE = 1280,
    parameter H_FP     = 110,
    parameter H_SYNC   = 40,
    parameter H_BP     = 220,

    parameter V_ACTIVE = 720,
    parameter V_FP     = 5,
    parameter V_SYNC   = 5,
    parameter V_BP     = 20
)(
    input  wire clk,
    input  wire rst_n,

    output reg [11:0] h_cnt = 0,
    output reg [11:0] v_cnt = 0,

    output wire hsync,
    output wire vsync,
    output wire vde
);

    localparam H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;
    localparam V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;

    // Horizontal counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            h_cnt <= 0;
        else if (h_cnt == H_TOTAL - 1)
            h_cnt <= 0;
        else
            h_cnt <= h_cnt + 1;
    end

    // Vertical counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            v_cnt <= 0;
        else if (h_cnt == H_TOTAL - 1) begin
            if (v_cnt == V_TOTAL - 1)
                v_cnt <= 0;
            else
                v_cnt <= v_cnt + 1;
        end
    end

    // HDMI chuẩn
    assign hsync = ~((h_cnt >= H_ACTIVE + H_FP) &&
                   (h_cnt <  H_ACTIVE + H_FP + H_SYNC));

    assign vsync = ~((v_cnt >= V_ACTIVE + V_FP) &&
                   (v_cnt <  V_ACTIVE + V_FP + V_SYNC));

    assign vde = (h_cnt < H_ACTIVE) && (v_cnt < V_ACTIVE);

endmodule