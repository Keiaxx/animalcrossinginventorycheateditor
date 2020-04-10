#ifndef FILEHANDLER_H
#define FILEHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QFile>
#include <QUrl>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QDebug>



class FileHandler : public QObject
{
    Q_OBJECT

public:
    FileHandler();
    ~FileHandler();

    Q_INVOKABLE void generate(QVariantList qvl);

    public slots:

private:
    QFile *data;
    QNetworkAccessManager nam;
    QNetworkReply *reply;

public slots:
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal)    {
        qDebug() << "Uploaded" << bytesSent << "of" << bytesTotal;
    }

    void uploadDone()     {
        qDebug() << "Finished" << reply->error();
        data->deleteLater();
        reply->deleteLater();
    }
};

#endif // FILEHANDLER_H
