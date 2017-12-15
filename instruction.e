
   Sample instruction.e file
   -------------------------
   This file provides the basic structure for the calc1 design instructions
   and also an example response checker for ADD instructions.

<'

type opcode_t : [ NOP, ADD, SUB, INV1, INV2, SHL, SHR, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11] (bits:4);

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

    get_exp_data(ins : instruction_s): uint(bits:32) is empty;


    check_reset(ins : instruction_s) is {
        check that ins.out_resp1_p == 0 else
            dut_error(appendf("[R==>Port 1 - none zero on resp out. (RESET)<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp1_p));
        check that ins.out_resp2_p == 0 else
            dut_error(appendf("[R==>Port 2 - none zero on resp out. (RESET)<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp2_p));
        check that ins.out_resp3_p == 0 else
            dut_error(appendf("[R==>Port 3 - none zero on resp out. (RESET)<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp3_p));
        check that ins.out_resp4_p == 0 else
            dut_error(appendf("[R==>Port 4 - none zero on resp out. (RESET)<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_resp4_p));
        check that ins.out_data1_p == 0 else
            dut_error(appendf("[R==>Port 1 - none zero on data out. (RESET)<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data1_p));
        check that ins.out_data2_p == 0 else
            dut_error(appendf("[R==>Port 2 - none zero on data out. (RESET)<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data2_p));
        check that ins.out_data3_p == 0 else
            dut_error(appendf("[R==>Port 3 - none zero on data out. (RESET)<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data3_p));
        check that ins.out_data3_p == 0 else
            dut_error(appendf("[R==>Port 4 - none zero on data out. (RESET)<==R]\n \
                        expected 00,\n \
                        received %d,\n",
                        ins.out_data4_p));
    };


}; // struct instruction_s

struct instruction_parallel2_s {

    %cmd_in1 : opcode_t;
    %cmd_in2 : opcode_t;

    %din1_1  : uint (bits:32);
    %din2_1  : uint (bits:32);
    %din1_2  : uint (bits:32);
    %din2_2  : uint (bits:32);

    %port_1 : uint (bits:3);
    %port_2 : uint (bits:3);

    out_resp1_p : uint (bits:2);
    out_resp2_p : uint (bits:2);

    out_data1_p : uint (bits:32);
    out_data2_p : uint (bits:32);

}; // struct instruction__parallel4_s


struct instruction_parallel4_s {

    %cmd_in1 : opcode_t;
    %cmd_in2 : opcode_t;
    %cmd_in3 : opcode_t;
    %cmd_in4 : opcode_t;

    %din1_1   : uint (bits:32);
    %din2_1   : uint (bits:32);

    %din1_2   : uint (bits:32);
    %din2_2   : uint (bits:32);

    %din1_3   : uint (bits:32);
    %din2_3   : uint (bits:32);

    %din1_4   : uint (bits:32);
    %din2_4   : uint (bits:32);

    out_resp1_p : uint (bits:2);
    out_resp2_p : uint (bits:2);
    out_resp3_p : uint (bits:2);
    out_resp4_p : uint (bits:2);

    out_data1_p : uint (bits:32);
    out_data2_p : uint (bits:32);
    out_data3_p : uint (bits:32);
    out_data4_p : uint (bits:32);

}; // struct instruction__parallel4_s


extend instruction_s {

    check_response(ins : instruction_s) is only {
        // example check for correct addition
        if (ins.cmd_in == ADD) {
            var expresp : uint (bits:2) = 1;
            var res     : uint (bits:128) = ins.din1 + ins.din2;
            if (res > 4294967296) {
                expresp = 2;
            };

            check that ins.resp == expresp else
                dut_error(appendf("[R==>Port %u - invalid responce code.<==R]\n \
                            expected %u,\n \
                            received %u,\n",
                            ins.port, expresp, ins.resp));

            check that ins.dout == (ins.din1 + ins.din2) else
                dut_error(appendf("[R==>Port %u - Invalid output data.<==R]\n \
                            Instruction %s %u %u,\n \
                            expected %032.32b \t %u,\n \
                            received %032.32b \t %u.\n",
                            ins.port,
                            ins.cmd_in, ins.din1, ins.din2,
                            (ins.din1 + ins.din2), (ins.din1 + ins.din2),
                            ins.dout,ins.dout));

        } else if (ins.cmd_in == SUB) {

            var expresp : uint (bits:2) = 1;
            var res     : int (bits:128) = ins.din1 - ins.din2;
            if (res < 0) {
                expresp = 2;
            };

            check that ins.resp == expresp else
                dut_error(appendf("[R==>Port %u - invalid responce code.<==R]\n \
                            expected %u,\n \
                            received %u,\n",
                            ins.port, expresp, ins.resp));

            check that ins.dout == (ins.din1 - ins.din2) else
                dut_error(appendf("[R==>Port 1 invalid output.<==R]\n \
                            Instruction %s %u %u,\n \
                            expected %032.32b \t %u,\n \
                            received %032.32b \t %u.\n",
                            ins.cmd_in, ins.din1, ins.din2,
                            (ins.din1 - ins.din2), (ins.din1 - ins.din2),
                            ins.dout,ins.dout));

        } else if (ins.cmd_in in [INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]) {

            check that ins.resp == 02 else
                dut_error(appendf("[R==>port %u - invalid responce code.<==R]\n \
                            expected 02,\n \
                            received %u,\n",
                            ins.port, ins.resp));
            check that ins.dout == 0 else
                dut_error(appendf("[R==>Port 1 invalid output.<==R]\n \
                            Instruction %s %u %u,\n \
                            expected 0,\n \
                            received %032.32b \t %u.\n",
                            ins.cmd_in, ins.din1, ins.din2,
                            ins.dout,ins.dout));

        } else if (ins.cmd_in == SHL) {
            var res     : int (bits:32);
            if (ins.din2 > 31) {
                res = 0;
            } else {
                res = ins.din1 << ins.din2;
            };

            check that ins.resp == 01 else
                dut_error(appendf("[R==>Port %u - invalid responce code.<==R]\n \
                            expected 01,\n \
                            received %u,\n",
                            ins.port, ins.resp));
            check that ins.dout == (res) else
                dut_error(appendf("[R==>Port 1 invalid output.<==R]\n \
                            Instruction %s %u %u,\n \
                            expected %032.32b \t %u,\n \
                            received %032.32b \t %u.\n",
                            ins.cmd_in, ins.din1, ins.din2,
                            (res), (res),
                            ins.dout,ins.dout));

        } else if (ins.cmd_in == SHR) {
            var res     : int (bits:32);
            if (ins.din2 > 31) {
                res = 0;
            } else {
                res = ins.din1 >> ins.din2;
            };

            check that ins.resp == 01 else
                dut_error(appendf("[R==>Port %u - invalid responce code.<==R]\n \
                            expected 01,\n \
                            received %u,\n",
                            ins.port, ins.resp));
            check that ins.dout == (ins.din1 >> ins.din2) else
                dut_error(appendf("[R==>Port 1 invalid output.<==R]\n \
                            Instruction %s %u %u,\n \
                            expected %032.32b \t %u,\n \
                            received %032.32b \t %u.\n",
                            ins.cmd_in, ins.din1, ins.din2,
                            (res), (res),
                            ins.dout,ins.dout));

        };
    };


    get_exp_data(ins : instruction_s):uint(bits:32) is only {
        if (ins.cmd_in == ADD) {
            return ins.din1 + ins.din2;

        } else if (ins.cmd_in == SUB) {
            var res     : int (bits:128) = ins.din1 - ins.din2;
            if (res < 0) {
                return 0;
            };

            return res;

        } else if (ins.cmd_in in [INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]) {
            return 0;

        } else if (ins.cmd_in == SHL) {
            return ins.din1 << ins.din2;

        } else if (ins.cmd_in == SHR) {
            return ins.din1 >> ins.din2;
        };
    };
};

'>
