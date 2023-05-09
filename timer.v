module timer 
(
  input rst, //reset do módulo que é ativo alto (‘1’)
  input clk, //clock rápido de 10 Hz;
  input t_en, //enable do módulo que indica quando produzir o dado de saída, é tipo apertar um botão de start
  
  output t_valid, //indica que o valor colocado no sinal de saída é válido
  output [15:0]t_out //sinal que contém o valor positivo gerado,  caso o valor produzido estoure essa representação numérica, você deve apresentar sempre os 16 bits menos significativos
);
  
  
  //SINAIS
  reg clk_10; 
  reg [31:0] cont_50K;
  reg t_valid_ed;
  
  wire t_en;
  
  
  // CLOCK DE 10Hz
  // ESSE era DE 1KHz com o parêmetro em 50000, para ir de 1khz para 10hz dividimos por 100, já que 0,01 kHz	= 10 Hz
  always @(posedge clk or posedge rst)
  begin
    if (reset == 1'b1) begin
      clk_10   <= 1'b0; 
      count_50K <= 32'd0;
    end
    else begin
      if (count_50K == HALF_MS_COUNT-1) begin
        clk_10   <= ~clk_10;
        count_50K <= 32'd0;
      end
      else begin
        count_50K <= count_50K + 1;
      end
    end
  end
    
  // processo de verificação se entrada é valida ou n
  always @(posedge clk or posedge rst)
    begin
      if(t_en == 1)begin
        t_valid_ed <= 1'b1;
        t_out <= t_out + 1;  // se eu to recebendo coisas validas, a cada cilco de clock a saida recebe o valor q ela tinha mais 
      end
      else begin
        t_valid_ed <= 1'b0;
      end
    end
  

  
endmodule
