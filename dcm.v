module dcm 
 #(parameter HALF_MS_CONT = 50000000)
(
  input rst, // reset do módulo que é ativo alto (‘1’);
  input clk, // clock de referência deste módulo síncrono que opera a 100 MHz
  input update, // indica que o clock lento deve ser atualizado para a frequência indicada pelo sinal prog_in
  input [2:0]prog_in,// indica qual frequência o clock lento deve operar 
  
  output clk_1, // clock rápido gerado, que opera a 10 Hz
  output clk_2, // clock lento gerado, que pode operar entre 10Hz e 78.125 mHz;
  output [2:0]prog_out // indica qual frequência o clock lento está gerando naquele momento
);

  reg clk_1;
  reg [31:0]count_50K;
  reg [31:0]count_100mh;
  reg [2:0]prog_reg; // sinal do prog_out
  reg[7:0]count_mode;
  
  wire update_w; // realmente precisa desse wire? 
  
  //  clock de 10hz para o clk_1
  // faz a mesma coisa que o de cima, mas pra outro clock
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
 edge_detector update_w (.clock(clk), .reset(rst), .din(update), rising(update_w));
 
 
 assign clk_2 = (update_w == 1 && prog_reg == 2'd0) ? count_mode[0]: // Modo 0
                (update_w == 1 && prog_reg == 2'd1) ? count_mode[1]: // Modo 1
                (update_w == 1 && prog_reg == 2'd2) ? count_mode[2]: // Modo 2
                (update_w == 1 && prog_reg == 2'd3) ? count_mode[3]: // Modo 3
                (update_w == 1 && prog_reg == 2'd4) ? count_mode[4]: // Modo 4
                (update_w == 1 && prog_reg == 2'd5) ? count_mode[5]: // Modo 5
                (update_w == 1 && prog_reg == 2'd6) ? count_mode[6]: // Modo 6
                (update_w == 1 && prog_reg == 2'd7) ? count_mode[7]; // Modo 7
 
 always @(posedge clk_1 or posedge rst)
    begin
      if(rst == 1)begin // apertou o reset
        prog_reg <= 2'd0; // vai pro mode 0, ou seja, 0.1s
        count_mode <= 7'd0;  
      end
      else begin
        if(update_w == 1)begin // Pressionou o update e agora a magia vira potência de 2
           count_mode <= 7'd0;
        end
       count_mode <= count_mode + 1'b1;
      end
    end
  
  // preciso de um registrador prog pra poder zerar ele dps de passar pro prog_reg?          
  

endmodule
