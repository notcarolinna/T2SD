module wrapper // gerencia a escrita e leitura dos dados no buffer
(
  input rst, //reset do módulo que é ativo alto (‘1’)
  input clk_1, //é o clock rápido, que opera a 10 Hz
  input clk_2, //clock lento, que pode operar entre 10Hz e 78.125 mHz 
  input data_1_en, //sinal enable que indica que o dado de entrada é válido
  input [15:0]data_1, //é o valor de 16 bits que foi produzido pelo sistema, sendo este proveniente do módulo Fibonacci ou do módulo Timer
  
  output buffer_empty,//flag de controle que indica que o buffer interno do módulo está vazio
  output buffer_full, //flag de controle que indica que o buffer interno do módulo está cheio
  output reg data_valid_2,//indica que o valor a ser consumido é válido
  output reg [15:0]data_2//valor de 16 bits que o sistema está consumindo naquele momento, o qual foi previamente gerado pelo módulo Fibonacci ou pelo módulo Timer.
);

  // se a frequencia de leiura for mais q a de escrita o buffer vai enchar e qnd isso acontecer o buffer tem q mandar um sinal pro timer parar de produzir as infos e isso vai criar uma saída incorreta
  //sinais
  reg[15:0] buffer_reg[0:7];
  reg[2:0] buffer_wr; //clk1
  reg[2:0] buffer_rd; //clk2
  
  
  //processo de escrita
  always @(posedge clk_1 or posedge rst)begin
    if(rst == 1)begin
      buffer_wr <= 3'b0;
    end
    
    else begin
      if(data_1_en == 1 && buffer_full != 1'b1)begin  // se o data_1_en estiver em 1 e o buffer não estivier cheio, há um dado válido para ser escrito no buffer
        buffer_reg[buffer_wr] <= data_1; // o valor de data_1 é armazenado no buffer_reg na posição indicada pelo buffer_wr
        buffer_wr <= buffer_wr + 3'd1; // icrementa o buffer_wr em 1, selecionando a próxima posição de escrita no buffer
      end
    end
  end
  
  //processo de leitura
  always @(posedge clk_2 or posedge rst) begin
    if(rst == 1)begin
      buffer_rd <= 3'b0;
      data_2 <= 16'd0;
      data_valid_2 <= 1'b0;
    end
    
    else begin
      if(buffer_empty != 1'b1)begin // se o buffer não estiver cheio
      data_valid_2 <= 1'b1; // atribui 1 ao data_valid_2 para indicar que o valor a ser cosumido é válido
      data_2 <= buffer_reg[buffer_rd]; // atribui o valor armazenado na posiição do buffer à data_2
      buffer_rd <= buffer_rd + 3'd1; // icremeta o buffer_rd em 1
      end
      
      else begin
      data_valid_2 <= 1'b0;  // caso o buffer esteja cheio, atribui 0
      end
    end    
  end
  
  // defiição dos valores dos sinais
assign buffer_empty = (buffer_wr == buffer_rd) ? 3'd1 : 3'd0;
assign buffer_full = (buffer_rd - 1'b1 == buffer_wr) ? 3'd1 : 3'd0;
  
  
endmodule
