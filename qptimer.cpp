#include <QtQml>
#include <QVariant>
#include <QTimer>
#include "qptimer.h"

QPTimer::QPTimer(QObject *parent) : QObject(parent)
{

}

QPTimer::~QPTimer()
{

}

int QPTimer::setTimeout(QJSValue func, int interval)
{
    // It can't use the Timer from Quick Component to implement the function.
    // Because setTimeout(0) could not be executed in next tick with < Qt 5.4

    int id = startTimer(interval);

    callbacks[id] = func;

    return id;
}

void QPTimer::clearTimeout(int id)
{
    if (callbacks.contains(id)) {
        killTimer(id);
        callbacks.remove(id);
    }
}

void QPTimer::timerEvent(QTimerEvent *event)
{
    int id = event->timerId();

    QJSValue func = callbacks[id];

    callbacks.remove(id);

    QJSValue res = func.call();

    if (res.isError()) {
        qDebug() << "Q.setTimeout() - Uncaught exception at line"
                 << res.property("lineNumber").toInt()
                 << ":" << res.toString();
    }

    killTimer(id);
}

void QPTimer::onTriggered()
{
    QTimer* timer = qobject_cast<QTimer*>(sender());

    QJSValue func = timer->property("__quick_promise_func___").value<QJSValue>();

    QJSValue res = func.call();

    if (res.isError()) {
        qDebug() << "Q.setTimeout() - Uncaught exception at line"
                 << res.property("lineNumber").toInt()
                 << ":" << res.toString();
    }

    timer->deleteLater();
}

static QJSValue provider(QQmlEngine* engine , QJSEngine *scriptEngine) {
    Q_UNUSED(engine);

    QPTimer* timer = new QPTimer();

    QJSValue value = scriptEngine->newQObject(timer);
    return value;
}


static void registerQmlTypes() {
    qmlRegisterSingletonType("QuickPromise", 1, 0, "QPTimer", provider);
}

Q_COREAPP_STARTUP_FUNCTION(registerQmlTypes)
