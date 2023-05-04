module top 
#(parameter HALF_MS_COUNT = 500)
(
  input rst, // reset do módulo que é ativo alto (‘1’)
  input clk, //clock de referência deste módulo síncrono que opera a 100 MHz
  input start_f,//o botão que indica o início ou continuação da produção de dados pelo módulo Fibonacc
  input start_t, // botão que indica o início ou continuação da produção de dados pelo módulo Timer
  input stop_f_t,//botão que indica a parada de produção de dados dos módulos Fibonacci e Timer
  input update, //botão que indica que o clock lento deve ser atualizado para a frequência indicada pelo valor prog
  input [2:0]prog, //indica qual frequência o clock lento deve operar
  
  output [5:0]led,//sinal visual que indica em que estado da máquina de estado o sistema está operando
  output [7:0]an, //controla a ativação de cada um dos displays disponíveis no FPGA
  output [7:0]dec_ddp //valor decodificado do dígito de 8 bits a ser mostrado no instante atual pelo display
);
  
 
      

endmodule
