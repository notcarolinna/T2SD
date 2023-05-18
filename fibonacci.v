module fibonacci 
(
  input rst, // reset do módulo que é ativo alto (‘1’)
  input clk, // clock
  input f_en, // enable do módulo que indica quando produzir o dado de saída
  
  output reg f_valid, // verifica se o sinal de saída é valido
  output [15:0] f_out // valor atual da sequencia de fibonacci
);
  
  // t1 = posição anterior
  // t2 = posição atual
  reg [15:0] t1, t2;
   
 
   // Cálculo Fibonacci
  always @(posedge clk or posedge rst)
    begin
      
      if(rst == 1) // se o reset estiver ativo, o módulo deverá ser reinicializado
      begin 
        t1 <= 16'd0; // inicializa o t1 em 0, pois é a primeira posição do fibonacci
        t2 <= 16'd1; // inicializa o t2 em 1, pois é a segunda posição do vibonacci
        f_valid <= 1'b0; // f_valid é definido como 0, indicando que o valor da saída é inválido
      end
      
      else 
      begin // reset está inativo, verifica:
        if(f_en == 1) begin // se o enable estiver ativo, deverá gerar o próximo valor do fiboancci
          f_valid <= 1'b1;  // o f_valid define que a saída é válida
          t1 <= t2; // o anterior recebe o atual
          t2 <= t2 + t1; // o atual recebe ele mais o anterior
        end
        else begin
          f_valid <= 1'b0; // se o enable não for ativado, a saída é considerada inválida
        end
      end
    end

assign f_out = t1; // atribui o f_out ao t1, representado o valor atual do fibonacci

endmodule
