#include "c_com.h"
#include <qdebug.h>
#include <QtSerialPort/QSerialPortInfo>
c_com::c_com(QObject *parent) : QObject(parent)
{
    m_serial = new QSerialPort(this);
    m_stat = new c_mstat();

    connect(m_serial, SIGNAL(readyRead()), this, SLOT(readData()));
    connect(this,SIGNAL(seriesChanged()), this, SLOT(fill()));
    connect(m_serial, SIGNAL(error(QSerialPort::SerialPortError)),
            this, SLOT(readError()));
    fill();
    emit radiusChanged();
    setRadius(2.1);
    qDebug()<<"Rad="<<getRadius();
}

c_com::~c_com()
{
    m_serial->close();
    delete m_serial;
}

void c_com::openSerialPort(int port)
{
        m_name="NULL";
    if (port>=m_ports.length()) {
        qDebug()<<"WRONG PORT NUMBER";
        return;
    }

    m_name=m_ports.at(port);
    m_serial->setPortName(m_name);
    m_serial->setBaudRate(m_baudRate);
    m_serial->setDataBits(m_dataBits);
    m_serial->setParity(m_parity);
    m_serial->setStopBits(m_stopBits);
    m_serial->setFlowControl(m_flowControl);
    if (m_serial->open(QIODevice::ReadWrite)) {
        qDebug()<<"serial port:"<<m_name<<"has opened";

    } else {
        m_error=m_serial->error();
        qDebug()<<"Open port Error:"<<m_error;
    }

}

void c_com::listPorts()
{
    const auto infos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &info: infos) {
    qDebug() << "Name : " << info.portName();
    qDebug() << "Description : " << info.description();
    qDebug() << "Manufacturer: " << info.manufacturer();
    m_ports.append(info.portName());
    }
    qDebug()<<"com ports available:"<<m_ports;
    emit portsChanged();
}

void c_com::tare(int count)  //запуск процедуры тарирования
{
    m_tarecount=count; //количество подсчетов для тарирования
    m_count=1; //начинаем считать сумму по весу с единицы
    m_taresum=0;
}

void c_com::calibrate(qreal cur_weight)
{
    m_devider=m_weight/cur_weight;
}

void c_com::reset()
{
    m_devider=1;
    m_weight=0;
    m_count=0;
    m_tarecount=0;
    m_taresum=0;
    m_tare0=0;

}

void c_com::readData()
{
    bool ok;
    int w,r;
    setData(m_serial->readAll());
    if(m_data[0]=='r') {
        m_data.remove(0,1);
        w=m_data.toInt(&ok,10); if(!ok) return;
        setRotor(w/100.0);
    }
    if(m_data[0]=='d') { // d01781:65912
        m_data.remove(0,1);
        QString s=m_data.left(5);
        r=s.toInt(&ok,10); if(!ok) return;
        m_data.remove(0,6);
        w=m_data.toInt(&ok,10); if(!ok) return;

        m_stat->addPoint(r,w);
        setRotor(r);
        qDebug()<<"r="<<r<<"w="<<w;
        return;

    }
    w=m_data.toInt(&ok,10); if(!ok) return;
    //qDebug()<<"current:"<<current;
    series->append(current,w); current++; if (current>NUM_POINTS) { current=0; fill();}
    setWeight((w-m_tare0)/m_devider);
    if (m_tarecount==0) return;
    if (m_count>0&&m_count<=m_tarecount) {
        m_taresum=m_taresum+w;
        qDebug()<<"c:"<<m_count<<"tare:"<<m_taresum;
        m_count++;
        if (m_count>m_tarecount) {
            setTare0(m_taresum/m_tarecount);
            qDebug()<<"tare:"<<m_tare0;
            m_count=0; m_taresum=0; m_tarecount=0;
            emit stopTare();
        }
    }

}
void c_com::writeData(const QByteArray &data)
  {
    m_serial->write(data);
}

void c_com::start()
{
   int i=m_serial->write("s");
   if (i!=1) {
       qDebug()<<"Write error:";
   }


   m_stat->init();
}

void c_com::readError()
{

    m_error=m_serial->error();
    qDebug()<<"Error:"<<m_error;
    emit errorChanged();
}

void c_com::fill()
{
    ;
    if (series==NULL) return;
    series->clear();
//    for (int i=0; i<=NUM_POINTS; i++)
//    {
//        series->append(i, 0.0);
//    }
}

qreal c_com::getRadius() const
{
    return m_radius;
}

qint32 c_com::tare0() const
{
    return m_tare0;
}

void c_com::setTare0(const qint32 &tare0)
{
    m_tare0 = tare0;
    emit tare0Changed();
}


void c_com::setRadius(const qreal &radius)
{
    m_radius = radius;
    emit radiusChanged();
    qDebug()<<"CHRAD";
    qDebug()<<"Rad="<<getRadius();
}

QXYSeries *c_com::getSeries() const
{
    return series;
}

void c_com::setSeries(QXYSeries *value)
{
    series = value;
    emit seriesChanged();
}

qreal c_com::rotor() const
{
    return m_rotor;
}

void c_com::setRotor(const qreal &rotor)
{
    if (m_rotor == rotor) return;
    m_rotor = rotor;
    emit rotorChanged();
}

qreal c_com::average() const
{
    return m_average;
}

void c_com::setAverage(const qreal &average)
{
    if (m_average == average) return;
    m_average = average;
    emit averageChanged();
}



qreal c_com::devider() const
{
    return m_devider;
}

void c_com::setDevider(const qreal &devider)
{
    m_devider = devider;

}

void c_com::setWeight(const qreal &weight)
{
    m_stat->addPoint(weight);
    setAverage(m_stat->average());
    m_weight = weight;
    emit weightChanged();

}

qreal c_com::weight() const
{
    return m_weight;
}



QStringList c_com::ports() const
{
    return m_ports;
}



QSerialPort::SerialPortError c_com::error() const
{
    return m_error;
}

void c_com::setError(const QSerialPort::SerialPortError &error)
{
    m_error = error;
    emit errorChanged();
    qDebug()<<"Error:"<<error;
}

QString c_com::data() const
{
    return m_data;
}

void c_com::setData(const QString &data)
{
    m_data = data;
    emit dataChanged();
}

QString c_com::name() const
{
    return m_name;
}

void c_com::setName(const QString &name)
{
    m_name = name;
    emit nameChanged();
}
