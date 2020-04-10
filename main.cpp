#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "jsonfile.h"

#include "filehandler.h"



int main(int argc, char** argv)
{

    FileHandler *fh = new FileHandler();

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<JsonFile>("gose.JsonFile", 1, 0, "JsonFile");
    engine.rootContext()->setContextProperty("fileHandler", fh);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


//    QString filename="Data.txt";
//    QFile file( filename );
//    file.open(QIODevice::ReadWrite);
//    file.write("HELLO") ;

//    QUrl urlup("ftp://192.168.86.41:5000/sxos/01006f8002326000/cheats/test.txt");
//    QNetworkAccessManager *nam = new QNetworkAccessManager;

//    QNetworkRequest requp(urlup);
//    QNetworkReply *reply = nam->put(requp,&file);

//    file.close();

    return app.exec();
}
