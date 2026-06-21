// src/top.v
module top(
    input  wire clk_50m, rst_btn,
    input  wire pir_raw, ldr_dark_raw, overcur_raw,
    input  wire btn0_raw, btn1_raw, btn2_raw, btn3_raw,
    output wire L0_PWM, L1_PWM, L2_PWM, L3_PWM,
    output wire F0_PWM, F1_PWM,
    output wire R0, R1, R2, R3,
    output wire ALARM_LED
);
    wire rst_n = ~rst_btn;
    wire tick_1k, tick_10;

// Scaled down frequencies for much faster simulation
clk_en #(.CLK_HZ(50_000), .TICK_HZ(1000)) u_tick1k(.clk(clk_50m), .rst_n(rst_n), .tick(tick_1k));
clk_en #(.CLK_HZ(5_000),  .TICK_HZ(10))   u_tick10(.clk(clk_50m), .rst_n(rst_n), .tick(tick_10));

    wire pir, dark, overcur, b0_pulse;
    debounce #(.CNT(1)) u_pir (.clk(clk_50m), .rst_n(rst_n), .tick(tick_10), .async_in(pir_raw), .level(pir), .rise_pulse());
    debounce #(.CNT(1)) u_dark(.clk(clk_50m), .rst_n(rst_n), .tick(tick_10), .async_in(ldr_dark_raw), .level(dark), .rise_pulse());
    debounce #(.CNT(1)) u_oc  (.clk(clk_50m), .rst_n(rst_n), .tick(tick_10), .async_in(overcur_raw), .level(overcur), .rise_pulse());
    debounce #(.CNT(2)) u_b0  (.clk(clk_50m), .rst_n(rst_n), .tick(tick_10), .async_in(btn0_raw), .level(), .rise_pulse(b0_pulse));

    wire manual_evt = b0_pulse;
    
    wire [7:0] S_L0, S_L1, S_L2, S_L3, S_F0, S_F1; wire [3:0] S_R;
    scenes U_SCN(.clk(clk_50m), .idx(3'd1), .L0(S_L0), .L1(S_L1), .L2(S_L2), .L3(S_L3), .F0(S_F0), .F1(S_F1), .R(S_R));

    wire [7:0] dutyL0, dutyL1, dutyL2, dutyL3, dutyF0, dutyF1; 
    wire [3:0] relays; wire alarm_active;

    ctrl_fsm U_CTRL(
        .clk(clk_50m), .rst_n(rst_n), .tick_10(tick_10),
        .pir(pir), .dark(dark), .overcur(overcur),
        .manual_evt(manual_evt),
        .cmd_duty_L0(8'd128), .cmd_duty_L1(8'd128), .cmd_duty_L2(8'd0), .cmd_duty_L3(8'd0),
        .cmd_set_scene(1'b0), .cmd_scene_idx(3'd0),
        .S_L0(S_L0), .S_L1(S_L1), .S_L2(S_L2), .S_L3(S_L3), .S_F0(S_F0), .S_F1(S_F1), .S_R(S_R),
        .dutyL0(dutyL0), .dutyL1(dutyL1), .dutyL2(dutyL2), .dutyL3(dutyL3),
        .dutyF0(dutyF0), .dutyF1(dutyF1), .relays(relays), .alarm_active(alarm_active)
    );

    pwm8 P0(.clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .duty(dutyL0), .out(L0_PWM));
    pwm8 P1(.clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .duty(dutyL1), .out(L1_PWM));
    pwm8 P2(.clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .duty(dutyL2), .out(L2_PWM));
    pwm8 P3(.clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .duty(dutyL3), .out(L3_PWM));
    pwm8 F0(.clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .duty(dutyF0), .out(F0_PWM));
    pwm8 F1(.clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .duty(dutyF1), .out(F1_PWM));

    assign {R3, R2, R1, R0} = relays;
    assign ALARM_LED = alarm_active;
endmodule