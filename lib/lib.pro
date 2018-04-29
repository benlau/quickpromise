TEMPLATE = lib
TARGET = quickpromise

#To build dynamic library, set CONFIG+=no_staticlib to qmake
!CONFIG(no_staticlib) {
    CONFIG += staticlib
}

include(../quickpromise.pri)


