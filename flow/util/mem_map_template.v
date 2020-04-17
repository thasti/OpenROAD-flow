
module \$mem (RD_CLK, RD_EN, RD_ADDR, RD_DATA, WR_CLK, WR_EN, WR_ADDR, WR_DATA);
  parameter MEMID = "";
  parameter SIZE = 256;
  parameter OFFSET = 0;
  parameter ABITS = 8;
  parameter WIDTH = 8;
  parameter signed INIT = 1'bx;

  parameter RD_PORTS = 1;
  parameter RD_CLK_ENABLE = 1'b1;
  parameter RD_CLK_POLARITY = 1'b1;
  parameter RD_TRANSPARENT = 1'b1;

  parameter WR_PORTS = 1;
  parameter WR_CLK_ENABLE = 1'b1;
  parameter WR_CLK_POLARITY = 1'b1;

  input [RD_PORTS-1:0] RD_CLK;
  input [RD_PORTS-1:0] RD_EN;
  input [RD_PORTS*ABITS-1:0] RD_ADDR;
  output reg [RD_PORTS*WIDTH-1:0] RD_DATA;

  input [WR_PORTS-1:0] WR_CLK;
  input [WR_PORTS*WIDTH-1:0] WR_EN;
  input [WR_PORTS*ABITS-1:0] WR_ADDR;
  input [WR_PORTS*WIDTH-1:0] WR_DATA;

  wire [1023:0] _TECHMAP_DO_ = "proc; clean";

  parameter _TECHMAP_CONNMAP_RD_CLK_ = 0;
  parameter _TECHMAP_CONNMAP_WR_CLK_ = 0;

  parameter _TECHMAP_CONSTVAL_RD_EN_ = 0;

  parameter _TECHMAP_BITS_CONNMAP_ = 0;
  parameter _TECHMAP_CONNMAP_WR_EN_ = 0;

  reg _TECHMAP_FAIL_;
  integer k;
  initial begin
    _TECHMAP_FAIL_ <= 1;
  end



  wire [ABITS-1:0] addr_in;
  wire we_in;
  wire re_in;
  wire ce_in;

  // No support for masking in
  assign we_in = |WR_EN;
  assign re_in = |RD_EN;
  assign ce_in = we_in | re_in;
  assign addr_in = we_in ? WR_ADDR :
                   re_in ? RD_ADDR :
                   {ABITS{1'b0}};

// The following are auto-generated rams
###AUTO_GENERATED_RAMS###

endmodule
