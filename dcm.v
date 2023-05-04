module dcm 
(
  input rst, //reset do módulo que é ativo alto (‘1’);
  input clk, // clock de referência deste módulo síncrono que opera a 100 MHz
  input update, //
  input [2:0]prog_in,
  
  output clk_1,
  output clk_2,
  output [2:0]prog_out
);

endmodule
