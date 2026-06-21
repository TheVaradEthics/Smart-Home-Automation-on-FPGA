// src/debounce.v
module debounce #(
    parameter integer CNT=5 // CNT * 100ms if used with 10Hz tick
) (
    input  wire clk, rst_n, tick,
    input  wire async_in,
    output reg  level,
    output reg  rise_pulse
);
    reg s1, s2; 
    always @(posedge clk) {s1,s2} <= {async_in,s1}; // 2FF sync

    reg [$clog2(CNT+1)-1:0] db; 
    reg stable;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin 
            db <= 0; stable <= 0; level <= 0; rise_pulse <= 0; 
        end else begin
            rise_pulse <= 0;
            if(tick) begin
                if(s2 != stable) begin 
                    db <= db + 1; 
                    if(db == CNT) begin 
                        stable <= s2; db <= 0; 
                    end 
                end else begin
                    db <= 0;
                end
                
                if(stable && !level) begin 
                    level <= 1; rise_pulse <= 1; 
                end else if(!stable) begin
                    level <= 0;
                end
            end
        end
    end
endmodule