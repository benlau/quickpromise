#ifndef QPTIMER_H
#define QPTIMER_H

#include <QObject>
#include <QJSValue>

/// QuickPromise's timer utility

class QPTimer : public QObject
{
    Q_OBJECT
public:
    explicit QPTimer(QObject *parent = 0);
    ~QPTimer();

    /// Implement the setTimeout function by C++.
    Q_INVOKABLE void setTimeout(QJSValue func,int interval);

private:

    Q_INVOKABLE void onTriggered();

};

#endif // QPTIMER_H
