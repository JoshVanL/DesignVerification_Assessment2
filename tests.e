
   Sample test.e file
   ----------------------
   This file provides basic test-specific constraints for the calc1
   testbench.

<'

extend instruction_s {
    keep cmd_in in [ADD,SUB,SHL,SHR, INV, INV1];
    //keep cmd_in in [SHL,SHR];
    //keep soft cmd_in == ADD;
    keep din1 < 4294967296;
    keep din2 < 4294967296;
    keep port > 0 && port < 5;

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
