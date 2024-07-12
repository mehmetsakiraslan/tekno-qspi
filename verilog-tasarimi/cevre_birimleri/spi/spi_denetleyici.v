// spi_denetleyici.v
`timescale 1ps / 1ps


module spi_denetleyici (
   input clk_i,
   input rst_i,
   // Wishbone arayüzü
   input  [ 7:0] wb_adr_i,
   input  [31:0] wb_dat_i,
   input         wb_we_i,
   input         wb_stb_i,
   input  [ 3:0] wb_sel_i,
   input         wb_cyc_i,
   output        wb_ack_o,
   output [31:0] wb_dat_o,

   // QSPI i/o
   inout [3:0] io_qspi_data,
   output spi_cs_o,
   output spi_sck_o
);
   
   // Durum makinesi parametreleri
   localparam [4:0]
   IDLE  = 5'b00001,
   WRITE = 5'b00010,
   READ  = 5'b00100,
   DUMMY = 5'b01000,
   INST  = 5'b10000;

   // data mode
   localparam [1:0] 
   sr = 2'b01,
   dr = 2'b10,
   qr = 2'b11;

   // Inst that require address
   localparam [7:0] 
   CMD_READ = 2'h03,
   CMD_DOR = 2'h3B,
   CMD_QOR = 2'h6B,
   CMD_PP = 2'h02,
   CMD_QPP = 2'h32,
   CMD_SE = 2'hD8;

   // Define registers 
   reg [31:0] control_register_r [9:0];

   reg [31:0] dat_r;
   
   // word counter for dr registers
   reg [3:0] word_ctr;
   // Send Instruction-Read-Write-Dummy Cycle
   reg [4:0] state;
   // transmission/receiver buffer
   reg [31:0] buffer;
   // Flag for new instruction
   wire new_inst = wb_stb_i; //TODO: change values
   // Bit counter
   reg [10:0] bit_ctr;
   // Address enable flag
   wire adr_en;

   // Name registers
   wire [31:0] QSPI_CCR = control_register_r[0];
   wire [31:0] QSPI_ADR = control_register_r[1];
   // wire [31:0] QSPI_DR  = control_register_r[word_ctr];
   wire [31:0] QSPI_STA = control_register_r[9];

   // Name config reg values
   // Instruction to be send to flash device
   wire [7:0] instruction_value = QSPI_CCR[7:0];
   // 00 -> send data
   // 01 -> x1 (single channel)
   // 10 -> x2 (dual channel)
   // 11 -> x4 (quad channel)
   wire [1:0] data_mod = QSPI_CCR[9:8];
   // 0 -> read
   // 1 -> write
   wire write_flash = QSPI_CCR[10];
   // Number of dummy cycles
   wire [4:0] dummy_cycles = QSPI_CCR[15:11];
   // Size of data
   wire [8:0] data_size = QSPI_CCR[24:16];
   // Clock divide value
   wire [5:0] prescale = QSPI_CCR[30:25];
   // Reset status reg
   wire reset_status_reg = QSPI_CCR[31];
   // Status reg
   wire status_reg = QSPI_STA[0];
   // data rate
   wire [1:0] data_rate = (data_mod==2'b11) ? 4 : data_mod;
   // ack
   reg ack;
   reg ack_flag;
   assign wb_ack_o = ack;
   // assign dat_o
   assign wb_dat_o = dat_r;
   // adr en
   assign adr_en = (instruction_value==CMD_READ);
                     // (instruction_value==CMD_DOR) ||
                     // (instruction_value==CMD_QOR) ||
                     // (instruction_value==CMD_PP) ||
                     // (instruction_value==CMD_QPP) ||
                     // (instruction_value==CMD_SE);
   // flag to stop
   reg inst_flag;

   // Slowdown clock
   reg clock_en;
   reg [5:0] prescale_ctr;
   always @(posedge clk_i) begin
      if(rst_i) begin
         prescale_ctr <= 0;
         clock_en <= 0;   
      end
      else begin
         if(prescale_ctr < prescale) begin
            clock_en <= 0;
            prescale_ctr <= prescale_ctr + 1;
         end
         else begin
            clock_en <= 1;
            prescale_ctr <= 0;
         end
      end
   end

   // Read-write control registers
   wire busy = state != IDLE; 
  
   integer i;
   always @(posedge clk_i) begin
      if(rst_i) begin
         for(i=0; i<10; i=i+1) begin
            control_register_r[i] <= 0;
         end
         inst_flag <= 0;
         ack <= 0;
      end
      else begin
         if(ack_flag && state==IDLE && !ack) begin
            ack <= 1;
         end
         else if(wb_we_i && wb_stb_i && state==IDLE && !ack) begin
            control_register_r[wb_adr_i>>2] = wb_dat_i;
            if(wb_adr_i==0) begin
               inst_flag <= 1;
               ack <= 0;
            end
            else if(wb_adr_i!=0) begin
               ack <= 1;
            end
            else begin
               ack <= 0;
            end
         end
         else if(!wb_we_i && wb_stb_i && state==IDLE && !ack) begin
            dat_r <= control_register_r[wb_adr_i>>2];
            ack <= 1;
         end
         else begin
            ack <= 0;
         end
      end
   end

   reg [1:0] out_mod;
   assign io_qspi_data = out_mod==2'b11 ? buffer[31:28] : 
                         out_mod==2'b10 ? {2'bZZ, buffer[31:30]} : 
                         out_mod==2'b01 ? {2'b11, 1'bZ, buffer[31]} : 4'bZZZZ;

   always @(posedge clk_i) begin
      if(rst_i) begin
         state <= IDLE;
         word_ctr <= 0;
         bit_ctr <= 0;
         buffer <= 0;
         ack_flag <= 0;
         out_mod <= 2'b01;
      end
      else if (clock_en) begin
         case(state)
         
         IDLE: begin
            ack_flag <= 0;
            if(new_inst && inst_flag) begin
               state <= INST;
               // addr ekle
               bit_ctr <= (adr_en) ? 32 : 8;
               buffer <= (adr_en) ? {instruction_value, QSPI_ADR[23:0]} : {instruction_value, 24'b0};
            end
         end

         INST: begin
            if(bit_ctr != 0) begin
               buffer <= buffer << 1;
               bit_ctr <= bit_ctr - 1;
               inst_flag <= 0;
               if(bit_ctr==1) begin
                  out_mod <= (!write_flash) ? 2'b00 : data_mod;
                  if(dummy_cycles!=0) begin
                     state <= DUMMY;
                     bit_ctr <= dummy_cycles;
                  end
                  else begin
                     state <= (write_flash) ? WRITE : READ;
                     bit_ctr <= ((data_size+1)<<3)-1;
                     word_ctr <= 1;
                     buffer <= control_register_r[2];
                  end
               end
            end
         end

         DUMMY: begin
            if(bit_ctr != 0) begin
               bit_ctr <= bit_ctr - data_rate; 
            end
            else begin
               state <= (write_flash) ? WRITE : READ;
               bit_ctr <= data_size;
               word_ctr <= 2;
               buffer <= control_register_r[2];
            end
         end

         WRITE: begin
            if(bit_ctr != 0) begin
               bit_ctr <= bit_ctr - data_rate;
               buffer <= buffer << data_rate;
               
               if((bit_ctr-data_rate)%32==0) begin
                  word_ctr <= word_ctr + 1;
                  buffer <= control_register_r[word_ctr+2];
               end
            end
            else begin
               ack_flag <= 1;
               state <= IDLE;
               bit_ctr <= 0;
               out_mod <= 2'b01;
               control_register_r[0] <= 0;
            end
         end

         READ: begin
            if(bit_ctr != 0) begin
               case(data_mod)
               sr: buffer[word_ctr] <= {buffer[word_ctr], io_qspi_data[1]};
               dr: buffer[word_ctr] <= {buffer[word_ctr], io_qspi_data[1:0]};
               qr: buffer[word_ctr] <= {buffer[word_ctr], io_qspi_data[3:0]};
               default: buffer[word_ctr] <= {buffer[word_ctr], io_qspi_data[1]};
               endcase
               bit_ctr <= bit_ctr - data_rate;

               if((bit_ctr-data_rate+1)%32==0) begin
                  word_ctr <= word_ctr + 1;
                  control_register_r[2+word_ctr] <= buffer; 
               end
            end
            else begin
               ack_flag <= 1;
               state <= IDLE;
               bit_ctr <= 0;
               out_mod <= 2'b01;
               control_register_r[0] <= 0;
            end
         end
         
         endcase
      end   
   end

   reg sck_r;
   always @(posedge clk_i) begin
      if(rst_i) begin
         sck_r <= 0;
      end
      // Assumption!! prescale must be odd number.
      if((prescale_ctr == (prescale+1)>>1) || (prescale_ctr == 0)) begin
         // clock_en <= 1;
         sck_r <= ~sck_r;
      end
   end
   // // Control sck and cs
   assign spi_cs_o = (state==IDLE);
   // reg sck;
   assign spi_sck_o = (prescale==0) ? clk_i&&(state!=IDLE) : (prescale==1) ? clock_en&&(state!=IDLE) : sck_r&&(state!=IDLE);

endmodule