#include "c_com.h"
#include <qdebug.h>
#include <QtSerialPort/QSerialPortInfo>
#include <QSettings>
#include <QtGlobal>
#include <QPrinter>
#include <QTextDocumentWriter>

static void addTable(QTextCursor& cursor, const int &ncol, const int &nrow)
{
    const int columns = 6+ncol;
    const int rows = 3+nrow;

    QTextTableFormat tableFormat;

    tableFormat.setHeaderRowCount( 1 );
    tableFormat.setAlignment(Qt::AlignCenter);

    tableFormat.setBorderStyle(QTextFrameFormat::BorderStyle_Solid);
    tableFormat.setCellPadding(1);
    tableFormat.setCellSpacing(0);
    //tableFormat.setWidth(QTextLength(QTextLength::PercentageLength, 40));
//    tableFormat.setAlignment(Qt::AlignLeft);
    QTextTable* textTable = cursor.insertTable( rows + 5,
                                                columns,
                                                tableFormat );
    QTextCharFormat tableHeaderFormat;
    tableHeaderFormat.setBackground( QColor( "#DADADA" ) );

    QStringList headers;
    headers << "Порядковый\n №\n измерений" << "№\n гирь" << "Вес гирь\nна площадке\n P, г/с" <<"Вр.момент\nМ=R*P,\nгс*см" <<"Сопр.вращ.\nсрезу\nгс/см/см"<<"Данные с датчика, ед."<<">Среднее\nарифм.\nзначение\nед."<<"77"<<"88";
    for( int column = 0; column < columns; column++ ) {
        QTextTableCell cell;
        qDebug()<<"column="<<column;
        if (column<5||column==columns-1) {
            cell = textTable->cellAt( 0, column );
            Q_ASSERT( cell.isValid() );
            cell.setFormat( tableHeaderFormat );
            QTextCursor cellCursor = cell.firstCursorPosition();
            if (column<5) cellCursor.insertText( headers[column] );
            else cellCursor.insertText( headers[6] );
        }
        else {
            cell = textTable->cellAt( 2, column );
            Q_ASSERT( cell.isValid() );
            cell.setFormat( tableHeaderFormat );
            QTextCursor cellCursor = cell.firstCursorPosition();
            cellCursor.insertText(QString::number(column));
        }
    }
    int row = 0+3;
    for( int column = 0; column < columns; column++ ) {
        QTextTableCell cell = textTable->cellAt( row + 1, column );

        Q_ASSERT( cell.isValid() );
        QTextCursor cellCursor = cell.firstCursorPosition();
        const QString cellText = QString( "A 220.00" );
        cellCursor.insertText( cellText );
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
c_com::c_com(QObject *parent) : QObject(parent), series(NULL)
{
    m_serial = new QSerialPort(this);
    m_stat = new c_mstat();

    connect(m_serial, SIGNAL(readyRead()), this, SLOT(readData()));
    connect(this,SIGNAL(seriesChanged()), this, SLOT(fill()));
    connect(this,SIGNAL(tabledataChanged()), this, SLOT(filltableseries()));
    connect(m_serial, SIGNAL(error(QSerialPort::SerialPortError)),
            this, SLOT(readError()));
    connect(m_serial, SIGNAL(aboutToClose()),  this, SLOT(readIsOpen()));
    connect(this, SIGNAL(impeller_hChanged()), this, SLOT(calcImpeller()));
    connect(this, SIGNAL(impeller_dChanged()), this, SLOT(calcImpeller()));
    //connect(this, SIGNAL(filenameChanged()),   this, SLOT(writefile()));
    fill();
    //setPulley(2.5);
    listPorts();
    readSettings();
    calcImpeller();

}

c_com::~c_com()
{
    m_serial->close();
    delete m_serial;
    saveSettings();
}

void c_com::saveSettings()
{
    QSettings settings("HYCO", "PRIBOR");
    settings.setValue("PortName",name());
    settings.setValue("PulleyRadius",getPulley());
    settings.setValue("TareWeight",tare0());
    settings.setValue("Devider",devider());
    settings.setValue("HImpeller",getImpeller_h());
    settings.setValue("DImpeller",getImpeller_d());
    //==
    settings.setValue("K_a",getA());
    settings.setValue("K_b",getB());
}

void c_com::readSettings()
{
    QSettings settings("HYCO", "PRIBOR");
    listPorts();
    setName(settings.value("PortName","COM11").toString());
    setPulley(settings.value("PulleyRadius",2.1).toReal());
    setTare0(settings.value("TareWeight",0.0).toReal());
    setDevider(settings.value("Devider",1.0).toReal());
    setImpeller_h(settings.value("HImpeller",1.0).toReal());
    setImpeller_d(settings.value("DImpeller",1.0).toReal());
    //==
    setA(settings.value("K_a",0.0).toReal());
    setB(settings.value("K_b",1.0).toReal());
}

void c_com::makeDoc()
{

    QTextCursor cursor(&m_doc);

    QFont headerFont("Times", 14, QFont::Bold);

    QFont normalFont("Times", 12, QFont::Normal);
    QTextBlockFormat blockFormat;
    QTextCharFormat charFormat;
    charFormat.setFont(normalFont);
    m_doc.setDefaultFont(headerFont);
    cursor.insertText("РЕЗУЛЬТАТЫ КАЛИБРОВКИ");
    cursor.insertBlock(blockFormat,charFormat);
    cursor.insertText(" 1");
    cursor.insertBlock();

    cursor.insertText("Таблица калибровки прибора");
    addTable(cursor,7,1);

    QPrinter printer(QPrinter::HighResolution);
    printer.setOutputFormat(QPrinter::PdfFormat);
    printer.setOutputFileName("file.pdf");
    m_doc.print(&printer);
    QTextDocumentWriter odfWritter("filedoc.doc");
    qDebug()<<odfWritter.supportedDocumentFormats();
    odfWritter.setFormat("html");
    odfWritter.write(&m_doc);
}

qreal c_com::func(const qreal &x)
{
    return x*m_b+m_a;
}

qreal c_com::mantissa(const qreal &x)
{
    return floor(log10(x));


}

QString c_com::getFilename() const
{
    return m_filename;
}

void c_com::setFilename(const QString &filename)
{
    m_filename = filename;
    emit filenameChanged();
}

void c_com::filltableseries()
{
    qDebug()<<"fill data on CHARTS";
    qreal x,y, minx=1000000, maxx=0, miny=1000000, maxy=0;
    qreal sxy=0, sx2=0; //суммы произведения и квадратов
    qreal sx=0, sy=0; //суммы значений
    int n=0; // количество точек
    qreal a,b; //коэффициенты линейного уравнения
    bool ok;
    qDebug()<<"filltableseries";
    QStringList qs=m_tabledata.split(13);
    if (qs.length()==0) return;
    qDebug()<<m_tabledata;
    lineseries->clear();
    tableseries->clear();
    absseries->clear();
    foreach(QString item, qs) {
        QStringList dl=item.split(";");
        if (dl.length()<6) break;
        //qDebug()<<dl.length();
        x=dl.at(4).toDouble(&ok); minx=qMin(minx, x); maxx=qMax(maxx, x);
        y=dl.at(6).toDouble(&ok); miny=qMin(miny, y); maxy=qMax(maxy, y);
        qDebug()<<x<<"--"<<y<<"maxx:"<<maxx<<"maxy:"<<maxy;
        tableseries->append(x,y);
        //===============
        n++;
        sxy+=x*y; sx2+=x*x;
        sx+=x; sy+=y;
    }
    //

    minx=0;
    qreal m=pow(10,mantissa(maxy)+1);
    qDebug()<<"m="<<m;
    qreal p=m;
    for(int j=0; j<=10;j++) {
        qDebug()<<"p="<<p<<"maxy="<<maxy;
        if ((maxy>=m-m*0.1*j)&&(maxy<p)) {maxy=p+m*0.05; break;}
        p=m-m*0.1*j;
    }
    qDebug()<<"maxy="<<maxy;

    p=m;
//    for(int j=0; j<=10;j++) {
//        qDebug()<<"p="<<p<<"maxx="<<maxx;
//        if ((maxx>=m-m*0.1*j)&&(maxx<p)) {maxx=p; break;}
//        p=m-m*0.1*j;
//    }
    qDebug()<<"maxx="<<maxx;

    maxx=maxx*1.1;
    miny=-000;
    b=(sxy-sx*sy/n)/(sx2-sx*sx/n);
    a=sy/n-b*sx/n;
    m_a=a; m_b=b;
    qDebug()<<"A="<<m_a<<" B="<<m_b;
    if (tableseries->attachedAxes().length()<2) return;
    tableseries->attachedAxes()[0]->setMin(minx);
    tableseries->attachedAxes()[1]->setMin(miny);
    tableseries->attachedAxes()[0]->setMax(maxx);
    tableseries->attachedAxes()[1]->setMax(maxy);
    //qDebug()<<"SER"<<tableseries->children();
    lineseries->append(0,a);
    lineseries->append(maxx,a+b*maxx);
    lineseries->attachedAxes()[0]->setMin(minx);
    lineseries->attachedAxes()[1]->setMin(miny);
    lineseries->attachedAxes()[0]->setMax(maxx);
    lineseries->attachedAxes()[1]->setMax(maxy);

    absseries->attachedAxes()[0]->setMin(minx);
    absseries->attachedAxes()[0]->setMax(maxx);
    foreach (QPointF p, tableseries->pointsVector()) {
        qDebug()<<"p="<<p<<" f="<<func(p.x())<<" abs="<<qAbs(func(p.x())-p.y())<<"otkl:"<<100*qAbs(func(p.x())-p.y())/p.y();
        absseries->append(p.x(),100*qAbs(func(p.x())-p.y())/p.y());
    }
    m_a=a;
    m_b=b;
}

void c_com::writefile()
{

    //qDebug()<<"Write file-1:"<<m_filename;
    QUrl url(m_filename);
    QFile file(url.toLocalFile());
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug()<<"error:"<<file.errorString();
        return;
    }
    //qDebug()<<"Write file-2:"<<m_tabledata;
    QTextStream out(&file);
    out << m_tabledata;
    file.close();

}

QString c_com::readfile()
{
    QUrl url(m_filename);
    QFile file(url.toLocalFile());
    qDebug()<<url;
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
       qDebug()<<"error:"<<file.errorString();
       return "";
    }
    QTextStream in(&file);
    QString line;
    qDebug()<<"read";
    while (!in.atEnd()) {
               line += in.readLine()+"\n\r";

    //          process_line(line);
    }
    qDebug()<<line;
    return line;

}

