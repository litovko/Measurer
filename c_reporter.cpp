#include "c_reporter.h"
#include <QPrinter>
#include <QTextDocumentWriter>
#include <QTextTable>
#include <QDebug>

void c_reporter::addGraduatorTable(QTextCursor &cursor, const int &ncol, const int &nrow)
{
    const int columns = 6+ncol;
    const int rows = 3+nrow;

    if (m_data_izm.length()==0) return;

    tableFormat.setHeaderRowCount( 1 );
    tableFormat.setAlignment(Qt::AlignCenter);

    tableFormat.setBorderStyle(QTextFrameFormat::BorderStyle_Solid);
    tableFormat.setCellPadding(3);
    tableFormat.setCellSpacing(1);
    QTextTable* textTable = cursor.insertTable( rows,
                                                columns,
                                                tableFormat );
    tableCellFormat.setBackground( QColor( "#DADADA" ) );
    blockFormat.setAlignment(Qt::AlignHCenter);

    QStringList headers;
    headers << "№\n изме-\nрения" << "№\nгирь" << "Вес гирь\nна площадке\nP, г/с" <<"Вр.момент\nМ=R*P,\nгс*см" <<"Сопр.вращ.\nсрезу\nгс/см/см"<<"Данные с датчика, ед."<<"Среднее\nарифм.\nзначение\nед."<<"77"<<"88";
    for( int column = 0; column < columns; column++ ) {
        if (column<5||column==columns-1) {
            if (column<5) setCell(textTable, 0, column, headers[column] );
            else setCell(textTable, 0, column, headers[6] );
        }
        else { //нумерация колонок с данными измерений
            setCell(textTable, 2, column, QString::number(column-4));
        }
    }
    setCell(textTable, 0, 5, headers[5]);
    setCell(textTable, 1, 5, "Порядковый номер наблюдений");
    tableCellFormat.setBackground(QColor( "#AFAFFF" ));
    // заполняем данными
    for ( int i=0; i<m_rows; i++) {
        QString s="";
        for (int j=0; j<m_columns+6; j++)  setCell(textTable, i+3, j, m_array[i][j]);
//            s=s+m_array[i][j]+ " ";
//        qDebug()<<"["<<s<<"]\n";
    }
//    int row = 0+3;
//    for(int column = 0; column < columns; column++) {
//        setCell(textTable, row, column, QString::number(column));
//    }
    textTable->mergeCells(0,0,3,1);
    textTable->mergeCells(0,1,3,1);
    textTable->mergeCells(0,2,3,1);
    textTable->mergeCells(0,3,3,1);
    textTable->mergeCells(0,4,3,1);
    textTable->mergeCells(0,5,1,ncol);
    textTable->mergeCells(1,5,1,ncol);
    textTable->mergeCells(0,5+ncol,3,1);
    cursor.movePosition( QTextCursor::End );
}

void c_reporter::createGraduatorReport(QString fname)
{
    QTextCursor cursor(&m_doc);

    QFont headerFont("Times", 14, QFont::Bold);

    QFont normalFont("Times", 10, QFont::Normal);
    QTextBlockFormat blockFormat;

    charFormat.setFont(normalFont);
    m_doc.setDefaultFont(headerFont);
    blockFormat.setAlignment(Qt::AlignHCenter);
    cursor.insertText("РЕЗУЛЬТАТЫ КАЛИБРОВКИ");
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertText(" 1");
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertText("Таблица калибровки прибора");
    addGraduatorTable(cursor,7,7);

    QPrinter printer(QPrinter::HighResolution);
    printer.setOutputFormat(QPrinter::PdfFormat);
    printer.setOutputFileName("file.pdf");
    m_doc.print(&printer);
    QTextDocumentWriter odfWritter(fname);
    qDebug()<<odfWritter.supportedDocumentFormats();
    odfWritter.setFormat("html");
    odfWritter.write(&m_doc);
}

void c_reporter::setCell(QTextTable *textTable, int row, int col, QString str)
{
    QTextTableCell cell=textTable->cellAt( row, col );
    Q_ASSERT( cell.isValid() );
    cell.setFormat(tableCellFormat);
    QTextCursor cellCursor = cell.firstCursorPosition();
    cellCursor.insertBlock(blockFormat, charFormat);
    cellCursor.insertText(str);
}

void c_reporter::setData(QString data)
{
//    m_rows=rows;
//    m_columns=columns;
    m_data_izm=data;
    qDebug()<<"reporter data:"<<m_data_izm;
    QStringList qs=m_data_izm.split(13);

    qDebug()<<qs;
    m_rows=qs.length()-1;
    if (qs.length()==0) return;
    for( int i=0; i<m_rows; i++) {
        QStringList dl=qs[i].split(";");
        if (dl.length()<6) break;
        //qDebug()<<dl;
        m_array[i][0]=dl[0];
        m_array[i][1]=dl[1];
        m_array[i][2]=dl[2];
        m_array[i][3]=dl[3];
        m_array[i][4]=dl[4];
        QStringList dd=dl[5].split("/");
        m_columns=dd.length();
        //qDebug()<<"m_columns="<<m_columns<<"m_rows="<<m_rows;
        for (int j=0; j<m_columns;j++) m_array[i][5+j]=dd[j];
        m_array[i][5+m_columns]=dl[6]; // среднее значение

    }
    qDebug()<<"==>m_columns="<<m_columns<<"m_rows="<<m_rows;
    for ( int i=0; i<m_rows; i++) {
        QString s="";
        for (int j=0; j<m_columns+6; j++) s=s+m_array[i][j]+ " ";
        qDebug()<<"["<<s<<"]\n";
    }
}

c_reporter::c_reporter(QObject *parent) : QObject(parent)
{

}



