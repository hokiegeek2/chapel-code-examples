module BeginFun {

    use IO;
    use Time;
    proc main() {
         begin {
             var counter = 0;

             for counter in 1..10 do {
                 try! writeln('INSIDE BEGIN %i'.format(counter));
                 Time.sleep(1);
             }
         }
         var counter = 0;
         for counter in 1..10 do {
             Time.sleep(3);
             try! writeln("OUTSIDE BEGIN");
         }
    }
}
