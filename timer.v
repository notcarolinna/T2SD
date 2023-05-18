module timer 
(
  input rst, //reset do módulo que é ativo alto (‘1’)
  input clk, //clock rápido de 10 Hz;
  input t_en, //enable do módulo que indica quando produzir o dado de saída, é tipo apertar um botão de start
  
  output reg t_valid, //indica que o valor colocado no sinal de saída é válido
  output [15:0]t_out //sinal que contém o valor positivo gerado,  caso o valor produzido estoure essa representação numérica, você deve apresentar sempre os 16 bits menos significativos
);

  reg [15:0] t_out_r; // reg de 16 bits que armazena o valor de saída
	
  // processo de verificação se entrada é valida ou não
  always @(posedge clk or posedge rst) begin

	  if(rst) begin // se o reset estiver ativo
        t_out_r <= 16'd0; // o t_out_r é reiniciado com o valor 0
      end
	    
        else begin // se o reset estiver inativo
	        if(t_en == 1'b1)begin // verifica se o sinal de enable é 1, se for:
        	  t_valid <= 1'b1; // o t_valid é definido como 1, indicando que o sinal é válido
	      	  t_out_r <= t_out_r + 1'b1;  // e esse t_out_r é incrementado em 1
           end
	      
     	 else begin // se o enable estiver inativo
        t_valid <= 1'b0; // o t_valid é definido como 0, indicando que o sinal é inválido
       end  
    end
  end
  
assign t_out = t_out_r; // aqui, o sinal de saída t_out é atribuído ao t_out_r, contedo os bits menos significativos do valor gerado
    
endmodule
