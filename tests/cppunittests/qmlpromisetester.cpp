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

        app.processEvents();
        engine.collectGarbage();
        app.processEvents();
    }
}

QmlPromiseTester::QmlPromiseTester(QObject *parent) : QObject(parent), app(argc, (char**)argv) {
    connect(&engine, &QQmlApplicationEngine::quit, &app, &QApplication::quit);
    qmlRegisterType<QmlPromiseTester>("tests", 1, 0, "Tester");
    qmlRegisterUncreatableType<QmlPromise>("QuickPromise", 1, 0, "QmlPromise", "");
    engine.addImportPath("qrc:/");
    engine.rootContext()->setContextProperty("tester", this);
    engine.load(QUrl("qrc:/tests.qml"));
}

QmlPromise* QmlPromiseTester::makePromise() {
    auto promise = new QmlPromise(engine.rootObjects().first());
    return promise;
}

QJSValue QmlPromiseTester::getScriptPromise(QmlPromise* promise) {
    return *promise;
}

QTEST_MAIN(QmlPromiseTester)
