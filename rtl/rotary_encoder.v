`timescale 1ns / 1ps

module rotary_encoder #(
    parameter CLK_FREQ = 75_000_000 // Cập nhật mặc định 75MHz cho khớp với Clocking Wizard
)(
    input  wire        clk,   
    input  wire        rst_n, // Chuyển sang Active Low để tiện nối dây trong Block Design
    input  wire        A,
    input  wire        B,
    output reg         left,
    output reg         right
);

    //======================================
    // 1. Tạo clock enable ~1kHz (Lấy mẫu chống dội)
    //======================================
    reg [16:0] div_cnt;
    reg ce_1k;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_cnt <= 0;
            ce_1k   <= 0;
        end else begin
            if (div_cnt == (CLK_FREQ / 1000) - 1) begin  
                div_cnt <= 0;
                ce_1k   <= 1;
            end else begin
                div_cnt <= div_cnt + 1;
                ce_1k   <= 0;
            end
        end
    end

    //======================================
    // 2. Đồng bộ A, B vào miền Clock hệ thống
    //======================================
    reg [1:0] sync_A, sync_B;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_A <= 2'b11;
            sync_B <= 2'b11;
        end else begin
            sync_A <= {sync_A[0], A};
            sync_B <= {sync_B[0], B};
        end
    end

    wire A_sync = sync_A[1];
    wire B_sync = sync_B[1];

    //======================================
    // 3. Sample theo CE và Cập nhật Hướng xoay
    //======================================
    reg [1:0] prev_AB;
    reg [1:0] curr_AB;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_AB <= 2'b11;
            curr_AB <= 2'b11;
            right   <= 1'b0;
            left    <= 1'b0;
        end else begin
            // QUAN TRỌNG: Luôn mặc định dập tắt xung left/right về 0 ở MỌI CHU KỲ CLOCK HỆ THỐNG
            right <= 1'b0;
            left  <= 1'b0;
            
            // Chỉ khi có nhịp lấy mẫu 1ms (ce_1k) thì mới quét xem encoder có xoay không
            if (ce_1k) begin
                curr_AB <= {A_sync, B_sync};

                case ({prev_AB, curr_AB})
                    // ===== THUẬN (Xoay Phải) =====
                    4'b00_10, 4'b10_11, 4'b11_01, 4'b01_00: right <= 1'b1; 
                    
                    // ===== NGHỊCH (Xoay Trái) =====
                    4'b00_01, 4'b01_11, 4'b11_10, 4'b10_00: left <= 1'b1;
                    
                    default: ;
                endcase

                prev_AB <= curr_AB;
            end
        end
    end

endmodule