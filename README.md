<a href="https://promisesaplus.com/">
    <img src="https://promisesaplus.com/assets/logo-small.png" alt="Promises/A+ logo"
         title="Promises/A+ 1.0 compliant" align="right" />
</a>
Quick Promise - QML Promise Library
===================================
[![Build Status](https://travis-ci.org/benlau/quickpromise.svg?branch=master)](https://travis-ci.org/benlau/quickpromise)

The Promise object is widely used for deferred and asynchronous computation in Javascript Application. "Quick Promise” is a library that provides Promise object in QML way. It comes with a Promise component with signal and property. It could be resolved via a binary expression,  another promise object, then trigger your callback by QueuedConnection.

Moreover, it also provides Promise as Javascript object that don’t need to declare in QML way. The API is fully compliant with  [Promises/A+](https://promisesaplus.com/) specification (Passed all the test cases) and therefore it just works like many other Promise solution for Javascript application.

*Example:*

```
import QtQuick 2.0
import QuickPromise 1.0

Item {
    id: item
    opacity: 0

    Column {
        Image {
            id : image1
            asynchronous: true
            source : "https://lh3.googleusercontent.com/_yimBU8uLUTqQQ9gl5vODqDufdZ_cJEiKnx6O6uNkX6K9lT63MReAWiEonkAVatiPxvWQu7GDs8=s640-h400-e365-rw";
        }

        Image {
            id : image2
            asynchronous: true
            source : "https://lh6.googleusercontent.com/RJtB863D-avwKyz3nuhcDZTCQ8SFL_27jHYuJ5gWurk72P2WMUyUvKDfIUlBxfFMkKMEL7luiA=s640-h400-e365-rw";
        }
    }

    PropertyAnimation {
        id: anim
        target: item; property: "opacity"
        from : "0"; to: "1";
        duration: 5000
    }

    Promise {
        resolveWhen: image1.status === Image.Ready && image2.status === Image.Ready
        onFulfilled:  {
            anim.start();
        }
    }
}

```

The code above demonstrated how Promise component could be used in asynchronous workflow for QML application. The resolveWhen property accepts a boolean expression or another Promise object. Once the result of expression becomes truth, it will trigger the “onFulfilled” slot via queued Connection. *The slot will be executed for once only*.

Remarks: The QML Promise component is not fully compliant with Promises/A+ specification.

Feature List
------------

1. Promise in QML way
 1. Trigger resolve()/reject() via binary expression, signal from resloveWhen / rejectWhen property
 2. isFulfilled / isRejected / isSettled properties for data binding.
 3. fulfulled , rejected , settled signals
2. Promise in Javascript way
 1. Unlike QML component, it don’t need to declare before use it.
 2. The API interface is fully compatible with [Promises/A+](https://promisesaplus.com/) specification. It is easy to get started.
3. Extra API
 1. Q.setTimeout() - A implementation of setTimeout() function for QML.
 2. all()/allSettled()  - Create a promise object from an array of promises

Installation Instruction
========================

 1) Clone this repository or download release to a folder within your source tree.

(You may use `git submodule` to embed this repository)

 2) Add this line to your profile file(.pro):

    include(quickpromise/quickpromise.pri) # You should modify the path by yourself

 3) Add "qrc://" to your QML import path

``` 
engine.addImportPath("qrc:///"); // QQmlEngine
```

 4) Add import statement in your QML file

```
import QuickPromise 1.0
```

What is Promise and how to use it?
==========================

Please refer to this site for core concept : [Promises](https://www.promisejs.org/)

Promise QML Componnet
=====================

```
Promise {
    property bool isFulfilled
    
    property bool isRejected
    
    property bool isSettled : isFulfilled || isRejected

    /// An expression that will trigger resolve() if the value become true or another promise object got resolved. 
    property var resolveWhen

    /// An expression that will trigger reject() if the value become true. Don't assign another promise object here.
    property var rejectWhen

    signal fulfilled(var value)

    signal rejected(var reason)

    signal settled(var value)

    function setTimeout(func,timeout) { ... }
    
    function then(onFulfilled,onRejected) { ... }

    function resolve(value) { ... }
    
    function reject(value) { ... }
    
    function all(promises) { ... }

    function allSettled(promises) { ... }
}
```

**resolveWhen**

resolveWhen property is an alternative method to call resolve() in QML way. You may bind a binary expression, another promise, signal to the "resolveWhen" property. It may trigger the resolve() depend on its type and value.

*resolveWhen(binary expression)*

Once the expression become true, it will trigger resolve(true).

*resolveWhen(signal)*

Listen the signal, once it is triggered, it will call resolve().

Example:
```
Timer {
    id: timer;
    repeat: true
    interval : 50
}

Promise {
    id : promise
    resolveWhen: timer.onTriggered
}
```

*resolveWhen(promise)*

It is equivalent to resolve(promise). It will adopt the state from the input promise object.

Let x be the input promise.

If x is fullfilled, call resolve().

If x is rejected, call reject().

If x is not settled, listen its state change. Once it is triggered, repeat the above steps.


Q.promise()
===========

Q.promise() is the creator function of Promise object in Javascript way. You won't need to declare a QML component before use it. As it is fully compliant with Promise/A+ specification, it is very easy to get started. However, it don't support property binding (resolveWhen , rejectWhen) and signal (fulfilled, rejected , settled) like the Promise QML component.

```
Promise.prototype.then = function(onFulfilled,onRejected) { ... }
Promise.prototype.resolve = function(value) { ... }
Promise.prototype.reject = function(reason) { ... }
```

Instruction of using then/resolve/reject: [Promises](https://www.promisejs.org/)

Extra API
---------

**Q.setTimeout(func,milliseconds)**

The setTimeout() method will wait the specified number of milliseconds, and then execute the specified function. If the milliseconds is equal to zero, the behaviour will be same as QueuedConnection.


**Q.all(promises)**

Given an array of promises , it will create a promise object that will be fulfilled once all the input promises are fulfilled. And it will be rejected if any one of the input promises is rejected.


**Q.allSettled(promises)**

Given an array of promises , it will create a promise object that will be fulfilled once all the input promises are fulfilled. And it will be rejected if any one of the input promises is rejected. It won't change the state until all the input promises are settled. 




