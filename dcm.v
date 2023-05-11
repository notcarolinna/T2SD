module dcm 
 #(parameter HALF_MS_CONT = 50000000)
 #(parameter HALF_COUNT = 500000)
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
  reg clk_1;
  reg clk_100;
  reg [31:0]count_50K;
  reg [31:0]count_100mh;
  reg [2:0]prog_reg; // sinal do prog_out
  
  wire update_w;
 
  // 1 KHZ divide the frequency value by 1000 para MHz = 0.001
  // 100 MHz == 100000 KHz
  // se eu fizer dividido por 1000 e dps multiplicar por 100 vai dar certo?
  //clock de 100 mHz
  always @(posedge clk or posedge rst)
  begin
    if (rst == 1'b1) begin
      clk_100   <= 1'b0;
      count_100mh <= 32'd0;
    end
    else begin
      if (count_100mh == HALF_COUNT-1) begin
        clk_100   <= ~ck_1KHz;
        count_100mh <= 32'd0;
      end
      else begin
        count_100mh <= count_100mh + 1;
      end
    end
  end
  
  //clock de 10hz para o clk_1
  always @(posedge clk or posedge rst)
  begin
    if (rst == 1'b1) begin
      clk_1   <= 1'b0; 
      cont_50K <= 32'd0;
    end
    else begin
      if (cont_50K == HALF_MS_CONT-1) begin
        clk_1   <= ~clk_1;
        cont_50K <= 32'd0;
      end
      else begin
        cont_50K <= cont_50K + 1;
      end
    end
  end
  
 
 //instanciação do edge detector para o wire do update
 edge_detector update_w (
 
 
 assign clk_2 = (update_w == 1 && prog_reg == 2'd0) ? /* 1 clk_1*/;
                (update_w == 1 && prog_reg == 2'd1) ? /* 2 clk_1*/;
                (update_w == 1 && prog_reg == 2'd2) ? /* 4 clk_1*/;
                (update_w == 1 && prog_reg == 2'd3) ? /* 8 clk_1*/;
                (update_w == 1 && prog_reg == 2'd4) ? /* 16 clk_1*/;
                (update_w == 1 && prog_reg == 2'd5) ? /* 32 clk_1*/;
                (update_w == 1 && prog_reg == 2'd6) ? /* 64 clk_1*/;
                (update_w == 1 && prog_reg == 2'd7) ? /* 128 clk_1*/;
 
  always @(posedge clk or posedge rst)
    begin
      // tem q ver a situação do reset ainda
      if(rst == 1)begin
        prog_reg <= 2'd0;
      end
      else begin
        if(update_w == 1)begin
          // pegar o valor q o usuário colocaou no prog_in
          prog_reg <= prog_in;
        end
      end
  
  // preciso de um registrador prog pra poder zerar ele dps de passar pro prog_reg
     
     
     
     
     
     ///falta conferir o 2.3  o 2.4    2.5    o 3  e testar as waves de cada um
       
  
  


endmodule
