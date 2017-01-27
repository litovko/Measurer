#include "c_com.h"
#include <qdebug.h>
c_com::c_com(QObject *parent) : QObject(parent)
{
    m_serial = new QSerialPort(this);
    connect(m_serial, SIGNAL(readyRead()), this, SLOT(readData()));
}

c_com::~c_com()
{
    m_serial->close();
    delete m_serial;
}

void c_com::openSerialPort()
{


    m_serial->setPortName(m_name);
    m_serial->setBaudRate(m_baudRate);
    m_serial->setDataBits(m_dataBits);
    m_serial->setParity(m_parity);
    m_serial->setStopBits(m_stopBits);
    m_serial->setFlowControl(m_flowControl);
    if (m_serial->open(QIODevice::ReadWrite)) {
        qDebug()<<"serial open";

    } else {
        //QMessageBox::critical(this, tr("Error"), serial->errorString());

        //showStatusMessage(tr("Open error"));
    }

}

void c_com::readData()
{
   setData(m_serial->readAll());
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
