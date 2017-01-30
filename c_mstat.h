#ifndef C_MSTAT_H
#define C_MSTAT_H
#include <QVector>

class c_mstat
{
public:
    c_mstat();
public:
    qreal sum() const;
    void setSum(const qreal &sum);
    void addPoint(const qreal &point);
    int number() const;
    void setNumber(int number);

    qreal average() const;

private:
    int m_number=20;
    QVector<qreal> m_data;
    QVector<qreal> m_delta;
    QVector<qreal> m_sco;
    qreal m_sum;
    qreal m_average;

    void process();

};

#endif // C_MSTAT_H
