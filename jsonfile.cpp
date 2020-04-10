//From forum.qt.io by Xander84
// https://forum.qt.io/topic/39756/qml-and-js-reading-json-file-and-change-content-on-the-go/9#

#include "jsonfile.h"

#include <QUrl>
#include <QFileInfo>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QNetworkRequest>
#include <QNetworkReply>

JsonFile::JsonFile(QObject *parent) :
    QObject(parent)
{
}

JsonFile::JsonFile(const QString &name, QObject *parent) :
    QObject(parent), m_file(name)
{
}

void JsonFile::setName(const QString &name)
{
    // fix to convert URL's to local file names
    QUrl url(name);
    QString localName = url.isLocalFile() ? url.toLocalFile() : name;
    if (m_file.fileName() != localName) {
        m_file.setFileName(localName);
        emit nameChanged(localName);
        qDebug() << "LOADED FILE";
    }else{
        qDebug() << "ERROR LOADING FILE";
    }
}

QString JsonFile::fileName() const
{
    return QFileInfo(m_file).fileName();
}

QString JsonFile::relativeFilePath(const QString &dir) const
{
    return QDir(dir).relativeFilePath(m_file.fileName());
}

bool JsonFile::rename(const QString &newName)
{
    bool success = m_file.rename(newName);
    if (success) {
        emit nameChanged(newName);
    }
    return success;
}

bool JsonFile::write(const QVariantMap &data)
{
    if (m_file.fileName().isEmpty()) {
        m_error = tr("empty name");
        return false;
    }
    QJsonDocument doc(QJsonObject::fromVariantMap(data));
    if (doc.isNull()) {
        m_error = tr("cannot convert to JSON document");
        return false;
    }
    if (doc.isEmpty()) {
        m_error = tr("empty data");
        return false;
    }
    QByteArray json = doc.toJson();
    if (!m_file.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text)) {
        m_error = tr("cannot open file '%1' for writing: %2")
                .arg(m_file.fileName()).arg((m_file.errorString()));
        return false;
    }
    bool success = m_file.write(json) == json.size();
    qDebug() << QString::number(json.size());
    m_file.close();
    return success;
}

QVariant JsonFile::read()
{
    if (m_file.fileName().isEmpty()) {
        m_error = tr("empty name");
        return QVariant();
    }
    if (!m_file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        m_error = tr("cannot open file '%1' for reading: %2")
                .arg(m_file.fileName()).arg((m_file.errorString()));
        return QVariant();
    }
    QByteArray json = m_file.readAll();
    m_file.close();
    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(json, &error);
    if (error.error != QJsonParseError::NoError) {
        m_error = tr("invalid JSON file '%1' at offset %2")
                .arg(error.errorString()).arg(error.offset);
        return QVariant();
    }
    return doc.toVariant();
}

void JsonFile::uploadCheat(QString titleid, QString buildid, QString ftpurl)
{

}
