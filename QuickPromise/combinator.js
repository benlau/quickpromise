.pragma library
.import "./promise.js" as PromiseJS

// Combinate a list of promises into a single promise object.
function Combinator(promises,allSettled) {
    this._combined = new PromiseJS.Promise();
    this._allSettled = allSettled === undefined ? false  : allSettled;
    this._promises = [];
    this._results = [];
    this._count = 0;

    // Any promise rejected?
    this._rejected = false;
    this._rejectReason = undefined;

    this.add(promises);

    this._settle();
}

Combinator.prototype.add = function(promises) {
    if (PromiseJS.instanceOfPromise(promises)) {
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
    if (PromiseJS._instanceOfSignal(promise)) {
        var delegate = new PromiseJS.Promise();
        delegate.resolve(promise);
        this._addCheckedPromise(delegate);
    } else if (promise.isSettled) {
        if (promise.isRejected) {
            this._reject(promise._result);
        }
        // calling `resolve` after adding resolved promises is covered
        // by the call to `_settle` in constructor
    } else {
        this._addCheckedPromise(promise);
    }
}

Combinator.prototype._addCheckedPromise = function(promise) {
    var combinator = this;

    var promiseIndex = this._promises.length;
    combinator._promises.push(promise);
    combinator._results.push(undefined);
    combinator._count++;

    promise.then(function(value) {
        combinator._count--;
        combinator._results[promiseIndex] = value;
        combinator._settle();
    },function(reason) {
        combinator._count--;
        combinator._reject(reason);
    });
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
Combinator.prototype._settle = function() {
    if (this._count !== 0) {
        return;
    }

    if (this._rejected) {
        this._combined.reject(this._rejectedReason);
    } else {
        this._combined.resolve(this._results);
    }
}

function create(promises,allSettled) {
    return new Combinator(promises,allSettled);
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

