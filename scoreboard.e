
   scoreboard.e file
   -----------------
   This file provides a scoreboard to check for proper priority and data integrity.

<'

struct expected_resp {
    key_port : uint(bits:3);
    val      : uint(bits:32);
};

struct queue_entry {
    key : int;

    entry : list(key: key_port) of expected_resp;
};

struct scoreboard_u {

  !queue: list(key: key) of queue_entry;

   //queue1 : list of uint(bits:32);
   //queue2 : list of uint(bits:32);
   //queue3 : list of uint(bits:32);
   //queue4 : list of uint(bits:32);

    //new_expected_resp(key_port : uint(bits:3), val : uint(bits:32)) : return expected_resp is {
    //    var exp_resp : expected_resp = new;
    //    exp_resp.key_port = key_port;
    //    exp_resp.val = val;
    //    result = exp_resp;
    //};

    queue_last : int;
    queue_curr : int;

    add_new_entry(entry: queue_entry) is {
        entry.key = queue_last;
        queue.add(entry);
        queue_last += 1;
    };

    remove_expected_res(entry_key: int, key_port: uint(bits:3)) is {
        queue.key(entry_key).entry.delete(key_port)
    };

    seen_a_resp(port: uint(bits:3), val: uint(bits:32)) is {
        var entry : queue_entry = queue.key(queue_curr);
        if (!entry.entry.key_exists(queue_curr)) {
            dut_error(appendf("[R==>Unexpected port response %u in scoreboard.<==R]\n \
                               Bad priority, FIFO?\n",
                               queue_curr));
        } else if (entry.entry.key(queue_curr).val != val) {
            dut_error(appendf("[R==>Unexpected value response from port %u in scoreboard.<==R]\n \
                               expected: %u \n \
                               received: %u \n ",
                               queue_curr, entry.entry.key(queue_curr).val, val));
        } else {
            remove_expected_res(queue_curr, port);
        };
    };
    //=============================================
    // test if entry is empty and so increase curr ++
    // ===============================================

    // adding an entry
    //var s : array_entry = new;
    //s.key = "foo";
    //s.val = 0xdead_beef;
    //assoc_array.add(s);

    // check if an entry exists
    //print assoc_array.key_exists("bar");

    // get an entry
    //if assoc_array.key_exists("foo") {
    //  print assoc_array.key("foo").val using hex;
    //};

   //add_to_queue(queueN : int, num : uint(bits:32)) is {
   //   case queueN {
   //     1: {
   //         queue1.add(num);
   //     };
   //     2: {
   //         queue2.add(num);
   //     };
   //     3: {
   //         queue3.add(num);
   //     };
   //     4: {
   //         queue4.add(num);
   //     };
   //   };
   //};

   //check_queue(i : int) is {
   //    outport = queue.pop0();
   //    if outport != i {
   //        dut_error(appendf("[R==>Unexpected priority<==R]\n \
   //                    expected port %d,\n \
   //                    received port %d,\n",
   //                    i, outport));
   //    };
   //}
};

'>
