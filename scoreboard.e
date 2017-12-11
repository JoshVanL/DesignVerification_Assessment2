
   scoreboard.e file
   -----------------
   This file provides a scoreboard to check for proper priority and data integrity.

<'

struct expected_resp {
    key_port : uint(bits:3);
    //val      : uint(bits:32);
};

struct queue_entry {
    qIndex  : int;
    size : int;

    entry : list(key: key_port) of expected_resp;
};

unit scoreboard_u {

    !queue: list(key: qIndex) of queue_entry;

    queue_last : int;
    queue_curr : int;

    add_new_entry(scr: scoreboard_u, entry: queue_entry) is {
        entry.qIndex = scr.queue_last;
        scr.queue.add(entry);
        scr.queue_last += 1;
    };

    remove_expected_res(scr: scoreboard_u, entry_key: int, key_port: uint(bits:3)) is {
        //for each (ent) in scr.queue.key(scr.queue_curr).entry {
        //    outf("============= %d ==========\n", ent.key_port);
        //};
        //outf("\n");
        //outf("Deleted %d from queue\n", key_port);

        scr.queue.key(entry_key).entry.delete(scr.queue.key(entry_key).entry.key_index(key_port));
        scr.queue.key(entry_key).size -= 1;
        if (scr.queue.key(entry_key).size == 0) {
            scr.queue.delete(scr.queue.key_index(entry_key));
            scr.queue_curr += 1;
        };
        //queue.key(entry_key).entry.resize(queue.key(entry_key).size);
    };

    seen_a_resp(scr: scoreboard_u, port: uint(bits:3)) is {

        if (!scr.queue.key(scr.queue_curr).entry.key_exists(port)) {
            dut_error(appendf("[R==>SCOREBOARD: Unexpected port response %u.<==R]\n \
                               Bad priority, FIFO?\n",
                               port));
            outf("Current entry contains: \n");
            for each (ent) in scr.queue.key(scr.queue_curr).entry {
                outf("%d,", ent.key_port);
            };
            outf("\n");

        //} else if (entry.entry.key(port).val != val) {
        //    dut_error(appendf("[R==>SCOREBOARD: Unexpected value response from port %u.<==R]\n \
        //                       expected: %u \n \
        //                       received: %u \n ",
        //                       scr.queue_curr, entry.entry.key(scr.queue_curr).val, val));

        } else {
            remove_expected_res(scr, scr.queue_curr, port);
        };
    };

    init_scoreboard(scr: scoreboard_u) is {
        scr.queue_last = 1;
        scr.queue_curr = 1;
    };

    clean(scr: scoreboard_u) is {
        scr.queue_last = 1;
        scr.queue_curr = 1;
        scr.queue.clear();
    };

};

'>
