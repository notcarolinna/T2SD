module wrapper 
(
  input rst, //reset do módulo que é ativo alto (‘1’)
  input clk_1, //é o clock rápido, que opera a 10 Hz
  input clk_2, //clock lento, que pode operar entre 10Hz e 78.125 mHz 
  input data_1_en, //sinal enable que indica que o dado de entrada é válido
  input [15:0]data_1, //é o valor de 16 bits que foi produzido pelo sistema, sendo este proveniente do módulo Fibonacci ou do módulo Timer
  
  output buffer_empty,//flag de controle que indica que o buffer interno do módulo está vazio
  output buffer_full, //flag de controle que indica que o buffer interno do módulo está cheio
  output data_2_valid,//indica que o valor a ser consumido é válido
  output [15:0]data_2//valor de 16 bits que o sistema está consumindo naquele momento, o qual foi previamente gerado pelo módulo Fibonacci ou pelo módulo Timer.
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
      if(data_1_en == 1)begin
        if(buffer_wr == 3'd7)begin
          buffer_full <= 1'b1;
        end
        buffer_reg[buffer_wr] <= data_1;
        buffer_wr <= buffer_wr + 1;
      end
    end
  end
  
  
  
endmodule
