/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Robert Armstrong
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

`timescale 1ns/1ps

module axi_servo_pwm #
   (
    parameter integer C_CLK_FREQ_HZ     = 100000000,
    parameter integer C_PERIOD_US       = 20000,
    parameter integer C_DUTY_MIN_US     = 500,
    parameter integer C_DUTY_MAX_US     = 1800
)  (
    input wire         resetn,
    input wire         clk,

    // Servo controls
    input signed [7:0] position,
    input signed [7:0] trim,
    input wire         enable,
    output reg         servo_ctl
);

    localparam integer COUNT_BITS       = $clog2((C_CLK_FREQ_HZ / 1000000) * C_PERIOD_US - 1);
    localparam integer DUTY_MIN_COUNT   = (C_CLK_FREQ_HZ / 1000000) * C_DUTY_MIN_US - 1;
    localparam integer DUTY_MAX_COUNT   = (C_CLK_FREQ_HZ / 1000000) * C_DUTY_MAX_US - 1;
    localparam integer PERIOD_COUNT     = (C_CLK_FREQ_HZ / 1000000) * C_PERIOD_US - 1;
    localparam integer STEP_SIZE        = ((C_CLK_FREQ_HZ / 1000000) * (C_DUTY_MAX_US - C_DUTY_MIN_US) / 256);
    localparam integer CENTER_COUNT     = DUTY_MIN_COUNT + ((C_CLK_FREQ_HZ / 1000000) * (C_DUTY_MAX_US - C_DUTY_MIN_US)) / 2;

    // Local registers
    reg signed [COUNT_BITS-1:0] position_reg;
    reg signed [COUNT_BITS-1:0] trim_reg;
    reg signed [COUNT_BITS-1:0] target_position;
    reg signed [COUNT_BITS:0] pwm_counter;

    // Free running PWM counter. The counter will reset to zero if the servo is disabled.
    always @(posedge clk) begin
        if (resetn == 1'b0)
            pwm_counter <= 0;
        else begin
            if ((enable == 1'b0) || (pwm_counter == PERIOD_COUNT))
                pwm_counter <= 0;
            else
                pwm_counter <= pwm_counter + 1;
        end
    end

    always @(posedge clk) begin
        if (pwm_counter == PERIOD_COUNT) begin
            position_reg    <= position * STEP_SIZE;
            trim_reg        <= trim * STEP_SIZE;
            target_position <= CENTER_COUNT + position_reg + trim_reg;
        end
    end

    // Due to the arithmetic involved, we'll incur one clock of delay and register this
    always @(posedge clk) begin
        if (resetn == 1'b0)
            servo_ctl <= 1'b0;
        else
            if (((pwm_counter <= DUTY_MIN_COUNT) || (pwm_counter <= target_position)) &&
                (pwm_counter <= DUTY_MAX_COUNT) && (enable == 1'b1))
                servo_ctl  <= 1'b1;
            else
                servo_ctl <= 1'b0;
    end

endmodule
