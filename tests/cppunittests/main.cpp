#include "qmlpromisetester.hpp"
#include <QQmlContext>
#include <QtQml>

int main(int argc, char* argv[]) {
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    QPPromise::setEngine(&engine);

    qmlRegisterUncreatableType<QmlPromiseTester>("tests", 1, 0, "Tester", "");
    qmlRegisterUncreatableType<QPPromise>("QuickPromise", 1, 0, "QmlPromise", "");
    engine.addImportPath("qrc:/");
    engine.load(QUrl("qrc:/tests.qml"));

    QmlPromiseTester tester(engine.rootObjects().first());
    engine.rootContext()->setContextProperty("tester", &tester);

    return QTest::qExec(&tester, argc, argv);
}
