#ifndef C_COM_H
#define C_COM_H

#include <QObject>
#include <QtSerialPort/QSerialPort>
#include <QString>

class c_com : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString data READ data WRITE setData NOTIFY dataChanged)
public:
    explicit c_com(QObject *parent = 0);
    virtual ~c_com();

    QString name() const;
    void setName(const QString &name);

    QString data() const;
    void setData(const QString &data);


signals:
    void nameChanged();
    void dataChanged();


public slots:
    Q_INVOKABLE void openSerialPort();
    void readData();

private:
    QSerialPort *m_serial;
    QString m_name="COM3";
    qint32 m_baudRate=QSerialPort::Baud115200;
    QSerialPort::DataBits m_dataBits=QSerialPort::Data8;
    QSerialPort::Parity m_parity=QSerialPort::NoParity;
    QSerialPort::StopBits m_stopBits=QSerialPort::OneStop;
    QSerialPort::FlowControl m_flowControl=QSerialPort::NoFlowControl;
    QString m_data;

};

#endif // C_COM_H
