#include "c_reporter.h"
#include <QPrinter>
#include <QTextDocumentWriter>
#include <QTextTable>
#include <QDebug>

void c_reporter::addGraduatorTable(QTextCursor &cursor, const int &ncol, const int &nrow)
{
    const int columns = 6+ncol;
    const int rows = 3+nrow;



    tableFormat.setHeaderRowCount( 1 );
    tableFormat.setAlignment(Qt::AlignCenter);

    tableFormat.setBorderStyle(QTextFrameFormat::BorderStyle_Solid);
    tableFormat.setCellPadding(3);
    tableFormat.setCellSpacing(1);
    QTextTable* textTable = cursor.insertTable( rows + 5,
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
        else {
            //cell = textTable->cellAt( 2, column );
            //Q_ASSERT( cell.isValid() );
            //cell.setFormat( tableHeaderFormat );
            //QTextCursor cellCursor = cell.firstCursorPosition();
            //cellCursor.blockFormat().setAlignment(Qt::AlignHCenter);
            //cellCursor.insertText(QString::number(column-4));
            setCell(textTable, 2, column, QString::number(column-4));
        }
    }
    setCell(textTable, 0, 5, headers[5]);
    setCell(textTable, 1, 5, "Порядковый номер наблюдений");
    tableCellFormat.setBackground(QColor( "#AFAFFF" ));
    int row = 0+3;
    for(int column = 0; column < columns; column++) {
        setCell(textTable, row, column, QString::number(column));
    }
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

    QFont normalFont("Times", 12, QFont::Normal);
    QTextBlockFormat blockFormat;

    charFormat.setFont(normalFont);
    m_doc.setDefaultFont(headerFont);
    blockFormat.setAlignment(Qt::AlignHCenter);
    cursor.insertText("РЕЗУЛЬТАТЫ КАЛИБРОВКИ");
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertText(" 1");
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertText("Таблица калибровки прибора");
    addGraduatorTable(cursor,7,1);

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

c_reporter::c_reporter(QObject *parent) : QObject(parent)
{

}



