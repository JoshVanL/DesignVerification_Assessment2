
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

   instructions_to_drive : list of instruction_s;

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

   new_queue_entry4(ins1 : instruction_s, ins2 : instruction_s, ins3 : instruction_s, ins4 : instruction_s) is {
       var new_entry : queue_entry = new;

       var exp_resp1 : expected_resp = new;
       var exp_resp2 : expected_resp = new;
       var exp_resp3 : expected_resp = new;
       var exp_resp4 : expected_resp = new;

       exp_resp1.port = ins1.port;
       exp_resp2.port = ins2.port;
       exp_resp3.port = ins3.port;
       exp_resp4.port = ins4.port;

       new_entry.size = 4;
       new_entry.entry.add(exp_resp1);
       new_entry.entry.add(exp_resp2);
       new_entry.entry.add(exp_resp3);
       new_entry.entry.add(exp_resp4);
       scrboard.add_new_entry(scrboard, new_entry);
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

       case ins.port {
      1: {
        // drive data into calculator port 1
        //scoreboard.add_to_queue(1);
        req1_cmd_in_p$  = pack(NULL, ins.cmd_in);
        req1_data_in_p$ = pack(NULL, ins.din1);
        wait cycle;
        req1_cmd_in_p$  = 0000;
        req1_data_in_p$ = pack(NULL, ins.din2);
      };

      2: {
        // drive data into calculator port 1
        //scoreboard.add_to_queue(2);
        req2_cmd_in_p$  = pack(NULL, ins.cmd_in);
        req2_data_in_p$ = pack(NULL, ins.din1);
        wait cycle;
        req2_cmd_in_p$  = 0000;
        req2_data_in_p$ = pack(NULL, ins.din2);
      };

      3: {
        // drive data into calculator port 1
        //scoreboard.add_to_queue(3);
        req3_cmd_in_p$  = pack(NULL, ins.cmd_in);
        req3_data_in_p$ = pack(NULL, ins.din1);
        wait cycle;
        req3_cmd_in_p$  = 0000;
        req3_data_in_p$ = pack(NULL, ins.din2);
      };

      4: {
        // drive data into calculator port 1
        //scoreboard.add_to_queue(4);
        req4_cmd_in_p$  = pack(NULL, ins.cmd_in);
        req4_data_in_p$ = pack(NULL, ins.din1);
        wait cycle;
        req4_cmd_in_p$  = 0000;
        req4_data_in_p$ = pack(NULL, ins.din2);
      };
    };
   }; // drive_instruction

   drive4_instructions(ins1 : instruction_s, ins2 : instruction_s, ins3 : instruction_s, ins4 : instruction_s, i : int) @clk is {

       new_queue_entry4(ins1, ins2, ins3, ins4);

      // display generated command and data
      outf("TEST %s", i);
      outf("Command1 = %s\n", ins1.cmd_in);
      out("data1_in1     = ", ins1.din1);
      out("data2_in1     = ", ins1.din2);
      out("Port1    = ", ins1.port);
      outf("Command2 = %s\n", ins2.cmd_in);
      out("data1_in2     = ", ins2.din1);
      out("data2_in2     = ", ins2.din2);
      out("Port2    = ", ins2.port);
      outf("Command3 = %s\n", ins3.cmd_in);
      out("data1_in3     = ", ins3.din1);
      out("data2_in3     = ", ins3.din2);
      out("Port3    = ", ins3.port);
      outf("Command4 = %s\n", ins4.cmd_in);
      out("data1_in4     = ", ins4.din1);
      out("data2_in4     = ", ins4.din2);
      out("Port4    = ", ins4.port);
      out();

      // drive data into calculator port 1
      //scoreboard.add_to_queue(1);
      req1_cmd_in_p$  = pack(NULL, ins1.cmd_in);
      req1_data_in_p$ = pack(NULL, ins1.din1);
      req2_cmd_in_p$  = pack(NULL, ins2.cmd_in);
      req2_data_in_p$ = pack(NULL, ins2.din1);
      req3_cmd_in_p$  = pack(NULL, ins3.cmd_in);
      req3_data_in_p$ = pack(NULL, ins3.din1);
      req4_cmd_in_p$  = pack(NULL, ins4.cmd_in);
      req4_data_in_p$ = pack(NULL, ins4.din1);
      wait cycle;
      req1_cmd_in_p$  = 0000;
      req1_data_in_p$ = pack(NULL, ins1.din2);
      req2_cmd_in_p$  = 0000;
      req2_data_in_p$ = pack(NULL, ins2.din2);
      req3_cmd_in_p$  = 0000;
      req3_data_in_p$ = pack(NULL, ins3.din2);
      req4_cmd_in_p$  = 0000;
      req4_data_in_p$ = pack(NULL, ins4.din2);

   }; // drive_instruction


   collect_response(ins : instruction_s) @clk is {

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

   }; // collect_response

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
      var ins1 : instruction_s;
      var ins2 : instruction_s;
      var ins3 : instruction_s;
      var ins4 : instruction_s;

      for each (ins) in instructions_to_drive do {

         drive_instruction(ins, index);
         collect_response(ins);
         ins.check_response(ins);
         //scrboard.seen_a_resp(scrboard, ins.port);
         drive_reset();
         update_instuction_wires(ins);
         ins.check_reset(ins);
         wait cycle;

      }; // for each instruction

      start wait_port1();
      start wait_port2();
      start wait_port3();
      start wait_port4();


      for i from 0 to 1000 {
        scrboard.clean(scrboard);

        ins1 = instructions_to_drive.pop();
        ins2 = instructions_to_drive.pop();
        ins3 = instructions_to_drive.pop();
        ins4 = instructions_to_drive.pop();

        ins1.port = 1;
        ins2.port = 2;
        ins3.port = 3;
        ins4.port = 4;

        ins1.cmd_in = ADD;
        ins2.cmd_in = ADD;
        ins3.cmd_in = ADD;
        ins4.cmd_in = ADD;
        drive4_instructions(ins1, ins2, ins3, ins4, i);

        wait cycle;

        ins1.cmd_in = SHR;
        ins2.cmd_in = SHR;
        ins3.cmd_in = SHR;
        ins4.cmd_in = SHR;
        drive4_instructions(ins1, ins2, ins3, ins4, i);

        wait [10] * cycle;

        drive_reset();
        update_instuction_wires(ins1);
        ins1.check_reset(ins1);

        wait cycle;
      };

      wait [10] * cycle;
      stop_run();

   }; // drive


   run() is also {
      start drive();        // spawn
   }; // run

}; // unit driver_u


'>

