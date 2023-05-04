module timer 
(
  input rst, //reset do módulo que é ativo alto (‘1’)
  input clk, //clock rápido de 10 Hz;
  input t_en, //enable do módulo que indica quando produzir o dado de saída
  
  output t_valid, //indica que o valor colocado no sinal de saída é válido
  output [15:0]t_out //sinal que contém o valor positivo gerado,  caso o valor produzido estoure essa representação numérica, você deve apresentar sempre os 16 bits menos significativos
);

endmodule
