#include "qmlpromise.h"

#include <QQmlComponent>
#include <QQmlEngine>
#include <QDebug>

QmlPromise::QmlPromise(QObject* parent)
    : QObject(parent) {
    QQmlComponent promiserComponent(qmlEngine(parent));
    promiserComponent.setData("import QuickPromise 1.0\nPromise {}", QUrl());
    internalPromise = promiserComponent.create();

    QQmlEngine::setObjectOwnership(internalPromise, QQmlEngine::JavaScriptOwnership);
    connect(internalPromise, &QObject::destroyed, this, [this] {
        // Probably won't happen often, if ever, but if it does it could provide useful insights vis a vis debugging
        qDebug() << "Promise{} was garbage collected while QmlPromise still valid";
        internalPromise = nullptr;
    });
    connect(internalPromise, SIGNAL(fulfilled(QVariant)), this, SIGNAL(fulfilled(QVariant)));
    connect(internalPromise, SIGNAL(rejected(QVariant)), this, SIGNAL(rejected(QVariant)));
    connect(internalPromise, SIGNAL(settled(QVariant)), this, SIGNAL(settled()));
    connect(this, &QmlPromise::fulfilled, [this] { wasFulfilled = true; });
    connect(this, &QmlPromise::rejected, [this] { wasRejected = true; });
}

QmlPromise::~QmlPromise() {
}

bool QmlPromise::isFulfilled() {
    return internalPromise? internalPromise->property("isFulfilled").toBool() : wasFulfilled;
}

bool QmlPromise::isRejected() {
    return internalPromise? internalPromise->property("isRejected").toBool() : wasRejected;
}

bool QmlPromise::isSettled() {
    return internalPromise? internalPromise->property("isSettled").toBool() : wasFulfilled || wasRejected;
}

QmlPromise::operator QJSValue() {
    return qmlEngine(internalPromise)->toScriptValue(internalPromise);
}

void QmlPromise::resolve(QVariant args) {
    if (internalPromise)
        QMetaObject::invokeMethod(internalPromise, "resolve", Q_ARG(QVariant, args));
}

void QmlPromise::reject(QVariant reason) {
    if (internalPromise)
        QMetaObject::invokeMethod(internalPromise, "reject", Q_ARG(QVariant, reason));
}
