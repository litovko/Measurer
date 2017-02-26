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
//        Button {
//            id: btn
//            width: celwidth
//            height: dataline.height

//            style: ButtonStyle {
//                      background: Rectangle {
//                          implicitWidth: 100
//                          implicitHeight: 25
//                          border.width: control.activeFocus ? 2 : 1
//                          border.color: "lightgreen"
//                          radius: 4
//                          color: "transparent"
//                          gradient: Gradient {
//                              GradientStop { position: 0 ; color: control.pressed ? "darkgreen" : "green" }
//                              GradientStop { position: 1 ; color: control.pressed ? "green" : "lightgreen" }
////                              GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
////                              GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
//                          }
//                      }
//                      label: Text {
//                          anchors.fill: parent
//                          color: "white"
//                          text: "Удалить"
//                          font.bold: true
//                          verticalAlignment: Text.AlignVCenter
//                          horizontalAlignment: Text.AlignHCenter
//                      }

//                  }

//        }
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
            celldate: "1321,5"
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
