
   scoreboard.e file
   -----------------
   This file provides a scoreboard to check for proper priority.

<'

//Port wave
struct queue_entry_s {
    qIndex  : int;
    size : int;

    port_wave : list(key: port) of expected_resp_port_s;
};

//Port struct for parts of the wave
struct expected_resp_port_s {
    port : uint(bits:3);
};

unit scoreboard_u {

    //scoreboard queue of port waves
    !queue: list(key: qIndex) of queue_entry_s;

    q_tail : int;
    q_head : int;

    //clean scoreboard for next test
    initialise_scoreboard(scr: scoreboard_u) is {
        scr.q_tail = 1;
        scr.q_head = 1;
        scr.queue.clear();
    };

    // add new port wave
    add_new_entry(scr: scoreboard_u, entry: queue_entry_s) is {
        entry.qIndex = scr.q_tail;
        scr.queue.add(entry);
        scr.q_tail += 1;
    };

    //remove port from wave
    remove_port(scr: scoreboard_u, port: uint(bits:3)) is {
        var q_head_entry : queue_entry_s = scr.queue.key(q_head);
        var port_index : uint(bits:3) = q_head_entry.port_wave.key_index(port);

        q_head_entry.port_wave.delete(port_index);
        q_head_entry.size -= 1;
        scr.check_entry_empty(scr);
    };

    //Check if the port wave has finished
    check_entry_empty(scr: scoreboard_u) is {
        var q_head_entry : queue_entry_s = scr.queue.key(q_head);
        if (q_head_entry.size == 0) {
            scr.queue.delete(scr.queue.key_index(q_head));
            scr.q_head += 1;
        };
    };

    //Test is a port is in the current wave
    seen_a_port(scr: scoreboard_u, port: uint(bits:3)) is {
        var q_head_entry : queue_entry_s = scr.queue.key(q_head);

        if (!q_head_entry.port_wave.key_exists(port)) {
            dut_error(appendf("[R==>SCOREBOARD: Unexpected port response %u.<==R]\n \
                               Bad priority, FIFO?\n",
                               port));
            outf("Current entry contains: \n");

        } else {
            remove_port(scr, port);
        };
    };

};

'>
