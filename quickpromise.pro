TEMPLATE = subdirs

CONFIG += ordered

SUBDIRS += plugin tests/unittests
unittests.depends = plugin
