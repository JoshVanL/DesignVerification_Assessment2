
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
   %port : uint (bits:3); //

   !resp   : uint (bits:2);
   !dout   : uint (bits:32);
   //!port_o : uint (bits:3); //

   check_response(ins : instruction_s) is empty;

}; // struct instruction_s


extend instruction_s {

   // example check for correct addition
   when ADD'cmd_in instruction_s {

    check_response(ins : instruction_s) is only {

       check that ins.resp == 01 else
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

       check that ins.resp == 02 else
       dut_error(appendf("[R==>Port %d - invalid responce code.<==R]\n \
                          expected 02,\n \
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

       //check that ins.resp == 03 else
       //dut_error(appendf("[R==>Port %d - invalid responce code.<==R]\n \
       //                   expected 03,\n \
       //                   received %d,\n",
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


   when INV1'cmd_in instruction_s {

     check_response(ins : instruction_s) is only {

       //check that ins.resp == 04;
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

       check that ins.resp == 05 else
       dut_error(appendf("[R==>Port %d - invalid responce code.<==R]\n \
                          expected 05,\n \
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

       check that ins.resp == 06 else
       dut_error(appendf("[R==>Port %d - invalid responce code.<==R]\n \
                          expected 06,\n \
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

