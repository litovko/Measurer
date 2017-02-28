import QtQuick 2.0
import "./table"
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

Item {
    id: gr
    property string fname: "tbl.csv"
    property int maxrow : 7
    Rectangle {

        Settings {
            //category: "PPGraduator"
            property alias fname: gr.fname
            property alias maxrow: gr.maxrow

        }
        anchors.margins: 5
        anchors.fill: parent
        color: "black"
        border.color: "lightgray"
        border.width: 2
        radius: 5
        FileDialog {
            id: fileDialog
            title: "Please choose a file"
            folder: shortcuts.home
            onAccepted: {
                console.log("You chose: " + fileDialog.fileUrls)
                Qt.quit()
            }
            onRejected: {
                console.log("Canceled")
                Qt.quit()
            }
            Component.onCompleted: visible = true
        }
        Text {
            width: 200
            height: 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            text: "ГРАДУИРОВКА ПРИБОРА"
            font.bold: true
            font.pointSize: 12
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "lightgray"
        }

        MyTable{
            id: tbl
            height:400
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            Component.onCompleted: {
                for(var i=0;i<table_rows; i++) {
                    addrow();
                }
                for( i=0;i<table_columns; i++) {
                    addcolumn()
                }
            }
            rad: m.pulley
            imp_d: m.impeller_d
            imp_h: m.impeller_h
            imp: m.impeller
        }
    }
    states: [
        State {
            name: "Таблица"
        },
        State {
            name: "График"
        }
    ]

}
