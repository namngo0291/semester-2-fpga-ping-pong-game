`timescale 1ns / 1ps

module font_rom (
    input  wire [4:0] digit,    // Đã mở rộng lên 5-bit (0-31) để chứa cả chữ cái
    input  wire [3:0] y_row,    // Tọa độ hàng ngang của Font (0-15)
    output reg  [7:0] font_row  // Dữ liệu 8 pixel của hàng đó
);

    always @(*) begin
        case (digit)
            // SỐ (0 -> 9)
            5'd0: case (y_row) 4'h0:font_row=8'h3C; 4'h1:font_row=8'h66; 4'h2:font_row=8'hC3; 4'h3:font_row=8'hC3; 4'h4:font_row=8'hC3; 4'h5:font_row=8'hC3; 4'h6:font_row=8'hC3; 4'h7:font_row=8'hC3; 4'h8:font_row=8'hC3; 4'h9:font_row=8'hC3; 4'hA:font_row=8'hC3; 4'hB:font_row=8'hC3; 4'hC:font_row=8'hC3; 4'hD:font_row=8'h66; 4'hE:font_row=8'h3C; 4'hF:font_row=8'h00; endcase
            5'd1: case (y_row) 4'h0:font_row=8'h18; 4'h1:font_row=8'h38; 4'h2:font_row=8'h78; 4'h3:font_row=8'h18; 4'h4:font_row=8'h18; 4'h5:font_row=8'h18; 4'h6:font_row=8'h18; 4'h7:font_row=8'h18; 4'h8:font_row=8'h18; 4'h9:font_row=8'h18; 4'hA:font_row=8'h18; 4'hB:font_row=8'h18; 4'hC:font_row=8'h18; 4'hD:font_row=8'h18; 4'hE:font_row=8'h7E; 4'hF:font_row=8'h00; endcase
            5'd2: case (y_row) 4'h0:font_row=8'h3C; 4'h1:font_row=8'h66; 4'h2:font_row=8'hC3; 4'h3:font_row=8'h03; 4'h4:font_row=8'h03; 4'h5:font_row=8'h06; 4'h6:font_row=8'h0C; 4'h7:font_row=8'h18; 4'h8:font_row=8'h30; 4'h9:font_row=8'h60; 4'hA:font_row=8'hC0; 4'hB:font_row=8'hC0; 4'hC:font_row=8'hC0; 4'hD:font_row=8'hC0; 4'hE:font_row=8'hFF; 4'hF:font_row=8'h00; endcase
            5'd3: case (y_row) 4'h0:font_row=8'h3C; 4'h1:font_row=8'h66; 4'h2:font_row=8'hC3; 4'h3:font_row=8'h03; 4'h4:font_row=8'h03; 4'h5:font_row=8'h06; 4'h6:font_row=8'h3C; 4'h7:font_row=8'h06; 4'h8:font_row=8'h03; 4'h9:font_row=8'h03; 4'hA:font_row=8'h03; 4'hB:font_row=8'h03; 4'hC:font_row=8'hC3; 4'hD:font_row=8'h66; 4'hE:font_row=8'h3C; 4'hF:font_row=8'h00; endcase
            5'd4: case (y_row) 4'h0:font_row=8'h0C; 4'h1:font_row=8'h1C; 4'h2:font_row=8'h3C; 4'h3:font_row=8'h6C; 4'h4:font_row=8'hCC; 4'h5:font_row=8'hCC; 4'h6:font_row=8'hCC; 4'h7:font_row=8'hCC; 4'h8:font_row=8'hFF; 4'h9:font_row=8'h0C; 4'hA:font_row=8'h0C; 4'hB:font_row=8'h0C; 4'hC:font_row=8'h0C; 4'hD:font_row=8'h0C; 4'hE:font_row=8'h0C; 4'hF:font_row=8'h00; endcase
            5'd5: case (y_row) 4'h0:font_row=8'hFF; 4'h1:font_row=8'hC0; 4'h2:font_row=8'hC0; 4'h3:font_row=8'hC0; 4'h4:font_row=8'hC0; 4'h5:font_row=8'hFC; 4'h6:font_row=8'h06; 4'h7:font_row=8'h03; 4'h8:font_row=8'h03; 4'h9:font_row=8'h03; 4'hA:font_row=8'h03; 4'hB:font_row=8'h03; 4'hC:font_row=8'hC3; 4'hD:font_row=8'h66; 4'hE:font_row=8'h3C; 4'hF:font_row=8'h00; endcase
            5'd6: case (y_row) 4'h0:font_row=8'h3C; 4'h1:font_row=8'h66; 4'h2:font_row=8'hC0; 4'h3:font_row=8'hC0; 4'h4:font_row=8'hC0; 4'h5:font_row=8'hFC; 4'h6:font_row=8'hC6; 4'h7:font_row=8'hC3; 4'h8:font_row=8'hC3; 4'h9:font_row=8'hC3; 4'hA:font_row=8'hC3; 4'hB:font_row=8'hC3; 4'hC:font_row=8'hC3; 4'hD:font_row=8'h66; 4'hE:font_row=8'h3C; 4'hF:font_row=8'h00; endcase
            5'd7: case (y_row) 4'h0:font_row=8'hFF; 4'h1:font_row=8'h03; 4'h2:font_row=8'h03; 4'h3:font_row=8'h03; 4'h4:font_row=8'h06; 4'h5:font_row=8'h06; 4'h6:font_row=8'h0C; 4'h7:font_row=8'h0C; 4'h8:font_row=8'h18; 4'h9:font_row=8'h18; 4'hA:font_row=8'h30; 4'hB:font_row=8'h30; 4'hC:font_row=8'h60; 4'hD:font_row=8'h60; 4'hE:font_row=8'h60; 4'hF:font_row=8'h00; endcase
            5'd8: case (y_row) 4'h0:font_row=8'h3C; 4'h1:font_row=8'h66; 4'h2:font_row=8'hC3; 4'h3:font_row=8'hC3; 4'h4:font_row=8'hC3; 4'h5:font_row=8'hC3; 4'h6:font_row=8'h66; 4'h7:font_row=8'h3C; 4'h8:font_row=8'h66; 4'h9:font_row=8'hC3; 4'hA:font_row=8'hC3; 4'hB:font_row=8'hC3; 4'hC:font_row=8'hC3; 4'hD:font_row=8'h66; 4'hE:font_row=8'h3C; 4'hF:font_row=8'h00; endcase
            5'd9: case (y_row) 4'h0:font_row=8'h3C; 4'h1:font_row=8'h66; 4'h2:font_row=8'hC3; 4'h3:font_row=8'hC3; 4'h4:font_row=8'hC3; 4'h5:font_row=8'hC3; 4'h6:font_row=8'hC3; 4'h7:font_row=8'h63; 4'h8:font_row=8'h3F; 4'h9:font_row=8'h03; 4'hA:font_row=8'h03; 4'hB:font_row=8'h03; 4'hC:font_row=8'h03; 4'hD:font_row=8'h66; 4'hE:font_row=8'h3C; 4'hF:font_row=8'h00; endcase
            
            // CHỮ CÁI (10 -> 17)
            5'd10: case (y_row) 4'h0:font_row=8'h3C; 4'h1:font_row=8'h66; 4'h2:font_row=8'hC0; 4'h3:font_row=8'hC0; 4'h4:font_row=8'hC0; 4'h5:font_row=8'hCE; 4'h6:font_row=8'hC6; 4'h7:font_row=8'hC6; 4'h8:font_row=8'hC6; 4'h9:font_row=8'hC6; 4'hA:font_row=8'hC6; 4'hB:font_row=8'h66; 4'hC:font_row=8'h3C; 4'hD:font_row=8'h00; 4'hE:font_row=8'h00; 4'hF:font_row=8'h00; endcase // G
            5'd11: case (y_row) 4'h0:font_row=8'h18; 4'h1:font_row=8'h3C; 4'h2:font_row=8'h66; 4'h3:font_row=8'hC3; 4'h4:font_row=8'hC3; 4'h5:font_row=8'hC3; 4'h6:font_row=8'hFF; 4'h7:font_row=8'hC3; 4'h8:font_row=8'hC3; 4'h9:font_row=8'hC3; 4'hA:font_row=8'hC3; 4'hB:font_row=8'hC3; 4'hC:font_row=8'hC3; 4'hD:font_row=8'h00; 4'hE:font_row=8'h00; 4'hF:font_row=8'h00; endcase // A
            5'd12: case (y_row) 4'h0:font_row=8'hC3; 4'h1:font_row=8'hE7; 4'h2:font_row=8'hFF; 4'h3:font_row=8'hDB; 4'h4:font_row=8'hDB; 4'h5:font_row=8'hC3; 4'h6:font_row=8'hC3; 4'h7:font_row=8'hC3; 4'h8:font_row=8'hC3; 4'h9:font_row=8'hC3; 4'hA:font_row=8'hC3; 4'hB:font_row=8'hC3; 4'hC:font_row=8'hC3; 4'hD:font_row=8'h00; 4'hE:font_row=8'h00; 4'hF:font_row=8'h00; endcase // M
            5'd13: case (y_row) 4'h0:font_row=8'hFF; 4'h1:font_row=8'hC0; 4'h2:font_row=8'hC0; 4'h3:font_row=8'hC0; 4'h4:font_row=8'hC0; 4'h5:font_row=8'hFC; 4'h6:font_row=8'hC0; 4'h7:font_row=8'hC0; 4'h8:font_row=8'hC0; 4'h9:font_row=8'hC0; 4'hA:font_row=8'hC0; 4'hB:font_row=8'hC0; 4'hC:font_row=8'hFF; 4'hD:font_row=8'h00; 4'hE:font_row=8'h00; 4'hF:font_row=8'h00; endcase // E
            5'd14: case (y_row) 4'h0:font_row=8'h3C; 4'h1:font_row=8'h66; 4'h2:font_row=8'hC3; 4'h3:font_row=8'hC3; 4'h4:font_row=8'hC3; 4'h5:font_row=8'hC3; 4'h6:font_row=8'hC3; 4'h7:font_row=8'hC3; 4'h8:font_row=8'hC3; 4'h9:font_row=8'hC3; 4'hA:font_row=8'hC3; 4'hB:font_row=8'hC3; 4'hC:font_row=8'h66; 4'hD:font_row=8'h3C; 4'hE:font_row=8'h00; 4'hF:font_row=8'h00; endcase // O
            5'd15: case (y_row) 4'h0:font_row=8'hC3; 4'h1:font_row=8'hC3; 4'h2:font_row=8'hC3; 4'h3:font_row=8'hC3; 4'h4:font_row=8'hC3; 4'h5:font_row=8'hC3; 4'h6:font_row=8'hC3; 4'h7:font_row=8'hC3; 4'h8:font_row=8'h66; 4'h9:font_row=8'h66; 4'hA:font_row=8'h66; 4'hB:font_row=8'h3C; 4'hC:font_row=8'h3C; 4'hD:font_row=8'h18; 4'hE:font_row=8'h00; 4'hF:font_row=8'h00; endcase // V
            5'd16: case (y_row) 4'h0:font_row=8'hFC; 4'h1:font_row=8'h66; 4'h2:font_row=8'h66; 4'h3:font_row=8'h66; 4'h4:font_row=8'h66; 4'h5:font_row=8'hFC; 4'h6:font_row=8'h6C; 4'h7:font_row=8'h66; 4'h8:font_row=8'h66; 4'h9:font_row=8'h63; 4'hA:font_row=8'h63; 4'hB:font_row=8'h63; 4'hC:font_row=8'h61; 4'hD:font_row=8'h61; 4'hE:font_row=8'h00; 4'hF:font_row=8'h00; endcase // R
            5'd17: font_row = 8'h00; // SPACE (Dấu cách)
            
            default: font_row = 8'h00;
        endcase
    end

endmodule