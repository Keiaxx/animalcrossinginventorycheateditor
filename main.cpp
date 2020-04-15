#include <QDebug>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "jsonfile.h"

#include <QDir>
#include <QStandardPaths>

#include "filehandler.h"



int main(int argc, char** argv)
{

    FileHandler *fh = new FileHandler();

    QApplication app(argc, argv);

    app.setOrganizationName("Keiaxx Software");
    app.setOrganizationDomain("gose.pw");
    app.setApplicationName("ACItemCheatMaker");

    QString dataLocation = QStandardPaths::locate(QStandardPaths::DataLocation, QString(), QStandardPaths::LocateDirectory);

    qDebug() << "DATA DIR: " << dataLocation;

    if(!QDir(dataLocation+"/sets").exists()){
        qDebug() << "Sets folder did not exist. Creating " << dataLocation;
        QDir().mkdir(dataLocation+"/sets");
    }

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
