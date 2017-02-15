#ifndef C_COM_H
#define C_COM_H

#include <QObject>
#include <QtCharts>
#include <QtSerialPort/QSerialPort>
#include <QString>
#include "c_mstat.h"

#define NUM_POINTS 200
using namespace QtCharts;

class c_com : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged) // имя порта
    Q_PROPERTY(QString data READ data WRITE setData NOTIFY dataChanged)  // строка, пришедшая от контроллера
    Q_PROPERTY(QSerialPort::SerialPortError error READ error WRITE setError NOTIFY errorChanged)
    Q_PROPERTY(QStringList ports READ ports NOTIFY portsChanged) //Список доступных портов
    Q_PROPERTY(bool isOpen READ isOpen NOTIFY isOpenChanged) // статус порта
    //=============================
    Q_PROPERTY(qreal weight READ weight NOTIFY weightChanged) // текущий вес
    Q_PROPERTY(qreal average READ average NOTIFY averageChanged) // среднее значение веса
    Q_PROPERTY(qreal rotor READ rotor NOTIFY rotorChanged) // относительное положение ротора в градусах
    Q_PROPERTY(qreal pulley READ getPulley() WRITE setPulley NOTIFY pulleyChanged)
    Q_PROPERTY(qreal tare0 READ tare0 NOTIFY tare0Changed) // радиус ролика
    //*******************************************
    Q_PROPERTY(QXYSeries *series READ getSeries WRITE setSeries NOTIFY seriesChanged) // серия данных для графика
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



    qreal weight() const;

    void setWeight(const qreal &weight);

    qreal devider() const;
    void setDevider(const qreal &devider);



    qreal average() const;
    void setAverage(const qreal &average);

    qreal rotor() const;
    void setRotor(const qreal &rotor);

    QXYSeries *getSeries() const;
    void setSeries(QXYSeries *value);


    qint32 tare0() const;
    void setTare0(const qint32 &tare0);



    qreal getPulley() const;
    void setPulley(const qreal &pulley);

    bool isOpen() const;


signals:
    void nameChanged();
    void dataChanged();
    void errorChanged();
    void portsChanged();
    void pulleyChanged();
    void isOpenChanged();
    //====================
    void weightChanged();
    void averageChanged();
    void rotorChanged();

    void tare0Changed();
    void seriesChanged();
    void stopTare();


public slots:
    Q_INVOKABLE void openSerialPort(int port);
    Q_INVOKABLE void listPorts();
    Q_INVOKABLE void tare(int count); //find zero in count number measures
    Q_INVOKABLE void calibrate(qreal cur_weight);
    Q_INVOKABLE void reset();
    Q_INVOKABLE void writeData(const QByteArray &data);
    Q_INVOKABLE void start();
    void readData();
    void readError();
    void readIsOpen();

    Q_INVOKABLE void fill();


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
    bool m_isOpen=false;

    //===============================
    qint32 m_tare0=0; // смещение нуля
    qreal m_devider=1;
    qreal m_weight;  //вес
    qreal m_average; //средний вес
    //====
    qreal m_rotor=180;
    qreal m_pulley;



    //==
    qint32 m_count=0;
    qint32 m_tarecount=0;
    qint64 m_taresum=0;
    //================================
    QXYSeries *series=0;
    int current=0;

    void saveSettings();
    void readSettings();


};

#endif // C_COM_H
