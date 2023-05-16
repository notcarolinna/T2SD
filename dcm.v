module dcm 
 #(parameter HALF_MS_CONT = 50000000)
 #(parameter HALF_COUNT = 500000)
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
  reg clk_100;
  reg [31:0]count_50K;
  reg [31:0]count_100mh;
  reg [2:0]prog_reg; // sinal do prog_out
  
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
 
 
 assign clk_2 = (update_w == 1 && prog_reg == 2'd0) ? 3'b000; // Modo 0
                (update_w == 1 && prog_reg == 2'd1) ? 3'b001; // Modo 1
                (update_w == 1 && prog_reg == 2'd2) ? 3'b010; // Modo 2
                (update_w == 1 && prog_reg == 2'd3) ? 3'b011; // Modo 3
                (update_w == 1 && prog_reg == 2'd4) ? 3'b100; // Modo 4
                (update_w == 1 && prog_reg == 2'd5) ? 3'b101; // Modo 5
                (update_w == 1 && prog_reg == 2'd6) ? 3'b110; // Modo 6
                (update_w == 1 && prog_reg == 2'd7) ? 3'b111; // Modo 7
 
  always @(posedge clk or posedge rst)
    begin
      if(rst == 1)begin // apertou o reset
        prog_reg <= 2'd0; // vai pro mode 0, ou seja, 0.1s
      end


      else begin
        if(update_w == 1)begin // Pressionou o update e agora a magia vira potência de 2

          // eu preciso disso aqui? acho q n pq ele ja to todo ali no assing?
        end
      end
    end
  
  // preciso de um registrador prog pra poder zerar ele dps de passar pro prog_reg?          
  

endmodule
