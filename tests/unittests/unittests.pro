QT       += core
QT       += testlib gui quick qml qmltest

TARGET = unittests
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES += main.cpp

include(../../quickpromise.pri)

DEFINES += SRCDIR=\\\"$$PWD/\\\" BASEDIR=\\\"$$PWD/..\\\"
DEFINES += QUICK_TEST_SOURCE_DIR=\\\"$$PWD\\\"
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000

DISTFILES += \
    tst_promise_resolve_signal.qml \
    tst_promise_resolvewhen_signal.qml \
    tst_promise_rejectwhen_signal.qml \
    tst_aplus_spec.qml \
    tst_promisejs_all_signal.qml \
    tst_promisejs_all_promise_item.qml \
    tst_promise_resolvewhen_promise.qml \
    TestSuite.qml \
    tst_promise_resolvewhen_all_signal.qml \
    tst_promise_resolvewhen_all_promise.qml \
    tst_promisejs_resolve_qt_binding.qml \
    tst_timer.qml \
    tst_promisejs_examples.qml
