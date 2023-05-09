module fibonacci 
(
  input rst, // reset do módulo que é ativo alto (‘1’)
  input clk, // clock
  input f_en, //enable do módulo que indica quando produzir o dado de saída
  
  output f_valid, // verifica se o sinal de saída é valido
  output [15:0] f_out // valor atual da sequencia de fibonacci
);
  
  //SINAIS
  reg clk_10; 
  reg [31:0] cont_50K;
  reg f_valid;
  reg [15:0] t1, t2, prox;
  
  wire f_en;
  
    
  
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
  
   // processo de verificação se entrada é valida ou n e calcula fibonacci
  always @(posedge clk or posedge rst)
    begin
      if(rst == 1)begin
        t1 <= 16'd0;
        t2 <= 16'd1;
      end
      else begin
        if(f_en == 1)begin
        f_valid <= 1'b1;
        // aqui soma
        prox <= t1 + t2;
        t1 <= t2;
        t2 <= prox;
        end
      end
      else begin
        f_valid <= 1'b0;
      end
    end
  
  

endmodule
