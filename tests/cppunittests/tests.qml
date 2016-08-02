// Author:  Nathan Hourt (https://github.com/nathanhourt/)

import QtQuick 2.0
import QuickPromise 1.0

/*
 * Funky test framework that I hacked together out of Qt Test. The infrastructure should take care of all the details;
 * all you need to know is that the actual tests are here in the QML (including testing invariants on the QmlPromise
 * because hopping back and forth between C++ and QML is too complex, and should make no difference).
 *
 * A test has a name, and is implemented as a series of functions in QML. If the test is named "foo" then the QML test
 * functions are foo1(), foo2(), etc, each of which returns true if the test passed or false otherwise. The test is
 * defined in qmlpromisetester.hpp as a private slot of the form `void foo() { runTest(__FUNCTION__); }`. Adding the
 * test slot in QmlPromiseTester will cause all of the (sequentially numbered) QML test functions to be called.
 *
 * It is necessary to check the result of a promise being resolved/rejected in a separate function from the one which
 * actually settles the promise, since there's no event loop actively running (I can't figure out how to do that with
 * Qt Test) so I need QML to relinquish execution so I can spin the event loop.
 */

Item {
    property var testProperties: ({})

    // ****** HELPER FUNCTIONS ******
    function checkUnsettled(promise) {
        if (promise.isFulfilled) {
            console.log("Spuriously fulfilled promise.")
            throw false
        }
        if (promise.isRejected) {
            console.log("Spuriously rejected promise.")
            throw false
        }
        if (promise.isSettled) {
            console.log("Spuriously settled promise.")
            throw false
        }
        return true
    }
    function checkFulfilled(promise) {
        if (!promise.isFulfilled) {
            console.log("Spuriously unfulfilled promise.")
            throw false
        }
        if (promise.isRejected) {
            console.log("Spuriously rejected promise.")
            throw false
        }
        if (!promise.isSettled) {
            console.log("Spuriously unsettled promise.")
            throw false
        }
        return true
    }
    function checkRejected(promise) {
        if (promise.isFulfilled) {
            console.log("Spuriously fulfilled promise.")
            throw false
        }
        if (!promise.isRejected) {
            console.log("Spuriously unrejected promise.")
            throw false
        }
        if (!promise.isSettled) {
            console.log("Spuriously unsettled promise.")
            throw false
        }
        return true
    }

    // ****** TEST CASES *******
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

    function rejectWithArgument1() {
        testProperties.resolved = false
        var promise = tester.makePromise()
        tester.getScriptPromise(promise).then(function() {
            console.log("Promise was accepted when it shouldn't have been.")
        }, function(arg) {
            if (arg !== "ur ugly") {
                console.log("Promise rejected with wrong argument", arg)
                return
            }

            testProperties.resolved = true
        })
        checkUnsettled(promise)
        promise.reject("ur ugly")
        testProperties.promise = promise
        return true
    }
    function rejectWithArgument2() {
        checkRejected(testProperties.promise)
        return testProperties.resolved
    }

    function twoResolversWithArgs1() {
        testProperties.resolved = false
        var promise = tester.makePromise()
        tester.getScriptPromise(promise).then(function(args) {
            if (args[0] !== "blue" || args[1] !== 1 || args[2] !== false) {
                console.log("Arguments wrong", args)
                return
            }
            testProperties.resolved1 = true
        })
        tester.getScriptPromise(promise).then(function(args) {
            if (args[0] !== "blue" || args[1] !== 1 || args[2] !== false) {
                console.log("Arguments wrong", args)
                return
            }
            testProperties.resolved2 = true
        })
        checkUnsettled(promise)
        promise.resolve(["blue", 1, false])
        testProperties.promise = promise
        return true;
    }
    function twoResolversWithArgs2() {
        checkFulfilled(testProperties.promise)
        return testProperties.resolved1 && testProperties.resolved2
    }

    function twoRejectersWithArg1() {
        testProperties.resolved = false
        var promise = tester.makePromise()
        tester.getScriptPromise(promise).then(function() {
            console.log("Promise was accepted when it shouldn't have been.")
        }, function(arg) {
            if (arg !== "ur ugly") {
                console.log("Promise rejected with wrong argument", arg)
                return
            }

            testProperties.resolved1 = true
        })
        tester.getScriptPromise(promise).then(function() {
            console.log("Promise was accepted when it shouldn't have been.")
        }, function(arg) {
            if (arg !== "ur ugly") {
                console.log("Promise rejected with wrong argument", arg)
                return
            }

            testProperties.resolved2 = true
        })
       checkUnsettled(promise)
        promise.reject("ur ugly")
        testProperties.promise = promise
        return true
    }
    function twoRejectersWithArg2() {
        checkRejected(testProperties.promise)
        return testProperties.resolved1 && testProperties.resolved2
    }

    function nestedPromise1() {
        testProperties.resolved = false
        var promise = tester.makePromise()
        testProperties.finalPromise = tester.getScriptPromise(promise).then(function(args) {
            if (args[0] !== "blue" || args[1] !== 1 || args[2] !== false) {
                console.log("Arguments wrong", args)
                return
            }
            var nestedPromise = Q.promise()
            testProperties.nestedPromise = nestedPromise
            return nestedPromise.then(function(text) {
                return args[0] + text
            })
        }).then(function(text) {
            if (text === "bluejay")
                testProperties.resolved = true
            else {
                console.log("Unexpected result", text)
            }
        })
        checkUnsettled(promise)
        checkUnsettled(testProperties.finalPromise)
        promise.resolve(["blue", 1, false])
        testProperties.promise = promise
        return true;
    }
    function nestedPromise2() {
        checkFulfilled(testProperties.promise)
        checkUnsettled(testProperties.nestedPromise)
        checkUnsettled(testProperties.finalPromise)
        if (testProperties.resolved) {
            console.log("Unexpected resolved === true")
            return false
        }
        testProperties.nestedPromise.resolve("jay")
        return true
    }
    function nestedPromise3() {
        checkFulfilled(testProperties.promise)
        checkFulfilled(testProperties.nestedPromise)
        return true
    }
    function nestedPromise4() {
        if (!testProperties.resolved) {
            console.log("Never resolved the nestedPromise")
            return false
        }
        return true
    }
    function nestedPromise5() {
        return checkFulfilled(testProperties.finalPromise)
    }
}
