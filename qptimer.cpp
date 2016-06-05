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

void QPTimer::setTimeout(QJSValue func, int interval)
{
    // It can't use the Timer from Quick Component to implement the function.
    // Because setTimeout(0) could not be executed in next tick with < Qt 5.4

    QTimer *timer = new QTimer(this);

    connect(timer,SIGNAL(timeout()),
            this,SLOT(onTriggered()),Qt::QueuedConnection);

    QVariant v = QVariant::fromValue<QJSValue>(func);

    timer->setProperty("__quick_promise_func___",v);
    timer->setInterval(interval);
    timer->setSingleShot(true);
    timer->start();
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

class QPTimerRegisterHelper {

public:
    QPTimerRegisterHelper() {
        qmlRegisterSingletonType("QuickPromise", 1, 0, "QPTimer", provider);
    }
};

static QPTimerRegisterHelper registerHelper;

