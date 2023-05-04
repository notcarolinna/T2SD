module dm 
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
  
endmodule
