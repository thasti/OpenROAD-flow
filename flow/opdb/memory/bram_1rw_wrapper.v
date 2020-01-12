module bram_1rw_wrapper
#(parameter NAME="", DEPTH=1, ADDR_WIDTH=1, BITMASK_WIDTH=1, DATA_WIDTH=1)
(
    input                         MEMCLK,
    input wire RESET_N,
    input                         CE,
    input   [ADDR_WIDTH-1:0]      A,
    input                         RDWEN,
    input   [BITMASK_WIDTH-1:0]   BW,
    input   [DATA_WIDTH-1:0]      DIN,
    output  [DATA_WIDTH-1:0]      DOUT
);
wire                            write_en;

assign write_en   = CE & (RDWEN == 1'b0);

generate
  if (DEPTH == 128 && DATA_WIDTH == 78)
    fakeram65_128x78 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 128 && DATA_WIDTH == 132)
    fakeram65_128x132 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 128 && DATA_WIDTH == 66)
    fakeram65_128x66 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 128 && DATA_WIDTH == 132)
    fakeram65_128x132 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 256 && DATA_WIDTH == 104)
    fakeram65_256x104 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 256 && DATA_WIDTH == 132)
    fakeram65_256x132 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 256 && DATA_WIDTH == 272)
    fakeram65_256x272 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 256 && DATA_WIDTH == 132)
    fakeram65_256x132 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 512 && DATA_WIDTH == 32)
    fakeram65_512x32 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 512 && DATA_WIDTH == 100)
    fakeram65_512x100 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 512 && DATA_WIDTH == 128)
    fakeram65_512x128 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 512 && DATA_WIDTH == 132)
    fakeram65_512x132 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 512 && DATA_WIDTH == 272)
    fakeram65_512x272 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 512 && DATA_WIDTH == 66)
    fakeram65_512x66 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 1024 && DATA_WIDTH == 32)
    fakeram65_1024x32 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 1024 && DATA_WIDTH == 64)
    fakeram65_1024x64 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 1024 && DATA_WIDTH == 128)
    fakeram65_1024x128 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 1024 && DATA_WIDTH == 272)
    fakeram65_1024x272 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 2048 && DATA_WIDTH == 32)
    fakeram65_2048x32 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 2048 && DATA_WIDTH == 64)
    fakeram65_2048x64 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 2048 && DATA_WIDTH == 128)
    fakeram65_2048x128 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 4096 && DATA_WIDTH == 144)
    fakeram65_4096x144 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
  else if (DEPTH == 8192 && DATA_WIDTH == 144)
    fakeram65_8192x144 mem (.clk(MEMCLK), .rd_out(DOUT), .ce_in(CE), .we_in(write_en), .w_mask_in(BW), .addr_in(A), .wd_in(DIN));
endgenerate


endmodule