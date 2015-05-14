// Author:  Ben Lau (https://github.com/benlau)
import QtQuick 2.0
import QtQml 2.2
import QuickPromise 1.0
import "q.js" as Q

QtObject {
    id : promise

    default property alias data: promise.__data
    property list<QtObject> __data: [QtObject{}]

    property bool isFulfilled : false

    property bool isRejected : false

    property bool isSettled : isFulfilled || isRejected

    /// An expression that will trigger resolve() if the value become true or another promise object. It should be set once only.
    property var resolveWhen

    /// An expression that will trigger reject() if the value become true. Don't assign another promise object here.
    property var rejectWhen

    signal fulfilled(var value)
    signal rejected(var reason)
    signal settled(var value)

    property var _promise;

    property var _result

    /// Random signature for type checking
    property var ___promiseQmlSignature71237___

    property var _thenPromise : null;

    /*
    function setTimeout(callback,interval) {
        var obj = Qt.createQmlObject('import QtQuick 2.2; Timer {running: false; repeat: false; }', promise, "setTimeout");
        obj.interval = interval;
        obj.triggered.connect(function() {
            obj.destroy();
            callback();
        });
        obj.running = true;
    }
    */

    function setTimeout(callback,interval) {
        QPTimer.setTimeout(callback,interval);
    }

    function then(onFulfilled,onRejected) {
        return _promise.then(onFulfilled,onRejected);
    }

    function resolve(value) {
        if (instanceOfPromise(value)) {
            value = value._promise;
        } else if (_instanceOfSignal(value)) {
            var promise = Q.promise();
            value.connect(function() {
                promise.resolve();
            });
            value = promise;
        }

        _promise.resolve(value);
    }

    function reject(reason) {
        _promise.reject(reason);
    }

    /// Combine multiple promises into a single promise.
    function all(promises) {
        return Q.all(promises);
    }

    /// Combine multiple promises into a single promise. It will wait for all of the promises to either be fulfilled or rejected.
    function allSettled(promises) {
        return Q.allSettled(promises);
    }

    function instanceOfPromise(object) {
        return typeof object === "object" && object.hasOwnProperty("___promiseQmlSignature71237___");
    }

    function _instanceOfSignal(object) {
        return typeof object === "object" &&
                      object.hasOwnProperty("connect") &&
                      object.hasOwnProperty("disconnect");
    }

    function _init() {
        if (!_promise)
            _promise = Q.promise();
    }

    onResolveWhenChanged: {
        _init();

        if (resolveWhen === true) {
            // Resolve on next tick is necessary for promise
            // created via Component and fulfill immediately
            setTimeout(function() {
                resolve();
            },0);

        } else if (instanceOfPromise(resolveWhen) || Q.instanceOfPromise(resolveWhen)) {
            setTimeout(function() {
                resolve(resolveWhen);
            },0);
        }
    }

    onRejectWhenChanged: {
        _init();
        if (rejectWhen === true) {
            reject();
        }
    }

    Component.onCompleted: {
        _init();

        _promise.then(function(value) {
            isFulfilled = true;
            fulfilled(value);
            settled(value);
        },function(reason) {
            isRejected = true;
            rejected(reason);
            settled(reason);
        });
    }

}

