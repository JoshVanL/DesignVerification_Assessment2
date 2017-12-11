
   Sample test.e file
   ----------------------
   This file provides basic test-specific constraints for the calc1
   testbench.

   0001 - Turn port 4 to working.
   0010 - Turn overflow out 2 working.

<'

extend instruction_s {
    keep cmd_in in [ADD,SUB,SHL,SHR, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11];
    //keep cmd_in in [ADD, SUB];
    //keep cmd_in in [INV, INV1];
    //keep soft cmd_in == ADD;
    //keep din1 < 10;
    keep din1 >= 0 && din1 < 4294967211;
    keep din2 >= 0 && din2 < 4294967211;
    //keep din2 == 0;
    //keep din2 < 10;
    keep port > 0 && port < 5;
    //keep port == 4;

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
