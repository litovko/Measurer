import QtQuick 2.0
import "./table"
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

Item {
    id: gr

    property alias maxrow : tbl.maxrow
    property string dataset: ""

    property int table_rows: 7
    property int table_columns: 7
    property alias chart: chart
    state: "Таблица"
    Settings {
        category: "Graduator"
        property alias maxrow: tbl.maxrow
        property alias dataset: gr.dataset
        property alias table_rows: gr.table_rows
        property alias table_columns: gr.table_columns
    }
    Rectangle {
        anchors.margins: 5
        anchors.fill: parent
        color: "black"
        border.color: "lightgray"
        border.width: 2
        radius: 5

        Text {
            id: tt
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
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: tt.bottom
            anchors.margins: 10
            spacing: 30
            MyMenuItem {
                width: 200
                height: 40
                text: "Записать таблицу"
                command: "SAVE"
                onButtonClicked: {
                    table_columns=tbl.colnumber
                    table_rows=tbl.rownumber
                    dataset=tbl.getdata()
                }
            }
            MyMenuItem {
                width: 200
                height: 40
                text: "Таблица/График"
                command: "ПЕРЕКЛ"
                onButtonClicked: {
                   gr.state=gr.state==="Таблица"?"График":"Таблица"
                }
            }
            MyMenuItem {
                width: 200
                height: 40
                text: "Закрыть"
                command: "ЗАКРЫТЬ"
                onButtonClicked: {
                   mainrect.state="MAIN"
                }
            }
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
                    addcolumn();
                }
                //Расставляем данные
                //print(dataset)
                var str=dataset
                //print(str)
                var s0=0

                var s=str.indexOf("\r",0)
                i=0; var j=0
                while (s>0) {
                    var sbstr=str.substring(0,s)
                    str=str.substring(s+1,str.length)
//                    print("i="+i)
                    s=str.indexOf("\r",0)
                    var sl=sbstr.split(";");  //print("sl="+sl)
                        setcell(i,1,sl[0].trim());
                        setcell(i,2,sl[1]);
                        setcell(i,3,sl[2].trim());
                        setcell(i,6,sl[5].trim());

                    i++
                }
//                print("01234567890123456789012345678901234567890")
//                print(dataset)
//                print(s);
                //setcell(2,2,10)
                //setcell(2,6,"1/2/3/4/5/6/7/8")
            }
            rad: m.pulley
            imp_d: m.impeller_d
            imp_h: m.impeller_h
            imp: m.impeller
        }
        MyChartGrad {
            id: chart
            height:400
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
        }
    }
    states: [
        State {
            name: "Таблица"
            PropertyChanges { target: tbl; visible: true; }
             PropertyChanges { target: chart; visible: false; }
        },
        State {
            name: "График"
            PropertyChanges { target: tbl; visible: false; }
             PropertyChanges { target: chart; visible: true; }
        }
    ]

}
