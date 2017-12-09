
   Sample test.e file
   ----------------------
   This file provides basic test-specific constraints for the calc1 
   testbench.

<'

extend instruction_s {
//   keep cmd_in in [ADD,SUB,SHL,SHR];
   keep soft cmd_in == SHL;
   keep din1 < 4294967296;
   keep din2 < 4294967296;
}; // extend instruction_s


extend driver_u {
   keep instructions_to_drive.size() == 10000;
}; // extend driver_u


'>

