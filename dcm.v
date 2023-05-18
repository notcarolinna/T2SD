module dcm // controla os dois clocks o clk_1 e o clk_2
 #(parameter HALF_MS_CONT = 500000)
(
  input rst, // reset do módulo que é ativo alto (‘1’);
  input clk, // clock de referência deste módulo síncrono que opera a 100 MHz
  input update, // indica que o clock lento deve ser atualizado para a frequência indicada pelo sinal prog_in
  input [2:0] prog_in,// indica qual frequência o clock lento deve operar 
  
  output reg clk_1, // clock rápido gerado, que opera a 10 Hz
  output clk_2, // clock lento gerado, que pode operar entre 10Hz e 78.125 mHz;
  output [2:0] prog_out // indica qual frequência que o clock lento está gerando naquele momento
);

 // registradores usados para controlar os contadores e armazear informações relacionadas à egração dos clocks
 reg [31:0] cont_50K;
 reg [2:0] prog_reg; 
 reg [7:0] count_mode;
 reg [2:0] mode;
  
  always @(posedge clk or posedge rst)
  begin
   if (rst == 1'b1) begin // se o reset estiver ativo
      clk_1 <= 1'b0; // define o clock  como 0
      cont_50K <= 32'd0; // o contador é reiniciaado
      mode <= 3'd0; // e o mode é definido como 0, ou seja, a frequencia mais baixa do clock 
    end
   
    else begin // reset inativo
     if (cont_50K == HALF_MS_CONT-1) begin // se o contador atingir o valor do half ms
        clk_1  <= ~clk_1; // ocorre uma mudança de estado no clock, de 0 para 1 ou de 1 para 0
        cont_50K <= 32'd0; 
      end
     
      else begin // se o contador não atingir o valor do half ms
        cont_50K <= cont_50K + 1; // ele é incrementado em 1
      end
     
     if(update == 1)begin // se o update for ativado
      mode <= prog_in; // o mode recebe o valor do sinal do prog_in, indicando a frequência desejada para o clock 
     end
    end
  end

 always @(posedge clk_1 or posedge rst)
    begin
      if(rst == 1)begin // apertou o reset
        prog_reg <= 2'd0; // vai pro mode 0 (modo de freq mais baixo), ou seja, 0.1s
        count_mode <= 8'd0;  // reinicia o count_mode
      end
     
      else begin // se o reset estiver inativo
         count_mode <= count_mode + 8'd1; // o count_mode é incrementado em 1
      end
    end
        
 assign prog_out = mode; // o sinal de prog_out é atribuído ao reg mode, indicando a frequência atual do clock
 assign clk_2 = count_mode[mode]; // o sinal do clk_2 é atribuído ao bit correspondente do modo atual

endmodule
