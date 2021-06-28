module snake_moving
(
	input clk,			
	input rst,			
	
	input left_press,	
	input right_press,
	input up_press,
	input down_press,
	
	output reg [1:0]snake, //snake status, 00:none 01:head 10:body 11:wall
	
	input [9:0]x_pos, //current coordinate(pixel)
	input [9:0]y_pos,

	output [5:0]head_x,
	output [5:0]head_y,
	
	input add_cube, //add length
	input speedRecover,
	
	input [1:0]game_status, //input four game status
	input 	reward_protected,
	input	reward_slowly,
	
	output reg [6:0]cube_num, //current length
	
	output reg hit_body, //hit self
	output reg hit_wall, //hit wall
	input die_flash //game over
);
	
	localparam UP = 2'b00;
	localparam DOWN = 2'b01;
	localparam LEFT = 2'b10;
	localparam RIGHT = 2'b11;
	
	localparam NONE = 2'b00;
	localparam HEAD = 2'b01;
	localparam BODY = 2'b10;
	localparam WALL = 2'b11;
	
    localparam RESTART = 2'b00;
	localparam START = 2'b01;
	localparam PLAY = 2'b10;
	
	reg[31:0]cnt;
	
	wire[1:0]direct;
	reg [1:0]direct_r;
	assign direct = direct_r;
	reg[1:0]direct_next;
	
	reg change_to_left;
	reg change_to_right;
	reg change_to_up;
	reg change_to_down;
	
	reg [5:0]cube_x[15:0];
	reg [5:0]cube_y[15:0];
	reg [15:0]is_exist;
	
	reg addcube_state;
	
	assign head_x = cube_x[0];
	assign head_y = cube_y[0];
	
	parameter speedValue = 12_500_000; //speed control
	
	always @(posedge clk or negedge rst) begin		
		if(!rst)
			direct_r <= RIGHT; //default direction right
		else if(game_status == RESTART) 
		    direct_r <= RIGHT;
		else
			direct_r <= direct_next;
	end

    
	always @(posedge clk or negedge rst) begin
		//default value, length=3, fixed position
		if(!rst) begin
			cnt <= 0;
								
			cube_x[0] <= 10;
			cube_y[0] <= 5;
					
			cube_x[1] <= 9;
			cube_y[1] <= 5;
					
			cube_x[2] <= 8;
			cube_y[2] <= 5;

			cube_x[3] <= 0;
			cube_y[3] <= 0;
					
			cube_x[4] <= 0;
			cube_y[4] <= 0;
					
			cube_x[5] <= 0;
			cube_y[5] <= 0;
					
			cube_x[6] <= 0;
			cube_y[6] <= 0;
					
			cube_x[7] <= 0;
			cube_y[7] <= 0;
					
			cube_x[8] <= 0;
			cube_y[8] <= 0;
					
			cube_x[9] <= 0;
			cube_y[9] <= 0;					
					
			cube_x[10] <= 0;
			cube_y[10] <= 0;
					
			cube_x[11] <= 0;
			cube_y[11] <= 0;
					
            cube_x[12] <= 0;
			cube_y[12] <= 0;
					
			cube_x[13] <= 0;
			cube_y[13] <= 0;
					
			cube_x[14] <= 0;
			cube_y[14] <= 0;
					
			cube_x[15] <= 0;
			cube_y[15] <= 0;

			hit_wall <= 0;
			hit_body <= 0;
		end		

		else if(game_status == RESTART) begin
                    cnt <= 0;
                                                    
                    cube_x[0] <= 10;
                    cube_y[0] <= 5;
                                        
                    cube_x[1] <= 9;
                    cube_y[1] <= 5;
                                        
                    cube_x[2] <= 8;
                    cube_y[2] <= 5;
                    
                    cube_x[3] <= 0;
                    cube_y[3] <= 0;
                                        
                    cube_x[4] <= 0;
                    cube_y[4] <= 0;
                                        
                    cube_x[5] <= 0;
                    cube_y[5] <= 0;
                                        
                    cube_x[6] <= 0;
                    cube_y[6] <= 0;
                                        
                    cube_x[7] <= 0;
                    cube_y[7] <= 0;
                                        
                    cube_x[8] <= 0;
                    cube_y[8] <= 0;
                                        
                    cube_x[9] <= 0;
                    cube_y[9] <= 0;
                                        
                    cube_x[10] <= 0;
                    cube_y[10] <= 0;
                                        
                    cube_x[11] <= 0;
                    cube_y[11] <= 0;
                                        
                    cube_x[12] <= 0;
                    cube_y[12] <= 0;
                                        
                    cube_x[13] <= 0;
                    cube_y[13] <= 0;
                                        
                    cube_x[14] <= 0;
                    cube_y[14] <= 0;
                                        
                    cube_x[15] <= 0;
                    cube_y[15] <= 0;
                    
                    hit_wall <= 0;
                    hit_body <= 0; // snake longest 16                             
        end
		else begin
			cnt <= cnt + 1;
			if(cnt >= speedValue) begin   //move 4 every second
				cnt <= 0;
				//default status play
				if(game_status == PLAY) begin
					//check hit wall
					if(((direct == UP && cube_y[0] == 1)|(direct == DOWN && cube_y[0] == 28)|(direct == LEFT && cube_x[0] == 1)|(direct == RIGHT && cube_x[0] == 38)) && reward_protected == 0)
					   hit_wall <= 1; //hit wall
					//hit body
					else if( reward_protected == 0 &&((cube_y[0] == cube_y[1] && cube_x[0] == cube_x[1] && is_exist[1] == 1)|
							(cube_y[0] == cube_y[2] && cube_x[0] == cube_x[2] && is_exist[2] == 1)|
							(cube_y[0] == cube_y[3] && cube_x[0] == cube_x[3] && is_exist[3] == 1)|
							(cube_y[0] == cube_y[4] && cube_x[0] == cube_x[4] && is_exist[4] == 1)|
							(cube_y[0] == cube_y[5] && cube_x[0] == cube_x[5] && is_exist[5] == 1)|
							(cube_y[0] == cube_y[6] && cube_x[0] == cube_x[6] && is_exist[6] == 1)|
							(cube_y[0] == cube_y[7] && cube_x[0] == cube_x[7] && is_exist[7] == 1)|
							(cube_y[0] == cube_y[8] && cube_x[0] == cube_x[8] && is_exist[8] == 1)|
							(cube_y[0] == cube_y[9] && cube_x[0] == cube_x[9] && is_exist[9] == 1)|
							(cube_y[0] == cube_y[10] && cube_x[0] == cube_x[10] && is_exist[10] == 1)|
							(cube_y[0] == cube_y[11] && cube_x[0] == cube_x[11] && is_exist[11] == 1)|
							(cube_y[0] == cube_y[12] && cube_x[0] == cube_x[12] && is_exist[12] == 1)|
							(cube_y[0] == cube_y[13] && cube_x[0] == cube_x[13] && is_exist[13] == 1)|
							(cube_y[0] == cube_y[14] && cube_x[0] == cube_x[14] && is_exist[14] == 1)|
							(cube_y[0] == cube_y[15] && cube_x[0] == cube_x[15] && is_exist[15] == 1)))
							hit_body <= 1;
					else begin
						cube_x[1] <= cube_x[0];
						cube_y[1] <= cube_y[0];
										
						cube_x[2] <= cube_x[1];
						cube_y[2] <= cube_y[1];
										
						cube_x[3] <= cube_x[2];
						cube_y[3] <= cube_y[2];
										
						cube_x[4] <= cube_x[3];
						cube_y[4] <= cube_y[3];
										
						cube_x[5] <= cube_x[4];
						cube_y[5] <= cube_y[4];
										
						cube_x[6] <= cube_x[5];
						cube_y[6] <= cube_y[5];
										
						cube_x[7] <= cube_x[6];
						cube_y[7] <= cube_y[6];
										
						cube_x[8] <= cube_x[7];
						cube_y[8] <= cube_y[7];
										
						cube_x[9] <= cube_x[8];
						cube_y[9] <= cube_y[8];
										
						cube_x[10] <= cube_x[9];
						cube_y[10] <= cube_y[9];
										
						cube_x[11] <= cube_x[10];
						cube_y[11] <= cube_y[10];
										
						cube_x[12] <= cube_x[11];
						cube_y[12] <= cube_y[11];
										 
						cube_x[13] <= cube_x[12];
						cube_y[13] <= cube_y[12];
										
						cube_x[14] <= cube_x[13];
						cube_y[14] <= cube_y[13];
										
						cube_x[15] <= cube_x[14];
						cube_y[15] <= cube_y[14];
						case(direct)							
							UP:
							begin
							    if(cube_y[0] == 1 && reward_protected == 0)
									hit_wall <= 1;
								else
									cube_y[0] <= cube_y[0]-1;
							end
							DOWN:
							begin
								if(cube_y[0] == 28 && reward_protected == 0)
									hit_wall <= 1;
								else
									cube_y[0] <= cube_y[0] + 1;
							end		
							LEFT:
							begin
								if(cube_x[0] == 1 && reward_protected == 0)
									hit_wall <= 1;
								else
									cube_x[0] <= cube_x[0] - 1;											
							end
							RIGHT:
							begin
								if(cube_x[0] == 38 && reward_protected == 0)
									hit_wall <= 1;
                                else
									cube_x[0] <= cube_x[0] + 1;
							end
						endcase
					end
				end
			end
		end
	end
	
	always @(*) begin
		direct_next = direct;		
        case(direct)	
		    UP:
			begin
			    if(change_to_left)
				    direct_next = LEFT;
			    else if(change_to_right)
				    direct_next = RIGHT;
			    else
				    direct_next = UP;			
		    end
		    DOWN:
			begin
			    if(change_to_left)
				    direct_next = LEFT;
			    else if(change_to_right)
			        direct_next = RIGHT;
			    else
				    direct_next = DOWN;			
		    end
		    LEFT:
			begin
			    if(change_to_up)
				    direct_next = UP;
			    else if(change_to_down)
    			    direct_next = DOWN;
			    else
				    direct_next = LEFT;			
		    end
		    RIGHT:
			begin
			    if(change_to_up)
				    direct_next = UP;
			    else if(change_to_down)
				    direct_next = DOWN;
			    else
				    direct_next = RIGHT;
		    end	
	    endcase
	end
	
	always @(posedge clk) begin
		if(left_press == 1)
			change_to_left <= 1;
		else if(right_press == 1)
			change_to_right <= 1;
		else if(up_press == 1)
			change_to_up <= 1;
		else if(down_press == 1)
			change_to_down <= 1;
		else begin
			change_to_left <= 0;
			change_to_right <= 0;
			change_to_up <= 0;
			change_to_down <= 0;
		end
	end
	
	always @(posedge clk or negedge rst) begin
