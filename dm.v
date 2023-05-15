module dm 
 #(parameter HALF_MS_CONT = 50)
(
  input rst,//reset do módulo que é ativo alto (‘1’)
  input clk, //módulo síncrono que opera a 100 MHz ( é a mesma frequencia do microondas)
  input [2:0]prog, //indica qual frequência o clock lento está operando
  input [1:0]modulo, // cuidar pq no enunciado ta module(q n da pra usar pq é palavra reservada)
  input [15:0]data_2, // valor de 16 bits que o sistema está consumindo naquele momento, o qual foi previamente gerado pelo módulo Fibonacci ou módulo Timer
  
  output [7:0]an, //representando cada um dos displays disponíveis no FPGA
  output [7:0]dec_ddp //valor decodificado do dígito a ser mostrado no instante atual pelo display
);

  //Note que os valores decodificados dos dígitos estarão distribuídos da seguinte maneira: 
  //display #8 contém o valor de prog; 
  //display #6 contém o valor de module;
  //e displays de #4, #3, #2 e #1 contém o valor de data_2, sendo o 
  //display #4 os bits mais significativos e o display #1 os bits menos significativos.

 // sinais
 wire [3:0] uni_min;
 wire [3:0] dez_min;
 wire [3:0] cen_min;
 wire [3:0] mil_min;
 wire [2:0] prog_w; // é um wire pq o valor n precisa ser armazenado ele vai passar direto pro diplay
 
// funcionamento dos displays
assign uni_min = data_2[3:0];
assign dez_min = data_2[7:4];
assign cen_min = data_2[11:8];
assign mil_min = data_2[15:12];
 assign prog_w = (prog == 3'd1) ? // de onde vem o clack lento?

dspl_drv_NexysA7 display(.clk(clk), .rst(rst), .an(an), .dec_cat(dec_ddp), .d1({1'b1, uni_min[3:0], 1'b0}), .d2({1'b1, dez_min[3:0], 1'b0}), .d3({1'b1, cen_min[3:0], 1'b0}), .d4({1'b1, mil_min[3:0], 1'b0}), .d5(6'b0), .d6({3'b1, modulo[1:0],1'b0}), .d7(6'b0), .d8({2'b1, prog[2:0], 1'b0}));
// fiz a mesma coisa que no timer.v do t1

endmodule


  
