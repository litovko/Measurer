#ifndef C_COM_H
#define C_COM_H

#include <QObject>

class c_com : public QObject
{
    Q_OBJECT
public:
    explicit c_com(QObject *parent = 0);

signals:

public slots:
};

#endif // C_COM_H