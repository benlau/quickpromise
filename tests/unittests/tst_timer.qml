import QtQuick 2.0
import QtTest 1.0
import QuickPromise 1.0

TestSuite {
    name : "Timer"

    function test_exception() {
        // It should print exception.
        Q.setTimeout(function() {
            global = 1;
        },0);
        wait(10);
    }

}
