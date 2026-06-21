// src/pwm8.v
module pwm8(
    input  wire clk, rst_n, tick_1k, // 1kHz tick -> 8-bit PWM
    input  wire [7:0] duty,          // 0..255
    output reg  out
);
    reg [7:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin 
            cnt <= 0; out <= 1'b0; 
        end else if(tick_1k) begin
            cnt <= cnt + 8'd1;
            out <= (cnt < duty);
        end
    end
endmodule