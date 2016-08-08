#ifndef PROMISE_HPP
#define PROMISE_HPP

#include <QObject>
#include <QVariant>

class QJSValue;
class QQmlEngine;

class QPPromise : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isFulfilled READ isFulfilled NOTIFY settled)
    Q_PROPERTY(bool isRejected READ isRejected NOTIFY settled)
    Q_PROPERTY(bool isSettled READ isSettled NOTIFY settled)

protected:
    QObject* internalPromise;
    static QQmlEngine* engine;

public:
    QPPromise(QObject* parent);
    virtual ~QPPromise();

    static void setEngine(QQmlEngine* engine) { if (engine) QPPromise::engine = engine; }

    bool isFulfilled();
    bool isRejected();
    bool isSettled();

    operator QJSValue();

public slots:
    void resolve(QVariant args = QVariant());
    void reject(QVariant reason = QVariant());

signals:
    void fulfilled(QVariant);
    void rejected(QVariant);
    void settled(QVariant);
};

#endif // PROMISE_HPP
