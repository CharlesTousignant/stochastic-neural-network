/**
 * Generic FIFO.
 * Author: Carlos Diaz (2017)
 *
 * Parameters:
 *  WIDTH: Width of the data on the FIFO, default to 4.
 *  DEPTH: Depth of the FIFO, default to 4. (MUST BE A POWER OF 2!)
 *
 * Input signals:
 *  clk: Clock input.
 *  i_fifo_w_data: Data input, width controlled with WIDTH parameter.
 *  i_fifo_w_stb: Enable writing into the FIFO.
 *  i_fifo_r_stb: Enable reading from the FIFO.
 *
 * Output signals:
 *  o_fifo_r_data: Data output, witdh controlled with WIDTH parameter.
 *  o_fifo_full: 1bit signal, indicate when the FIFO is full.
 *  o_fifo_empty: 1bit signal, indicate when the FIFO is empty.
 *  o_fifo_not_empty: 1bit signal, indicate when the FIFO is not empty.
 *  o_fifo_not_full: 1bit signal, indicate when the FIFO is not full.
 *
 * Changed:
 *    2021.08.09: Changed names to be inline with my workflow
 *    2021.08.10: Added checks to determine if the next read/write
 *                will be out of bound
 *    2021.08.10: Fixed write_ptr so that it correctly points to
 *                last position, previously this incorrectly pointed
 *                to the last and not the read_ptr last
 *    2021.08.10: Added a note that the DEPTH must be a power of 2
**/

`timescale 1ns / 1ps
`default_nettype none


module fifo #(
  parameter WIDTH = 4,
  parameter DEPTH = 4
)(
  input  wire                 clk,
  input  wire                 rst,

  input  wire                 i_fifo_w_stb,
  input  wire     [WIDTH-1:0] i_fifo_w_data,
  output wire                 o_fifo_full,
  output wire                 o_fifo_not_full,

  input  wire                 i_fifo_r_stb,
  output wire    [WIDTH-1:0]  o_fifo_r_data,
  output wire                 o_fifo_empty,
  output wire                 o_fifo_not_empty
);

//local parameters
//registes/wires



// memory will contain the FIFO data.
reg [WIDTH-1:0]         memory [0:DEPTH-1];
// $clog2(DEPTH+1)-2 to count from 0 to DEPTH
reg [$clog2(DEPTH)-1:0] write_ptr;
reg [$clog2(DEPTH)-1:0] read_ptr;
reg [$clog2(DEPTH)-1:0] r_read_ptr;

//submodules
//asynchronous logic
assign o_fifo_empty     = ( write_ptr == read_ptr);
assign o_fifo_full      = ( write_ptr == 784);
//assign o_fifo_full      = ( (read_ptr == 0) ?
//                              write_ptr == (DEPTH - 1) :
//                              write_ptr == (read_ptr - 1));
assign o_fifo_not_empty = ~o_fifo_empty;
assign o_fifo_not_full  = ~o_fifo_full;

reg [2:0] sendDelay;

reg [(32*784)-1:0] memoryPacked;

wire [(10*32)-1:0] neuralNetResultPacked;
reg [(10)-1:0] neuralNetResultUnpacked[0:31];

// defparam net.WIDTH = WIDTH;
wire [WIDTH-1:0] incRes;
wire resValid;
NeuralNetWrapper net (.clk(clk),
                      .rst(rst),
                      .image(memoryPacked),
                      .imageValid(o_fifo_full),
                      .netResult(neuralNetResultPacked),
                      .outputValid(resValid));
//initialization
initial begin
  // Init both write_cnt and read_cnt to 0
  write_ptr   = 0;
  read_ptr    = 0;
  r_read_ptr  = (DEPTH - 1);

  // Display error if WIDTH is 0 or less.
  if ( WIDTH <= 0 ) begin
      $error("%m ** Illegal condition **, you used %d WIDTH", WIDTH);
  end
  // Display error if DEPTH is 0 or less.
  if ( DEPTH <= 0) begin
      $error("%m ** Illegal condition **, you used %d DEPTH", DEPTH);
  end
end // end initial

//synchronous logic
assign o_fifo_r_data = neuralNetResultUnpacked[read_ptr];

integer i;

// pack memory to give to neuralNetwork
always begin
    for (i = 0; i < 784; i = i + 1) begin
        memoryPacked[i*32+:32] = memory[i];
    end
end 

// unpack neural net result
always begin
    for (i = 0; i < 10; i = i + 1) begin
        neuralNetResultUnpacked[i] = neuralNetResultPacked[i*32+:32];
    end
end 



always @ (posedge clk) begin
  if (rst) begin
  end
  else begin
    if ( i_fifo_w_stb && o_fifo_not_full) begin
      memory[write_ptr] <= i_fifo_w_data;
    end
  end
end

always @ ( posedge clk ) begin
  if (rst) begin
    write_ptr         <=  0;
    read_ptr          <=  0;
    r_read_ptr        <=  (DEPTH - 1);
    sendDelay <= 0;
  end
  else begin
    if ( i_fifo_w_stb && o_fifo_not_full) begin
      write_ptr     <= write_ptr + 1;
    end
    if ( i_fifo_r_stb && o_fifo_not_empty && read_ptr < 9 ) begin
    
      if (sendDelay != 4) begin
        sendDelay <= sendDelay + 1;
      end 
      else begin
          r_read_ptr    <= read_ptr;
          read_ptr      <= read_ptr + 1;
      end
    end
  end
end

endmodule
