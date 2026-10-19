`timescale 1ns / 1ps

module tb_ping_pong_game_hd_wrapper;

    // 1. Khai báo các tín hiệu nguồn giả lập đầu vào (Inputs)
    reg A;
    reg B;
    reg clk_40Mhz;
    reg resetn;

    // 2. Khai báo các đường để quan sát tín hiệu đầu ra (Outputs)
    wire TMDS_CLK_N;
    wire TMDS_CLK_P;
    wire [2:0] TMDS_DATA_N;
    wire [2:0] TMDS_DATA_P;
    wire buzzer;
    wire clk_1hz;
    wire locked_led;

    // 3. Gọi file Wrapper tổng của sơ đồ Block Design (DUT) 
    ping_pong_game_hd_wrapper DUT (
        .A           (A),
        .B           (B),
        .TMDS_CLK_N  (TMDS_CLK_N),
        .TMDS_CLK_P  (TMDS_CLK_P),
        .TMDS_DATA_N (TMDS_DATA_N),
        .TMDS_DATA_P (TMDS_DATA_P),
        .buzzer      (buzzer),
        .clk_1hz     (clk_1hz),
        .clk_40Mhz   (clk_40Mhz),
        .locked_led  (locked_led),
        .resetn      (resetn)
    );

    // 4. Tạo xung nhịp hệ thống đầu vào chuẩn 40MHz (Chu kỳ T = 25ns)
    always begin
        #12.5 clk_40Mhz = ~clk_40Mhz;
    end

    // 5. Kịch bản chạy giả lập hành vi mạch game
    initial begin
        // Khởi tạo trạng thái ban đầu cho các chân
        clk_40Mhz = 0;
        resetn    = 0; // Kích hoạt Reset hệ thống (Mức thấp)
        A         = 0;
        B         = 0;

        // Chờ 100ns ổn định nguồn, sau đó nhả Reset (resetn = 1) để mạch bắt đầu xử lý game
        #100;
        resetn = 1;
        
        // Giả lập hành động xoay núm / bấm nút điều khiển thanh vợt
        #5000;
        A = 1; #200; B = 1; #200; A = 0; #200; B = 0; // Xoay xuôi
        
        #10000;
        B = 1; #200; A = 1; #200; B = 0; #200; A = 0; // Xoay ngược

        // Cho hệ thống chạy liên tục thêm 100 micro-giây để sinh toàn bộ khung hình đồ họa và âm thanh
        #100000;
        
        $finish; // Kết thúc mô phỏng
    end

endmodule