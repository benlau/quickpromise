#include "qppromise.h"

#include <QQmlComponent>
#include <QQmlEngine>
#include <QDebug>

#include <iostream>

QQmlEngine* QPPromise::engine = nullptr;

QPPromise::QPPromise(QObject* parent)
    : QObject(parent) {

    if (engine == nullptr) {
        engine = qmlEngine(parent);
        if (engine == nullptr)
            qFatal("Could not infer QML engine. Please call setEngine()");
        qWarning() << "Inferring QML engine pointer -- to squelch this warning, call QPPromise::setEngine() prior to "
                      "creating any QPPromise objects.";
    }

    QQmlComponent promiserComponent(engine);
    promiserComponent.setData("import QuickPromise 1.0\nPromise {}", QUrl());
    internalPromise = promiserComponent.create();
    internalPromise->setParent(this);

    connect(internalPromise, SIGNAL(fulfilled(QVariant)), this, SIGNAL(fulfilled(QVariant)));
    connect(internalPromise, SIGNAL(rejected(QVariant)), this, SIGNAL(rejected(QVariant)));
    connect(internalPromise, SIGNAL(settled(QVariant)), this, SIGNAL(settled(QVariant)));
}

QPPromise::~QPPromise() {
    // Release promise to QML engine for garbage collection (we can't know when javascript will be done with it)
    internalPromise->setParent(nullptr);
    // Go free, little promise, you're all grown up now!
    QQmlEngine::setObjectOwnership(internalPromise, QQmlEngine::JavaScriptOwnership);
}

bool QPPromise::isFulfilled() {
    return internalPromise->property("isFulfilled").toBool();
}

bool QPPromise::isRejected() {
    return internalPromise->property("isRejected").toBool();
}

bool QPPromise::isSettled() {
    return internalPromise->property("isSettled").toBool();
}

QPPromise::operator QJSValue() {
    return engine->toScriptValue(internalPromise);
}

void QPPromise::resolve(QVariant args) {
    QMetaObject::invokeMethod(internalPromise, "resolve", Q_ARG(QVariant, args));
}

void QPPromise::reject(QVariant reason) {
    QMetaObject::invokeMethod(internalPromise, "reject", Q_ARG(QVariant, reason));
}
