// Quick Promise Script
// Author:  Ben Lau (https://github.com/benlau)

.pragma library
.import QuickPromise 1.0 as QP

/* JavaScript implementation of promise

  TODO : Implement the rule of 2.3.3
 */

function Promise() {

    this.state = "pending";

    this._onFulfilled = [];
    this._onRejected = [];

    // The value of resolved promise or the reason to be rejected.
    this._result = undefined;

    this.___promiseSignature___ = true;

    this.settled = false;
    this.accepted = false;
    this.rejected = false;
}

function instanceOfPromise(object) {
    if (typeof object !== "object")
        return false;

    return object.hasOwnProperty("___promiseSignature___");
}

Promise.prototype.then = function(onFulfilled,onRejected) {
    var thenPromise = new Promise();

    this._onFulfilled.push(function(value) {
        if (typeof onFulfilled === "function" ) {
            try {
                var x = onFulfilled(value);
                thenPromise.resolve(x);
            } catch (e) {
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

    if (value &&
        instanceOfPromise(value)) {

        if (value.state === "pending") {
            var promise = this;
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
        this.fulfilled = true;
        this.settled = true;
        this._onFullfilled = [];
        this._onRejected = [];
    } else if (state === "rejected"){
        this.rejected = true;
        this.settled = true;
        this._onFullfilled = [];
        this._onRejected = [];
    }
    this.state = state;
}

// Combinate a list of promises into a single promise object.
function Combinator(promises,allSettled) {
    this._combined = new Promise();
    this._allSettled = allSettled === undefined ? false  : allSettled;
    this._promises = [];
    this._count = 0;

    // Any promise rejected?
    this._rejected = false;
    this._rejectReason  = undefined;

    this.add(promises);

    this._settle();
}

Combinator.prototype.add = function(promises) {
    if (instanceOfPromise(promises)) {
        this._addPromise(promises);
    } else {
        this._addPromises(promises);
    }
    return this.combined;
}

Combinator.prototype._addPromises = function(promises) {
    for (var i = 0 ; i < promises.length;i++) {
        this._addPromise(promises[i]);
    }
}

Combinator.prototype._addPromise = function(promise) {
    var combinator = this;

    if (promise.settled) {
        if (promise.rejected) {
            combinator._reject(promise._result);
        }
    } else {
        this._promises.push(promise);
        this._count++;
        promise.then(function(value) {
            combinator._count--;
            combinator._settle(value);
        },function(reason) {
            combinator._count--;
            combinator._reject(reason);
        });
    }
}

Combinator.prototype._reject = function(reason) {
    if (this._allSettled) {
        this._rejected = true;
        this._rejectReason = reason;
    } else {
        this._combined.reject(reason);
    }
}

/// Check it match the settle condition, it will call resolve / reject on the combined promise.
Combinator.prototype._settle = function(value) {
    if (this._count !== 0) {
        return;
    }

    if (this._rejected) {
        this._combined.reject(this._rejectedReason);
    } else {
        this._combined.resolve(value);
    }
}

function promise() {
    return new Promise();
}

function all(promises) {
    var combinator = new Combinator(promises,false);

    return combinator._combined;
}

/// Combine multiple promises into one. It will wait for all of the promises to either be fulfilled or rejected.
function allSettled(promises) {
    var combinator = new Combinator(promises,true);

    return combinator._combined;
}

