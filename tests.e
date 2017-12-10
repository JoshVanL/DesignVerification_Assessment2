
   Sample test.e file
   ----------------------
   This file provides basic test-specific constraints for the calc1
   testbench.

   0001 - Turn port 4 to working.
   0010 - Turn overflow out 2 working.

<'

extend instruction_s {
    keep cmd_in in [ADD,SUB,SHL,SHR, INV, INV1];
    //keep cmd_in in [ADD, SUB];
    //keep cmd_in in [INV, INV1];
    //keep soft cmd_in == ADD;
    keep din1 < 4294967296;
    //keep din2 > 0 && din2 < 4294967211;
    //keep din2 == 0;
    keep din2 < 4294967296;
    //keep port > 1 && port < 4;
    keep port == 4;

    when ADD'cmd_in instruction_s {

        keep soft din1 == select {
            10: [0];
            10: [1];
            70: [0..32];
            20: [32..4294967296];
        };

        keep soft din2 == select {
            10: [0];
            70: [0..32];
            20: [32..4294967296];
        };
    };

    when SUB'cmd_in instruction_s {

        keep soft din1 == select {
            10: [0];
            70: [0..32];
            20: [32..4294967296];
        };

        keep soft din2 == select {
            10: [0];
            70: [0..32];
            20: [32..4294967296];
        };
    };

    when SHR'cmd_in instruction_s {

        keep soft din1 == select {
            10: [0];
            70: [0..32];
            20: [32..4294967296];
        };

        keep soft din2 == select {
            10: [0];
            70: [0..32];
            20: [32..4294967296];
        };
    };

    when SHL'cmd_in instruction_s {

        keep soft din1 == select {
            10: [0];
            70: [0..32];
            20: [32..4294967296];
        };

        keep soft din2 == select {
            10: [0];
            70: [0..32];
            20: [32..4294967296];
        };
    };


}; // extend instruction_s


extend driver_u {
   keep instructions_to_drive.size() == 10000;
}; // extend driver_u


'>
