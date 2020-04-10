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

    Q_INVOKABLE void generate(QString ftpstring, QVariantList qvl);

    public slots:

private:
    QFile *data;
    QNetworkAccessManager nam;
    QNetworkReply *reply;

signals:
    void networkDone(QString message);
    void networkError(QString message);

public slots:
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal)    {
        qDebug() << "Uploaded" << bytesSent << "of" << bytesTotal;
    }

    void uploadDone()     {
        qDebug() << "Finished" << reply->error();
        data->deleteLater();
        reply->deleteLater();
        emit networkDone("Successfully uploaded cheats to switch!");
    }
    void networkError() {
        qDebug() << "Network error: "+reply->errorString();
        emit networkError("Error connecting to switch! Check ftp settings?");
    }
};

#endif // FILEHANDLER_H
