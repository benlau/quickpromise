#include "qmlpromisetester.hpp"

int main(int argc, char* argv[]) {
    QApplication app(argc, argv);
    QmlPromiseTester tester;
    return QTest::qExec(&tester, argc, argv);
}
