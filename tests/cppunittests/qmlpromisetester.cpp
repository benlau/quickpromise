// Author:  Nathan Hourt (https://github.com/nathanhourt/)
#include "qmlpromisetester.hpp"

#include <QJSValue>
#include <QtQml>

void QmlPromiseTester::runTest(QString testName) {
    int calls = 0;
    auto object = testObject->metaObject();
    for (int i = 0; i < object->methodCount(); ++i)
        if (object->method(i).name().startsWith(testName.toLocal8Bit()))
            ++calls;
    QVERIFY2(calls > 0, "No tests found");

    int call = 1;
    while (call <= calls) {
        std::string callName = (testName + QString::number(call++)).toStdString();
        qDebug() << "Invoking" << callName.c_str();

        QVariant passed = false;
        QMetaObject::invokeMethod(testObject, callName.c_str(), Q_RETURN_ARG(QVariant, passed));
        QVERIFY(passed.toBool());

        // Wait a few ticks, let promises resolve etc etc
        // NOTE: 10ms isn't enough time; tests fail. 11ms is. Weird. I would've thought 10 would be PLENTY of time.
        // Picking 50 for good measure.
        QEventLoop el;
        QTimer::singleShot(50, &el, SLOT(quit()));
        el.exec();
    }
}

QmlPromiseTester::QmlPromiseTester(QObject* testObject, QObject *parent)
    : QObject(parent),
      testObject(testObject) {}

QPPromise* QmlPromiseTester::makePromise() {
    return new QPPromise(testObject);
}

QJSValue QmlPromiseTester::getScriptPromise(QPPromise* promise) {
    return *promise;
}
