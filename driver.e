
   Sample driver.e file
   --------------------
   This file provides the basic structure for the calc1 testbench
   driver.

   The driver interacts directly with the DUV by driving test data into
   the DUV and collecting the response from the DUV. It also invokes the
   instruction specific response checker.

<'

import scoreboard;

unit driver_u {

   clk_p : inout simple_port of bit is instance; // can be driven or read by sn
   keep clk_p.hdl_path() == "~/calc1_sn/c_clk";

   reset_p : out simple_port of uint(bits:7) is instance; // driven by sn
   keep reset_p.hdl_path() == "~/calc1_sn/reset";

   req1_cmd_in_p : out simple_port of uint(bits:4) is instance; // driven by sn
   keep req1_cmd_in_p.hdl_path() == "~/calc1_sn/req1_cmd_in";

   req1_data_in_p : out simple_port of uint(bits:32) is instance; // driven by sn
   keep req1_data_in_p.hdl_path() == "~/calc1_sn/req1_data_in";

   req2_cmd_in_p : out simple_port of uint(bits:4) is instance; // driven by sn
   keep req2_cmd_in_p.hdl_path() == "~/calc1_sn/req2_cmd_in";

   req2_data_in_p : out simple_port of uint(bits:32) is instance; // driven by sn
   keep req2_data_in_p.hdl_path() == "~/calc1_sn/req2_data_in";

   req3_cmd_in_p : out simple_port of uint(bits:4) is instance; // driven by sn
   keep req3_cmd_in_p.hdl_path() == "~/calc1_sn/req3_cmd_in";

   req3_data_in_p : out simple_port of uint(bits:32) is instance; // driven by sn
   keep req3_data_in_p.hdl_path() == "~/calc1_sn/req3_data_in";

   req4_cmd_in_p : out simple_port of uint(bits:4) is instance; // driven by sn
   keep req4_cmd_in_p.hdl_path() == "~/calc1_sn/req4_cmd_in";

   req4_data_in_p : out simple_port of uint(bits:32) is instance; // driven by sn
   keep req4_data_in_p.hdl_path() == "~/calc1_sn/req4_data_in";

   out_resp1_p : in simple_port of uint(bits:2) is instance; // read by sn
   keep out_resp1_p.hdl_path() == "~/calc1_sn/out_resp1";

   out_data1_p : in simple_port of uint(bits:32) is instance; // read by sn
   keep out_data1_p.hdl_path() == "~/calc1_sn/out_data1";

   out_resp2_p : in simple_port of uint(bits:2) is instance; // read by sn
   keep out_resp2_p.hdl_path() == "~/calc1_sn/out_resp2";

   out_data2_p : in simple_port of uint(bits:32) is instance; // read by sn
   keep out_data2_p.hdl_path() == "~/calc1_sn/out_data2";

   out_resp3_p : in simple_port of uint(bits:2) is instance; // read by sn
   keep out_resp3_p.hdl_path() == "~/calc1_sn/out_resp3";

   out_data3_p : in simple_port of uint(bits:32) is instance; // read by sn
   keep out_data3_p.hdl_path() == "~/calc1_sn/out_data3";

   out_resp4_p : in simple_port of uint(bits:2) is instance; // read by sn
   keep out_resp4_p.hdl_path() == "~/calc1_sn/out_resp4";

   out_data4_p : in simple_port of uint(bits:32) is instance; // read by sn
   keep out_data4_p.hdl_path() == "~/calc1_sn/out_data4";

   instructions_to_drive_serial   : list of instruction_s;
   instructions_to_drive_parallel2 : list of instruction_parallel2_s;
   instructions_to_drive_parallel4 : list of instruction_parallel4_s;

   scrboard : scoreboard_u is instance;


   event clk is fall(clk_p$)@sim;
   event resp1 is change(out_resp1_p$)@sim;
   event resp2 is change(out_resp2_p$)@sim;
   event resp3 is change(out_resp3_p$)@sim;
   event resp4 is change(out_resp4_p$)@sim;


   drive_reset() @clk is {
      var i : int;

      for { i=0; i<=8; i+=1 } do {

         reset_p$ = 1111111;
         wait cycle;

      }; // for

      reset_p$ = 0000000;

   }; // drive_reset

   new_queue_entry(ins : instruction_s) is {
       var new_entry : queue_entry = new;
       var exp_resp : expected_resp = new;

       //exp_resp.val  = ins.get_exp_data(ins);
       exp_resp.port = ins.port;

       new_entry.size = 1;
       new_entry.entry.add(exp_resp);
       scrboard.add_new_entry(scrboard, new_entry);
   };

   new_queue_entry4(ins4 : instruction_parallel4_s) is {
       var new_entry : queue_entry = new;

       var exp_resp1 : expected_resp = new;
       var exp_resp2 : expected_resp = new;
       var exp_resp3 : expected_resp = new;
       var exp_resp4 : expected_resp = new;

       exp_resp1.port = 1;
       exp_resp2.port = 2;
       exp_resp3.port = 3;
       exp_resp4.port = 4;

       new_entry.size = 4;
       new_entry.entry.add(exp_resp1);
       new_entry.entry.add(exp_resp2);
       new_entry.entry.add(exp_resp3);
       new_entry.entry.add(exp_resp4);
       scrboard.add_new_entry(scrboard, new_entry);
   };

    put_data_on_port(port: uint(bits:3), cmd: opcode_t, data: uint(bits:32)) is {
       case port {
      1: {
        req1_cmd_in_p$  = pack(NULL, cmd);
        req1_data_in_p$ = pack(NULL, data);
      };

      2: {
        req2_cmd_in_p$  = pack(NULL, cmd);
        req2_data_in_p$ = pack(NULL, data);
      };

      3: {
        req3_cmd_in_p$  = pack(NULL, cmd);
        req3_data_in_p$ = pack(NULL, data);
      };

      4: {
        req4_cmd_in_p$  = pack(NULL, cmd);
        req4_data_in_p$ = pack(NULL, data);
      };
      };

    };


   drive_instruction(ins : instruction_s, i : int) @clk is {

       new_queue_entry(ins);

       // display generated command and data
       outf("TEST %s\n", i);
       outf("Command = %s\n", ins.cmd_in);
       out("Op1     = ", ins.din1);
       out("Op2     = ", ins.din2);
       out("Port    = ", ins.port);
       out();
      put_data_on_port(ins.port, ins.cmd_in, ins.din1);
      wait cycle;
      put_data_on_port(ins.port, NOP, ins.din2);

      // case ins.port {
      //1: {
      //  // drive data into calculator port 1
      //  //scoreboard.add_to_queue(1);
      //  //req1_cmd_in_p$  = pack(NULL, ins.cmd_in);
      //  //req1_data_in_p$ = pack(NULL, ins.din1);
      //  //wait cycle;
      //  //req1_cmd_in_p$  = 0000;
      //  //req1_data_in_p$ = pack(NULL, ins.din2);
      //  put_data_on_port(1, ins.cmd_in, ins.din1);
      //  wait cycle;
      //  put_data_on_port(1, NOP, ins.din2);
      //};

      //2: {
      //  // drive data into calculator port 1
      //  //scoreboard.add_to_queue(2);
      //  req2_cmd_in_p$  = pack(NULL, ins.cmd_in);
      //  req2_data_in_p$ = pack(NULL, ins.din1);
      //  wait cycle;
      //  req2_cmd_in_p$  = 0000;
      //  req2_data_in_p$ = pack(NULL, ins.din2);
      //};

      //3: {
      //  // drive data into calculator port 1
      //  //scoreboard.add_to_queue(3);
      //  //req3_cmd_in_p$  = pack(NULL, ins.cmd_in);
      //  //req3_data_in_p$ = pack(NULL, ins.din1);
      //  wait cycle;
      //  //req3_cmd_in_p$  = 0000;
      //  req3_data_in_p$ = pack(NULL, ins.din2);
      //};

      //4: {
      //  // drive data into calculator port 1
      //  //scoreboard.add_to_queue(4);
      //  req4_cmd_in_p$  = pack(NULL, ins.cmd_in);
      //  req4_data_in_p$ = pack(NULL, ins.din1);
      //  wait cycle;
      //  req4_cmd_in_p$  = 0000;
      //  req4_data_in_p$ = pack(NULL, ins.din2);
      //};
    //};
   }; // drive_instruction

   drive4_instructions(ins4 : instruction_parallel4_s, i : int) @clk is {

       new_queue_entry4(ins4);

      // display generated command and data
      outf("TEST %s", i);
      outf("Command1 = %s\n", ins4.cmd_in1);
      out("data1_in1     = ", ins4.din1_1);
      out("data2_in1     = ", ins4.din2_1);
      out("Port1\n");
      outf("Command2 = %s\n", ins4.cmd_in2);
      out("data1_in2     = ", ins4.din1_2);
      out("data2_in2     = ", ins4.din2_2);
      out("Port2\n");
      outf("Command3 = %s\n", ins4.cmd_in3);
      out("data1_in3     = ", ins4.din1_3);
      out("data2_in3     = ", ins4.din2_3);
      out("Port3\n");
      outf("Command4 = %s\n", ins4.cmd_in4);
      out("data1_in4     = ", ins4.din1_4);
      out("data2_in4     = ", ins4.din2_4);
      out("Port4\n");
      out();

      // drive data into calculator port 1
      //scoreboard.add_to_queue(1);
      put_data_on_port(1, ins4.cmd_in1, ins4.din1_1);
      put_data_on_port(2, ins4.cmd_in2, ins4.din1_2);
      put_data_on_port(3, ins4.cmd_in3, ins4.din1_3);
      put_data_on_port(4, ins4.cmd_in4, ins4.din1_4);
      wait cycle;
      put_data_on_port(1, NOP, ins4.din2_1);
      put_data_on_port(2, NOP, ins4.din2_2);
      put_data_on_port(3, NOP, ins4.din2_3);
      put_data_on_port(4, NOP, ins4.din2_4);
      //req1_cmd_in_p$  = pack(NULL, ins4.cmd_in1);
      //req1_data_in_p$ = pack(NULL, ins4.din1_1);
      //req2_cmd_in_p$  = pack(NULL, ins4.cmd_in2);
      //req2_data_in_p$ = pack(NULL, ins4.din1_2);
      //req3_cmd_in_p$  = pack(NULL, ins4.cmd_in3);
      //req3_data_in_p$ = pack(NULL, ins4.din1_3);
      //req4_cmd_in_p$  = pack(NULL, ins4.cmd_in4);
      //req4_data_in_p$ = pack(NULL, ins4.din1_4);
      //wait cycle;
      //req1_cmd_in_p$  = 0000;
      //req1_data_in_p$ = pack(NULL, ins4.din2_1);
      //req2_cmd_in_p$  = 0000;
      //req2_data_in_p$ = pack(NULL, ins4.din2_2);
      //req3_cmd_in_p$  = 0000;
      //req3_data_in_p$ = pack(NULL, ins4.din2_3);
      //req4_cmd_in_p$  = 0000;
      //req4_data_in_p$ = pack(NULL, ins4.din2_4);

   }; // drive_instruction

   drive2_instructions(ins : instruction_parallel2_s, i : int) @clk is {

      // display generated command and data
      outf("TEST %s", i);
      outf("Command1 = %s\n", ins.cmd_in1);
      out("data1_in1     = ", ins.din1_1);
      out("data2_in1     = ", ins.din2_1);
      out("Port          = ", ins.port_1);
      outf("Command2 = %s\n", ins.cmd_in2);
      out("data1_in2     = ", ins.din1_2);
      out("data2_in2     = ", ins.din2_2);
      out("Port          = ", ins.port_2);
      out();

      put_data_on_port(ins.port_1, ins.cmd_in1, ins.din1_1);
      put_data_on_port(ins.port_2, ins.cmd_in2, ins.din1_2);
      wait cycle;
      put_data_on_port(ins.port_1, NOP, ins.din2_1);
      put_data_on_port(ins.port_2, NOP, ins.din2_2);

   }; // drive_instruction


   collect_response_serial(ins : instruction_s) @clk is {

      case ins.port {
      1: {
        wait @resp1 or [10] * cycle;
        ins.resp = out_resp1_p$;
        ins.dout = out_data1_p$;
      };
      2: {
        wait @resp2 or [10] * cycle;
        ins.resp = out_resp2_p$;
        ins.dout = out_data2_p$;
      };
      3: {
        wait @resp3 or [10] * cycle;
        ins.resp = out_resp3_p$;
        ins.dout = out_data3_p$;
      };
      4: {
        wait @resp4 or [10] * cycle;
        ins.resp = out_resp4_p$;
        ins.dout = out_data4_p$;
        };
      };

   }; // collect_response_serial

   collect_response_parallel2(ins : instruction_parallel2_s) @clk is {
      if ((ins.cmd_in1 in [ADD, SUB] && ins.cmd_in2 in [SHL, SHR]) || (ins.cmd_in2 in [ADD, SUB] && ins.cmd_in1 in [SHL, SHR])) {
      case ins.port_1 {
      1: {
        wait @resp1 or [10] * cycle;
        ins.out_resp1_p = out_resp1_p$;
        ins.out_data1_p = out_data1_p$;
      };
      2: {
        wait @resp2 or [10] * cycle;
        ins.out_resp1_p = out_resp2_p$;
        ins.out_data1_p = out_data2_p$;
      };
      3: {
        wait @resp3 or [10] * cycle;
        ins.out_resp1_p = out_resp3_p$;
        ins.out_data1_p = out_data3_p$;
      };
      4: {
        wait @resp4 or [10] * cycle;
        ins.out_resp1_p = out_resp4_p$;
        ins.out_data1_p = out_data4_p$;
        };
      };

      case ins.port_2 {
      1: {
        ins.out_resp2_p = out_resp1_p$;
        ins.out_data2_p = out_data1_p$;
      };
      2: {
        ins.out_resp2_p = out_resp2_p$;
        ins.out_data2_p = out_data2_p$;
      };
      3: {
        ins.out_resp2_p = out_resp3_p$;
        ins.out_data2_p = out_data3_p$;
      };
      4: {
        ins.out_resp2_p = out_resp4_p$;
        ins.out_data2_p = out_data4_p$;
        };
      };

    } else {
      case ins.port_1 {
      1: {
        wait @resp1 or [10] * cycle;
        ins.out_resp1_p = out_resp1_p$;
        ins.out_data1_p = out_data1_p$;
      };
      2: {
        wait @resp2 or [10] * cycle;
        ins.out_resp1_p = out_resp2_p$;
        ins.out_data1_p = out_data2_p$;
      };
      3: {
        wait @resp3 or [10] * cycle;
        ins.out_resp1_p = out_resp3_p$;
        ins.out_data1_p = out_data3_p$;
      };
      4: {
        wait @resp4 or [10] * cycle;
        ins.out_resp1_p = out_resp4_p$;
        ins.out_data1_p = out_data4_p$;
        };
      };

      case ins.port_2 {
      1: {
        wait @resp1 or [10] * cycle;
        ins.out_resp2_p = out_resp1_p$;
        ins.out_data2_p = out_data1_p$;
      };
      2: {
        wait @resp2 or [10] * cycle;
        ins.out_resp2_p = out_resp2_p$;
        ins.out_data2_p = out_data2_p$;
      };
      3: {
        wait @resp3 or [10] * cycle;
        ins.out_resp2_p = out_resp3_p$;
        ins.out_data2_p = out_data3_p$;
      };
      4: {
        wait @resp4 or [10] * cycle;
        ins.out_resp2_p = out_resp4_p$;
        ins.out_data2_p = out_data4_p$;
        };
      };
    };

      //case ins.port {
      //1: {
      //  wait @resp1 or [10] * cycle;
      //  ins.resp = out_resp1_p$;
      //  ins.dout = out_data1_p$;
      //};
      //2: {
      //  wait @resp2 or [10] * cycle;
      //  ins.resp = out_resp2_p$;
      //  ins.dout = out_data2_p$;
      //};
      //3: {
      //  wait @resp3 or [10] * cycle;
      //  ins.resp = out_resp3_p$;
      //  ins.dout = out_data3_p$;
      //};
      //4: {
      //  wait @resp4 or [10] * cycle;
      //  ins.resp = out_resp4_p$;
      //  ins.dout = out_data4_p$;
      //  };
      //};

   }; // collect_response_serial

    collect_input_parallel4(ins : instruction_parallel4_s) @clk is empty;

    update_instuction_wires(ins : instruction_s) @clk is {
        ins.out_resp1_p = out_resp1_p$;
        ins.out_resp2_p = out_resp2_p$;
        ins.out_resp3_p = out_resp3_p$;
        ins.out_resp4_p = out_resp4_p$;

        ins.out_data1_p = out_data1_p$;
        ins.out_data2_p = out_data2_p$;
        ins.out_data3_p = out_data3_p$;
        ins.out_data4_p = out_data4_p$;
    };


    wait_port1() @clk is {
        while TRUE {
            wait @resp1;
            if (out_resp1_p$ != 0) {
                scrboard.seen_a_resp(scrboard, 1);
            };
        };
    };

    wait_port2() @clk is {
        while TRUE {
            wait @resp2;
            if (out_resp2_p$ != 0) {
                scrboard.seen_a_resp(scrboard, 2);
            };
        };
    };

    wait_port3() @clk is {
        while TRUE {
            wait @resp3;
            if (out_resp3_p$ != 0) {
                scrboard.seen_a_resp(scrboard, 3);
            };
        };
    };

    wait_port4() @clk is {
        while TRUE {
            wait @resp4;
            if (out_resp4_p$ != 0) {
                scrboard.seen_a_resp(scrboard, 4);
            };
        };
    };


   drive() @clk is {

      drive_reset();

      scrboard.init_scoreboard(scrboard);


      var i : int = 0;
      var j : int = 0;

      for each (ins) in instructions_to_drive_serial do {

         drive_instruction(ins, index);
         collect_response_serial(ins);
         ins.check_response(ins);
         //scrboard.seen_a_resp(scrboard, ins.port);
         drive_reset();
         update_instuction_wires(ins);
         ins.check_reset(ins);
         wait cycle;

      }; // for each instruction

      //for each (ins) in instructions_to_drive_parallel2 do {
      //  drive2_instructions(ins, i);
      //  collect_response_parallel2(ins);

      //  var ins1 : instruction_s = new;
      //  ins1.cmd_in = ins.cmd_in1;
      //  ins1.port = ins.port_1;
      //  ins1.din1 = ins.din1_1;
      //  ins1.din2 = ins.din1_2;
      //  ins1.resp = ins.out_resp1_p;
      //  ins1.dout = ins.out_data1_p;
      //  ins1.check_response(ins1);

      //  var ins2 : instruction_s = new;
      //  ins1.cmd_in = ins.cmd_in2;
      //  ins2.port = ins.port_2;
      //  ins2.din1 = ins.din2_1;
      //  ins2.din2 = ins.din2_2;
      //  ins2.resp = ins.out_resp2_p;
      //  ins2.dout = ins.out_data2_p;
      //  ins2.check_response(ins2);

      //  drive_reset();
      //  wait cycle;
      //};

      //start wait_port1();
      //start wait_port2();
      //start wait_port3();
      //start wait_port4();

      //var ins4 : instruction_parallel4_s;

      //for i from 0 to (instructions_to_drive_parallel4.size() / 2) do {
      //  scrboard.clean(scrboard);

      //  ins4 = instructions_to_drive_parallel4.pop();

      //  ins4.cmd_in2 = ins4.cmd_in1;
      //  ins4.cmd_in3 = ins4.cmd_in1;
      //  ins4.cmd_in4 = ins4.cmd_in1;

      //  drive4_instructions(ins4, i);
      //  collect_input_parallel4(ins4);

      //  wait cycle;

      //  ins4 = instructions_to_drive_parallel4.pop();

      //  ins4.cmd_in2 = ins4.cmd_in1;
      //  ins4.cmd_in3 = ins4.cmd_in1;
      //  ins4.cmd_in4 = ins4.cmd_in1;

      //  drive4_instructions(ins4, i);
      //  collect_input_parallel4(ins4);

      //  wait [10] * cycle;

      //  drive_reset();
      //  //update_instuction_wires(ins1);
      //  //ins1.check_reset(ins1);

      //  wait [5]*cycle;
      //};

      wait [10] * cycle;
      stop_run();

   }; // drive


   run() is also {
      start drive();        // spawn
   }; // run

}; // unit driver_u


'>

