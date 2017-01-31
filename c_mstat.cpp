#include "c_mstat.h"
#include <QVector>
c_mstat::c_mstat()
{

}

qreal c_mstat::sum() const
{
    return m_sum;
}

void c_mstat::setSum(const qreal &sum)
{
    m_sum = sum;
}

void c_mstat::addPoint(const qreal &point)
{
    m_data+=point;
    if (m_data.length()>m_number) {
        m_data.remove(0);
    }
    process();
}

void c_mstat::addPoint(const qint16 &r, const qint16 &w)
{
    m_array[r][0]=r;
    m_array[r][1]=w;
}

void c_mstat::init()
{
    for (int i=0;i<ARRAY_SIZE;i++) m_array[i][0]=0;
}

int c_mstat::number() const
{
    return m_number;
}

void c_mstat::setNumber(int number)
{
    m_number = number;
}

qreal c_mstat::average() const
{
    return m_average;
}

void c_mstat::process()
{
    int n=m_data.length();
    m_sum=0;
    for (int i=0; i<n;i++)  m_sum+=m_data[i];
    m_average=m_sum/n;

}
