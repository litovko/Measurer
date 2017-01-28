#include "c_com.h"
#include <qdebug.h>
#include <QtSerialPort/QSerialPortInfo>
c_com::c_com(QObject *parent) : QObject(parent)
{
    m_serial = new QSerialPort(this);

    connect(m_serial, SIGNAL(readyRead()), this, SLOT(readData()));
    //connect(m_serial, SIGNAL(error()), this, SLOT(readError()));

    connect(m_serial, static_cast<void (QSerialPort::*)(QSerialPort::SerialPortError)>(&QSerialPort::error),
            this, &c_com::readError);
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

void c_com::readData()
{
    setData(m_serial->readAll());
}

void c_com::readError()
{

    m_error=m_serial->error();
    qDebug()<<"Error:"<<m_error;
    emit errorChanged();
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
}
