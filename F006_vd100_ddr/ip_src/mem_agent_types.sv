package mem_agent_types;

    localparam AXI_MASTER_DATA_WIDTH  = 128;
    localparam AXI_MASTER_SIZE        = 3'b100; // 16 bytes (128 bits)
    localparam AXI_MASTER_ADDR_WIDTH  = 32;
    localparam AXI_RD_OUTSTANDING_MAX = 16;
    localparam AXI_WR_OUTSTANDING_MAX = 16;
    localparam AXI_RD_ADDR_BASE       = 32'h4000_0000; // 1 GB
    localparam AXI_RD_ADDR_HIGH       = 32'h8000_0000; // 2 GB
    localparam AXI_WR_ADDR_BASE       = 32'h4000_0000; // 1 GB
    localparam AXI_WR_ADDR_HIGH       = 32'h8000_0000; // 2 GB
    
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