QXYSeries *c_com::getAbsseries() const
{
    return absseries;
}

void c_com::setAbsseries(QXYSeries *value)
{
    absseries = value;
}

qreal c_com::getB() const
{
    return m_b;
}

void c_com::setB(const qreal &b)
{
    m_b = b;
}

qreal c_com::getA() const
{
    return m_a;
}

void c_com::setA(const qreal &a)
{
    m_a = a;
}

QXYSeries *c_com::getLineseries() const
{
    return lineseries;
}

void c_com::setLineseries(QXYSeries *value)
{
    lineseries = value;
}



void c_com::openSerialPort(int port)
{
    
    if (port>=m_ports.length()) {
        qDebug()<<"WRONG PORT NUMBER";
        return;
    }

    if (port>=0) m_name=m_ports.at(port);
    qDebug()<<"openport:"<<m_name<<"port="<<port; emit nameChanged();
    if(m_serial->isOpen()) {
        m_serial->close();
        qDebug()<<"закрыли порт";
    }
    m_serial->setPortName(m_name);
    m_serial->setBaudRate(m_baudRate);
    m_serial->setDataBits(m_dataBits);
    m_serial->setParity(m_parity);
    m_serial->setStopBits(m_stopBits);
    m_serial->setFlowControl(m_flowControl);
    if (m_serial->open(QIODevice::ReadWrite)) {
        qDebug()<<"serial port:"<<m_name<<"has opened";
        m_isOpen=true; emit isOpenChanged();
        qDebug()<<"Is open:"<<isOpen();

    } else {
        m_error=m_serial->error();
        qDebug()<<"Open port Error:"<<m_error;
        m_isOpen=false; emit isOpenChanged();
    }

}

