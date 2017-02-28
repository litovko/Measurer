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
    function addcolumn(){
        dc.addcolumn("-")
    }
    function delcolumn(num){
        dc.delcolumn(num)
    }
    function update(){
        moment.celldate=(mm.celldate*1.0*dl.radius_R).toFixed(2)
        res.celldate=(moment.celldate/dl.imp).toFixed(2)
    }
    function makedatastring() {
        var s=""
        for (var i=1; i<dataline.children.length; i++)
        s=s+i+"':'"+dataline.children[i].makedatastring()+"'; "
        return s
    }
    onRadius_RChanged:  update()

    onImpChanged:       update()


    //Component.onCompleted: addcolumn("+")
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
            celldate: dl.number
            celltype: 1
            width: celwidth
            height: dataline.height
        }
        MyCellInt {// название груза
            celldate: "1+пл."
            celltype: 3
            width: celwidth
            height: dataline.height
        }
        MyCellInt { //вес гирь
            id: mm
            celldate: "1.1"
            celltype: 2
            width: celwidth
            height: dataline.height
            onCelldateChanged: dl.update()

        }
        MyCellInt { //момент
            id: moment
            celldate: (mm.celldate*1.0*dl.radius_R).toFixed(2)
            celltype: 0
            width: celwidth
            height: dataline.height
        }
        MyCellInt { //сопротивл. вр. срезу
            id: res
            celldate: moment.celldate/dl.imp
            celltype: 0
            width: celwidth
            height: dataline.height
        }
        MyDataCells{
            id: dc
            width: longcelwidth
            height: dataline.height
            onChanged: avrg.celldate=dc.average().toFixed(1)
        }
        MyCellInt {
            id: avrg
            celldate: "-"
            celltype: 0
            width: celwidth
            height: dataline.height
        }

    }
}
