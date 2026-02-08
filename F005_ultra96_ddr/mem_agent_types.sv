package mem_agent_types;

    localparam AXI_MASTER_DATA_WIDTH  = 64;
    localparam AXI_MASTER_SIZE        = 3'b011; // 8 bytes (64 bits)
    localparam AXI_MASTER_ADDR_WIDTH  = 32;
    localparam AXI_RD_OUTSTANDING_MAX = 16;
    localparam AXI_WR_OUTSTANDING_MAX = 16;
    localparam AXI_RD_ADDR_BASE       = 32'h4000_0000;
    localparam AXI_RD_ADDR_HIGH       = 32'h4000_2000;
    localparam AXI_WR_ADDR_BASE       = 32'h4000_0000;
    localparam AXI_WR_ADDR_HIGH       = 32'h4000_2000;
    
    localparam DEBUG_COUNTER_BITS     = 32;
    localparam DEBUG_TIMESTAMP_DEPTH  = 2048;
    
    typedef struct packed {
        logic wrreq;
        logic full;
    } fifo_wr_if_t;

    typedef struct packed {
        logic rdreq;
        logic empty;
    } fifo_rd_if_t;


endpackage : mem_agent_types