module lab_top
#(
    parameter CLK       = 100,
              KEY       = 2,
              SW        = 16,
              LED       = 16,
              DIGIT     = 4
)
(
input                   clk,                       
input                   rst,

//- - - - - Keys,Switches,LEDs - - - - - - - 

input        [KEY-1:0]   key,
input        [SW- 1:0]   sw,
output logic [LED-1:0]   led,

//- - - - - Seven Seg Display - - - - - - - 

output logic [      7:0] abcdefgh,
output logic [DIGIT-1:0] digit
);

//assign abcdefgh         = '0;
//assign led              = '0;
//assign digit            = '0;

wire enable;
wire [1:0] fsm_in;
wire [1:0] moore_fsm_out;

wire [2:0] moore_state_out;


strobe_gen
#(.CLK_MHZ(CLK), .STRB_HZ(3))
sub_strobe_gen
(.strobe(enable), .*);

shift_reg
#(.D(LED))
sub_shift_reg
(
 .en       (enable),
 .shft_in  (   key),
 .shft_out (fsm_in),
 .shft_reg (   led),
 .*
 );
 
 moore_fsm sub_moore_fsm
 (.en          (       enable),
  .in_moore    (       fsm_in),
  .out_moore   (moore_fsm_out),
  .state_moore (moore_state_out),
  .*
  );
  

/*always_comb
begin
case(moore_fsm_out)
  2'd0: abcdefgh = 8'b1111_1100;
  2'd2: abcdefgh = 8'b1101_1010;
  2'd3: abcdefgh = 8'b1111_0010;
endcase 
digit = DIGIT'(1);
end*/

always_comb
begin
case(moore_state_out)
  3'b000:   abcdefgh = 8'b1111_1100;
  3'b001:   abcdefgh = 8'b0110_0000;
  3'b010:   abcdefgh = 8'b1101_1010;
  3'b011:   abcdefgh = 8'b1111_0010;
  3'b100:   abcdefgh = 8'b0110_0110;
  default:  abcdefgh = 8'b0000_0000;
endcase 
digit = DIGIT'(2);
end

endmodule 