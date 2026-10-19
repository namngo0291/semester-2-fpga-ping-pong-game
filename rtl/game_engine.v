`timescale 1ns / 1ps

module game_engine #(
    parameter H_ACTIVE = 1280,
    parameter V_ACTIVE = 720
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        left,
    input  wire        right,
    input  wire [11:0] h_cnt,
    input  wire [11:0] v_cnt,
    
    // Tọa độ và dữ liệu xuất ra cho khối Hình Ảnh (Renderer)
    output reg  [11:0] paddle_x,
    output reg  signed [12:0] ball_x,
    output reg  signed [12:0] ball_y,
    output reg  [3:0]  dig3, dig2, dig1, dig0,
    output reg         state,
    
    // Tín hiệu xuất ra cho khối Âm Thanh
    output wire        en_live,
    output wire        en_dead,
    output reg         hit_wall,
    output reg         hit_paddle
);

    localparam [11:0] PADDLE_W = 12'd180;
    localparam [11:0] PADDLE_H = 12'd20;
    localparam [11:0] PADDLE_Y = V_ACTIVE - 12'd40;
    localparam [11:0] PADDLE_STEP = 12'd16; 

    localparam [11:0] BALL_SIZE = 12'd64;           
    localparam signed [12:0] BALL_VX_INIT = 13'sd3;
    localparam signed [12:0] BALL_VY_INIT = -13'sd2;

    localparam STATE_PLAY = 1'b0;
    localparam STATE_OVER = 1'b1;

    assign en_live = (state == STATE_PLAY);
    assign en_dead = (state == STATE_OVER);

    wire frame_start = (h_cnt == 12'd0) && (v_cnt == 12'd0);
    wire [11:0] paddle_x_max = H_ACTIVE - PADDLE_W; 
    wire [11:0] ball_x_max = H_ACTIVE - BALL_SIZE;
    wire [11:0] ball_y_max = V_ACTIVE - BALL_SIZE;

    reg [9:0] frame_cnt;
    reg [3:0] speed_up_cnt;
    reg [5:0] frame_timer; 
    
    reg signed [12:0] ball_vx, ball_vy;
    reg signed [12:0] next_x, next_y, next_vx, next_vy;
    reg paddle_collision;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= STATE_PLAY;
            frame_timer  <= 0; frame_cnt <= 0; speed_up_cnt <= 0;
            hit_wall     <= 0; hit_paddle <= 0;
            dig3 <= 0; dig2 <= 0; dig1 <= 0; dig0 <= 0;
            paddle_x <= (H_ACTIVE - PADDLE_W) >> 1;
            ball_x   <= (H_ACTIVE - BALL_SIZE) >> 1;
            ball_y   <= V_ACTIVE >> 1;
            ball_vx  <= BALL_VX_INIT; ball_vy  <= BALL_VY_INIT;
        end else begin
            hit_wall   <= 1'b0;
            hit_paddle <= 1'b0;

            if (state == STATE_PLAY) begin
                // Di chuyển Paddle
                if (right) begin
                    if (paddle_x + PADDLE_STEP <= paddle_x_max) paddle_x <= paddle_x + PADDLE_STEP;
                    else paddle_x <= paddle_x_max;
                end else if (left) begin
                    if (paddle_x >= PADDLE_STEP) paddle_x <= paddle_x - PADDLE_STEP;
                    else paddle_x <= 12'd0;
                end

                // Cập nhật tọa độ mỗi khung hình
                if (frame_start) begin
                    // Đếm giờ (Tính điểm)
                    if (frame_timer == 6'd59) begin
                        frame_timer <= 0;
                        if (dig0 == 9) begin
                            dig0 <= 0;
                            if (dig1 == 9) begin dig1 <= 0; if (dig2 == 9) begin dig2 <= 0; if (dig3 != 9) dig3 <= dig3 + 1; end else dig2 <= dig2 + 1; end else dig1 <= dig1 + 1;
                        end else dig0 <= dig0 + 1;
                    end else frame_timer <= frame_timer + 1'b1;

                    // Tính toán vật lý bóng
                    next_x = ball_x + ball_vx;
                    next_y = ball_y + ball_vy;
                    next_vx = ball_vx;
                    next_vy = ball_vy;
                    paddle_collision = 1'b0;

                    // Đập tường
                    if (next_x <= 0 || next_x >= $signed({1'b0, ball_x_max})) begin 
                        next_vx = -next_vx; hit_wall <= 1'b1;
                    end
                    if (next_y <= 0) begin 
                        next_vy = -next_vy; hit_wall <= 1'b1; 
                    end

                    // Đập ván
                    if ((next_vy > 0) && (next_y + BALL_SIZE >= PADDLE_Y) &&
                        (next_y + BALL_SIZE <= PADDLE_Y + PADDLE_H) &&
                        (next_x + BALL_SIZE > paddle_x) && (next_x < paddle_x + PADDLE_W)) begin
                        next_y = PADDLE_Y - BALL_SIZE;
                        next_vy = -next_vy;
                        paddle_collision = 1'b1;
                        hit_paddle <= 1'b1;
                    end

                    // Rớt đài (Game Over)
                    if (!paddle_collision && (next_y >= $signed({1'b0, ball_y_max}))) begin
                        state <= STATE_OVER;
                    end else begin
                        // Tăng tốc bóng
                        if (frame_cnt == 10'd300 - 1) begin
                            frame_cnt <= 0;
                            if (speed_up_cnt < 4'd10) begin 
                                speed_up_cnt <= speed_up_cnt + 1'b1;
                                next_vx = (next_vx > 0) ? next_vx + 13'sd1 : next_vx - 13'sd1;
                                next_vy = (next_vy > 0) ? next_vy + 13'sd1 : next_vy - 13'sd1;
                            end
                        end else frame_cnt <= frame_cnt + 1'b1;

                        ball_x <= next_x; ball_y <= next_y;
                        ball_vx <= next_vx; ball_vy <= next_vy;
                    end
                end
            end else begin 
                // Xử lý Reset khi đang Game Over
                if (left || right) begin
                    state <= STATE_PLAY;
                    frame_timer <= 0; frame_cnt <= 0; speed_up_cnt <= 0; 
                    dig3 <= 0; dig2 <= 0; dig1 <= 0; dig0 <= 0; 
                    paddle_x <= (H_ACTIVE - PADDLE_W) >> 1;
                    ball_x   <= (H_ACTIVE - BALL_SIZE) >> 1;
                    ball_y   <= V_ACTIVE >> 1;
                    ball_vx  <= BALL_VX_INIT; ball_vy  <= BALL_VY_INIT;
                end
            end
        end
    end
endmodule