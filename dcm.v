module dcm 
(
  input rst, //reset do módulo que é ativo alto (‘1’);
  input clk, // clock de referência deste módulo síncrono que opera a 100 MHz
  input update, //indica que o clock lento deve ser atualizado para a frequência indicada pelo sinal prog_in
  input [2:0]prog_in,//indica qual frequência o clock lento deve operar 
  
  output clk_1, //clock rápido gerado, que opera a 10 Hz
  output clk_2, //clock lento gerado, que pode operar entre 10Hz e 78.125 mHz;
  output [2:0]prog_out //ndica qual frequência o clock lento está gerando naquele momento
);
  
  //clock de 100 mHz
  //10 Hertz [Hz] =   0.000 01 Megahertz [MHz]
  //100 Megahertz [MHz] =   100 000 000 Hertz [Hz]
  // 1 KHZ divide the frequency value by 1000 para MHz = 0.001
  // 100 MHz == 100000 KHz


endmodule
