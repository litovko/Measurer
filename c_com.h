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
    Q_PROPERTY(QSerialPort::SerialPortError error READ error WRITE setError NOTIFY errorChanged)
    Q_PROPERTY(QStringList ports READ ports NOTIFY portsChanged)
public:
    explicit c_com(QObject *parent = 0);
    virtual ~c_com();

    QString name() const;
    void setName(const QString &name);

    QString data() const;
    void setData(const QString &data);


    QSerialPort::SerialPortError error() const;
    void setError(const QSerialPort::SerialPortError &error);

    QStringList ports() const;


signals:
    void nameChanged();
    void dataChanged();
    void errorChanged();
    void portsChanged();


public slots:
    Q_INVOKABLE void openSerialPort(int port);
    Q_INVOKABLE void listPorts();
    void readData();
    void readError();


private:
    QSerialPort *m_serial;
    QString m_name="null";
    qint32 m_baudRate=QSerialPort::Baud115200;
    QSerialPort::DataBits m_dataBits=QSerialPort::Data8;
    QSerialPort::Parity m_parity=QSerialPort::NoParity;
    QSerialPort::StopBits m_stopBits=QSerialPort::OneStop;
    QSerialPort::FlowControl m_flowControl=QSerialPort::NoFlowControl;
    QSerialPort::SerialPortError m_error=QSerialPort::NoError;
    QString m_data;
    QStringList m_ports;

};

#endif // C_COM_H
