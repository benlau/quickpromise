import QtQuick 2.0
import "q.js" as Script
import QuickPromise 1.0
pragma Singleton

QtObject {
    id : component

    function setTimeout(callback,interval) {
        QPTimer.setTimeout(callback,interval);
    }

    function promise() {
        return Script.promise();
    }

    function all(promises) {
        return Script.all(promises);
    }

    function allSettled(promises) {
        return Script.allSettled(promises)
    }

    function instanceOfPromise(promise) {
        return Script.instanceOfPromise(promise);
    }

}

