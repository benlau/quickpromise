QT += qml
CONFIG += c++11

QML_IMPORT_PATH += $$PWD/qml

INCLUDEPATH += $$PWD/cpp

RESOURCES += \
    $$PWD/qml/quickpromise.qrc

HEADERS += \
    $$PWD/cpp/QuickPromise \
    $$PWD/cpp/qptimer.h \
    $$PWD/cpp/qppromise.h

SOURCES += \
    $$PWD/cpp/qptimer.cpp \
    $$PWD/cpp/qppromise.cpp

DISTFILES += \
    $$PWD/README.md
