
class generator;
  transaction trans;
  mailbox gen2driv;

  function new(mailbox gen2driv);
    this.gen2driv = gen2driv;
  endfunction

  task main();

    // Original 100 randomized tests
    repeat (100) begin
      trans = new();
      trans.randomize();
      trans.display("Generator");
      gen2driv.put(trans);
    end

    // Directed test 1: SUB (5 - 5 = 0)
    trans = new();
    trans.a = 4'd5;
    trans.b = 4'd5;
    trans.op_code = 3'b001;
    trans.display("Generator - SUB zero");
    gen2driv.put(trans);

    // Directed test 2: OR (0 | 0 = 0)
    trans = new();
    trans.a = 4'd0;
    trans.b = 4'd0;
    trans.op_code = 3'b011;
    trans.display("Generator - OR zero");
    gen2driv.put(trans);

    // Directed test 3: NOT (~15 = 0, 4-bit result)
    trans = new();
    trans.a = 4'd15;
    trans.b = 4'd0;
    trans.op_code = 3'b101;
    trans.display("Generator - NOT zero");
    gen2driv.put(trans);

    // Directed test 4: RIGHT SHIFT (1 >> 1 = 0)
    trans = new();
    trans.a = 4'd1;
    trans.b = 4'd1;
    trans.op_code = 3'b111;
    trans.display("Generator - RIGHT SHIFT zero");
    gen2driv.put(trans);

  endtask
endclass
