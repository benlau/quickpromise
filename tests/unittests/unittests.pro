QT       += core
QT       += testlib gui quick qml qmltest

TARGET = unittests
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES += main.cpp

include(../../quickpromise.pri)

DEFINES += SRCDIR=\\\"$$PWD/\\\" BASEDIR=\\\"$$PWD/..\\\"

DISTFILES += \
    tst_promise_resolve_signal.qml \
    tst_promise_resolvewhen_signal.qml \
    tst_promise_rejectwhen_signal.qml \
    tst_aplus_spec.qml \
    tst_q_all_signal.qml