void c_com::listPorts()
{
    m_ports.clear();
    const auto infos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &info: infos) {
    //qDebug() << "Name : " << info.portName();
    //qDebug() << "Description : " << info.description();
    //qDebug() << "Manufacturer: " << info.manufacturer();
    m_ports.append(info.portName());
    }
    //qDebug()<<"com ports available:"<<m_ports;
    emit portsChanged();
}

void c_com::tare(int count)  //запуск процедуры тарирования
{
    m_tarecount=count; //количество подсчетов для тарирования
    m_count=1; //начинаем считать сумму по весу с единицы
    m_taresum=0;
}

void c_com::calibrate(qreal cur_weight)
{
    m_devider=m_weight/cur_weight;
}

void c_com::reset()
{
    m_devider=1;
    m_weight=0;
    m_count=0;
    m_tarecount=0;
    m_taresum=0;
    m_tare0=0;

}

void c_com::readData()
{
    bool ok;
    int w,r;
    setData(m_serial->readAll());
    if(m_data[0]=='r') {
        m_data.remove(0,1);
        w=m_data.toInt(&ok,10); if(!ok) return;
        setRotor(w/100.0);
    }
    if(m_data[0]=='d') { // d01781:65912
        m_data.remove(0,1);
        QString s=m_data.left(5);
        r=s.toInt(&ok,10); if(!ok) return;
        m_data.remove(0,6);
        w=m_data.toInt(&ok,10); if(!ok) return;

        m_stat->addPoint(r,w);
        setRotor(r);
        //qDebug()<<"r="<<r<<"w="<<w;
        return;

    }
    w=m_data.toInt(&ok,10); if(!ok) return;
    //qDebug()<<"current:"<<current;
    series->append(current,w); current++; if (current>NUM_POINTS) { current=0; fill();}
    setWeight((w-m_tare0)/m_devider);
    if (m_tarecount==0) return;
    if (m_count>0&&m_count<=m_tarecount) {
        m_taresum=m_taresum+w;
        qDebug()<<"c:"<<m_count<<"tare:"<<m_taresum;
        m_count++;
        if (m_count>m_tarecount) {
            setTare0(m_taresum/m_tarecount);
            qDebug()<<"tare:"<<m_tare0;
            m_count=0; m_taresum=0; m_tarecount=0;
            emit stopTare();
        }
    }

}
void c_com::writeData(const QByteArray &data)
  {
    qDebug()<<"WRITE:"<<data;
    m_serial->write(data);
}

