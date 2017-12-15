
   Sample coverage.e file
   ----------------------
   This file provides a basic example of coverage collection for the calc1 
   testbench.

<'

extend instruction_s {

   event cmd_resp_withError_complete;
   event cmd_resp_noError_complete;
   event port_cmd_complete;
   event resp_port_complete;
   event port_resp_cmd_complete;

   cover cmd_resp_withError_complete is {
      item cmd_in using per_instance, ignore = (cmd_in in [NOP, SHR, SHL, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item resp using per_instance, ignore = (resp in [0, 3]);
      cross cmd_in, resp;
   };

   cover cmd_resp_noError_complete is {
      item cmd_in using per_instance, ignore = (cmd_in in [NOP, ADD, SUB, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item resp using per_instance, ignore = (resp in [0, 2, 3]);
      cross cmd_in, resp;
   };

   cover port_cmd_complete is {
      item cmd_in using per_instance, ignore = (cmd_in == NOP);
      item port using per_instance, ignore = (port in [0, 5..7]);
      cross cmd_in, port;
   };

   cover resp_port_complete is {
      item resp using per_instance, ignore = (resp in [0, 3]);
      item port using per_instance, ignore = (port in [0, 5..7]);
      cross resp, port;
   };

   cover port_resp_cmd_complete is {
      item cmd_in using per_instance, ignore = (cmd_in in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item resp using per_instance, ignore = (resp in [0, 3]);
      item port using per_instance, ignore = (port in [0, 5..7]);
      cross cmd_in, resp, port;
   };

}; // extend instruction_s

extend instruction_parallel2_s {

   event cmd_resp_withError_complete;
   event cmd_resp_noError_complete;
   event port_cmd_complete;
   event resp_port_complete;
   event port_resp_cmd_complete;

   cover cmd_resp_withError_complete is {
      item cmd_in1 using per_instance, ignore = ( cmd_in1 in [NOP, SHL, SHR, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item cmd_in2 using per_instance, ignore = ( cmd_in2 in [NOP, SHL, SHR, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item out_resp1_p using per_instance, ignore = (out_resp1_p in [0, 3]);
      item out_resp2_p using per_instance, ignore = (out_resp2_p in [0, 3]);
      cross cmd_in1, cmd_in2, out_resp1_p, out_resp2_p;
   };

   cover cmd_resp_noError_complete is {
      item cmd_in1 using per_instance, ignore = ( cmd_in1 in [NOP, ADD, SUB, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item cmd_in2 using per_instance, ignore = ( cmd_in2 in [NOP, ADD, SUB, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item out_resp1_p using per_instance, ignore = (out_resp1_p in [0, 2, 3]);
      item out_resp2_p using per_instance, ignore = (out_resp2_p in [0, 2, 3]);
      cross cmd_in1, cmd_in2, out_resp1_p, out_resp2_p;
   };

   cover port_cmd_complete is {
      item cmd_in1 using per_instance, ignore = ( cmd_in1 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item cmd_in2 using per_instance, ignore = ( cmd_in2 in [NOP, INV1, INV2, INV3, INV4, INV5, INV6, INV7, INV8, INV9, INV10, INV11]);
      item port_1 using per_instance, ignore = (port_1 in [0, 4..7]);
      item port_2 using per_instance, ignore = (port_2 in [0, 1, 5..7]);
      cross cmd_in1, cmd_in2, port_1, port_2;
   };

   cover resp_port_complete is {
      item out_resp1_p using per_instance, ignore = (out_resp1_p in [0, 3]);
      item out_resp2_p using per_instance, ignore = (out_resp2_p in [0, 3]);
      item port_1 using per_instance, ignore = (port_1 in [0, 4..7]);
      item port_2 using per_instance, ignore = (port_2 in [0, 1, 5..7]);
      cross out_resp1_p, out_resp2_p, port_1, port_2;
   };

};

extend driver_u {

   collect_response_serial(ins : instruction_s) @clk is also {

      emit ins.cmd_resp_withError_complete;
      emit ins.cmd_resp_noError_complete;
      emit ins.port_cmd_complete;
      emit ins.resp_port_complete;
      emit ins.port_resp_cmd_complete;

   };

   collect_response_parallel2(ins : instruction_parallel2_s) @clk is also {

      emit ins.cmd_resp_withError_complete;
      emit ins.cmd_resp_noError_complete;
      emit ins.port_cmd_complete;
      emit ins.resp_port_complete;

   };

}; // extend driver_u

'>

