module dcm 
  #(parameter HALF_MS_COUNT = 500000)
(
  input rst, //reset do módulo que é ativo alto (‘1’);
  input clk, // clock de referência deste módulo síncrono que opera a 100 MHz
  input update, //indica que o clock lento deve ser atualizado para a frequência indicada pelo sinal prog_in
  input [2:0]prog_in,//indica qual frequência o clock lento deve operar 
  
  output clk_1, //clock rápido gerado, que opera a 10 Hz
  output clk_2, //clock lento gerado, que pode operar entre 10Hz e 78.125 mHz;
  output [2:0]prog_out //ndica qual frequência o clock lento está gerando naquele momento
);
  
  //SINAIS:
  reg clk_100;
  reg [31:0]count_50K;
  reg [2:0]prog; // sinal do prog_in
  reg [2:0]prog_reg; // sinal do prog_out
  
  wire update_w;

  
  //clock de 100 mHz
  //10 Hertz [Hz] =   0.000 01 Megahertz [MHz]
  //100 Megahertz [MHz] =   100 000 000 Hertz [Hz]
  // 1 KHZ divide the frequency value by 1000 para MHz = 0.001
  // 100 MHz == 100000 KHz
  // se eu fizer dividido por 1000 e dps multiplicar por 100 vai dar certo?
  always @(posedge clk or posedge rst)
  begin
    if (rst == 1'b1) begin
      clk_100   <= 1'b0;
      count_50K <= 32'd0;
    end
    else begin
      if (count_50K == HALF_MS_COUNT-1) begin
        clk_100   <= ~ck_1KHz;
        count_50K <= 32'd0;
      end
      else begin
        count_50K <= count_50K + 1;
      end
    end
  end
  
  
  always @(posedge clk or posedge rst)
    begin
      // tem q ver a situação do reset ainda
      if(update_w == 1)begin
        
      end
  

  
  
  
  
  


endmodule
