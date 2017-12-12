
   Sample coverage.e file
   ----------------------
   This file provides a basic example of coverage collection for the calc1 
   testbench.

<'

extend instruction_s {

   event instruction_complete;
   event port_cmd_complete;
   event resp_port_complete;
   event port_resp_cmd_complete;

   cover instruction_complete is {
      item cmd_in using per_instance, ignore = (cmd_in in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item resp using per_instance, ignore = (resp == 3);
      cross cmd_in, resp;
   };

   cover port_cmd_complete is {
      item cmd_in using per_instance, ignore = (cmd_in == NOP);
      item port using per_instance, ignore = (port in [0, 5..7]);
      cross cmd_in, port;
   };

   cover resp_port_complete is {
      item resp using per_instance, ignore = (resp == 3);
      item port using per_instance, ignore = (port in [0, 5..7]);
      cross resp, port;
   };

   cover port_resp_cmd_complete is {
      item cmd_in using per_instance, ignore = (cmd_in in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item resp using per_instance, ignore = (resp == 3);
      item port using per_instance, ignore = (port in [0, 5..7]);
      cross cmd_in, resp, port;
   };

}; // extend instruction_s

extend instruction_parallel2_s {

   event instruction_complete;
   event port_cmd_complete;
   event resp_port_complete;
   event port_resp_cmd_complete;

   cover instruction_complete is {
      item cmd_in1 using per_instance, ignore = ( cmd_in1 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item cmd_in2 using per_instance, ignore = ( cmd_in2 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item out_resp1_p;
      item out_resp2_p;
      cross cmd_in1, cmd_in2, out_resp1_p, out_resp2_p;
   };

   cover port_cmd_complete is {
      item cmd_in1 using per_instance, ignore = ( cmd_in1 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item cmd_in2 using per_instance, ignore = ( cmd_in2 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item port_1 using per_instance, ignore = (port_1 in [0, 5..7]);
      item port_2 using per_instance, ignore = (port_2 in [0, 5..7]);
      cross cmd_in1, cmd_in2, port_1, port_2;
   };

   cover resp_port_complete is {
      item out_resp1_p using per_instance, ignore = (out_resp1_p == 3);
      item out_resp2_p using per_instance, ignore = (out_resp2_p == 3);
      item port_1 using per_instance, ignore = (port_1 in [0, 5..7]);
      item port_2 using per_instance, ignore = (port_2 in [0, 5..7]);
      cross out_resp1_p, out_resp2_p, port_1, port_2;
   };

   cover port_resp_cmd_complete is {
      item out_resp1_p using per_instance, ignore = (out_resp1_p == 3);
      item out_resp2_p using per_instance, ignore = (out_resp2_p == 3);
      item port_1 using per_instance, ignore = (port_1 in [0, 5..7]);
      item port_2 using per_instance, ignore = (port_2 in [0, 5..7]);
      item cmd_in1 using per_instance, ignore = ( cmd_in1 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item cmd_in2 using per_instance, ignore = ( cmd_in2 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      cross out_resp1_p, out_resp2_p, port_1, port_2, cmd_in1, cmd_in2;
   };

};

extend instruction_parallel4_s {

   event instruction_complete;

   cover instruction_complete is {
      item cmd_in1 using per_instance, ignore = ( cmd_in1 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item cmd_in2 using per_instance, ignore = ( cmd_in2 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item cmd_in3 using per_instance, ignore = ( cmd_in3 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item cmd_in4 using per_instance, ignore = ( cmd_in4 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item out_resp1_p using per_instance, ignore = (out_resp1_p == 3);
      item out_resp2_p using per_instance, ignore = (out_resp2_p == 3);
      item out_resp3_p using per_instance, ignore = (out_resp3_p == 3);
      item out_resp4_p using per_instance, ignore = (out_resp4_p == 3);
      cross cmd_in1, cmd_in2, cmd_in3, cmd_in4, out_resp1_p, out_resp2_p, out_resp3_p, out_resp4_p;
   };

};

extend driver_u {

   collect_response_serial(ins : instruction_s) @clk is also {

      emit ins.instruction_complete;
      emit ins.port_cmd_complete;
      emit ins.resp_port_complete;
      emit ins.port_resp_cmd_complete;

   };

   collect_response_parallel2(ins : instruction_parallel2_s) @clk is also {

      emit ins.instruction_complete;
      emit ins.port_cmd_complete;
      emit ins.resp_port_complete;
      emit ins.port_resp_cmd_complete;

   };


   collect_input_parallel4(ins : instruction_parallel4_s) @clk is also {

      emit ins.instruction_complete;

    };

}; // extend driver_u

'>

