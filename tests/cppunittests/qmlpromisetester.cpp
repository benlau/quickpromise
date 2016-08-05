// Author:  Nathan Hourt (https://github.com/nathanhourt/)
#include "qmlpromisetester.hpp"

#include <QQmlContext>
#include <QJSValue>
#include <QtQml>

void QmlPromiseTester::runTest(QString testName) {
    int calls = 0;
    auto object = engine.rootObjects().first()->metaObject();
    for (int i = 0; i < object->methodCount(); ++i)
        if (object->method(i).name().startsWith(testName.toLocal8Bit()))
            ++calls;
    QVERIFY2(calls > 0, "No tests found");

    int call = 1;
    while (call <= calls) {
        std::string callName = (testName + QString::number(call++)).toStdString();
        qDebug() << "Invoking" << callName.c_str();

        QVariant passed = false;
        QMetaObject::invokeMethod(engine.rootObjects().first(), callName.c_str(), Q_RETURN_ARG(QVariant, passed));
        QVERIFY(passed.toBool());

        qApp->processEvents();
        engine.collectGarbage();
        qApp->processEvents();
    }
}

QmlPromiseTester::QmlPromiseTester(QObject *parent) : QObject(parent) {
    qmlRegisterType<QmlPromiseTester>("tests", 1, 0, "Tester");
    qmlRegisterUncreatableType<QPPromise>("QuickPromise", 1, 0, "QmlPromise", "");
    engine.addImportPath("qrc:/");
    engine.rootContext()->setContextProperty("tester", this);
    engine.load(QUrl("qrc:/tests.qml"));
}

QPPromise* QmlPromiseTester::makePromise() {
    auto promise = new QPPromise(engine.rootObjects().first());
    return promise;
}

QJSValue QmlPromiseTester::getScriptPromise(QPPromise* promise) {
    return *promise;
}
