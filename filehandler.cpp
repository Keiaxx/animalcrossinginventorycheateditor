#include "filehandler.h"


FileHandler::FileHandler()
{

}

FileHandler::~FileHandler()
{

}

void FileHandler::generate(QString ftpstring, QVariantList qvl)
{

    qDebug() << "Attempting to connect to : " << ftpstring;
    QUrl url(ftpstring);

    QFile file("tempout.txt", this);
    file.remove();

    data = new QFile("tempout.txt", this);
    if(data->open(QIODevice::ReadWrite)){
        QTextStream ts(data);

        for(auto line : qvl){
            qDebug() << line.toString();
            ts << line.toString() << endl;
        }
    }
    data->close();

    data = new QFile("tempout.txt", this);
    if (data->open(QIODevice::ReadOnly)) {
        reply = nam.put(QNetworkRequest(url), data);
        connect(reply, SIGNAL(uploadProgress(qint64, qint64)), SLOT(uploadProgress(qint64, qint64)));
        connect(reply, SIGNAL(finished()), SLOT(uploadDone()));
        connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(networkError()));
    }
    else
        qDebug() << "Oops";

}

QVariantList FileHandler::getSavedItemSets()
{
    QVariantList itemSetFilenames;

    QDir directory(this->getStandardPath()+"/sets");

    QStringList sets = directory.entryList(QStringList() << "*.json" << "*.JSON",QDir::Files);
    foreach(QString set, sets) {
        itemSetFilenames.push_back(set.section(".",0,0));
    }
    return itemSetFilenames;
}

void FileHandler::deleteSet(QString name)
{
    QFile file(this->getStandardPath()+"/sets/"+name+".json");

    file.remove();
}

