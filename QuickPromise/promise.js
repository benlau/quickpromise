// Quick Promise Script
// Author:  Ben Lau (https://github.com/benlau)

.pragma library
.import QuickPromise 1.0 as QP

/* JavaScript implementation of promise object
 */

function Promise() {

    this.state = "pending";

    this._onFulfilled = [];
    this._onRejected = [];

    // The value of resolved promise or the reason to be rejected.
    this._result = undefined;

    this.___promiseSignature___ = true;

    this.isSettled = false;
    this.isFulfilled = false;
    this.isRejected = false;
}

function instanceOfPromiseJS(object) {
    return typeof object === "object" &&
           typeof object.hasOwnProperty === "function" &&
            object.hasOwnProperty("___promiseSignature___");
}

function instanceOfPromiseItem(object) {
    return typeof object === "object" &&
           typeof object.hasOwnProperty === "function" &&
            object.hasOwnProperty("___promiseQmlSignature71237___");
}

function instanceOfPromise(object) {
    return instanceOfPromiseJS(object) || instanceOfPromiseItem(object)
}

function _instanceOfSignal(object) {
    return (typeof object === "object" ||
            typeof object === "function") &&
            typeof object.hasOwnProperty === "function" &&
            typeof object.connect === "function" &&
            typeof object.disconnect === "function";
}

Promise.prototype.then = function(onFulfilled,onRejected) {
    var thenPromise = new Promise();

    this._onFulfilled.push(function(value) {
        if (typeof onFulfilled === "function" ) {
            try {
                var x = onFulfilled(value);
                thenPromise.resolve(x);
            } catch (e) {
                console.error(e);
                console.trace();
                thenPromise.reject(e);
            }

        } else {
            // 2.2.7.3
            thenPromise.resolve(value);
        }
    });

    this._onRejected.push(function(reason) {
        if (typeof onRejected === "function") {
            try {
                var x = onRejected(reason);
                thenPromise.resolve(x);
            } catch (e) {
                console.error(e);
                console.trace();
                thenPromise.reject(e);
            }
        } else {
            // 2.2.7.4
            thenPromise.reject(reason);
        }
    });

    return thenPromise;
}


Promise.prototype.resolve = function(value) {
    if (this.state !== "pending")
        return;

    if (this === value) { // 2.3.1
        this.reject(new TypeError("Promise.resolve(value) : The value can not be same as the promise object."));
        return;
    }

    var promise = this;

    if (value && _instanceOfSignal(value)) {
        try {
            var newPromise = new Promise();
            value.connect(function() {
                newPromise.resolve();
            });
            value = newPromise;
        } catch (e) {
            console.error(e);
            throw new Error("promise.resolve(object): Failed to call object.connect(). Are you passing the result of Qt.binding()? Please use QML Promise and pass it to resolveWhen property.");
        }
    }

    if (value &&
        instanceOfPromise(value)) {

        if (value.state === "pending") {
            value.then(function(x) {
                promise._resolveInTick(x);
            },function(x) {
                promise.reject(x);
            });

            return;
        } else if (value.state === "fulfilled") {
            this._resolveInTick(value._result);
            return;
        } else if (value.state === "rejected") {
            this.reject(value._result);
            return;
        }
    }

    if (value !== null && (typeof value === "object" || typeof value === "function")) {
        var then;
        try {
            then = value.then;
        } catch (e) {
            console.error(e);
            console.trace();
            promise.reject(e);
            return;
        }

        if (typeof then === "function") {
            try {
                var called = false;
                then.call(value,function(y) {
                    if (called)
                        return;
                    called = true;
                    promise.resolve(y);
                },function (y) {
                    if (called)
                        return;

                    called = true;
                    promise.reject(y);
                });
            } catch (e) {
                console.error(e);
                console.trace();
                if (!called) {
                    promise.reject(e);
                }
            }
            return;
        }
    }

    this._resolveInTick(value);
}

Promise.prototype._resolveInTick = function(value) {
    var promise = this;

    QP.QPTimer.setTimeout(function() {
        if (promise.state !== "pending")
            return;

        promise._resolveUnsafe(value);
    },0);
}

/*
     Resolve without value type checking
 */

Promise.prototype._resolveUnsafe = function(value) {

    this._emit(this._onFulfilled,value);

    this._result = value;
    this._setState("fulfilled");
}

Promise.prototype.reject = function(reason) {
    if (this.state !== "pending")
        return;

    var promise = this;

    if (reason && _instanceOfSignal(reason)) {
        reason.connect(function() {
            promise.reject();
        });
        return;
    }

    QP.QPTimer.setTimeout(function() {
        if (promise.state !== "pending")
            return;

        promise._rejectUnsafe(reason);
    },0);
}

Promise.prototype._rejectUnsafe = function(reason) {
    this._emit(this._onRejected,reason);

    this._result = reason;
    this._setState("rejected");
}

Promise.prototype._emit = function(arr,value) {
    var res = value;
    for (var i = 0 ; i < arr.length;i++) {
        var func = arr[i];
        if (typeof func !== "function")
            continue;
        var t = func(value);
        if (t) // It is non-defined behaviour in A+
            res = t;
    }
    return res;
}

Promise.prototype._setState = function(state) {
    if (state === "fulfilled") {
        this.isFulfilled = true;
        this.isSettled = true;
        this._onFullfilled = [];
        this._onRejected = [];
    } else if (state === "rejected"){
        this.isRejected = true;
        this.isSettled = true;
        this._onFullfilled = [];
        this._onRejected = [];
    }
    this.state = state;
}


function promise() {
    return new Promise();
}
