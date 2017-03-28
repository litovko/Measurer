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
signals:

public slots:
private:
    QTextDocument m_doc;
    QTextCharFormat tableCellFormat; //формат ячейки таблицы
    QTextTableFormat tableFormat; // spacing & padding ячеек таблицы
    QTextBlockFormat blockFormat; //формат блока текста
    QTextCharFormat charFormat; //переменная для создания блока с нужным фонтом

    void addGraduatorTable(QTextCursor& cursor, const int &ncol, const int &nrow);

};

#endif // C_REPORTER_H
