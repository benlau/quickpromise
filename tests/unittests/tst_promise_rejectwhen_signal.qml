import QtQuick 2.0
import QtTest 1.0
import QuickPromise 1.0

TestCase {
    name : "Promise_RejectWhen_Signal"

    Timer {
        id: timer;
        repeat: true
        interval : 50
    }

    Promise {
        id : promise
        rejectWhen: timer.onTriggered
    }

    function test_rejectwhen_signal() {
        compare(promise.isRejected,false);
        wait(10);
        compare(promise.isRejected,false);
        timer.start();
        wait(10);
        compare(promise.isRejected,false);
        wait(50);
        compare(promise.isRejected,true);

    }
}

