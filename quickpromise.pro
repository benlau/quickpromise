TEMPLATE = subdirs

CONFIG += ordered

SUBDIRS += qml tests/unittests

unittests.depends = qml