//after eat apple cube + 1
		if(!rst) begin
			is_exist <= 16'd7;
			cube_num <= 3;
			addcube_state <= 0;
		end  
		else if (game_status == RESTART) begin
		      is_exist <= 16'd7;
              cube_num <= 3;
              addcube_state <= 0;
         end
		else begin			
			case(addcube_state) //check apple == snake head
				0:
				begin
					if(add_cube) begin
						cube_num <= cube_num + 1;
						is_exist[cube_num] <= 1;
						addcube_state <= 1; //eat signal
					end						
				end
				1:
				begin
					if(!add_cube)
						addcube_state <= 0;				
				end
			endcase
		end
	end
	
	reg[3:0]lox;
	reg[3:0]loy;
	
	always @(x_pos or y_pos ) begin				
		if(x_pos >= 0 && x_pos < 640 && y_pos >= 0 && y_pos < 480) begin
			if(x_pos[9:4] == 0 | y_pos[9:4] == 0 | x_pos[9:4] == 39 | y_pos[9:4] == 29)
				snake = WALL;
			else if(x_pos[9:4] == cube_x[0] && y_pos[9:4] == cube_y[0] && is_exist[0] == 1) 
				snake = (die_flash == 1) ? HEAD : NONE;
			else if
				((x_pos[9:4] == cube_x[1] && y_pos[9:4] == cube_y[1] && is_exist[1] == 1)|
				 (x_pos[9:4] == cube_x[2] && y_pos[9:4] == cube_y[2] && is_exist[2] == 1)|
				 (x_pos[9:4] == cube_x[3] && y_pos[9:4] == cube_y[3] && is_exist[3] == 1)|
				 (x_pos[9:4] == cube_x[4] && y_pos[9:4] == cube_y[4] && is_exist[4] == 1)|
				 (x_pos[9:4] == cube_x[5] && y_pos[9:4] == cube_y[5] && is_exist[5] == 1)|
				 (x_pos[9:4] == cube_x[6] && y_pos[9:4] == cube_y[6] && is_exist[6] == 1)|
				 (x_pos[9:4] == cube_x[7] && y_pos[9:4] == cube_y[7] && is_exist[7] == 1)|
				 (x_pos[9:4] == cube_x[8] && y_pos[9:4] == cube_y[8] && is_exist[8] == 1)|
				 (x_pos[9:4] == cube_x[9] && y_pos[9:4] == cube_y[9] && is_exist[9] == 1)|
				 (x_pos[9:4] == cube_x[10] && y_pos[9:4] == cube_y[10] && is_exist[10] == 1)|
				 (x_pos[9:4] == cube_x[11] && y_pos[9:4] == cube_y[11] && is_exist[11] == 1)|
				 (x_pos[9:4] == cube_x[12] && y_pos[9:4] == cube_y[12] && is_exist[12] == 1)|
				 (x_pos[9:4] == cube_x[13] && y_pos[9:4] == cube_y[13] && is_exist[13] == 1)|
				 (x_pos[9:4] == cube_x[14] && y_pos[9:4] == cube_y[14] && is_exist[14] == 1)|
				 (x_pos[9:4] == cube_x[15] && y_pos[9:4] == cube_y[15] && is_exist[15] == 1))
				 snake = (die_flash == 1) ? BODY : NONE;
			else snake = NONE;
		end
	end
endmodule