`timescale 1ns / 1ps

module pixel_renderer #(
    parameter H_ACTIVE = 1280,
    parameter V_ACTIVE = 720
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [11:0] h_cnt,
    input  wire [11:0] v_cnt,
    input  wire        vde,
    
    // Tọa độ đầu vào từ Game Engine
    input  wire [11:0] paddle_x,
    input  wire signed [12:0] ball_x,
    input  wire signed [12:0] ball_y,
    input  wire [3:0]  dig3, dig2, dig1, dig0,
    input  wire        state,

    // Tín hiệu xuất màu ra màn hình HDMI
    output reg  [7:0]  red,
    output reg  [7:0]  green,
    output reg  [7:0]  blue
);

    localparam [11:0] PADDLE_W = 12'd180;
    localparam [11:0] PADDLE_H = 12'd20;
    localparam [11:0] PADDLE_Y = V_ACTIVE - 12'd40;
    
    localparam [11:0] BALL_SIZE = 12'd64;           
    localparam signed [13:0] BALL_RADIUS = 14'sd32;
    localparam [27:0] RADIUS_SQ = 28'd1024;          

    // XỬ LÝ ẢNH 1: VẼ THANH TRƯỢT (HÌNH CHỮ NHẬT)
    wire paddle_on = (h_cnt >= paddle_x) && (h_cnt < paddle_x + PADDLE_W) &&
                     (v_cnt >= PADDLE_Y) && (v_cnt < PADDLE_Y + PADDLE_H);

    // XỬ LÝ ẢNH 2: VẼ BÓNG (HÌNH TRÒN DỰA VÀO PHƯƠNG TRÌNH ĐƯỜNG TRÒN)
    wire in_ball_box = (h_cnt >= ball_x[11:0]) && (h_cnt < ball_x[11:0] + BALL_SIZE) &&
                       (v_cnt >= ball_y[11:0]) && (v_cnt < ball_y[11:0] + BALL_SIZE);

    wire signed [14:0] center_x = ball_x + BALL_RADIUS;
    wire signed [14:0] center_y = ball_y + BALL_RADIUS;
    wire signed [14:0] dx = $signed({1'b0, h_cnt}) - center_x;
    wire signed [14:0] dy = $signed({1'b0, v_cnt}) - center_y;
    wire signed [29:0] dx_sq = dx * dx;
    wire signed [29:0] dy_sq = dy * dy;

    wire ball_on = in_ball_box && ((dx_sq + dy_sq) <= $signed({2'b00, RADIUS_SQ}));

    // XỬ LÝ ẢNH 3: ÁNH XẠ FONT CHỮ VÀO VÙNG PIXEL TƯƠNG ỨNG
    wire [11:0] score_y_start = 12'd50;
    wire in_score_y = (v_cnt >= score_y_start) && (v_cnt < score_y_start + 12'd64);
    wire in_char_3 = in_score_y && (h_cnt >= 12'd1100) && (h_cnt < 12'd1132);
    wire in_char_2 = in_score_y && (h_cnt >= 12'd1140) && (h_cnt < 12'd1172);
    wire in_char_1 = in_score_y && (h_cnt >= 12'd1180) && (h_cnt < 12'd1212);
    wire in_char_0 = in_score_y && (h_cnt >= 12'd1220) && (h_cnt < 12'd1252);
    
    wire in_go_y = (state == 1'b1) && (v_cnt >= 12'd296) && (v_cnt < 12'd424);
    wire in_g  = in_go_y && (h_cnt >= 12'd288) && (h_cnt < 12'd352);
    wire in_a  = in_go_y && (h_cnt >= 12'd368) && (h_cnt < 12'd432);
    wire in_m  = in_go_y && (h_cnt >= 12'd448) && (h_cnt < 12'd512);
    wire in_e1 = in_go_y && (h_cnt >= 12'd528) && (h_cnt < 12'd592);
    wire in_o  = in_go_y && (h_cnt >= 12'd688) && (h_cnt < 12'd752);
    wire in_v  = in_go_y && (h_cnt >= 12'd768) && (h_cnt < 12'd832);
    wire in_e2 = in_go_y && (h_cnt >= 12'd848) && (h_cnt < 12'd912);
    wire in_r  = in_go_y && (h_cnt >= 12'd928) && (h_cnt < 12'd992);

    wire [4:0] current_digit = 
        in_char_3 ? {1'b0, dig3} : in_char_2 ? {1'b0, dig2} :
        in_char_1 ? {1'b0, dig1} : in_char_0 ? {1'b0, dig0} :
        in_g  ? 5'd10 : in_a  ? 5'd11 : in_m  ? 5'd12 : (in_e1 | in_e2) ? 5'd13 :
        in_o  ? 5'd14 : in_v  ? 5'd15 : in_r  ? 5'd16 : 5'd17;

    wire [3:0] font_y = in_score_y ? ((v_cnt - score_y_start) >> 2) : 
                        in_go_y    ? ((v_cnt - 12'd296) >> 3) : 4'd0;
    
    wire [2:0] font_x = 
        in_char_3 ? ((h_cnt - 12'd1100) >> 2) : in_char_2 ? ((h_cnt - 12'd1140) >> 2) :
        in_char_1 ? ((h_cnt - 12'd1180) >> 2) : in_char_0 ? ((h_cnt - 12'd1220) >> 2) :
        in_g  ? ((h_cnt - 12'd288) >> 3) : in_a  ? ((h_cnt - 12'd368) >> 3) :
        in_m  ? ((h_cnt - 12'd448) >> 3) : in_e1 ? ((h_cnt - 12'd528) >> 3) :
        in_o  ? ((h_cnt - 12'd688) >> 3) : in_v  ? ((h_cnt - 12'd768) >> 3) :
        in_e2 ? ((h_cnt - 12'd848) >> 3) : in_r  ? ((h_cnt - 12'd928) >> 3) : 3'd0;

    wire [7:0] font_row_data;
    font_rom font_rom_inst (
        .digit(current_digit),
        .y_row(font_y),
        .font_row(font_row_data)
    );

    wire score_pixel_on = (in_char_3 | in_char_2 | in_char_1 | in_char_0) && font_row_data[7 - font_x];
    wire game_over_pixel_on = (in_g | in_a | in_m | in_e1 | in_o | in_v | in_e2 | in_r) && font_row_data[7 - font_x];

    // XỬ LÝ ẢNH 4: XUẤT MÀU ƯU TIÊN LỚP (LAYERS RENDERING)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) {red, green, blue} <= 0;
        else if (!vde) {red, green, blue} <= 0;
        else begin
            if (state == 1'b1) begin
                // Lớp hiển thị màn hình Game Over
                if (game_over_pixel_on)  {red, green, blue} <= 24'hFFFFFF;
                else if (score_pixel_on) {red, green, blue} <= 24'hFFFF00; 
                else                     {red, green, blue} <= 24'h770000; // Nền đỏ mờ
            end 
            else begin
                // Lớp hiển thị khi đang chơi (Play)
                if (ball_on)             {red, green, blue} <= 24'h00FFFF; // Bóng Cyan
                else if (paddle_on)      {red, green, blue} <= 24'hFFFFFF; // Ván Trắng
                else if (score_pixel_on) {red, green, blue} <= 24'hFFFF00; // Điểm Vàng
                else                     {red, green, blue} <= 24'h000000; // Nền Đen
            end
        end
    end

endmodule