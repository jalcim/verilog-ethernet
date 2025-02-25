`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * GMII PHY interface
 */
module gmii_phy_if
  (
   input wire	     clk,
   input wire	     rst,

    /*
     * GMII interface to MAC
     */
   output wire	     mac_gmii_rx_clk,
   output wire	     mac_gmii_rx_rst,
   output wire [7:0] mac_gmii_rxd,
   output wire	     mac_gmii_rx_dv,
   output wire	     mac_gmii_rx_er,
   output wire	     mac_gmii_tx_clk,
   output wire	     mac_gmii_tx_rst,
   input wire [7:0]  mac_gmii_txd,
   input wire	     mac_gmii_tx_en,
   input wire	     mac_gmii_tx_er,

    /*
     * GMII interface to PHY
     */
   input wire	     phy_gmii_rx_clk,
   input wire [7:0]  phy_gmii_rxd,
   input wire	     phy_gmii_rx_dv,
   input wire	     phy_gmii_rx_er,
   input wire	     phy_mii_tx_clk,
   output wire	     phy_gmii_tx_clk,
   output wire [7:0] phy_gmii_txd,
   output wire	     phy_gmii_tx_en,
   output wire	     phy_gmii_tx_er,

    /*
     * Control
     */
   input wire	     mii_select
   );

ssio_sdr_in #
(
    .WIDTH(10)
)
rx_ssio_sdr_inst (
    .input_clk(phy_gmii_rx_clk),
    .input_d({phy_gmii_rxd, phy_gmii_rx_dv, phy_gmii_rx_er}),
    .output_clk(mac_gmii_rx_clk),
    .output_q({mac_gmii_rxd, mac_gmii_rx_dv, mac_gmii_rx_er})
);

ssio_sdr_out #
(
    .WIDTH(10)
)
tx_ssio_sdr_inst (
    .clk(mac_gmii_tx_clk),
    .input_d({mac_gmii_txd, mac_gmii_tx_en, mac_gmii_tx_er}),
    .output_clk(phy_gmii_tx_clk),
    .output_q({phy_gmii_txd, phy_gmii_tx_en, phy_gmii_tx_er})
);

   assign mac_gmii_tx_clk = mii_select ? phy_mii_tx_clk : clk;

// reset sync
reg [3:0] tx_rst_reg = 4'hf;
assign mac_gmii_tx_rst = tx_rst_reg[0];

always @(posedge mac_gmii_tx_clk or posedge rst) begin
    if (rst) begin
        tx_rst_reg <= 4'hf;
    end else begin
        tx_rst_reg <= {1'b0, tx_rst_reg[3:1]};
    end
end

reg [3:0] rx_rst_reg = 4'hf;
assign mac_gmii_rx_rst = rx_rst_reg[0];

always @(posedge mac_gmii_rx_clk or posedge rst) begin
    if (rst) begin
        rx_rst_reg <= 4'hf;
    end else begin
        rx_rst_reg <= {1'b0, rx_rst_reg[3:1]};
    end
end

endmodule

`resetall
