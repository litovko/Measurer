import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    property ListModel lm
    Rectangle {
        id: rectangle
        border.width: 2
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#000000";
            }
            GradientStop {
                position: 1.00;
                color: "#555555";
            }
        }
        border.color: "#ffff00"
        anchors.fill: parent
        TableView {
            id: tableView
            anchors.margins: 25
            anchors.fill: parent
            model: mainPayFormDataListCheck
            Component.onCompleted: console.log(lm)
            backgroundVisible: false
            TableViewColumn {
                id: c1Column
                title: "<p>&nbsp;</p><p>&nbsp;№</p><p>изм.</p>"
                role: "number"
                movable: false
                resizable: false
                width: tableView.viewport.width/10
                   }
            TableViewColumn {
                id: c2Column
                title: '<p>&nbsp;Вес гирь</p><p>&nbsp; &nbsp; &nbsp;на</p><p>площадке</p><p>&nbsp; &nbsp;Р, гс</p>'
                role: "weight"
                movable: false
                resizable: true
                width: tableView.viewport.width/5
            }
            TableViewColumn {
                id: c3Column
                title: "Вращ. момент"
                role: "moment"
                movable: false
                resizable: false
                //width: tableView.viewport.width / 2
            }
            TableViewColumn {
                id: c4Column
                title: "<p>Сопр. вращ.</p><p>срезу</p>"
                role: "cutres"
                movable: false
                resizable: false
                //width: tableView.viewport.width / 2
            }
//        itemDelegate: Item {
//           Rectangle{
//               color: "black"
//               border.color: "transparent"
//               border.width: 1
//               anchors.fill: parent
//               Text {
//                             anchors.verticalCenter: parent.verticalCenter
//                             anchors.horizontalCenter: parent.horizontalCenter
//                             font.pixelSize: 12
//                             elide: styleData.elideMode
//                             text: styleData.value
//                             color: "white"
//            }
//           }
//            }
            ListModel {
                  id: mainPayFormDataListCheck
                  objectName: "mainPayFormDataListCheck"
                  /* Функция обновления списка чека и добавления суммы чека */
                  Component.onCompleted: onInsertToTable()
                  function onInsertToTable()
                  {
                      mainPayFormDataListCheck.clear();
                      mainPayFormDataListCheck.insert(mainPayFormDataListCheck,{"number": 3, "weight":3.123,"moment":123.12});
                      mainPayFormDataListCheck.insert(mainPayFormDataListCheck,{"number": 2, "weight":2.01});
                      mainPayFormDataListCheck.insert(mainPayFormDataListCheck,{"number": 1, "weight":1.76});
                  }
               }
            style: TableViewStyle {

                        backgroundColor : "transparent"

                        alternateBackgroundColor : "transparent"
                        headerDelegate: Rectangle {
                            height: textItem.implicitHeight * 1.2
                            width: textItem.implicitWidth
                            color: "transparent"
                            Text {
                                id: textItem
                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: styleData.textAlignment
                                anchors.leftMargin: 12
                                text: styleData.value
                                elide: Text.ElideRight
                                color: "yellow"
                                renderType: Text.NativeRendering
                            }
//                            Rectangle {
//                                anchors.right: parent.right
//                                anchors.top: parent.top
//                                anchors.bottom: parent.bottom
//                                anchors.bottomMargin: 1
//                                anchors.topMargin: 1
//                                width: 1
//                                color: "transparent"
//                                border.color: "transparent"
//                            }
                        }
                    }
        }
    }

}
