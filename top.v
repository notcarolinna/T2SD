module top 
#(parameter HALF_MS_COUNT = 500)
(
  input rst, // reset do módulo que é ativo alto (‘1’)
  input clk, //clock de referência deste módulo síncrono que opera a 100 MHz
  input start_f,//o botão que indica o início ou continuação da produção de dados pelo módulo Fibonacc
  input start_t, // botão que indica o início ou continuação da produção de dados pelo módulo Timer
  input stop_f_t,//botão que indica a parada de produção de dados dos módulos Fibonacci e Timer
  input update, //botão que indica que o clock lento deve ser atualizado para a frequência indicada pelo valor prog
  input [2:0]prog, //indica qual frequência o clock lento deve operar
  
  output [5:0]led,//sinal visual que indica em que estado da máquina de estado o sistema está operando
  output [7:0]an, //controla a ativação de cada um dos displays disponíveis no FPGA
  output [7:0]dec_ddp //valor decodificado do dígito de 8 bits a ser mostrado no instante atual pelo display
);
  
  
  // FAZ A LIGAÇÃO DE TODOS OS MÓDULOS COM O FPGA
  
  // SINAIS
    //sinais do top mesmo
    wire start_f_ed;
    wire start_t_ed; 
    wire stop_f_t_ed;
    wire update_ed;
    reg [5:0]EA; // 6 bits pq são 6 valores
  
    //sinais q 'vem' do wrapper
    wire data_1_en;
    wire buffer_empty;
    wire buffer_full;
    wire data_2_valid;
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
  edge_detector start_f (.clock(clk), .reset(rst), .din(start_f), .rising(start_f_ed));
  edge_detector start_t (.clock(clk), .reset(rst), .din(start_t), .rising(start_t_ed));
  edge_detector start_f_t (.clock(clk), .reset(rst), .din(start_f_t), .rising(start_f_t_ed));
  edge_detector update (.clock(clk), .reset(rst), .din(update), .rising(update_ed));
  
  // máquina de estados:
  // 1: S_IDLE, estado inicial em repouso
  // 2: S_COMM_F, estado de produção e consumo dos dados do módulo Fibonacci
  // 3: S_WAIT_F, estado onde a produção de dados do módulo Fibonacci é parada temporariamente pois o buffer está cheio
  // 4: S_COMM_T, estado de produção e consumo dos dados do módulo Timer
  // 5: S_WAIT_T, estado onde a produção de dados do módulo Timer é parada temporariamente pois o buffer está cheio
  // 6: S_BUF_EMPTY, estado de consumo e esvaziamento do buffer
  
  
  always @(posedge clk or posedge rst)
    begin
      if(rst == 1)begin
        EA <= 6'd1; // estado inicial
      end
      else begin
        case (EA)
          6'd1: // estado inicial
            begin
              if(start_f_ed == 1)begin
                EA <= 6'd2; // prod fibonacci
              end
              else begin
                if(start_t_ed == 1)begin
                  EA <= 6'd4; //prod timer
                end
              end
         
         2'62:
              begin
                if(stop_f_t_ed == 1)begin
                  EA <= 6'd6; // esvaziamento e consumo do buffer
                end
                else begin
                  if( buffer_full == 1) begin // tem q ver como tu indica isso no wrapper e como isso vem pra ca
                    EA <= 6'd3; //prod fibonacci para temporariamente, buffer cheio
                  end                  
                end                
              end
           
          6'd3:
              begin
                if( not buffer_full ) begin  // tem q ver como tu indica isso no wrapper e como isso vem pra ca
                  EA <= 6'd2; //prod fibonacci
                end 
                else begin
                  if( stop_f_t_ed == 1)begin
                    EA <= 6'd2; // prod fibonacci
                  end
                end
              end  
            
           2'64:
              begin
                if(stop_f_t_ed == 1)begin
                  EA <= 6'd6; //esvaziamento e consumo do buffer
                end
                else begin
                  if( buffer_full == 1) begin // tem q ver como tu indica isso no wrapper e como isso vem pra ca
                    EA <= 6'd5; //prod timer para temporariamente, buffer cheio
                  end
                end
              end
              
          6'd5:
              begin
                if( not buffer_full ) begin  // tem q ver como tu indica isso no wrapper e como isso vem pra ca
                  EA <= 6'd4; //prod timer
                end
                else begin
                  if(stop_f_t_ed == 1)begin
                    EA <= 6'd6; //esvaziamento e consumo do buffer
                  end
                end
              end
              
          6'd6:
              begin
                if(  buffer_empty and not data_2_valid)begin // ver como isso vem parar aqui
                  EA <= 6'd1; //estado inicial
                end
              end
              endcase
          end
      end    
   end
          
   //comando para os led's, eles indicam qual o estado em q a maquina de estados se encontra
   assign led[0] = (EA == 6'd0) ? 1'b1 : 
          led[1] = (EA == 6'd1) ? 1'b1 :
          led[2] = (EA == 6'd2) ? 1'b1 :
          led[3] = (EA == 6'd3) ? 1'b1 :
          led[4] = (EA == 6'd4) ? 1'b1 :
          led[5] = (EA == 6'd5) ? 1'b1 :
          1'b0;
          
   //'instanciar'/ 'colocar as devidas infos nos devidos lugares' do timer, fibonacci, dm e wrapper
   //timer
   assign t_en = (EA == 6'd3 && buffer_full != 1'b1) ? 1'b1 : 1'b0; // pra saber qnd produzir o dado do timer
   //fibonacci
   assign f_en = (EA == 6'd1 && buffer_full != 1'b1) ? 1'b1 : 1'b0;  // pra saber qnd produzir o dado do fibonacci     
   //dm
   assign modulo_w = (EA == 6'd1 || EA == 6'd2) ? 2'd1 :  // HELPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
                     (EA == 6'd3 || EA == 6'd4) ? 2'd2 : 
                     2'd0;
   //wrapper
   assign data_1 = (EA == 6'd1) ? f_out : 
                   (EA == 6'd3) ? t_out : 
                   16'd0;
   assign data_1_en = f_en || t_en;  /// ISSo pode????
              
          
   //'chamar' os arquivos     
  fibonacci fibonacci_arq(.rst(rst), .clk(clk_1), .f_en(f_en), .f_valid(f_valid), .f_out(f_out));
  timer timer_arq(.rst(rst), .clk(clk_1), .t_en(t_en), .t_valid(t_valid), .t_out(t_out));
  dcm dcm_arq(.rst(rst), .clk(clock), .clk_1(clk_1), .clk_2(clk_2), .update(update_ed), .prog_in(prog), .prog_out(prog_out)); /// tem q ver o nosso dcm ainda pq acho q os sinais n batem todos com esses
  dm dm_arq(.rst(rst), .clk(clk), .prog(prog_out), .data_2(data_2), .dec_ddp(dec_ddp), .an(an), .modulo(modulo_w));
  wrapper wrapper_arq(.rst(rst), .clk_1(clk_1), .clk_2(clk_2), .data_1_en(data_1_en), .data_1(data_1), .buffer_empty(buffer_empty), .buffer_full(buffer_full), .data_2_valid(data_2_valid), .data_2(data_2));
 
   
   
 
endmodule
