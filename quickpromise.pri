QT += qml
CONFIG += c++11

QML_IMPORT_PATH += $$PWD/qml

INCLUDEPATH += $$PWD/cpp

RESOURCES += \
    $$PWD/qml/quickpromise.qrc

HEADERS += \
    $$PWD/cpp/QuickPromise

SOURCES +=

DISTFILES += \
    $$PWD/README.md
