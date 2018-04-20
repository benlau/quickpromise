TEMPLATE = subdirs

CONFIG += ordered

SUBDIRS += staticlib tests/unittests
unittests.depends = staticlib
