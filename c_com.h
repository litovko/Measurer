#ifndef C_COM_H
#define C_COM_H

#include <QObject>
#include <QtCharts>
#include <QtSerialPort/QSerialPort>
#include <QString>
#include "c_mstat.h"
#include <QFile>



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
    Q_PROPERTY(qreal impeller READ getImpeller() WRITE setImpeller NOTIFY impellerChanged)
    Q_PROPERTY(qreal impeller_h READ getImpeller_h() WRITE setImpeller_h NOTIFY impeller_hChanged)
    Q_PROPERTY(qreal impeller_d READ getImpeller_d() WRITE setImpeller_d NOTIFY impeller_dChanged)
    Q_PROPERTY(qreal tare0 READ tare0 NOTIFY tare0Changed) // радиус ролика
    //*******************************************
    Q_PROPERTY(QXYSeries *series READ getSeries WRITE setSeries NOTIFY seriesChanged) // серия данных для графика
    Q_PROPERTY(QXYSeries *tablseries READ getTableseries WRITE setTableseries NOTIFY tableseriesChanged) // серия данных для графика
    Q_PROPERTY(QXYSeries *lineseries READ getLineseries WRITE setLineseries NOTIFY lineseriesChanged) // серия данных для линейного графика
    Q_PROPERTY(QXYSeries *absseries READ getAbsseries WRITE setAbsseries NOTIFY absseriesChanged) // серия данных для линейного графика
    Q_PROPERTY(QString tabledata READ getTabledata WRITE setTabledata NOTIFY tabledataChanged) // данные из таблицы измерений
    Q_PROPERTY(QString tabledataerror READ getTabledataerror WRITE setTabledataerror NOTIFY tabledataerrorChanged) // данные из таблицы погрешностей
    Q_PROPERTY(QString values READ getValues WRITE setValues NOTIFY valuesChanged) // данные - результаты рассчетов
    Q_PROPERTY(QString parameters READ getParameters WRITE setParameters NOTIFY parametersChanged) // данные - результаты рассчетов
    //===========================
    Q_PROPERTY(QString filename READ getFilename() WRITE setFilename NOTIFY filenameChanged) // имя порта
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


    qreal getImpeller() const;
    void setImpeller(const qreal &impeller);

    qreal getImpeller_h() const;
    void setImpeller_h(const qreal &impeller_h);

    qreal getImpeller_d() const;
    void setImpeller_d(const qreal &impeller_d);

    QXYSeries *getTableseries() const;
    void setTableseries(QXYSeries *value);

    QString getTabledata() const;
    void setTabledata(const QString &tabledata);

    QXYSeries *getLineseries() const;
    void setLineseries(QXYSeries *value);

    qreal getA() const;
    void setA(const qreal &a);

    qreal getB() const;
    void setB(const qreal &b);

    QString getFilename() const;
    void setFilename(const QString &filename);

    QXYSeries *getAbsseries() const;
    void setAbsseries(QXYSeries *value);

    QString getTabledataerror() const;
    void setTabledataerror(const QString &tabledataerror);

    QString getValues() const;
    void setValues(const QString &values);

    QString getParameters() const;
    void setParameters(const QString &parameters);

signals:
    void nameChanged();
    void dataChanged();
    void errorChanged();
    void portsChanged();
    void pulleyChanged();
    void impellerChanged();
    void impeller_hChanged();
    void impeller_dChanged();

    void isOpenChanged();
    //====================
    void weightChanged();
    void averageChanged();
    void rotorChanged();

    void tare0Changed();
    void seriesChanged();
    void tableseriesChanged();
    void lineseriesChanged();
    void absseriesChanged();
    void stopTare();
    void tabledataChanged();
    void tabledataerrorChanged();
    void valuesChanged();
    void parametersChanged();
    void filenameChanged();

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
    void calcImpeller();

    Q_INVOKABLE void fill();
    Q_INVOKABLE void makeDoc();
    void filltableseries();
    void writefile();
    QString readfile();

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
    qreal m_weight=0;  //вес
    qreal m_average=0; //средний вес
    //====
    qreal m_rotor=180;
    qreal m_pulley=2.5; //Радиус шкива
    qreal m_impeller; // Постоянная крыльчатки
    qreal m_impeller_h=3.0; // Высота крыльчатки
    qreal m_impeller_d=2.5; // Диаметр крыльчатки
    //====
    // коэффициенты апроксимирующей прямой.
    qreal m_a=0;
    qreal m_b=1;
    qreal func(const qreal &x); //функция вычисления аппроксимированных значений
    //==
    qint32 m_count=0;
    qint32 m_tarecount=0;
    qint64 m_taresum=0;
    //================================
    QXYSeries *series=0;
    QXYSeries *tableseries=0;
    QXYSeries *lineseries=0;
    QXYSeries *absseries=0;
    qreal mantissa(const qreal &x);
    QString m_tabledata="";
    QString m_tabledataerror="";
    QString m_values="";
    QString m_parameters="";
    int current=0;

    void saveSettings();
    void readSettings();
    QFile m_file; // данные в файле
    QString m_filename="init.csv";
};

#endif // C_COM_H
