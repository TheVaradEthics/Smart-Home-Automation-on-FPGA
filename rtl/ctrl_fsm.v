// src/ctrl_fsm.v
module ctrl_fsm(
    input  wire clk, rst_n, tick_10,
    input  wire pir, dark, overcur,
    input  wire manual_evt,
    input  wire [7:0] cmd_duty_L0, cmd_duty_L1, cmd_duty_L2, cmd_duty_L3,
    input  wire       cmd_set_scene,
    input  wire [2:0] cmd_scene_idx,
    input  wire [7:0] S_L0, S_L1, S_L2, S_L3, S_F0, S_F1,
    input  wire [3:0] S_R,
    output reg  [7:0] dutyL0, dutyL1, dutyL2, dutyL3,
    output reg  [7:0] dutyF0, dutyF1,
    output reg  [3:0] relays,
    output reg  alarm_active
);
    localparam S_MANUAL = 2'b00, S_SCHED = 2'b01, S_AUTO = 2'b10, S_ALARM = 2'b11;
    reg [1:0] state, next_state;

    // FSM State Transition
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) state <= S_AUTO;
        else state <= next_state;
    end

    // FSM Next State & Priority Logic
    always @(*) begin
        next_state = state;
        if(overcur) next_state = S_ALARM;
        else if(manual_evt) next_state = S_MANUAL;
        else if(pir && dark) next_state = S_AUTO;
        else if(cmd_set_scene) next_state = S_SCHED;
    end

    // FSM Output Logic
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            dutyL0<=0; dutyL1<=0; dutyL2<=0; dutyL3<=0;
            dutyF0<=0; dutyF1<=0; relays<=0; alarm_active<=0;
        end else begin
            case(state)
                S_ALARM: begin
                    dutyL0<=255; dutyL1<=255; dutyL2<=255; dutyL3<=255; // Lights ON for safety
                    dutyF0<=0; dutyF1<=0; relays<=4'b0000; // Relays OFF
                    alarm_active<=1;
                end
                S_MANUAL: begin
                    alarm_active<=0;
                    dutyL0 <= cmd_duty_L0; dutyL1 <= cmd_duty_L1; 
                    dutyL2 <= cmd_duty_L2; dutyL3 <= cmd_duty_L3;
                end
                S_AUTO: begin
                    alarm_active<=0;
                    if(pir && dark) begin
                        dutyL0<=200; dutyL1<=200; relays<=4'b0001; // Auto Lights
                    end else begin
                        dutyL0<=0; dutyL1<=0; relays<=4'b0000; // Energy Saving
                    end
                end
                S_SCHED: begin
                    alarm_active<=0;
                    dutyL0<=S_L0; dutyL1<=S_L1; dutyL2<=S_L2; dutyL3<=S_L3;
                    dutyF0<=S_F0; dutyF1<=S_F1; relays<=S_R;
                end
            endcase
        end
    end
endmodule