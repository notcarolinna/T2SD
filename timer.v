module timer 
(
  input rst, //reset do módulo que é ativo alto (‘1’)
  input clk, //clock rápido de 10 Hz;
  input t_en, //enable do módulo que indica quando produzir o dado de saída, é tipo apertar um botão de start
  
  output reg t_valid, //indica que o valor colocado no sinal de saída é válido
  output [15:0]t_out //sinal que contém o valor positivo gerado,  caso o valor produzido estoure essa representação numérica, você deve apresentar sempre os 16 bits menos significativos
);
  
  
  //SINAIS
  reg [15:0] t_out_r;


    
  // processo de verificação se entrada é valida ou n
  always @(posedge clk or posedge rst)
    begin
      if(rst) begin
        t_out_r <= 16'd0;
      end
      else begin
      if(t_en == 1'b1)begin
        t_valid <= 1'b1;
	      t_out_r <= t_out_r + 1'b1;  // se eu to recebendo coisas validas , a cada cilco de clock a saida recebe o valor q ela tinha mais 1, ou seja, soma de 1 em 1
      end
      else begin
        t_valid <= 1'b0;
      end
    end
    end
  
assign t_out = t_out_r;
    
endmodule
