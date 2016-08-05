// Author:  Nathan Hourt (https://github.com/nathanhourt/)

#ifndef QMLPROMISETESTER_HPP
#define QMLPROMISETESTER_HPP

#include <qppromise.h>

#include <QQmlApplicationEngine>
#include <QtTest/QtTest>

#include <stdlib.h>

class QmlPromiseTester : public QObject
{
    Q_OBJECT

    QQmlApplicationEngine engine;

    void runTest(QString testName);

public:
    explicit QmlPromiseTester(QObject *parent = 0);
    virtual ~QmlPromiseTester() {}

    Q_INVOKABLE QPPromise* makePromise();
    Q_INVOKABLE QJSValue getScriptPromise(QPPromise* promise);

private slots:
    void basicResolve() { runTest(__FUNCTION__); }
    void basicReject() { runTest(__FUNCTION__); }
    void resolveWithArguments() { runTest(__FUNCTION__); }
    void rejectWithArgument() { runTest(__FUNCTION__); }
    void twoResolversWithArgs() { runTest(__FUNCTION__); }
    void twoRejectersWithArg() { runTest(__FUNCTION__); }
    void nestedPromise() { runTest(__FUNCTION__); }
};

#endif // QMLPROMISETESTER_HPP
