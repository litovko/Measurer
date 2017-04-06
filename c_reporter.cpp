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
        else { //проставляем номера колонок с данными измерений
            setCell(textTable, 2, column, QString::number(column-4));
        }
    }
    setCell(textTable, 0, 5, headers[5]);
    setCell(textTable, 1, 5, "Порядковый номер наблюдений");
    tableCellFormat.setBackground(QColor( "#AFAFFF" ));
    // заполняем данными
    for ( int i=0; i<m_rows; i++)
        for (int j=0; j<m_columns+6; j++)  setCell(textTable, i+3, j, m_array[i][j]);
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
void c_reporter::addErrorTable(QTextCursor &cursor, const int &ncol, const int &nrow)
{
    const int columns = 7+ncol;
    const int rows = 3+nrow;

    if (m_data_err.length()==0) return;

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
    headers << "№\n изме-\nрения" << "Сопр.вращ.\nсрезу\nгс/см/см" <<"Среднее\nарифм.\nзначение\nед."<< "Отклонение от среднего, ед." <<"Сумма отклонений\nед." <<"Абсо-\nлютная погрешность\nед."<<"Относи-\nтельная погрешность\n%"<<"Приве-\nденная погрешность\n%"<<"777"<<"888"<<"999"<<"000";
    for( int column = 0; column < columns; column++ ) {
        if (column<3) setCell(textTable, 0, column, headers[column]);
        else if (column>2+m_columns) setCell(textTable, 0, column, headers[column-6] );
             else setCell(textTable, 2, column, QString::number(column-2));  //проставляем номера колонок с данными измерений
    }
    setCell(textTable, 0, 3, headers[3]);
    setCell(textTable, 1, 3, "Порядковый номер наблюдений");
    tableCellFormat.setBackground(QColor( "#AFAFFF" ));
    // заполняем данными
    for ( int i=0; i<m_rows; i++)
        for (int j=0; j<columns; j++)  setCell(textTable, i+3, j, m_array_err[i][j]);
    textTable->mergeCells(0,0,3,1);
    textTable->mergeCells(0,1,3,1);
    textTable->mergeCells(0,2,3,1);
    textTable->mergeCells(0,3,1,ncol);
    textTable->mergeCells(1,3,1,ncol);
    textTable->mergeCells(0,3+ncol,3,1);
    textTable->mergeCells(0,4+ncol,3,1);
    textTable->mergeCells(0,5+ncol,3,1);
    textTable->mergeCells(0,6+ncol,3,1);
    cursor.movePosition( QTextCursor::End );
}

void c_reporter::addValues(QTextCursor &cursor)
{
    qDebug()<<m_values;
    if (m_values.length()==0) return;
    blockFormat.setAlignment(Qt::AlignLeft);
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertText(m_values);
}

void c_reporter::addChart(QTextCursor &cursor)
{
    blockFormat.setAlignment(Qt::AlignLeft);
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertText("График\n");

    QUrl Uri ( QString ( "filename.png" )  );
    QImage image;
    bool ok=image.load( "filename.png" );
    qDebug()<<"Image loaded:"<<ok<<"uri:"<<Uri.toString();
    m_doc.addResource( QTextDocument::ImageResource, Uri, QVariant ( image ) );
    image=image.scaledToWidth(600,Qt::SmoothTransformation);
    QTextImageFormat imageFormat;
    imageFormat.setWidth( image.width() );
    imageFormat.setHeight( image.height() );
    imageFormat.setName( Uri.toString() );
    cursor.insertImage(imageFormat);
}

void c_reporter::addError(QTextCursor &cursor)
{
    QTextCharFormat tcf=charFormat;
    QStringList l=m_params.split(';');
    tcf.setFontItalic(true);
    blockFormat.setAlignment(Qt::AlignLeft);
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertText("\nРезультаты расчета цены деления\n ");
    cursor.insertText("B",tcf);
    tcf.setVerticalAlignment(QTextCharFormat::AlignSubScript);
    cursor.insertText("ист",tcf);
    tcf.setVerticalAlignment(QTextCharFormat::AlignNormal);
    cursor.insertText("=",tcf);
    cursor.insertText(l.at(2)+"\u00B1"+l.at(3)+",  при n="+QString::number(m_rows),tcf);
    tcf.setFontFamily("GreekC_IV50");

    cursor.insertText(" и a=0.95 ",tcf);
    tcf=charFormat;
    cursor.insertText("t",tcf);
    tcf.setFontFamily("GreekC_IV50");tcf.setFontItalic(true);
    tcf.setVerticalAlignment(QTextCharFormat::AlignSubScript);
    cursor.insertText("a",tcf);
    tcf.setVerticalAlignment(QTextCharFormat::AlignNormal);
    cursor.insertText("="+l.at(1),tcf);
    //font.family: "GreekC_IV50"
}

void c_reporter::setParams(const QString &params)
{
    m_params = params;
}
void c_reporter::createGraduatorReport(QString fname)
{
    QTextCursor cursor(&m_doc);

    QFont headerFont("Times", 14, QFont::Bold);

    QFont normalFont("Times", 10, QFont::Normal);


    charFormat.setFont(normalFont);
    m_doc.setDefaultFont(headerFont);
    blockFormat.setAlignment(Qt::AlignHCenter);
    cursor.insertText("РЕЗУЛЬТАТЫ КАЛИБРОВКИ");
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertText(" ");
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertText("Таблица калибровки прибора");
    addGraduatorTable(cursor,m_columns,m_rows);
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertText("Результаты расчета погрешности");
    addErrorTable(cursor,m_columns,m_rows);
    addValues(cursor);
    addError(cursor);
    addChart(cursor);
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

void c_reporter::setData(QString &data)
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
        qDebug()<<"m_array["<<s<<"]";
    }
}

void c_reporter::setDataError(QString &data)
{
    m_data_err=data;
    qDebug()<<"reporter error data:"<<m_data_err;
    QStringList qs=m_data_err.split(13);

    qDebug()<<qs;
    m_rows=qs.length()-1;
    qDebug()<<m_rows;
    if (qs.length()==0) return;
    for( int i=0; i<m_rows; i++) {
        QStringList dl=qs[i].split(";");
        if (dl.length()<8) break;
        qDebug()<<dl;
        m_array_err[i][0]=dl[0];
        m_array_err[i][1]=dl[1];
        m_array_err[i][2]=dl[2];
        QStringList dd=dl[3].split("/");

        qDebug()<<"m_columns="<<m_columns<<"m_rows="<<m_rows;
        for (int j=0; j<m_columns;j++) m_array_err[i][3+j]=dd[j];
        m_array_err[i][3+m_columns]=dl[4];
        m_array_err[i][4+m_columns]=dl[5];
        m_array_err[i][5+m_columns]=dl[6];
        m_array_err[i][6+m_columns]=dl[7];

    }
    qDebug()<<"==>m_columns="<<m_columns<<"m_rows="<<m_rows;
    for ( int i=0; i<m_rows; i++) {
        QString s="";
        for (int j=0; j<m_columns+7; j++) s=s+m_array_err[i][j]+ " ";
        qDebug()<<"m_array_err["<<s<<"]";
    }
}

void c_reporter::setValues(QString &data)
{
    m_values=data;
}



c_reporter::c_reporter(QObject *parent) : QObject(parent)
{

}



