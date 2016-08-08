QT += qml
CONFIG += c++11

QML_IMPORT_PATH += $$PWD

INCLUDEPATH += $$PWD

RESOURCES += \
    $$PWD/quickpromise.qrc

HEADERS += \
    $$PWD/qptimer.h \
    $$PWD/qppromise.h

SOURCES += \
    $$PWD/qptimer.cpp \
    $$PWD/qppromise.cpp

DISTFILES += \
    $$PWD/README.md
