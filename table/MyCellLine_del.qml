import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../"
Item {
    id: dl
    property int celwidth: 90
    property real longcelwidth: 300
    property real prived_error: 300
    property alias weightname: w.celldata
    property alias weight: mm.celldata
    property alias datalinerow: dataline
    function addcolumn(){
        dc.addcolumn("-")
    }
    function delcolumn(num){
        dc.delcolumn(num)
    }
    function update(){
        //moment.celldata=(mm.celldata*1.0*dl.radius_R).toFixed(2)
        //res.celldata=(moment.celldata/dl.imp).toFixed(2)
        //dl.dataset=dl.makedatastring()
    }
    function getdata() {
        var s=""
        for (var i=1; i<dataline.children.length; i++)
        s=s+dataline.children[i].celldata+";"
        //print ("MyCellLine.getdata="+s)
        return s
    }

    Row {
        id: dataline
        width: dl.width
        height: parent.height


        MyCellInt {// номер строки таблицы

            celltype: 0
            width: celwidth
            height: dataline.height
        }
        MyCellInt {// сопротивление
            id: w
            celltype: 0
            width: celwidth
            height: dataline.height
        }
        MyCellInt { //среднее значение
            id: mm
            celltype: 0
            width: celwidth
            height: dataline.height

        }
        MyDataCells_error {
            id: d
            width: longcelwidth
            height: dataline.height
        }

        MyCellInt { //сумма отклонений
            id: serr
            celltype: 0
            width: celwidth
            height: dataline.height
            onCelldataChanged: dl.update()
            celldata: d.summa.toFixed(2)
        }
        MyCellInt { //абсолютная погрешность
            id: aerr
            celltype: 0
            width: celwidth
            height: dataline.height
            celldata: (d.summa/d.count).toFixed(2)
        }
        MyCellInt { //относительная погрешность
            id: rerr
            celltype: 0
            width: celwidth
            height: dataline.height
            celldata: ((d.summa/d.count)/mm.getdata()*100).toFixed(2)
        }
        MyCellInt { //приведенная погрешность
            id: perr
            celltype: 0
            width: celwidth
            height: dataline.height
            celldata: ((d.summa/d.count)*100/dl.prived_error).toFixed(2)
        }



    }
}
