// src/scenes.v
module scenes(
    input  wire        clk,
    input  wire  [2:0] idx,
    output reg  [7:0]  L0, L1, L2, L3, F0, F1,
    output reg  [3:0]  R
);
    always @(*) begin
        case(idx)
            3'd0: begin L0=8'd0;   L1=8'd0;   L2=8'd0;   L3=8'd0;   F0=0;  F1=0;  R=4'b0000; end // ALL OFF
            3'd1: begin L0=8'd40;  L1=8'd20;  L2=8'd10;  L3=8'd0;   F0=0;  F1=0;  R=4'b0001; end // Evening
            3'd2: begin L0=8'd200; L1=8'd180; L2=8'd0;   L3=8'd0;   F0=80; F1=0;  R=4'b0010; end // Work
            3'd3: begin L0=8'd10;  L1=8'd0;   L2=8'd0;   L3=8'd10;  F0=0;  F1=0;  R=4'b0000; end // Night
            default: begin L0=0; L1=0; L2=0; L3=0; F0=0; F1=0; R=0; end
        endcase
    end
endmodule