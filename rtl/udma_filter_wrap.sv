 module udma_filter_wrap
    import udma_pkg::udma_evt_t;
    import filter_pkg::filter_to_pad_t;
    import filter_pkg::pad_to_filter_t;
(
    input  logic         sys_clk_i,
	input  logic         rstn_i,

	input  logic  [31:0] cfg_data_i,
	input  logic   [4:0] cfg_addr_i,
	input  logic         cfg_valid_i,
	input  logic         cfg_rwn_i,
	output logic         cfg_ready_o,
    output logic  [31:0] cfg_data_o,

    output udma_evt_t    events_o,
    input  udma_evt_t    events_i,

    // UDMA CHANNEL CONNECTION
    UDMA_EXT_CH.rx_out     rx_ch[0:0],
    UDMA_EXT_CH.tx_in      tx_ch[1:0],
    UDMA_EXT_CH.rx_in      str_rx_ch[0:0]

);

import udma_pkg::TRANS_SIZE;  
import udma_pkg::L2_AWIDTH_NOAL; 

logic eot_event_s;
logic act_event_s;

udma_filter #(
    .DATA_WIDTH    (32),
    .FILTID_WIDTH  (udma_pkg::STREAM_ID_WIDTH),
    .L2_AWIDTH_NOAL(L2_AWIDTH_NOAL),
    .TRANS_SIZE    (TRANS_SIZE)


) i_udma_filter (
    .clk_i                   (sys_clk_i               ),
    .resetn_i                (rstn_i                  ),

    .cfg_data_i              (cfg_data_i              ),
    .cfg_addr_i              (cfg_addr_i              ),
    .cfg_valid_i             (cfg_valid_i             ),
    .cfg_rwn_i               (cfg_rwn_i               ),
    .cfg_data_o              (cfg_data_o              ),
    .cfg_ready_o             (cfg_ready_o             ),

    .eot_event_o             (eot_event_s             ),
    .act_event_o             (act_event_s             ),

    .filter_tx_ch0_req_o     (tx_ch[0].req            ),
    .filter_tx_ch0_addr_o    (tx_ch[0].addr           ),
    .filter_tx_ch0_datasize_o(tx_ch[0].datasize       ),
    .filter_tx_ch0_gnt_i     (tx_ch[0].gnt            ),
    .filter_tx_ch0_valid_i   (tx_ch[0].valid          ),
    .filter_tx_ch0_data_i    (tx_ch[0].data           ),
    .filter_tx_ch0_ready_o   (tx_ch[0].ready          ),

    .filter_tx_ch1_req_o     (tx_ch[1].req            ),
    .filter_tx_ch1_addr_o    (tx_ch[1].addr           ),
    .filter_tx_ch1_datasize_o(tx_ch[1].datasize       ),
    .filter_tx_ch1_gnt_i     (tx_ch[1].gnt            ),
    .filter_tx_ch1_valid_i   (tx_ch[1].valid          ),
    .filter_tx_ch1_data_i    (tx_ch[1].data           ),
    .filter_tx_ch1_ready_o   (tx_ch[1].ready          ),

    .filter_rx_ch_addr_o     (rx_ch[0].addr           ),
    .filter_rx_ch_datasize_o (rx_ch[0].datasize       ),
    .filter_rx_ch_valid_o    (rx_ch[0].valid          ),
    .filter_rx_ch_data_o     (rx_ch[0].data           ),
    .filter_rx_ch_ready_i    (rx_ch[0].ready          ),

    .filter_id_i             (str_rx_ch[0].stream_id  ),
    .filter_data_i           (str_rx_ch[0].data       ),
    .filter_datasize_i       (str_rx_ch[0].datasize   ),
    .filter_valid_i          (str_rx_ch[0].valid      ),
    .filter_sof_i            (str_rx_ch[0].sot        ),
    .filter_eof_i            (str_rx_ch[0].eot        ),
    .filter_ready_o          (str_rx_ch[0].ready      )
);

assign events_o[0] = eot_event_s;
assign events_o[1] = act_event_s;

assign rx_ch[0].stream = '0;
assign rx_ch[0].stream_id = '0;
assign rx_ch[0].destination = '0;

assign tx_ch[0].destination = '0;
assign tx_ch[1].destination = '0;
//assign str_rx_ch[0].destination = '0;

assign rx_ch[0].sot = '0;
assign rx_ch[0].eot = '0;

endmodule : udma_filter_wrap