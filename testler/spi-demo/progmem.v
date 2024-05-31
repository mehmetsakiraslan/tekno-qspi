module progmem (
    // Closk & reset
    input wire clk,
    input wire rstn,

    // PicoRV32 bus interface
    input  wire        valid,
    output wire        ready,
    input  wire [31:0] addr,
    output wire [31:0] rdata
);

  // ============================================================================

  localparam MEM_SIZE_BITS = 10;  // In 32-bit words
  localparam MEM_SIZE = 1 << MEM_SIZE_BITS;
  localparam MEM_ADDR_MASK = 32'h0010_0000;

  // ============================================================================

  wire [MEM_SIZE_BITS-1:0] mem_addr;
  reg  [             31:0] mem_data;
  reg  [             31:0] mem      [0:MEM_SIZE];

  initial begin

  mem['h0000] <= 32'h02020737;
  mem['h0001] <= 32'h200107b7;
  mem['h0002] <= 32'h19f70713;
  mem['h0003] <= 32'h00e7a023;
  mem['h0004] <= 32'h200106b7;
  mem['h0005] <= 32'h3e700793;
  mem['h0006] <= 32'h00e6a023;
  mem['h0007] <= 32'hfff78793;
  mem['h0008] <= 32'hfe079ce3;
  mem['h0009] <= 32'h0000006f;

  end

  always @(posedge clk) mem_data <= mem[mem_addr];

  // ============================================================================

  reg o_ready;

  always @(posedge clk or negedge rstn)
    if (!rstn) o_ready <= 1'd0;
    else o_ready <= valid && ((addr & MEM_ADDR_MASK) != 0);

  // Output connectins
  assign ready    = o_ready;
  assign rdata    = mem_data;
  assign mem_addr = addr[MEM_SIZE_BITS+1:2];

endmodule

