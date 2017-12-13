
   test.e file
   ----------------------

   0001 - Turn port 4 to working.
   0010 - Turn overflow out 2 working.
   0100 - Makes left shift return data on port 1
   1000 - Fixes ADD

<'

extend instruction_s {
    keep cmd_in in [ADD,SUB,SHL,SHR, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11];
    //keep cmd_in in [ADD];

    keep din1 >= 0 && din1 < 4294967211;
    keep din2 >= 0 && din2 < 4294967211;

    keep port >= 1 && port <= 4;

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

}; // extend instruction_s

extend instruction_parallel2_s {
    keep cmd_in1 in [ADD,SUB,SHL,SHR];
    keep cmd_in2 in [ADD,SUB,SHL,SHR];

    keep din1_1 >= 0 && din1_1 < 4294967211;
    keep din2_1 >= 0 && din2_1 < 4294967211;

    keep din1_2 >= 0 && din1_2 < 4294967211;
    keep din2_2 >= 0 && din2_2 < 4294967211;

    keep port_1 >= 1 && port_1 <= 4;
    keep port_2 >= 1 && port_2 <= 4;

    keep port_1 != port_2;
    keep port_1 < port_2;

    keep soft din1_1 == select {
        10: [0];
        10: [1];
        70: [0..32];
        20: [32..4294967296];
    };
    keep soft din2_1 == select {
        10: [0];
        70: [0..32];
        20: [32..4294967296];
    };

    keep soft din1_2 == select {
        10: [0];
        10: [1];
        70: [0..32];
        20: [32..4294967296];
    };
    keep soft din2_2 == select {
        10: [0];
        70: [0..32];
        20: [32..4294967296];
    };

};

extend instruction_parallel4_s {
    keep cmd_in1 in [ADD,SUB,SHL,SHR];
    keep cmd_in2 in [ADD,SUB,SHL,SHR];
    keep cmd_in3 in [ADD,SUB,SHL,SHR];
    keep cmd_in4 in [ADD,SUB,SHL,SHR];

    keep din1_1 >= 0 && din1_1 < 4294967211;
    keep din2_1 >= 0 && din2_1 < 4294967211;

    keep din1_2 >= 0 && din1_2 < 4294967211;
    keep din2_2 >= 0 && din2_2 < 4294967211;

    keep din1_3 >= 0 && din1_3 < 4294967211;
    keep din2_3 >= 0 && din2_3 < 4294967211;

    keep din1_4 >= 0 && din1_4 < 4294967211;
    keep din2_4 >= 0 && din2_4 < 4294967211;

    keep soft din1_1 == select {
        10: [0];
        10: [1];
        70: [0..32];
        20: [32..4294967296];
    };
    keep soft din2_1 == select {
        10: [0];
        70: [0..32];
        20: [32..4294967296];
    };

    keep soft din1_2 == select {
        10: [0];
        10: [1];
        70: [0..32];
        20: [32..4294967296];
    };
    keep soft din2_2 == select {
        10: [0];
        70: [0..32];
        20: [32..4294967296];
    };

    keep soft din1_3 == select {
        10: [0];
        10: [1];
        70: [0..32];
        20: [32..4294967296];
    };
    keep soft din2_3 == select {
        10: [0];
        70: [0..32];
        20: [32..4294967296];
    };

    keep soft din1_4 == select {
        10: [0];
        10: [1];
        70: [0..32];
        20: [32..4294967296];
    };
    keep soft din2_4 == select {
        10: [0];
        70: [0..32];
        20: [32..4294967296];
    };
};


extend driver_u {
   keep instructions_to_drive_serial.size() == 1000;
   keep instructions_to_drive_parallel2.size() == 2000;
   keep instructions_to_drive_parallel4.size() == 3000;
}; // extend driver_u


'>
