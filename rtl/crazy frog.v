`timescale 1ns / 1ps

module buzzer_game_over (
    input  wire clk,       
    input  wire rst_n,      
    input  wire enable,
    output reg  buzzer
);

    localparam CLK_FREQ = 75_000_000;
    localparam MS_COUNT = 75_000;

    localparam REST = 0;

    // Các nốt nhạc dải trầm (Octave 3) cho giai điệu "Sad Trombone"
    localparam DS3 = 311; // D#3
    localparam D3  = 294; // D3
    localparam CS3 = 277; // C#3
    localparam C3  = 261; // C3 (Ngân dài và tắt)

    reg [$clog2(MS_COUNT)-1:0] ms_cnt;
    reg ms_tick;

    // Tạo xung tick 1 mili-giây
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ms_cnt  <= 0;
            ms_tick <= 0;
        end else begin
            if (ms_cnt >= MS_COUNT - 1) begin
                ms_cnt  <= 0;
                ms_tick <= 1;
            end else begin
                ms_cnt  <= ms_cnt + 1;
                ms_tick <= 0;
            end
        end
    end

    reg [3:0]  note_idx;
    reg [15:0] note_freq;
    reg [15:0] note_duration;
    reg [15:0] note_time_ms;

    // Bảng Tra Cứu (ROM) cho giai điệu Cụt Hứng
    always @(*) begin
        case (note_idx)
            0:  begin note_freq=DS3;   note_duration=350;  end
            1:  begin note_freq=REST;  note_duration=50;   end // Ngắt âm ngắn để tách nốt
            2:  begin note_freq=D3;    note_duration=350;  end
            3:  begin note_freq=REST;  note_duration=50;   end
            4:  begin note_freq=CS3;   note_duration=350;  end
            5:  begin note_freq=REST;  note_duration=50;   end
            6:  begin note_freq=C3;    note_duration=1200; end // Rớt đài: Ngân cực dài
            7:  begin note_freq=REST;  note_duration=100;  end // Kết thúc, giữ im lặng
            default: begin note_freq = REST; note_duration = 100; end
        endcase
    end

    // FSM Điều hướng bài hát (Phát 1 lần duy nhất)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            note_idx     <= 0;
            note_time_ms <= 0;
        end else if (!enable) begin
            note_idx     <= 0;  // Tự động Reset bài nhạc khi game đang chơi
            note_time_ms <= 0;
        end else if (ms_tick) begin
            if (note_time_ms >= note_duration) begin
                note_time_ms <= 0;
                // Chạy tới nốt cuối cùng (REST) thì kẹt lại luôn tại đó, không lặp lại vòng lặp
                if (note_idx < 4'd7)
                    note_idx <= note_idx + 1;
            end else begin
                note_time_ms <= note_time_ms + 1;
            end
        end
    end

    reg [31:0] half_period;
    reg [31:0] tone_cnt;

    // Tính toán chu kỳ băm xung
    always @(*) begin
        if (note_freq == 0)
            half_period = 0;
        else
            half_period = CLK_FREQ / (note_freq * 2);
    end

    // Mạch tạo PWM cho Buzzer
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buzzer   <= 0;
            tone_cnt <= 0;
        end else if (!enable || note_freq == 0) begin
            buzzer   <= 0;
            tone_cnt <= 0;
        end else begin
            if (tone_cnt >= half_period) begin
                tone_cnt <= 0;
                buzzer   <= ~buzzer;
            end else begin
                tone_cnt <= tone_cnt + 1;
            end
        end
    end

endmodule