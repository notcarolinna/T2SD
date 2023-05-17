module top 
#(parameter HALF_MS_COUNT = 500)
(
  input rst, // reset do mÃ³dulo que eÌ ativo alto (â1â)
  input clk, //clock de referÃªncia deste mÃ³dulo sÃ­ncrono que opera a 100 MHz
  input start_f,//o botÃ£o que indica o inÃ­cio ou continuaÃ§Ã£o da produÃ§Ã£o de dados pelo mÃ³dulo Fibonacc
  input start_t, // botÃ£o que indica o inÃ­cio ou continuaÃ§Ã£o da produÃ§Ã£o de dados pelo mÃ³dulo Timer
  input stop_f_t,//botÃ£o que indica a parada de produÃ§Ã£o de dados dos mÃ³dulos Fibonacci e Timer
  input update, //botÃ£o que indica que o clock lento deve ser atualizado para a frequÃªncia indicada pelo valor prog
  input [2:0]prog, //indica qual frequÃªncia o clock lento deve operar
  
  output [5:0]led,//sinal visual que indica em que estado da mÃ¡quina de estado o sistema estÃ¡ operando
  output [7:0]an, //controla a ativaÃ§Ã£o de cada um dos displays disponÃ­veis no FPGA
  output [7:0]dec_ddp //valor decodificado do dÃ­gito de 8 bits a ser mostrado no instante atual pelo display
);
  
  
  // FAZ A LIGAÃÃO DE TODOS OS MÃDULOS COM O FPGA
  
  // SINAIS
    //sinais do top mesmo
    wire start_f_ed;
    wire start_t_ed; 
    wire stop_f_t_ed;
    wire update_ed;
    reg [5:0]EA; // 6 bits pq sÃ£o 6 valores
  
    //sinais q 'vem' do wrapper
    wire data_1_en;
    wire buffer_empty;
    wire buffer_full;
    wire data_valid_2;
    wire [15:0]data_1, data_2;  
  
    //sinais q 'vem' do dm
    wire[1:0] modulo_w;
  
    //sinais q 'vem' do dcm
    wire clk_1;
    wire clk_2;
    wire [2:0]prog_out;
  
    //sinais q 'vem' do fibonacci
    wire f_en;
    wire f_valid; 
    wire [15:0]f_out;
    
    //sinais q 'vem' do timer
     wire t_en;
     wire t_valid;
     wire [15:0]t_out;
       
  
  // precisa filtrar os sinais do start, stop, update
  edge_detector start_fa (.clock(clk), .reset(rst), .din(start_f), .rising(start_f_ed));
  edge_detector start_ta (.clock(clk), .reset(rst), .din(start_t), .rising(start_t_ed));
  edge_detector astart_f_t (.clock(clk), .reset(rst), .din(stop_f_t), .rising(stop_f_t_ed));
  edge_detector aupdate (.clock(clk), .reset(rst), .din(update), .rising(update_ed));
  
  // mÃ¡quina de estados:
  // 0: S_IDLE, estado inicial em repouso
  // 1: S_COMM_F, estado de produÃ§Ã£o e consumo dos dados do mÃ³dulo Fibonacci
  // 2: S_WAIT_F, estado onde a produÃ§Ã£o de dados do mÃ³dulo Fibonacci Ã© parada temporariamente pois o buffer estÃ¡ cheio
  // 3: S_COMM_T, estado de produÃ§Ã£o e consumo dos dados do mÃ³dulo Timer
  // 4: S_WAIT_T, estado onde a produÃ§Ã£o de dados do mÃ³dulo Timer Ã© parada temporariamente pois o buffer estÃ¡ cheio
  // 5: S_BUF_EMPTY, estado de consumo e esvaziamento do buffer
  
  
