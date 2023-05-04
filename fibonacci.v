module fibonacci 
(
  input rst, //reset do módulo que é ativo alto (‘1’)
  input clk, // clock
  input f_en, //enable do módulo que indica quando produzir o dado de saída
  
  output f_valid, // verifica se o sinal de saída é valido
  output [15:0] f_out // valor atual da sequencia de fibonacci
);

endmodule
