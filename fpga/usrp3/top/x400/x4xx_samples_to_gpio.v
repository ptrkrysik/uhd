//
// Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
//
// SPDX-License-Identifier: LGPL-3.0
//
// Module: x4xx_samples_to_gpio
//
// Description:
//
//   This module changes LSB bit of Q component of the signal
//   from the first channel into a single output signal
//   that is meant to be used for driving gpio line.
//
// Parameters:
//
//   RADIO_SPC      : Number of samples per radio clock cycle
//

module x4xx_samples_to_gpio #(
  parameter NUM_CHANNELS = 4,
  parameter RADIO_SPC    = 1
) ( 
  input                                 radio_clk,
  input wire                            radio_rst,
  input [32*RADIO_SPC*NUM_CHANNELS-1:0] tx_data,
  input [ NUM_CHANNELS-1:0]             tx_stb,
  output                                gpio_out
);
   
  reg gpio_out_reg;
   
  always @(posedge radio_clk)
    begin
     if(radio_rst)
       begin
        gpio_out_reg <= 1'b0;
       end
     else if(tx_stb)
       begin
          gpio_out_reg <= tx_data[0];
       end
    end

   assign gpio_out = gpio_out_reg;

endmodule
