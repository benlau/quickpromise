import QtQuick 2.0
import "promise.js" as PromiseJS
import "combinator.js" as Combinator
import QuickPromise 1.0
pragma Singleton

QtObject {
    id : component

    function setTimeout(callback,interval) {
        QPTimer.setTimeout(callback,interval);
    }

    function promise() {
        return PromiseJS.promise();
    }

    function all(promises) {
        return Combinator.all(promises);
    }

    function allSettled(promises) {
        return Combinator.allSettled(promises)
    }

    function instanceOfPromise(promise) {
        return PromiseJS.instanceOfPromise(promise);
    }

}

