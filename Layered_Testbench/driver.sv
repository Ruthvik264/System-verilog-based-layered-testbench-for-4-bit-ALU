class driver;
  virtual intf vif;
  mailbox gen2driv;

  function new(virtual intf vif, mailbox gen2driv);
    this.vif = vif;
    this.gen2driv = gen2driv;
  endfunction

  task main();
    transaction trans;
    repeat(104)
      begin
        gen2driv.get(trans);
        vif.a       <= trans.a;
        vif.b       <= trans.b;
        vif.op_code <= trans.op_code;

        #3;
        trans.y     = vif.y;
        trans.carry = vif.carry;
        trans.zero  = vif.zero;
        trans.display("Driver");

        #2;
      end
  endtask
endclass
