QT       += core testlib gui quick qml qmltest

TARGET = cppunittests
CONFIG   += console testlib
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES += main.cpp \
    qmlpromisetester.cpp

HEADERS += \
    qmlpromisetester.hpp

include(../../quickpromise.pri)

DEFINES += SRCDIR=\\\"$$PWD/\\\" BASEDIR=\\\"$$PWD/..\\\"

DISTFILES += \
    tests.qml

RESOURCES += \
    qml.qrc
