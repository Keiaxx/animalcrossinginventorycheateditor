#include "filehandler.h"


FileHandler::FileHandler()
{

}

FileHandler::~FileHandler()
{

}

void FileHandler::generate(QVariantList qvl)
{

    QUrl url("ftp://192.168.86.41:5000/sxos/titles/01006f8002326000/cheats/a31f81d41e1039c5.txt");

    data = new QFile("tempout.txt", this);
    if(data->open(QIODevice::ReadWrite)){
        QTextStream ts(data);

        for(auto line : qvl){
            ts << line.toString() << endl;
        }
    }
    data->close();

    data = new QFile("tempout.txt", this);
    if (data->open(QIODevice::ReadOnly)) {
        reply = nam.put(QNetworkRequest(url), data);
        connect(reply, SIGNAL(uploadProgress(qint64, qint64)), SLOT(uploadProgress(qint64, qint64)));
        connect(reply, SIGNAL(finished()), SLOT(uploadDone()));
    }
    else
        qDebug() << "Oops";

    //    compressedFile = new QFile("tempout.txt");

    //    QTextStream stream( compressedFile );
    //    if(compressedFile->open(QIODevice::ReadWrite)){
    //        QUrl urlup("ftp://127.0.0.1:21/tempout.txt");
    //        //        QNetworkAccessManager *nam = new QNetworkAccessManager;

    //        //        QNetworkRequest requp(urlup);
    //        //        QNetworkReply *reply = nam->put(requp,&file);

    //        //        file.close();

    //        QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    ////        connect(manager, &QNetworkAccessManager::finished,
    ////                this, &FileHandler::replyFinished);


    //        QNetworkRequest req;
    //        req.setUrl(urlup);


    //        QNetworkReply *reply = manager->put(req, compressedFile);

    //        connect(reply, SIGNAL(uploadProgress(qint64, qint64)), SLOT(uploadProgress(qint64, qint64)));
    //        connect(reply, SIGNAL(finished()), SLOT(uploadDone()));

    //        qDebug() << "TESTING FILE";
    //    }
}
