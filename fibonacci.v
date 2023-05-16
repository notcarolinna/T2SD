module fibonacci 
(
  input rst, // reset do módulo que é ativo alto (‘1’)
  input clk, // clock
  input f_en, // enable do módulo que indica quando produzir o dado de saída
  
  output f_valid, // verifica se o sinal de saída é valido
  output [15:0] f_out // valor atual da sequencia de fibonacci
);
  
  reg f_valid;
  reg [15:0] t1, t2, prox;
  
  wire f_en;
    
 
   // Cálculo Fibonacci
  always @(posedge clk or posedge rst)
    begin
      if(rst == 1)begin // se o reset for ativado
        t1 <= 16'd0; // retorna o valor de t1 para 0
        t2 <= 16'd1; // e retorna o valor de t2 para 1
      end
      else begin // senão
        if(f_en == 1)begin // se o enable estiver ativo
        f_valid <= 1'b1;  // o f_valid define que a saída é válida
        prox <= t1 + t2; // o próximo número de Fibbonacci e a soma dos dois antecessores
        t1 <= t2;
        t2 <= prox;
        end
      end
      else begin
        f_valid <= 1'b0; // se o enable não for ativado, a saída é considerada inválida
      end
    end
  
  

endmodule
