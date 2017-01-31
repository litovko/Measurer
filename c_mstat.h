#ifndef C_MSTAT_H
#define C_MSTAT_H
#include <QVector>
#define ARRAY_SIZE 18000
class c_mstat
{
public:
    c_mstat();
public:
    qreal sum() const;
    void setSum(const qreal &sum);
    void addPoint(const qreal &point);
    void addPoint(const qint16 &r, const qint16 &w);
    void init();
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
    qint16 m_array[ARRAY_SIZE][2];
    void process();

};

#endif // C_MSTAT_H
