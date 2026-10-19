module buzzer_without_me (
    input  wire clk,       
    input  wire rst_n,       
    input  wire enable,
    output reg  buzzer
);

    // =====================================================
    // CLOCK
    // =====================================================
    localparam CLK_FREQ = 75_000_000;
    localparam MS_COUNT = 75_000;

    // =====================================================
    // TEMPO 112 BPM
    // =====================================================
    localparam W = 2144;   // whole
    localparam H = 1072;   // half
    localparam Q = 536;    // quarter
    localparam E = 268;    // eighth

    // =====================================================
    // NOTES
    // =====================================================
    localparam REST = 0;

    // octave 1
    localparam F1  = 349;
    localparam G1  = 392;
    localparam A1  = 440;
    localparam AS1 = 466;

    // octave 2
    localparam C2  = 523;
    localparam D2  = 587;
    localparam F2  = 698;
    localparam G2  = 784;
    localparam A2  = 880;
    localparam AS2 = 932;

    // =====================================================
    // 1ms tick
    // =====================================================
    reg [$clog2(MS_COUNT)-1:0] ms_cnt;
    reg        ms_tick;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            ms_cnt  <= 0;
            ms_tick <= 0;
        end
        else begin

            if (ms_cnt >= MS_COUNT - 1) begin
                ms_cnt  <= 0;
                ms_tick <= 1;
            end
            else begin
                ms_cnt  <= ms_cnt + 1;
                ms_tick <= 0;
            end

        end

    end

    // =====================================================
    // SONG ROM
    // =====================================================
    reg [7:0]  note_idx;

    reg [15:0] note_freq;
    reg [15:0] note_duration;

    always @(*) begin

        case (note_idx)

            0:  begin note_freq=D2;   note_duration=E; end
            1:  begin note_freq=AS2;  note_duration=E; end
            2:  begin note_freq=A2;   note_duration=E; end
            3:  begin note_freq=G2;   note_duration=E; end
            4:  begin note_freq=D2;   note_duration=Q; end
            5:  begin note_freq=REST; note_duration=Q; end
            6:  begin note_freq=D2;   note_duration=E; end
            7:  begin note_freq=C2;   note_duration=E; end
            8:  begin note_freq=D2;   note_duration=E; end
            9:  begin note_freq=F2;   note_duration=E; end
            10: begin note_freq=D2;   note_duration=E; end
            11: begin note_freq=REST; note_duration=E; end
            12: begin note_freq=REST; note_duration=Q; end

            13: begin note_freq=D2;   note_duration=E; end
            14: begin note_freq=C2;   note_duration=E; end
            15: begin note_freq=D2;   note_duration=E; end
            16: begin note_freq=C2;   note_duration=E; end
            17: begin note_freq=AS1;  note_duration=E; end
            18: begin note_freq=REST; note_duration=E; end
            19: begin note_freq=REST; note_duration=Q; end
            20: begin note_freq=AS1;  note_duration=E; end
            21: begin note_freq=A1;   note_duration=E; end
            22: begin note_freq=F1;   note_duration=E; end
            23: begin note_freq=G1;   note_duration=Q; end
            24: begin note_freq=REST; note_duration=Q; end
            25: begin note_freq=REST; note_duration=E; end

            26: begin note_freq=D2;   note_duration=E; end
            27: begin note_freq=AS2;  note_duration=E; end
            28: begin note_freq=A2;   note_duration=E; end
            29: begin note_freq=G2;   note_duration=E; end
            30: begin note_freq=D2;   note_duration=E; end
            31: begin note_freq=REST; note_duration=E; end
            32: begin note_freq=REST; note_duration=Q; end

            33: begin note_freq=D2;   note_duration=E; end
            34: begin note_freq=C2;   note_duration=E; end
            35: begin note_freq=D2;   note_duration=E; end
            36: begin note_freq=F2;   note_duration=E; end
            37: begin note_freq=D2;   note_duration=Q; end
            38: begin note_freq=REST; note_duration=Q; end

            39: begin note_freq=D2;   note_duration=E; end
            40: begin note_freq=C2;   note_duration=E; end
            41: begin note_freq=D2;   note_duration=E; end
            42: begin note_freq=C2;   note_duration=E; end
            43: begin note_freq=AS1;  note_duration=E; end
            44: begin note_freq=REST; note_duration=E; end
            45: begin note_freq=REST; note_duration=Q; end
            46: begin note_freq=AS1;  note_duration=E; end
            47: begin note_freq=A1;   note_duration=E; end
            48: begin note_freq=F1;   note_duration=E; end
            49: begin note_freq=G1;   note_duration=E; end

            // nghỉ cuối bài
            50: begin note_freq=REST; note_duration=700; end

            default: begin
                note_freq     = REST;
                note_duration = Q;
            end

        endcase

    end

    // =====================================================
    // NOTE TIMER
    // =====================================================
    reg [15:0] note_time_ms;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            note_idx     <= 0;
            note_time_ms <= 0;
        end
        else if (!enable) begin
            note_idx     <= 0;
            note_time_ms <= 0;
        end
        else if (ms_tick) begin

            if (note_time_ms >= note_duration) begin

                note_time_ms <= 0;

                if (note_idx >= 50)
                    note_idx <= 0;
                else
                    note_idx <= note_idx + 1;

            end
            else begin
                note_time_ms <= note_time_ms + 1;
            end

        end

    end

    // =====================================================
    // TONE GENERATOR
    // Nokia style:
    // 70% play, 30% silence
    // =====================================================
    reg [31:0] half_period;
    reg [31:0] tone_cnt;

    always @(*) begin

        if (note_freq == 0)
            half_period = 0;
        else
            half_period = CLK_FREQ / (note_freq * 2);

    end

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            buzzer   <= 0;
            tone_cnt <= 0;
        end

        else if (
            !enable ||
            note_freq == 0 ||
            note_time_ms >= (note_duration * 7) / 10
        ) begin

            buzzer   <= 0;
            tone_cnt <= 0;

        end

        else begin

            if (tone_cnt >= half_period) begin
                tone_cnt <= 0;
                buzzer   <= ~buzzer;
            end
            else begin
                tone_cnt <= tone_cnt + 1;
            end

        end

    end

endmodule