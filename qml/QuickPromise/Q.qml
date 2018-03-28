import QtQuick 2.0
import "promise.js" as PromiseJS
import QuickPromise 1.0
pragma Singleton

QtObject {
    id : component

    function setTimeout(callback,interval) {
        return QPTimer.setTimeout(callback,interval);
    }

    function clearTimeout(id) {
        QPTimer.clearTimeout(id);
    }

    function promise(executor) {
        return PromiseJS.promise(executor);
    }

    function resolved(result) {
        var p = PromiseJS.promise();
        p.resolve(result);
        return p;
    }

    function rejected(reason) {
        var p = PromiseJS.promise();
        p.reject(reason);
        return p;
    }

    function all(promises) {
        return PromiseJS.all(promises);
    }

    function allSettled(promises) {
        return PromiseJS.allSettled(promises)
    }

    function instanceOfPromise(promise) {
        return PromiseJS.instanceOfPromise(promise);
    }

}

