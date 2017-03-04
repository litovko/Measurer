import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../"
Item {
    id: dl
    property int celwidth: 90
    property real longcelwidth: 300
    property int number: 0
    property real radius_R: 1.0
    property real imp_h: 1.0
    property real imp_d: 1.0
    property real imp: 1
    //property string dataset: ""
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
        moment.celldata=(mm.celldata*1.0*dl.radius_R).toFixed(2)
        res.celldata=(moment.celldata/dl.imp).toFixed(2)
        //dl.dataset=dl.makedatastring()
    }
    function getdata() {
        var s=""
        for (var i=1; i<dataline.children.length; i++)
        s=s+dataline.children[i].celldata+"; "
        //print ("MyCellLine.getdata="+s)
        return s
    }
    onRadius_RChanged:  update()

    onImpChanged:       update()

    Row {
        id: dataline
        width: dl.width
        height: parent.height

        Rectangle {
            width: celwidth
            height: dataline.height
            color: "transparent"
            border.color: "transparent"
            MyMenuItem{
              anchors.fill: parent
              anchors.margins: 6

              text: "Удалить"
              onButtonClicked: dl.destroy()
            }
        }

        MyCellInt {// номер строки таблицы
            celldata: dl.number
            celltype: 1
            width: celwidth
            height: dataline.height
        }
        MyCellInt {// название груза
            id: w
            celldata: dl.number
            celltype: 3
            width: celwidth
            height: dataline.height
        }
        MyCellInt { //вес гирь
            id: mm
            celldata: "0"
            celltype: 2
            width: celwidth
            height: dataline.height
            onCelldataChanged: dl.update()

        }
        MyCellInt { //момент
            id: moment
            celldata: (mm.celldata*1.0*dl.radius_R).toFixed(2)
            celltype: 0
            width: celwidth
            height: dataline.height
        }
        MyCellInt { //сопротивл. вр. срезу
            id: res
            celldata: moment.celldata/dl.imp
            celltype: 0
            width: celwidth
            height: dataline.height
        }
        MyDataCells{
            id: dc
            width: longcelwidth
            height: dataline.height
//            onChanged: {
//                //dl.dataset=dl.makedatastring()
//                avrg.celldata=dc.average().toFixed(1)
//            }
        }
        MyCellInt {
            id: avrg
            celldata: dc.average
            celltype: 0
            width: celwidth
            height: dataline.height
        }

    }
}
