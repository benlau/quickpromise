TEMPLATE = lib
TARGET = quickpromise

#To build dynamic library, set CONFIG+=no_staticlib to qmake
!CONFIG(no_staticlib) {
    CONFIG += staticlib
}

isEmpty(INSTALL_ROOT) {
    target.path = $$[QT_INSTALL_LIBS]
} else {
    target.path = $${INSTALL_ROOT}
}

INSTALLS += target
include(../quickpromise.pri)


