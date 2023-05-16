module dcm 
 #(parameter HALF_MS_CONT = 50000000)
(
  input rst, // reset do módulo que é ativo alto (‘1’);
  input clk, // clock de referência deste módulo síncrono que opera a 100 MHz
  input update, // indica que o clock lento deve ser atualizado para a frequência indicada pelo sinal prog_in
  input [2:0]prog_in,// indica qual frequência o clock lento deve operar 
  
  output reg clk_1, // clock rápido gerado, que opera a 10 Hz
  output clk_2, // clock lento gerado, que pode operar entre 10Hz e 78.125 mHz;
  output [2:0]prog_out // indica qual frequência o clock lento está gerando naquele momento
);

  reg [31:0]cont_50K;
  reg [2:0]prog_reg; // sinal do prog_out
  reg[7:0]count_mode;
  reg[2:0]mode;
  
  //wire update_w; // realmente precisa desse wire? 
  
  //  clock de 10hz para o reg clk_1
  // faz a mesma coisa que o de cima, mas pra outro clock
  always @(posedge clk or posedge rst)
  begin
    if (rst == 1'b1) begin
      clk_1 <= 1'b0; 
      cont_50K <= 32'd0;
      mode <= 3'd0;
    end
    else begin
      if (cont_50K == HALF_MS_CONT-1) begin
        clk_1  <= ~clk_1;
        cont_50K <= 32'd0;
      end
      else begin
        cont_50K <= cont_50K + 1;
      end
     if(update == 1)begin
      mode <= prog_in;
     end
    end
  end
  
 
 // instanciação do edge detector para o wire do update
 // edge_detector update_w (.clock(clk), .reset(rst), .din(update), .rising(update_w)); //isso não vem do top?
  
 always @(posedge clk_1 or posedge rst)
    begin
      if(rst == 1)begin // apertou o reset
        prog_reg <= 2'd0; // vai pro mode 0, ou seja, 0.1s
        count_mode <= 8'd0;  
      end
      else begin
        if(update == 1)begin // Pressionou o update e agora a magia vira potência de 
         count_mode <= count_mode + 8'd1;
        end
      end
    end
        
assign clk_2 = count_mode[mode];

endmodule
