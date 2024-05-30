// spi_denetleyici.v
`timescale 1ps / 1ps

// Not: Flashin 0. adresinde calismiyor. Register eklenerek duzeltilebilir.ack

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

   // Define registers 
   reg [31:0] control_register_r [9:0];
   
   // word counter for dr registers
   reg [3:0] word_ctr;
   // Send Instruction-Read-Write-Dummy Cycle
   reg [4:0] state;
   // transmission buffer
   reg [31:0] t_buffer;
   // Reciever buffer
   reg [31:0] r_buffer;
   // Flag for new instruction
   wire new_inst = wb_stb_i; //TODO: change values
   // Bit counter
   reg [10:0] bit_ctr;

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
   assign wb_ack_o = ack || wb_stb_i && (wb_adr_i!=0);
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
   // Read
   assign wb_dat_o = control_register_r[wb_adr_i>>2]; // TODO: adresi genislet
   // todo: ack ekle
   integer i;
   always @(posedge clk_i) begin
      if(rst_i) begin
         for(i=0; i<10; i=i+1) begin
            control_register_r[i] <= 0;
            inst_flag <= 0;
         end
      end
      else begin
         if(wb_we_i && ~busy) begin
            control_register_r[wb_adr_i>>2] = wb_dat_i;
            if(wb_adr_i==0 && !wb_ack_o) begin
               inst_flag <= 1;
            end
         end
      end
   end

   reg [1:0] out_mod;
   assign io_qspi_data = out_mod==2'b11 ? t_buffer[31:28] : 
                         out_mod==2'b10 ? {t_buffer[31:30],2'bZZ} : 
                         out_mod==2'b01 ? {3'bZZZ, t_buffer[31]} : 4'bZZZZ;

   always @(posedge clk_i) begin
      if(rst_i) begin
         state <= IDLE;
         word_ctr <= 0;
         bit_ctr <= 0;
         t_buffer <= 0;
         r_buffer <= 0;
         ack <= 0;
         out_mod <= 2'b01;
      end
      else if (clock_en) begin
         case(state)
         
         IDLE: begin
            ack <= 0;
            if(new_inst && inst_flag) begin
               state <= INST;
               // addr ekle
               bit_ctr <= (QSPI_ADR==32'b0) ? 8 : 32;
               t_buffer <= (QSPI_ADR==32'b0) ? {instruction_value, 24'b0} : {instruction_value, QSPI_ADR[23:0]};
            end
         end

         INST: begin
            if(bit_ctr != 0) begin
               t_buffer <= t_buffer << 1;
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
                     bit_ctr <= (data_size+1)<<3;
                     word_ctr <= 1;
                     t_buffer <= control_register_r[2];
                  end
               end
            end
         end

         DUMMY: begin
            if(bit_ctr != 0) begin
               bit_ctr <= bit_ctr - data_rate; // TODO: yazilan koda gore degismesi gerekebilir (4x dummy cycle vs)
            end
            else begin
               state <= (write_flash) ? WRITE : READ;
               bit_ctr <= data_size;
               word_ctr <= 1;
               t_buffer <= control_register_r[2];
            end
         end

         WRITE: begin
            if(bit_ctr != 0) begin
               bit_ctr <= bit_ctr - data_rate;
               t_buffer <= t_buffer << data_rate;
               
               if((bit_ctr-data_rate)%32==0) begin
                  word_ctr <= word_ctr + 1;
                  t_buffer <= control_register_r[word_ctr+2];
               end
            end
            else begin
               ack <= 1;
               state <= IDLE;
               bit_ctr <= 0;
               out_mod <= 2'b01;
            end
         end

         READ: begin
            if(bit_ctr != 0) begin
               case(data_mod)
               sr: r_buffer <= {r_buffer, io_qspi_data[0]};
               dr: r_buffer <= {r_buffer, io_qspi_data[1:0]};
               qr: r_buffer <= {r_buffer, io_qspi_data[3:0]};
               default: r_buffer <= {r_buffer, io_qspi_data[0]};
               endcase
               bit_ctr <= bit_ctr - data_rate;

               if((bit_ctr-data_rate)%32==0) begin
                  word_ctr <= word_ctr + 1;
                  control_register_r[word_ctr] <= t_buffer;
               end
            end
            else begin
               ack <= 1;
               state <= IDLE;
               bit_ctr <= 0;
               out_mod <= 2'b01;
            end
         end
         
         endcase
      end   
   end

   // // Control sck and cs
   assign spi_cs_o = (state==IDLE); //|| (state==IDLE && new_inst);
   // reg sck;
   assign spi_sck_o = (prescale==0) ? clk_i&&(state!=IDLE) : clock_en&&(state!=IDLE);

endmodule
