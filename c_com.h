#ifndef C_COM_H
#define C_COM_H

#include <QObject>
#include <QtSerialPort/QSerialPort>
#include <QString>
#include "c_mstat.h"

class c_com : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString data READ data WRITE setData NOTIFY dataChanged)
    Q_PROPERTY(QSerialPort::SerialPortError error READ error WRITE setError NOTIFY errorChanged)
    Q_PROPERTY(QStringList ports READ ports NOTIFY portsChanged) //Список доступных портов
    //=============================
    Q_PROPERTY(qreal weight READ weight NOTIFY weightChanged)
    Q_PROPERTY(qreal average READ average NOTIFY averageChanged)
    Q_PROPERTY(qreal rotor READ rotor NOTIFY rotorChanged)
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


    qint32 tare() const;
    void setTare(const qint32 &tare);

    qreal weight() const;

    void setWeight(const qreal &weight);

    qreal devider() const;
    void setDevider(const qreal &devider);



    qreal average() const;
    void setAverage(const qreal &average);

    qreal rotor() const;
    void setRotor(const qreal &rotor);

signals:
    void nameChanged();
    void dataChanged();
    void errorChanged();
    void portsChanged();

    //====================
    void weightChanged();
    void averageChanged();
    void rotorChanged();


public slots:
    Q_INVOKABLE void openSerialPort(int port);
    Q_INVOKABLE void listPorts();
    Q_INVOKABLE void tare(int count); //find zero in count number measures
    Q_INVOKABLE void calibrate(qreal cur_weight);
    Q_INVOKABLE void reset();
    Q_INVOKABLE void writeData(const QByteArray &data);

    void readData();
    void readError();


private:
    QSerialPort *m_serial;
    c_mstat *m_stat; //выборка - массив
    QString m_name="null";
    qint32 m_baudRate=QSerialPort::Baud115200;
    QSerialPort::DataBits m_dataBits=QSerialPort::Data8;
    QSerialPort::Parity m_parity=QSerialPort::NoParity;
    QSerialPort::StopBits m_stopBits=QSerialPort::OneStop;
    QSerialPort::FlowControl m_flowControl=QSerialPort::NoFlowControl;
    QSerialPort::SerialPortError m_error=QSerialPort::NoError;
    QString m_data;
    QStringList m_ports;

    //===============================
    qint32 m_tare=0;
    qreal m_devider=1;
    qreal m_weight;  //вес
    qreal m_average; //средний вес
    //====
    qreal m_rotor=0;


    //==
    qint32 m_count=0;
    qint32 m_tarecount=0;
    qint64 m_taresum=0;

};

#endif // C_COM_H
