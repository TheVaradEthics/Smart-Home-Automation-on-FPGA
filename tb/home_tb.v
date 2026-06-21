// tb/home_tb.v
`timescale 1ns/1ps

module home_tb;
    reg clk=0, rst_btn=1;
    reg pir=0, dark=0, oc=0, b0=0, b1=0, b2=0, b3=0;
    
    wire L0, L1, L2, L3, F0, F1; 
    wire R0, R1, R2, R3, AL;

    top DUT(
        .clk_50m(clk), .rst_btn(rst_btn),
        .pir_raw(pir), .ldr_dark_raw(dark), .overcur_raw(oc),
        .btn0_raw(b0), .btn1_raw(b1), .btn2_raw(b2), .btn3_raw(b3),
        .L0_PWM(L0), .L1_PWM(L1), .L2_PWM(L2), .L3_PWM(L3),
        .F0_PWM(F0), .F1_PWM(F1), .R0(R0), .R1(R1), .R2(R2), .R3(R3),
        .ALARM_LED(AL)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("home.vcd"); 
        $dumpvars(0, home_tb);
        
        #100 rst_btn = 0; // Release Reset

        // 1. Manual override test
        #10000 b0 = 1; #10000 b0 = 0;

        // 2. Sensor automation test
        #50000 dark = 1; pir = 1; 
        #50000 pir = 0; // Trigger energy saving

        // 3. Security/Alarm test
        #50000 oc = 1; // Overcurrent alarm
        #50000 oc = 0;

        #200000 $finish;
    end
endmodule