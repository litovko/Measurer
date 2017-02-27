import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../"
Item {
    id: dl
    property int celwidth: 90
    property real longcelwidth: 300
    property int number: 0
    //property int count: 0
    function addcolumn(){
        dc.addcolumn("-")
    }
    function delcolumn(num){
        dc.delcolumn(num)
    }
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

        MyCellInt {
            celldate: dl.number
            celltype: 1
            width: celwidth
            height: dataline.height
        }
        MyCellInt {
            celldate: "1+пл."
            celltype: 0
            width: celwidth
            height: dataline.height
        }
        MyCellInt {
            celldate: "1.1"
            celltype: 2
            width: celwidth
            height: dataline.height
        }
        MyCellInt {
            celldate: "-"
            celltype: -1
            width: celwidth
            height: dataline.height
        }
        MyCellInt {
            celldate: "-"
            celltype: -1
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
            celltype: -1
            width: celwidth
            height: dataline.height
        }

    }
}
