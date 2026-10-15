class siv_io_test extends siv_pcie_base_test;
  `uvm_component_utils(siv_io_test)
  // ------------------------------------------------------------
  // Environment
  // ------------------------------------------------------------
  // ------------------------------------------------------------
  // Sequences
  // ------------------------------------------------------------
  io_wr_rd_seq  rc_seq;
  io_wr_rd_seq  ep_seq;
  reg_seq            regseq;

  // ------------------------------------------------------------
  // Constructor
  // ------------------------------------------------------------
  function new(string name="siv_io_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  // ------------------------------------------------------------
  // Build phase
  // ------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create sequences
   // rc_seq    = io_wr_rd_seq ::type_id::create("rc_seq");
   // ep_seq    = io_wr_rd_seq ::type_id::create("ep_seq");
  endfunction
  // ----------------------------------------
  // Task to Run TL sequences
  // ----------------------------------------
  task run_TL(uvm_phase phase);
    // Create all sequences
    regseq = reg_seq::type_id::create("regseq");
    rc_seq = io_wr_rd_seq::type_id::create("rc_seq");
    ep_seq = io_wr_rd_seq::type_id::create("ep_seq");
    phase.raise_objection(this);
    regseq.start(env.magent.sqr);
    fork
      begin 
        rc_seq.start(env.rc_agent.tl_agent.sequencer);
        ep_seq.start(env.ep_agent.tl_agent.sequencer);
      end
    join
    phase.drop_objection(this);   
  endtask

  // ----------------------------------------
  // Task to Run DL sequences
  // ----------------------------------------
  task run_DL(uvm_phase phase);
  super.run_DL(phase);
  endtask
  // ----------------------------------------
  // Task to Run PL sequences
  // ----------------------------------------
  task run_PL(uvm_phase phase);
   super.run_PL(phase);
  endtask
  // Run phase: launch all three "primary" sequences in parallel
  // ----------------------------------------
  // Run ALL layer sequences
  // ----------------------------------------
  task run_phase(uvm_phase phase);
    fork
      run_TL(phase);
      run_DL(phase);
      run_PL(phase);
    join
  endtask
endclass
