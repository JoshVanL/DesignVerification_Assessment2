
   scoreboard.e file
   -----------------
   This file provides a scoreboard to check for proper priority and data integrity.

<'

unit scoreboard_u {

   queue   : list of uint(bits:3);
   outport : uint(bits:3);

   add_to_queue(i : int) is {
        queue.add(i);
   };

   check_queue(i : int) is {
       outport = queue.pop0();
       if outport != i {
           dut_error(appendf("[R==>Unexpected priority<==R]\n \
                       expected port %d,\n \
                       received port %d,\n",
                       i, outport));
       };
   }

};

'>
