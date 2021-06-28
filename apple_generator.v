module apple_generator
(
	input clk,
	input rst,
	
	input [5:0]head_x,
	input [5:0]head_y,
	output reg [5:0]apple_x,
	output reg [4:0]apple_y,
	output reg [7:0]score,
	output reg add_cube
);
	reg [31:0]clk_cnt;
	reg [10:0]random_num;
	reg add_score_state;
	always@(posedge clk)
		random_num <= random_num + 998; 
	
	always@(posedge clk or negedge rst) begin
		if(!rst) begin
			score <= 8'h00;
			add_score_state <= 0;
		end
		else begin
			case(add_score_state)
			0:
			begin
				if(add_cube) begin
					score <= score + 8'h01;
					add_score_state <= 1;
				end
			end
			1:
			begin
				if(!add_cube)
					add_score_state <= 0;
			end
			endcase
		end
	end
	
	always@(posedge clk or negedge rst) begin
		if(!rst) begin
			clk_cnt <= 0;
			apple_x <= 24;
			apple_y <= 10;
			add_cube <= 0;
		end
		else begin
			clk_cnt <= clk_cnt+1;
			if(clk_cnt == 250_000) begin
				clk_cnt <= 0;
				if(apple_x == head_x && apple_y == head_y) 
				begin
					add_cube <= 1;
					apple_x <= {1'b0, (random_num[9:5] == 0 ? 2 : random_num[9:5])};
					apple_y <= (random_num[4:0] > 24) ? (random_num[4:0] - 10) : (random_num[4:0] == 0) ? 1:random_num[4:0];
				end
				else
					add_cube <= 0;
			end
		end
	end
endmodule