void c_com::start()
{
   int i=m_serial->write("s");
   if (i!=1) {
       qDebug()<<"Write error:";
   }


   m_stat->init();
}

void c_com::readError()
{

    m_error=m_serial->error();
    if (m_error) {
        m_isOpen=false; emit isOpenChanged();
        // qDebug()<<"IsOpen:"<<m_isOpen;
    }
    qDebug()<<"Error:"<<m_error;
    emit errorChanged();
}

void c_com::readIsOpen()
{
    m_isOpen=false;
    //qDebug()<<"IsOpen:"<<m_isOpen;
    emit isOpenChanged();
}

void c_com::calcImpeller()
{
    setImpeller(M_PI*m_impeller_d*m_impeller_d/2.0*(m_impeller_d/6.0+m_impeller_h));
    //qDebug()<<"imp="<<M_PI<<"*"<<m_impeller_d*m_impeller_d;
    //qDebug()<<"imp="<<m_impeller;
    emit impellerChanged();
}

void c_com::fill()
{
    ;
    if (series==NULL) return;
    series->clear();
//    for (int i=0; i<=NUM_POINTS; i++)
//    {
//        series->append(i, 0.0);
//    }
}

QString c_com::getTabledata() const
{
    return m_tabledata;
}

void c_com::setTabledata(const QString &tabledata)
{
    m_tabledata = tabledata;
    emit tabledataChanged();
}

QXYSeries *c_com::getTableseries() const
{
    return tableseries;
}

void c_com::setTableseries(QXYSeries *value)
{
    tableseries = value;
}

qreal c_com::getImpeller_d() const
{
    return m_impeller_d;
}

void c_com::setImpeller_d(const qreal &impeller_d)
{
    m_impeller_d = impeller_d;
    emit impeller_dChanged();
}

qreal c_com::getImpeller_h() const
{
    return m_impeller_h;
}

void c_com::setImpeller_h(const qreal &impeller_h)
{
    m_impeller_h = impeller_h;
    emit impeller_hChanged();
}

qreal c_com::getImpeller() const
{
    return m_impeller;
}

void c_com::setImpeller(const qreal &impeller)
{
    m_impeller = impeller;
    emit impellerChanged();
}


bool c_com::isOpen() const
{
    return m_isOpen;
}

qreal c_com::getPulley() const
{
    return m_pulley;
}

void c_com::setPulley(const qreal &pulley)
{
    m_pulley = pulley;
    emit pulleyChanged();
}



qint32 c_com::tare0() const
{
    return m_tare0;
}

void c_com::setTare0(const qint32 &tare0)
{
    m_tare0 = tare0;
    emit tare0Changed();
}



QXYSeries *c_com::getSeries() const
{
    return series;
}

void c_com::setSeries(QXYSeries *value)
{
    series = value;
    emit seriesChanged();
}

qreal c_com::rotor() const
{
    return m_rotor;
}

void c_com::setRotor(const qreal &rotor)
{
    if (m_rotor == rotor) return;
    m_rotor = rotor;
    emit rotorChanged();
}

qreal c_com::average() const
{
    return m_average;
}

void c_com::setAverage(const qreal &average)
{
    if (m_average == average) return;
    m_average = average;
    emit averageChanged();
}



qreal c_com::devider() const
{
    return m_devider;
}

void c_com::setDevider(const qreal &devider)
{
    m_devider = devider;

}

void c_com::setWeight(const qreal &weight)
{
    m_stat->addPoint(weight);
    setAverage(m_stat->average());
//    qDebug()<<"w1"<<weight<<" "<<m_weight;
    if (m_weight == weight) return;
    m_weight = weight;
//    qDebug()<<"w2"<<weight<<" "<<m_weight;
    emit weightChanged();

}

qreal c_com::weight() const
{
    return m_weight;
}



QStringList c_com::ports() const
{
    return m_ports;
}



QSerialPort::SerialPortError c_com::error() const
{
    return m_error;
}

void c_com::setError(const QSerialPort::SerialPortError &error)
{
    m_error = error;
    emit errorChanged();
    qDebug()<<"Error:"<<error;
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
    int i=m_ports.indexOf(m_name,0);
    //qDebug()<<"i="<<i<<"m_name:"<<m_name;
    if (i>0) openSerialPort(i);
    emit nameChanged();
}
