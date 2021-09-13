module MultiportServer {
    use ZMQ;
    use IO;
    proc main() {
        begin {
            var context: ZMQ.Context;
            var socket : ZMQ.Socket = context.socket(ZMQ.REP);
            try! writeln("STARTING 5556");
            try! socket.bind("tcp://*:%t".format(5556));
            while true {
                var req = try! socket.recv(bytes).decode();
                try! writeln("GOT REQ on 5556 %t".format(req));
                try! socket.send('response to msg %t'.format(req));
            }
        }
        var context: ZMQ.Context;
        var socket : ZMQ.Socket = context.socket(ZMQ.REP);
        try! writeln("STARTING 5555");
        try! socket.bind("tcp://*:%t".format(5555));
        while true {
            var req = try! socket.recv(bytes).decode();
            try! writeln("GOT REQ on 5555 %t".format(req));
            try! socket.send('response to msg %t'.format(req));
        }
    }
}
