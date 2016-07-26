import QtQuick 2.0

Item {
    property var testProperties: ({})

    function checkUnsettled(promise) {
        if (promise.isFulfilled) {
            console.log("Spuriously fulfilled promise.")
            return false
        }
        if (promise.isRejected) {
            console.log("Spuriously rejected promise.")
            return false
        }
        if (promise.isSettled) {
            console.log("Spuriously settled promise.")
            return false
        }
        return true
    }
    function checkFulfilled(promise) {
        if (!promise.isFulfilled) {
            console.log("Spuriously unfulfilled promise.")
            return false
        }
        if (promise.isRejected) {
            console.log("Spuriously rejected promise.")
            return false
        }
        if (!promise.isSettled) {
            console.log("Spuriously unsettled promise.")
            return false
        }
        return true
    }
    function checkRejected(promise) {
        if (promise.isFulfilled) {
            console.log("Spuriously fulfilled promise.")
            return false
        }
        if (!promise.isRejected) {
            console.log("Spuriously unrejected promise.")
            return false
        }
        if (!promise.isSettled) {
            console.log("Spuriously unsettled promise.")
            return false
        }
        return true
    }

    function basicResolve1() {
        testProperties.resolved = false
        var promise = tester.makePromise()
        tester.getScriptPromise(promise).then(function() {
            testProperties.resolved = true
        })
        checkUnsettled(promise)
        promise.resolve()
        testProperties.promise = promise
        return true;
    }
    function basicResolve2() {
        checkFulfilled(testProperties.promise)
        return testProperties.resolved
    }

    function basicReject1() {
        testProperties.resolved = false
        var promise = tester.makePromise()
        tester.getScriptPromise(promise).then(function() {
            console.log("Promise was accepted when it shouldn't have been.")
        }, function() {
            testProperties.resolved = true
        })
        checkUnsettled(promise)
        promise.reject()
        testProperties.promise = promise
        return true
    }
    function basicReject2() {
        checkRejected(testProperties.promise)
        return testProperties.resolved
    }

    function resolveWithArguments1() {
        testProperties.resolved = false
        var promise = tester.makePromise()
        tester.getScriptPromise(promise).then(function(args) {
            if (args[0] !== "blue" || args[1] !== 1 || args[2] !== false) {
                console.log("Arguments wrong", args)
                return
            }
            testProperties.resolved = true
        })
        checkUnsettled(promise)
        promise.resolve(["blue", 1, false])
        testProperties.promise = promise
        return true;
    }
    function resolveWithArguments2() {
        checkFulfilled(testProperties.promise)
        return testProperties.resolved
    }
}
