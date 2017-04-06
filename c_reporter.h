#ifndef C_REPORTER_H
#define C_REPORTER_H

#include <QObject>
#include <QTextDocument>
#include <QTextTable>

class c_reporter : public QObject
{
    Q_OBJECT
public:
    explicit c_reporter(QObject *parent = 0);
    void createGraduatorReport(QString fname);
    void setCell(QTextTable* textTable,int row, int col, QString str);
    void setParams(const QString &params);

signals:

public slots:
    void setData(QString &data);
    void setDataError(QString &data);
    void setValues(QString &data);


private:
    QTextDocument m_doc;
    QTextCharFormat tableCellFormat; //формат ячейки таблицы
    QTextTableFormat tableFormat; // spacing & padding ячеек таблицы
    QTextBlockFormat blockFormat; //формат блока текста
    QTextCharFormat charFormat; //переменная для создания блока с нужным фонтом

    void addGraduatorTable(QTextCursor& cursor, const int &ncol, const int &nrow);
    void addErrorTable(QTextCursor& cursor, const int &ncol, const int &nrow);
    void addValues(QTextCursor& cursor);
    void addChart(QTextCursor& cursor);
    void addChart2(QTextCursor& cursor);
    void addError(QTextCursor& cursor);
    int m_rows=0;
    int m_columns=0;
    QString m_data_izm=""; //данные таблицы измерений
    QString m_data_err=""; //данные таблицы погрешностей
    QString m_values="";
    QString m_params="";
    QString m_array[15][15];
    QString m_array_err[15][15];

};

#endif // C_REPORTER_H
