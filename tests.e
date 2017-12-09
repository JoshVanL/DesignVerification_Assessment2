
   Sample test.e file
   ----------------------
   This file provides basic test-specific constraints for the calc1 
   testbench.

<'

extend instruction_s {
   keep cmd_in in [ADD,SUB];//,SHL,SHR];
   //keep soft cmd_in == ADD;
   //keep din1 < 4294967296;
   //keep din2 < 4294967296;
   keep din1 < 10000;
   keep din2 < 10000;
   keep port > 0 && port < 4;
}; // extend instruction_s


extend driver_u {
   keep instructions_to_drive.size() == 5000;
}; // extend driver_u


'>

