
   Sample instruction.e file
   -------------------------
   This file provides the basic structure for the calc1 design instructions
   and also an example response checker for ADD instructions.

<'

type opcode_t : [ NOP, ADD, SUB, INV, INV1, SHL, SHR ] (bits:4);

struct instruction_s {

    %cmd_in : opcode_t;
    %din1   : uint (bits:32);
    %din2   : uint (bits:32);
    %port   : uint (bits:3); //

    !resp   : uint (bits:2);
    !dout   : uint (bits:32);

    out_resp1_p : uint (bits:2);
    out_resp2_p : uint (bits:2);
    out_resp3_p : uint (bits:2);
    out_resp4_p : uint (bits:2);

    out_data1_p : uint (bits:32);
    out_data2_p : uint (bits:32);
    out_data3_p : uint (bits:32);
    out_data4_p : uint (bits:32);

    check_response(ins : instruction_s) is empty;


    check_reset(ins : instruction_s) is {
        check that ins.out_resp1_p == 0 else
            dut_error(appendf("[R==>Port 1 - none zero on resp out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp1_p));
        check that ins.out_resp2_p == 0 else
            dut_error(appendf("[R==>Port 2 - none zero on resp out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp2_p));
        check that ins.out_resp3_p == 0 else
            dut_error(appendf("[R==>Port 3 - none zero on resp out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp3_p));
        check that ins.out_resp4_p == 0 else
            dut_error(appendf("[R==>Port 4 - none zero on resp out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp4_p));
        check that ins.out_data1_p == 0 else
            dut_error(appendf("[R==>Port 1 - none zero on data out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data1_p));
        check that ins.out_data2_p == 0 else
            dut_error(appendf("[R==>Port 2 - none zero on data out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data2_p));
        check that ins.out_resp3_p == 0 else
            dut_error(appendf("[R==>Port 3 - none zero on data out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data3_p));
        check that ins.out_data3_p == 0 else
            dut_error(appendf("[R==>Port 4 - none zero on data out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data4_p));
    };


}; // struct instruction_s

struct instruction_p {

    %cmd_in1 : opcode_t;
    %cmd_in2 : opcode_t;
    %cmd_in3 : opcode_t;
    %cmd_in4 : opcode_t;

    %data1_in1 : uint (bits:32);
    %data1_in2 : uint (bits:32);
    %data1_in3 : uint (bits:32);
    %data1_in4 : uint (bits:32);
    %data2_in1 : uint (bits:32);
    %data2_in2 : uint (bits:32);
    %data2_in3 : uint (bits:32);
    %data2_in4 : uint (bits:32);

    !out_resp1 : uint (bits:2);
    !out_resp2 : uint (bits:2);
    !out_resp3 : uint (bits:2);
    !out_resp4 : uint (bits:2);

    !out_data1 : uint (bits:32);
    !out_data2 : uint (bits:32);
    !out_data3 : uint (bits:32);
    !out_data4 : uint (bits:32);

    check_response(ins : instruction_s) is empty;

    check_reset(ins : instruction_s) is {
        check that ins.out_resp1_p == 0 else
            dut_error(appendf("[R==>Port 1 - none zero on resp out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp1_p));
        check that ins.out_resp2_p == 0 else
            dut_error(appendf("[R==>Port 2 - none zero on resp out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp2_p));
        check that ins.out_resp3_p == 0 else
            dut_error(appendf("[R==>Port 3 - none zero on resp out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp3_p));
        check that ins.out_resp4_p == 0 else
            dut_error(appendf("[R==>Port 4 - none zero on resp out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp4_p));
        check that ins.out_data1_p == 0 else
            dut_error(appendf("[R==>Port 1 - none zero on data out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data1_p));
        check that ins.out_data2_p == 0 else
            dut_error(appendf("[R==>Port 2 - none zero on data out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data2_p));
        check that ins.out_resp3_p == 0 else
            dut_error(appendf("[R==>Port 3 - none zero on data out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data3_p));
        check that ins.out_data3_p == 0 else
            dut_error(appendf("[R==>Port 4 - none zero on data out.<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data4_p));
    };


}; // struct instruction_p



extend instruction_s {

   // example check for correct addition
   when ADD'cmd_in instruction_s {

    check_response(ins : instruction_s) is only {

       check that ins.resp == (ins.din1 + ins.din2 < 4294967296 ? 01 : 02) else
       dut_error(appendf("[R==>Port %d - invalid responce code.<==R]\n \
                          expected 01,\n \
                          received %d,\n",
                          ins.port, ins.resp));

       check that ins.dout == (ins.din1 + ins.din2) else
       dut_error(appendf("[R==>Port %d - Invalid output data.<==R]\n \
                          Instruction %s %d %d,\n \
                          expected %032.32b \t %d,\n \
                          received %032.32b \t %d.\n",
                          ins.port,
                          ins.cmd_in, ins.din1, ins.din2,
                          (ins.din1 + ins.din2),
                          (ins.din1 + ins.din2),
                          ins.dout,ins.dout));

     }; // check_response
    };

   when SUB'cmd_in instruction_s {

     check_response(ins : instruction_s) is only {

       check that ins.resp == (ins.din1 - ins.din2 > 0 ? 01 : 02) else
       dut_error(appendf("[R==>Port %d - invalid responce code.<==R]\n \
                          expected 01,\n \
                          received %d,\n",
                          ins.port, ins.resp));
       check that ins.dout == (ins.din1 - ins.din2) else
       dut_error(appendf("[R==>Port 1 invalid output.<==R]\n \
                          Instruction %s %d %d,\n \
                          expected %032.32b \t %d,\n \
                          received %032.32b \t %d.\n",
                          ins.cmd_in, ins.din1, ins.din2,
                          (ins.din1 + ins.din2),
                          (ins.din1 + ins.din2),
                          ins.dout,ins.dout));

     }; // check_response
    };

   when INV'cmd_in instruction_s {

     check_response(ins : instruction_s) is only {

       check that ins.resp == 02 else
       dut_error(appendf("[R==>port %d - invalid responce code.<==r]\n \
                          expected 02,\n \
                          received %d,\n",
                          ins.port, ins.resp));
       check that ins.dout == 0 else
       dut_error(appendf("[R==>Port 1 invalid output.<==R]\n \
                          Instruction %s %d %d,\n \
                          expected %032.32b \t %d,\n \
                          received %032.32b \t %d.\n",
                          ins.cmd_in, ins.din1, ins.din2,
                          (ins.din1 + ins.din2),
                          (ins.din1 + ins.din2),
                          ins.dout,ins.dout));

     }; // check_response
    };


   when INV1'cmd_in instruction_s {

     check_response(ins : instruction_s) is only {

       check that ins.resp == 02 else
       dut_error(appendf("[R==>port %d - invalid responce code.<==R]\n \
                          expected 02,\n \
                          received %d,\n",
                          ins.port, ins.resp));
       check that ins.dout == (0) else
       dut_error(appendf("[R==>Port 1 invalid output.<==R]\n \
                          Instruction %s %d %d,\n \
                          expected %032.32b \t %d,\n \
                          received %032.32b \t %d.\n",
                          ins.cmd_in, ins.din1, ins.din2,
                          (ins.din1 + ins.din2),
                          (ins.din1 + ins.din2),
                          ins.dout,ins.dout));

     }; // check_response
    };

   when SHL'cmd_in instruction_s {

     check_response(ins : instruction_s) is only {

       check that ins.resp == 01 else
       dut_error(appendf("[R==>Port %d - invalid responce code.<==R]\n \
                          expected 01,\n \
                          received %d,\n",
                          ins.port, ins.resp));
       check that ins.dout == (ins.din1 << ins.din2) else
       dut_error(appendf("[R==>Port 1 invalid output.<==R]\n \
                          Instruction %s %d %d,\n \
                          expected %032.32b \t %d,\n \
                          received %032.32b \t %d.\n",
                          ins.cmd_in, ins.din1, ins.din2,
                          (ins.din1 + ins.din2),
                          (ins.din1 + ins.din2),
                          ins.dout,ins.dout));

     }; // check_response
    };

   when SHR'cmd_in instruction_s {

     check_response(ins : instruction_s) is only {

       check that ins.resp == 01 else
       dut_error(appendf("[R==>Port %d - invalid responce code.<==R]\n \
                          expected 01,\n \
                          received %d,\n",
                          ins.port, ins.resp));
       check that ins.dout == (ins.din1 >> ins.din2) else
       dut_error(appendf("[R==>Port 1 invalid output.<==R]\n \
                          Instruction %s %d %d,\n \
                          expected %032.32b \t %d,\n \
                          received %032.32b \t %d.\n",
                          ins.cmd_in, ins.din1, ins.din2,
                          (ins.din1 + ins.din2),
                          (ins.din1 + ins.din2),
                          ins.dout,ins.dout));

     }; // check_response
    };

}; // extend instruction_s

'>
