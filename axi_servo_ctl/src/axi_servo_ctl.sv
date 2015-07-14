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


`timescale 1ns / 1ps

module axi_servo_ctl #
   (
    parameter integer C_AXI_DATA_WIDTH  = 32,
    parameter integer C_CLK_FREQ_HZ     = 100000000,
    parameter integer C_AXI_ADDR_WIDTH  = 32,
    parameter integer C_NUM_SERVOS      = 8,
    parameter integer C_PERIOD_US       = 20000,
    parameter integer C_DUTY_MIN_US     = 500,
    parameter integer C_DUTY_MAX_US     = 1800
)  (
    // Ports for the servo control lines
    output wire [C_NUM_SERVOS-1:0]        servo_ctl,

    // Ports for the AXI slave interface
    input wire                            s_axi_aclk,
    input wire                            s_axi_aresetn,
    input wire [C_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr,
    input wire [2:0]                      s_axi_awprot,
    input wire                            s_axi_awvalid,
    output reg                            s_axi_awready,
    input wire [C_AXI_DATA_WIDTH-1:0]     s_axi_wdata,
    input wire                            s_axi_wvalid,
    output reg                            s_axi_wready,
    output reg [1:0]                      s_axi_bresp,
    output reg                            s_axi_bvalid,
    input wire                            s_axi_bready,
    input wire [C_AXI_ADDR_WIDTH-1:0]     s_axi_araddr,
    input wire [2:0]                      s_axi_arprot,
    input wire                            s_axi_arvalid,
    output reg                            s_axi_arready,
    output reg [C_AXI_DATA_WIDTH-1:0]     s_axi_rdata,
    output reg [1:0]                      s_axi_rresp,
    output reg                            s_axi_rvalid,
    input wire                            s_axi_rready
    );

    localparam integer       ADDR_LSB           = (C_AXI_DATA_WIDTH / 32) + 1;
    localparam integer       OPT_MEM_ADDR_BITS  = $clog2(1 + 2 * C_NUM_SERVOS);

    // Declare all of the local registers
    reg [C_AXI_DATA_WIDTH-1:0]  enable_reg;
    reg [C_AXI_DATA_WIDTH-1:0]  trim_reg [C_NUM_SERVOS-1:0];
    reg [C_AXI_DATA_WIDTH-1:0]  position_reg [C_NUM_SERVOS-1:0];

    reg [OPT_MEM_ADDR_BITS-1:0] reg_waddr;
    reg [OPT_MEM_ADDR_BITS-1:0] reg_raddr;
    wire                        slv_reg_rden;
    wire                        slv_reg_wren;
    reg [C_AXI_DATA_WIDTH-1:0]  reg_data_out;

    // Implement AXI AWREADY
    // axi_awready is asserted for one S_AXI_ACLK cycle when both s_axi_awvalid
    // and s_axi_wvalid are asserted. axi_awready is de-asserted when reset it low.

    always @(posedge s_axi_aclk) begin
        if (s_axi_aresetn == 1'b0)
            s_axi_awready <= 1'b0;
        else begin
            if (~s_axi_awready && s_axi_awvalid && s_axi_wvalid)
                s_axi_awready <= 1'b1;
            else
                s_axi_awready <= 1'b0;
        end
    end

    // Implement axi_awaddr latching
    always @(posedge s_axi_aclk) begin
        if (s_axi_aresetn == 1'b0)
            reg_waddr <= 0;
        else
            if (~s_axi_awready && s_axi_awvalid && s_axi_wvalid)
                reg_waddr <= s_axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];
    end

    // axi_wready is asserted for one s_axi_aclk cycle when both s_axi_awvalid an s_axi_wvalid
    // are asserted.
    always @(posedge s_axi_aclk) begin
        if (s_axi_aresetn == 1'b0)
            s_axi_wready <= 1'b0;
        else
            if (~s_axi_wready && s_axi_wvalid && s_axi_awvalid)
                s_axi_wready <= 1'b1;
            else
                s_axi_wready <= 1'b0;
    end

    assign slv_reg_wren  = s_axi_wready && s_axi_wvalid && s_axi_awready && s_axi_awvalid;

    // Logic to write to the various control registers
    always @(posedge s_axi_aclk) begin
        if (s_axi_aresetn == 1'b0) begin
            enable_reg <= 0;
            for(int i = 0; i < C_NUM_SERVOS; i = i + 1) begin
                    trim_reg[i]     <= 0;
                    position_reg[i] <= 0;
            end
        end
        else begin
            if (slv_reg_wren) begin
                if (reg_waddr == 0)
                    enable_reg <= s_axi_wdata;
                else begin
                    for (int i = 1; i <= C_NUM_SERVOS; i = i + 1) begin
                        if (reg_waddr == 2 * i - 1)
                            trim_reg[i-1]  <= s_axi_wdata;
                        else if (reg_waddr == 2 * i)
                            position_reg[i-1] <= s_axi_wdata;
                    end
                end
            end
        end
    end

    // The write response and response valid signals are asserted by the slave when
    // axi_awready, s_axi_wvalid, axi_wready, and s_axi_wvalid are asserted. This marks
    // the acceptance of address and indicates the status of write transactions.

    always @(posedge s_axi_aclk) begin
        if (s_axi_aresetn == 1'b0) begin
            s_axi_bvalid <= 0;
            s_axi_bresp  <= 2'b0;
        end
        else
            if (s_axi_awready && s_axi_awvalid && ~s_axi_bvalid && s_axi_wready && s_axi_wvalid) begin
                s_axi_bvalid <= 1'b1;
                s_axi_bresp  <= 2'b0;
            end
            else if (s_axi_bready && s_axi_bvalid)
                s_axi_bvalid <= 1'b0;
    end

    // axi_arready is asserted for one s_axi_aclk cycle when s_axi_arvalid is asserted. The read
    // address is also latched when s_axi_arvalid is asserted.
    always @(posedge s_axi_aclk) begin
        if (s_axi_aresetn == 1'b0) begin
            s_axi_arready <= 1'b0;
            reg_raddr     <= 0;
        end
        else
            if (~s_axi_arready && s_axi_arvalid) begin
                s_axi_arready <= 1'b1;
                reg_raddr     <= s_axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];
            end
            else
                s_axi_arready <= 1'b0;
    end

    // Generate axi_rvalid. Assert it for one clock cycle when both s_axi_arvalid and axi_arready
    // are asserted. The slave register data is available on the axi_rdata bus at this time. The
    // assertion of axi_rvalid marks the end of the read transaction, and comes with an 'OKAY' status
    // to indicate a successful read.
    always @(posedge s_axi_aclk) begin
        if (s_axi_aresetn == 1'b0) begin
            s_axi_rvalid <= 1'b0;
            s_axi_rresp  <= 2'b0;
        end
        else
            if (s_axi_arready && s_axi_arvalid && ~s_axi_rvalid) begin
                s_axi_rvalid <= 1'b1;
                s_axi_rresp  <= 2'b0;
            end
            else if (s_axi_rvalid && s_axi_rready)
                s_axi_rvalid <= 1'b0;
    end

    // Memory mapped register select and read logic. Drive zeros when not otherwise reading.
    assign slv_reg_rden  = s_axi_arready & s_axi_arvalid & ~s_axi_rvalid;
    always_comb begin
        reg_data_out  <= 0;
        if (reg_raddr == 0)
            reg_data_out <= enable_reg;

        for(int i = 1; i <= C_NUM_SERVOS; i = i + 1) begin
            if (reg_raddr == 2 * i - 1)
                reg_data_out <= trim_reg[i-1];
            else if (reg_raddr == 2 * i)
                reg_data_out <= position_reg[i-1];
        end
    end

    // Output the read data to the bus
    always @(posedge s_axi_aclk) begin
        if (s_axi_aresetn == 1'b0)
            s_axi_rdata <= 0;
        else
            if (slv_reg_rden)
                s_axi_rdata <= reg_data_out;
    end

    // Add instantiations for each servo PWM controller
    genvar i;
    generate
        for (i = 0; i < C_NUM_SERVOS; i = i + 1) begin
            axi_servo_pwm #
               (
                .C_CLK_FREQ_HZ  ( C_CLK_FREQ_HZ         ),
                .C_PERIOD_US    ( C_PERIOD_US           ),
                .C_DUTY_MAX_US  ( C_DUTY_MAX_US         ),
                .C_DUTY_MIN_US  ( C_DUTY_MIN_US         )
               ) pwm
               (
                .resetn         ( s_axi_aresetn         ),
                .clk            ( s_axi_aclk            ),
                .position       ( position_reg[i][7:0]  ),
                .trim           ( trim_reg[i][7:0]      ),
                .enable         ( enable_reg[i]         ),
                .servo_ctl      ( servo_ctl[i]          )
               );
        end
    endgenerate

endmodule