always @(posedge clk or posedge rst)
    begin
      if(rst == 1'b1)
      begin
        EA <= 6'd0;
      end
      else
      case(EA)
            6'd0:
            begin
              if(start_f_ed == 1)begin
                EA <= 6'd1; // prod fibonacci
              end
                if(start_t_ed == 1)begin
                  EA <= 6'd3; //prod timer
                end
              end
         6'd1:
	      begin
                if(stop_f_t_ed == 1'b1)begin
                  EA <= 6'd5; // esvaziamento e consumo do buffer
                end
                  if( buffer_full == 1) begin // tem q ver como tu indica isso no wrapper e como isso vem pra ca
                    EA <= 6'd2; //prod fibonacci para temporariamente, buffer cheio
                  end                  
                end               
           
          6'd2:
              begin
                if( buffer_full != 1'b1 ) begin  // em vez daquele not, cooloquei != 1'b1
                  EA <= 6'd1; //prod fibonacci
                end 
               
                  if( stop_f_t_ed == 1)begin
                    EA <= 6'd5;
                  end
                end
          6'd3:
              begin
                if( buffer_full == 1'b1 ) begin  
                  EA <= 6'd4; //prod timer
                end
               
                  if(stop_f_t_ed == 1)begin
                    EA <= 6'd5; //esvaziamento e consumo do buffer
                  end
                end
        6'd4:
              begin
                if( buffer_full != 1'b1 ) begin  
                  EA <= 6'd3; //prod timer
                end
               
                  if(stop_f_t_ed == 1)begin
                    EA <= 6'd5; //esvaziamento e consumo do buffer
                  end
                end
              
          6'd5:
              begin
                if(buffer_empty == 1'b1 && data_valid_2 != 1'b1)begin 
                  EA <= 6'd0; //estado inicial
                end
              end
              endcase
          end
          
   //comando para os led's, eles indicam qual o estado em q a maquina de estados se encontra
  assign led[0] = (EA == 6'd0) ? 1'b1 : 1'b0;
  assign led[1] = (EA == 6'd1) ? 1'b1 : 1'b0;
  assign led[2] = (EA == 6'd2) ? 1'b1 : 1'b0;
  assign led[3] = (EA == 6'd3) ? 1'b1 : 1'b0;
  assign led[4] = (EA == 6'd4) ? 1'b1 : 1'b0;
  assign led[5] = (EA == 6'd5) ? 1'b1 : 1'b0;

   //'instanciar'/ 'colocar as devidas infos nos devidos lugares' do timer, fibonacci, dm e wrapper
   //timer
   assign t_en = (EA == 6'd3 && buffer_full != 1'b1) ? 1'b1 : 1'b0; // pra saber qnd produzir o dado do timer
   //fibonacci
   assign f_en = (EA == 6'd1 && buffer_full != 1'b1) ? 1'b1 : 1'b0;  // pra saber qnd produzir o dado do fibonacci     
   //dm isso é pra luz aparecer certinho
   assign modulo_w = (EA == 6'd1 || EA == 6'd2) ? 2'd1 :  
                     (EA == 6'd3 || EA == 6'd4) ? 2'd2 : 
                     2'd0;
   //wrapper pra saber qnd pegar a data do timer e do fibonacci
   assign data_1 = (EA == 6'd1) ? f_out : 
                   (EA == 6'd3) ? t_out : 
                   16'd0;
   assign data_1_en = f_en || t_en;  
              
          
   //'chamar' os arquivos     
  fibonacci fibonacci_arq(.rst(rst), .clk(clk_1), .f_en(f_en), .f_valid(f_valid), .f_out(f_out));
  timer timer_arq(.rst(rst), .clk(clk_1), .t_en(t_en), .t_valid(t_valid), .t_out(t_out));
  dcm dcm_arq(.rst(rst), .clk(clk), .clk_1(clk_1), .clk_2(clk_2), .update(update_ed), .prog_in(prog), .prog_out(prog_out)); /// tem q ver o nosso dcm ainda pq acho q os sinais n batem todos com esses
  dm dm_arq(.rst(rst), .clk(clk), .prog(prog_out), .data_2(data_2), .dec_ddp(dec_ddp), .an(an), .modulo(modulo_w));
  wrapper wrapper_arq(.rst(rst), .clk_1(clk_1), .clk_2(clk_2), .data_1_en(data_1_en), .data_1(data_1), .buffer_empty(buffer_empty), .buffer_full(buffer_full), .data_valid_2(data_valid_2), .data_2(data_2));
 
 
endmodule
