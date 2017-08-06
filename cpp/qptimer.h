#ifndef QPTIMER_H
#define QPTIMER_H

#include <QObject>
#include <QJSValue>
#include <QMap>

/// QuickPromise's timer utility

class QPTimer : public QObject
{
    Q_OBJECT
public:
    explicit QPTimer(QObject *parent = 0);
    ~QPTimer();

    /// Implement the setTimeout function by C++.
    Q_INVOKABLE int setTimeout(QJSValue func,int interval);

    Q_INVOKABLE void clearTimeout(int id);

protected:
    void timerEvent(QTimerEvent *event);

private:
    Q_INVOKABLE void onTriggered();

    QMap<int, QJSValue> callbacks;

};

#endif // QPTIMER_H
