
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
      item cmd_in;
      item resp using per_instance, ignore = (resp == 3);
      cross cmd_in, resp;
   };

   cover port_cmd_complete is {
      item cmd_in;
      item port;
      cross cmd_in, port;
   };

   cover resp_port_complete is {
      item resp using per_instance, ignore = (resp == 3);
      item port;
      cross resp, port;
   };

   cover port_resp_cmd_complete is {
      item cmd_in;
      item resp using per_instance, ignore = (resp == 3);
      item port;
      cross cmd_in, resp, port;
   };

}; // extend instruction_s

extend driver_u {

   collect_response(ins : instruction_s) @clk is also {

      emit ins.instruction_complete;
      emit ins.port_cmd_complete;
      emit ins.resp_port_complete;
      emit ins.port_resp_cmd_complete;

   };

}; // extend driver_u

'>

