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

module xadc_data_demux 
    (
     input             clk,
     input             reset,

     input [15:0]      xadc_data,
     input             xadc_data_ready,
     input [4:0]       channel,
     output reg [15:0] xadc_vaux0_data,
     output reg        xadc_vaux0_ready,
     output reg [15:0] xadc_vaux8_data,
     output reg        xadc_vaux8_ready
     );

    // Assignments for the XADC 0 data
    always @(posedge clk) begin
        if (reset) begin
            xadc_vaux0_data  <= 16'd0;
            xadc_vaux0_ready <= 1'b0;
        end
        else
            if (xadc_data_ready && (channel == 5'h10)) begin
                xadc_vaux0_data  <= xadc_data;
                xadc_vaux0_ready <= 1'b1;
            end 
            else
                xadc_vaux0_ready <= 1'b0;
    end

    always @(posedge clk) begin
        if (reset) begin
            xadc_vaux8_data  <= 16'd0;
            xadc_vaux8_ready <= 1'b0;
        end
        else
            if (xadc_data_ready && (channel == 5'h18)) begin
                xadc_vaux8_data  <= xadc_data;
                xadc_vaux8_ready <= 1'b1;
            end
            else
                xadc_vaux8_ready <= 1'b0;
    end
    
endmodule

                
            

    
    
    
