//---------------------------------------------------------------------------------------
// uart receive module  
//
//---------------------------------------------------------------------------------------

module uart_rx 
(
	clock, reset,
	ce_16, ce_1,
	ser_in, 
	rx_data, rx_busy,
	new_rx_data
);
//---------------------------------------------------------------------------------------
// modules inputs and outputs 
input 			clock;			// global clock input 
input 			reset;			// global reset input 
input			ce_16;			// baud rate multiplyed by 16 - generated by baud module 
input			ser_in;			// serial data input 
output	[7:0]	rx_data;		// data byte received 
output 			new_rx_data;	// signs that a new byte was received
output      rx_busy; 
output   ce_1;

// internal wires 
//wire ce_1;		// clock enable at bit rate 
wire ce_1_mid;	// clock enable at the middle of each bit - used to sample data 

// internal registers 
reg	[7:0] rx_data;
reg	new_rx_data;
reg [1:0] in_sync;
reg rx_busy; 
reg [3:0]	count16;
reg [3:0]	bit_count;
reg [7:0]	data_buf;
//---------------------------------------------------------------------------------------
// module implementation 
// input async input is sampled twice 
always @ (posedge clock or negedge reset)
begin 
	if (reset == 1'b0) 
		in_sync <= 2'b11;
	else 
		in_sync <= {in_sync[0], ser_in};
end 

// a counter to count 16 pulses of ce_16 to generate the ce_1 and ce_1_mid pulses.
// this counter is used to detect the start bit while the receiver is not receiving and 
// signs the sampling cycle during reception. 
always @ (posedge clock or negedge reset)
begin
	if (reset == 1'b0) 
		count16 <= 4'b0;
	else if (ce_16) 
	begin 
		if (rx_busy | (in_sync[1] == 1'b0))
			count16 <= count16 + 4'b1;
		else 
			count16 <= 4'b0;
	end 
end 

// ce_1 pulse indicating expected end of current bit 
assign ce_1 = (count16 == 4'b1111) & ce_16;
// ce_1_mid pulse indication the sampling clock cycle of the current data bit 
assign ce_1_mid = (count16 == 4'b0111) & ce_16;

// receiving busy flag 
always @ (posedge clock or negedge reset)
begin 
	if (reset == 1'b0)
		rx_busy <= 1'b0;
	else if (~rx_busy & ce_1_mid)
		rx_busy <= 1'b1;
	else if (rx_busy & (bit_count == 4'h8) & ce_1_mid) 
		rx_busy <= 1'b0;
end 

// bit counter 
always @ (posedge clock or negedge reset)
begin 
	if (reset == 1'b0)
		bit_count <= 4'h0;
	else if (~rx_busy) 
		bit_count <= 4'h0;
	else if (rx_busy & ce_1_mid)
		bit_count <= bit_count + 4'h1;
end 

// data buffer shift register 
always @ (posedge clock or negedge reset)
begin 
	if (reset == 1'b0)
		data_buf <= 8'h0;
	else if (rx_busy & ce_1_mid)
		data_buf <= {in_sync[1], data_buf[7:1]};
end 

// data output and flag 
always @ (posedge clock or negedge reset)
begin 
	if (reset == 1'b0) 
	begin 
		rx_data <= 8'h0;
		new_rx_data <= 1'b0;
	end 
	else if (rx_busy & (bit_count == 4'h8) & ce_1)
	begin 
		rx_data <= data_buf;
		new_rx_data <= 1'b1;
	end 
	else 
		new_rx_data <= 1'b0;
end 

endmodule
//---------------------------------------------------------------------------------------
//						That is all !
//---------------------------------------------------------------------------------------
