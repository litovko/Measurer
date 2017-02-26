#include <QApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include "c_com.h"
#define giko_name "HYCO"
#define giko_program "PRIBOR"
int main(int argc, char *argv[])
{
    QSettings settings(giko_name, giko_program);
    qmlRegisterType<c_com>("Gyco", 1, 0, "Measurer");

    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    app.setOrganizationName(giko_name);
    app.setOrganizationDomain("hyco.ru");
    app.setApplicationName(giko_program);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
