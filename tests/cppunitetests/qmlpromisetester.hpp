// Author:  Nathan Hourt (https://github.com/nathanhourt/)

#ifndef QMLPROMISETESTER_HPP
#define QMLPROMISETESTER_HPP

#include <qmlpromise.h>

#include <QQmlApplicationEngine>
#include <QtTest/QtTest>

#include <stdlib.h>

class QmlPromiseTester : public QObject
{
    Q_OBJECT

    int argc = 0;
    char argv[1][17] = {{"qmlpromisetester"}};
    QApplication app;
    QQmlApplicationEngine engine;

    void runTest(QString testName);

public:
    explicit QmlPromiseTester(QObject *parent = 0);
    virtual ~QmlPromiseTester() {
        // Otherwise it crashes on exit. Not sure why, but I don't care: it's a test app and the tests are done.
        _Exit(0);
    }

    Q_INVOKABLE QmlPromise* makePromise();
    Q_INVOKABLE QJSValue getScriptPromise(QmlPromise* promise);

private slots:
    void basicResolve() { runTest(__FUNCTION__); }
    void basicReject() { runTest(__FUNCTION__); }
    void resolveWithArguments() { runTest(__FUNCTION__); }
    void rejectWithArgument() { runTest(__FUNCTION__); }
    void twoResolversWithArgs() { runTest(__FUNCTION__); }
    void twoRejectersWithArg() { runTest(__FUNCTION__); }
    void wasForgotten() { runTest(__FUNCTION__); }
};

#endif // QMLPROMISETESTER_HPP
