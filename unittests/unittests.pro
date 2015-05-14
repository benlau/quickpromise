QT       += core
QT       += testlib gui declarative quick qml qmltest

TARGET = unittests
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES += main.cpp

include(../quickpromise.pri)

DEFINES += SRCDIR=\\\"$$PWD/\\\" BASEDIR=\\\"$$PWD/..\\\"

DISTFILES += \
    tst_q.qml
