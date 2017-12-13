
   scoreboard.e file
   -----------------
   This file provides a scoreboard to check for proper priority.

<'

struct expected_resp {
    port : uint(bits:3);
};

struct queue_entry {
    qIndex  : int;
    size : int;

    entry : list(key: port) of expected_resp;
};

unit scoreboard_u {

    !queue: list(key: qIndex) of queue_entry;

    q_tail : int;
    q_head : int;

    add_new_entry(scr: scoreboard_u, entry: queue_entry) is {
        entry.qIndex = scr.q_tail;
        scr.queue.add(entry);
        scr.q_tail += 1;
    };

    remove_expected_res(scr: scoreboard_u, port: uint(bits:3)) is {
        var q_head_entry : queue_entry = scr.queue.key(q_head);

        q_head_entry.entry.delete(q_head_entry.entry.key_index(port));
        q_head_entry.size -= 1;
        if (q_head_entry.size == 0) {
            scr.queue.delete(scr.queue.key_index(q_head));
            scr.q_head += 1;
        };
    };

    seen_a_resp(scr: scoreboard_u, port: uint(bits:3)) is {
        var q_head_entry : queue_entry = scr.queue.key(q_head);

        if (!q_head_entry.entry.key_exists(port)) {
            dut_error(appendf("[R==>SCOREBOARD: Unexpected port response %u.<==R]\n \
                               Bad priority, FIFO?\n",
                               port));
            outf("Current entry contains: \n");

        } else {
            remove_expected_res(scr, port);
        };
    };

    init_scoreboard(scr: scoreboard_u) is {
        scr.q_tail = 1;
        scr.q_head = 1;
    };

    clean(scr: scoreboard_u) is {
        scr.q_tail = 1;
        scr.q_head = 1;
        scr.queue.clear();
    };

};

'>
