include constants.v;
include nw.v;

// We're going to use a hard-wired length of 4 here
localparam HLENGTH = 4;

// Instantiate compute grid with hard-wired inputs
//wire signed[(HLENGTH+1)*SWIDTH-1:0] bottom_scores[HLENGTH:0] = {0, -1, -2, -3, -4};
//wire signed[HLENGTH*SWIDTH-1:0] right_scores[HLENGTH-1:0] = {-1, -2, -3, -4};
//wire signed[(HLENGTH+1)*SWIDTH-1:0] bottom_scores = {16'd0, -16'd1, -16'd2, -16'd3, -16'd4};
wire signed[(HLENGTH+1)*SWIDTH-1:0] bottom_scores = {-16'd4, -16'd3, -16'd2, -16'd1, 16'd0};
wire signed[HLENGTH*SWIDTH-1:0] right_scores = {-16'd4, -16'd3, -16'd2, -16'd1};
//wire signed[HLENGTH*SWIDTH-1:0] right_scores = {-1, -2, -3, -4};

wire [HLENGTH*CWIDTH-1:0] s1 = {A, T, C, G};
wire [HLENGTH*CWIDTH-1:0] s2 = {A, T, C, G};

wire signed[(HLENGTH+1)*SWIDTH-1:0] top_scores;
wire signed[HLENGTH*SWIDTH-1:0] left_scores;

wire done;
Grid#(
  .LENGTH(HLENGTH),
  .CWIDTH(CWIDTH),
  .SWIDTH(SWIDTH),
  .MATCH(MATCH),
  .INDEL(INDEL),
  .MISMATCH(MISMATCH)
) g (
  .clk(clock.val),
  .top_scores(bottom_scores),
  .left_scores(right_scores),
  .s1(s1),
  .s2(s2),
  .valid(1),
  .bottom_scores(top_scores),
  .right_scores(left_scores)
);

//initial begin
  //$display("initial");
  //for (i = 0; i < HLENGTH+1; i = i+1) begin
    //bottom_scores[i*SWIDTH +:SWIDTH] = HLENGTH - i;
    //$display(bottom_scores[i*SWIDTH +:SWIDTH]);
  //end
//end

// Time out after 16 cycles
reg [3:0] count = 0;

// Print the result. We should see:
//  1  0 -1 -2
//  0  2  1  0
// -1  1  3  2
// -2  0  2  4
// after you replace the "..." below with signals for the
// grid elements in your top level module
wire signed[SWIDTH-1:0] bt_sc = bottom_scores[SWIDTH +:SWIDTH];
wire [SWIDTH-1:0] bt_sc3 = -1;
//reg signed[SWIDTH-1:0] bt_sc2 = bt_sc3[0+:SWIDTH];
reg signed[SWIDTH-1:0] bt_sc2;

always @(posedge clock.val) begin
  bt_sc2 <= bt_sc3[0+:SWIDTH];
  $display("n: %b", bottom_scores);
  $display("n: %b", bottom_scores[SWIDTH +:SWIDTH]);
  $display("n: %b", bt_sc);
  $display("n: %d", bt_sc);
  $display("n: %d", bt_sc2);
  $display("n: %b", bt_sc2);
  $display(right_scores);
  $display("=======================================================");
  $display("above");

  $display("%d", g.interconnect[0][0]);
  $display("%d %d %d", g.outer_cells[0].inner_cells[1].c.above,
                          g.outer_cells[0].inner_cells[1].c.left,
                          g.outer_cells[0].inner_cells[1].c.corner);

  $display("%d %d %d %d", g.outer_cells[0].inner_cells[0].c.above,
                          g.outer_cells[0].inner_cells[1].c.above,
                          g.outer_cells[0].inner_cells[2].c.above,
                          g.outer_cells[0].inner_cells[3].c.above
  );
  $display("=======================================================");
  $display("%d %d %d %d", g.outer_cells[0].inner_cells[0].c.score,
                          g.outer_cells[0].inner_cells[1].c.score,
                          g.outer_cells[0].inner_cells[2].c.score,
                          g.outer_cells[0].inner_cells[3].c.score
  );
  $display("%d %d %d %d", g.outer_cells[1].inner_cells[0].c.score,
                          g.outer_cells[1].inner_cells[1].c.score,
                          g.outer_cells[1].inner_cells[2].c.score,
                          g.outer_cells[1].inner_cells[3].c.score
  );
  $display("%d %d %d %d", g.outer_cells[2].inner_cells[0].c.score,
                          g.outer_cells[2].inner_cells[1].c.score,
                          g.outer_cells[2].inner_cells[2].c.score,
                          g.outer_cells[2].inner_cells[3].c.score
  );
  $display("%d %d %d %d", g.outer_cells[3].inner_cells[0].c.score,
                          g.outer_cells[3].inner_cells[1].c.score,
                          g.outer_cells[3].inner_cells[2].c.score,
                          g.outer_cells[3].inner_cells[3].c.score
  );

  count <= (count + 1);
  if (done | (&count)) begin
    $finish(1);
  end
end