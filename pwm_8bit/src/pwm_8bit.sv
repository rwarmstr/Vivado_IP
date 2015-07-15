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

module pwm_8bit #
    (parameter integer C_CLK_FREQ_HZ = 100000000,
     parameter integer C_PWM_PERIOD_US = 200
)   (input             clk,
     input             reset,

     input [7:0]       duty_cycle,
     input             duty_cycle_valid,
     input             enable,
     output reg        pwm
);

    localparam integer COUNT_BITS    = $clog2((C_CLK_FREQ_HZ / 1000000) * C_PWM_PERIOD_US) - 1;
    localparam integer PERIOD_COUNT  = (C_CLK_FREQ_HZ / 1000000) * C_PWM_PERIOD_US - 1;
    localparam integer STEP_SIZE     = ((C_CLK_FREQ_HZ / 1000000) * C_PWM_PERIOD_US) / 256;

    // Local registers
    reg [COUNT_BITS:0] pwm_counter;
    reg [COUNT_BITS:0] duty_cycle_count_reg;
                                     
    // Free running PWM counter. The counter will reset to zero if the output is disabled
    always @(posedge clk) begin
        if (reset)
            pwm_counter <= 0;
        else begin
            if ((enable == 1'b0) || (pwm_counter >= PERIOD_COUNT))
                pwm_counter <= 0;
            else
                pwm_counter <= pwm_counter + 1;
        end
    end

    always @(posedge clk) begin
        if (reset)
            duty_cycle_count_reg <= 8'd0;
        else if (duty_cycle_valid)
            duty_cycle_count_reg <= duty_cycle * STEP_SIZE;
    end
    
    always @(posedge clk) begin
        if (reset)
            pwm <= 1'b0;
        else
            if ((enable == 1'b1) && (pwm_counter <= duty_cycle_count_reg))
                pwm <= 1'b1;
            else
                pwm <= 1'b0;
    end

endmodule

    
