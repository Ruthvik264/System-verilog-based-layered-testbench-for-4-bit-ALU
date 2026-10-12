class monitor;
  virtual intf vif;
  mailbox mon2scb;

  function new(virtual intf vif, mailbox mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction

  task main;
    transaction trans;
    repeat(104)
      begin
        #3;
        trans = new();

        trans.a       = vif.a;
        trans.b       = vif.b;
        trans.op_code = vif.op_code;

        trans.y       = vif.y;
        trans.carry   = vif.carry;
        trans.zero    = vif.zero;

        mon2scb.put(trans);
        trans.display("Monitor");

        #2;
      end
  endtask
endclass
