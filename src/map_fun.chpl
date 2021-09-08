module MapFun {

    use Map;
    use IO;

    proc main() {

        var metrics = new map(keyType=string,valType=int);
        metrics.addOrSet('item',1);
        try! writeln("NUMBER OF ITEMS: %i".format(metrics.getValue('item')));
        metrics.addOrSet('item',2);
        try! writeln("NUMBER OF ITEMS: %i".format(metrics.getValue('item')));

        metrics.addOrSet('two', 2);

        for key in metrics.keys() {
            try! writeln(key);
        }
        
        for (key,value) in metrics.items() {
            try! writeln("key: %t value: %t".format(key,value));
        }
    }
}
