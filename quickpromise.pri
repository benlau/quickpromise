QT += qml

QML_IMPORT_PATH += $$PWD

INCLUDEPATH += $$PWD

RESOURCES += \
    $$PWD/quickpromise.qrc

HEADERS += \
    $$PWD/qptimer.h \
    $$PWD/qmlpromise.h

SOURCES += \
    $$PWD/qptimer.cpp \
    $$PWD/qmlpromise.cpp

DISTFILES += \
    $$PWD/README.md
