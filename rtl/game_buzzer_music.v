`timescale 1ns / 1ps

module game_buzzer_music #(
    // Đặt mặc định 75MHz để đồng bộ với clock của hệ thống PYNQ-Z2
    parameter CLK_FREQ = 75_000_000 
)(
    input  wire clk,
    input  wire rst_n,       // Đã chuyển sang Active-LOW
    input  wire en_live,     // game sống -> Without Me
    input  wire en_dead,     // game chết -> Crazy Frog
    input  wire hit_wall,    // cờ chạm tường (pulse 1 xung nhịp)
    input  wire hit_paddle,  // cờ chạm ván (pulse 1 xung nhịp)
    output wire buzzer
);

    // =========================================================
    // KHỞI TẠO CÁC MODULE NHẠC NỀN
    // =========================================================
    wire buzzer_live;
    wire buzzer_dead;

    // Chết ưu tiên cao hơn sống
    wire play_dead = en_dead;
    wire play_live = en_live & ~en_dead;

    // Cập nhật port .rst_n(rst_n) cho khớp với module con
    buzzer_without_me u_without_me (
        .clk(clk),
        .rst_n(rst_n),
        .enable(play_live),
        .buzzer(buzzer_live)
    );

    buzzer_game_over u_game_over (
        .clk(clk),
        .rst_n(rst_n),
        .enable(play_dead),
        .buzzer(buzzer_dead)
    );

    // =========================================================
    // LOGIC TẠO SOUND EFFECT (SFX) CHO HIT_WALL & HIT_PADDLE
    // =========================================================
    // Kéo dài âm thanh khoảng ~66ms để tai người nghe rõ
    localparam SFX_DURATION = CLK_FREQ / 15; 
    
    // Tần số âm thanh (Hz)
    localparam FREQ_PADDLE = 1000; // Tiếng "Bíp" thanh, cao khi đập trúng ván
    localparam FREQ_WALL   = 400;  // Tiếng "Bục" trầm, thấp khi đập vào tường
    
    localparam HALF_PERIOD_PADDLE = CLK_FREQ / (FREQ_PADDLE * 2);
    localparam HALF_PERIOD_WALL   = CLK_FREQ / (FREQ_WALL * 2);

    reg [31:0] timer_paddle, timer_wall;
    reg [31:0] tone_cnt_paddle, tone_cnt_wall;
    reg sfx_paddle_active, sfx_wall_active;
    reg buzzer_paddle, buzzer_wall;

    // Cập nhật Trigger Reset Âm
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            timer_paddle <= 0; 
            timer_wall <= 0;
            tone_cnt_paddle <= 0; 
            tone_cnt_wall <= 0;
            sfx_paddle_active <= 0; 
            sfx_wall_active <= 0;
            buzzer_paddle <= 0; 
            buzzer_wall <= 0;
        end else begin
            // --- Xử lý SFX cho Paddle ---
            if (hit_paddle) begin
                timer_paddle <= SFX_DURATION;
                sfx_paddle_active <= 1;
                tone_cnt_paddle <= 0;
            end else if (timer_paddle > 0) begin
                timer_paddle <= timer_paddle - 1;
                
                // Tạo xung vuông tần số 1000Hz
                if (tone_cnt_paddle >= HALF_PERIOD_PADDLE) begin
                    tone_cnt_paddle <= 0;
                    buzzer_paddle <= ~buzzer_paddle;
                end else begin
                    tone_cnt_paddle <= tone_cnt_paddle + 1;
                end
            end else begin
                sfx_paddle_active <= 0;
                buzzer_paddle <= 0;
            end

            // --- Xử lý SFX cho Wall ---
            if (hit_wall) begin
                timer_wall <= SFX_DURATION;
                sfx_wall_active <= 1;
                tone_cnt_wall <= 0;
            end else if (timer_wall > 0) begin
                timer_wall <= timer_wall - 1;
                
                // Tạo xung vuông tần số 400Hz
                if (tone_cnt_wall >= HALF_PERIOD_WALL) begin
                    tone_cnt_wall <= 0;
                    buzzer_wall <= ~buzzer_wall;
                end else begin
                    tone_cnt_wall <= tone_cnt_wall + 1;
                end
            end else begin
                sfx_wall_active <= 0;
                buzzer_wall <= 0;
            end
        end
    end

    // =========================================================
    // AUDIO MULTIPLEXER (Bộ dồn kênh Audio)
    // =========================================================
    assign buzzer = play_dead         ? buzzer_dead :   
                    sfx_paddle_active ? buzzer_paddle : 
                    sfx_wall_active   ? buzzer_wall :   
                    play_live         ? buzzer_live :   
                    1'b0;

endmodule