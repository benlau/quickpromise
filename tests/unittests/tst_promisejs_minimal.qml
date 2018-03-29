import QtQuick 2.0
import QtTest 1.0
import "qrc:///QuickPromise/promise.js"  as Q


TestCase {
    name : "PromiseJS_Minimal"

    function tick() {
        wait(0);
        wait(0);
        wait(0);
    }

    function test_constructor() {
        var callbackResult = {}

        var promise = new Q.Promise(function(resolve, reject) {
           resolve("ready") ;
        });

        tick();

        compare(callbackResult.result, "ready");
    }

    function test_resolve() {
        var promise = Q.Promise.resolve("done");
        var callbackResult = {}
        promise.then(function(result) {
            callbackResult.result = result;
        });

        tick();

        compare(callbackResult.result, "done");
    }


}
