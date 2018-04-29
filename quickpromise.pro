TEMPLATE = subdirs

CONFIG += ordered
CONFIG += staticlib

SUBDIRS += lib tests/unittests
unittests.depends = lib
