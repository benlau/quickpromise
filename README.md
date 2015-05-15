# Quick Promise - QML Promise Library

The Promise object is used for deferred and asynchronous computation. It is widely used in Javascript application. QuickPromise is an implementation of Promise object for QT/QML. It has followed the [https://promisesaplus.com/](Promise/A+) standard plus extra support for QML component. 


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
        resolveWhen: image1.status === Image.Ready || image2.status === Image.Ready
        onFulfilled:  {
            anim.start();
        }
    }
}

```

The code above demonstrated how Promise component could be used in asynchronous workflow. The resolveWhen property accepts a boolean expression. Once the expression comes truth, it will trigger the “onFulfilled” slot in next execution context stack (Qt::QueuedConnection). *The slot will be executed for once only*.

QuickPromise implemented two set of Promise object. The first is QML-based which was shown in the above example. Another one is for pure Javascript environment , you don't need to declare the component and just used like other Promise implementation in Javascript applicaiton.

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


Q.promise()
===========

Q.promise() is the creator function of Promise object for Javascript code. You won't need to declare a QML component before use it. As it follow the Promise/A+ standard , the API is very similar to other implementation. However, it don't support property binding (resolveWhen , rejectWhen) and signal (fulfilled, rejected , settled) like the Promise QML component. 

```
Promise.prototype.then = function(onFulfilled,onRejected) { ... }
Promise.prototype.resolve = function(value) { ... }
Promise.prototype.reject = function(reason) { ... }

```

Extra API

Q.all(promises)
-------

Given an array of promises , it will create a promise object that will be fulfilled once all the input promises are fulfilled. And it will be rejected if any one of the input promises is rejected.


Q.allSettled(promises)
--------------

Given an array of promises , it will create a promise object that will be fulfilled once all the input promises are fulfilled. And it will be rejected if any one of the input promises is rejected. It won't change the state until all the input promises are settled. 




