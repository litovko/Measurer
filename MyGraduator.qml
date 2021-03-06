import QtQuick 2.0
import "./table"
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

//import QtQuick.Controls 2.0
Item {
    id: gr

    property alias maxrow : tbl.maxrow
    property string dataset: ""
    property string dataset_error: ""
    property int table_rows: 0
    property int table_columns: 0
    property alias chart: chart
    property real student: 1
    state: "Таблица"

    function filltable(str)
    {
        //var str=dataset
        table_rows=tbl.children.length;
        if (table_rows>0) {
            print("check delay")
            if (!timer.running)timer.start()
            return;
        }
        //var s0=0
        var s=str.indexOf("\r",0)
        var i=0; var j=0
        while (s>0) {
            print("filltable-table_rows:"+table_rows)
            if (i > table_rows-1) tbl.addrow();
            var sbstr=str.substring(0,s)
            str=str.substring(s+1,str.length)
            print("str:"+sbstr)
            s=str.indexOf("\r",0);
            var sl=sbstr.split(";");  //print("sl="+sl)
                tbl.setcell(i,1,sl[0].trim());
                tbl.setcell(i,2,sl[1].trim());
                tbl.setcell(i,3,sl[2].trim());
                tbl.setcell(i,6,sl[5].trim());
            i++
        }
        gr.dataset=tbl.getdata();


    }
    Timer {
        id: timer
        interval: 500
        onTriggered: filltable(gr.dataset)
    }

    Settings {
        category: "Graduator"
        property alias maxrow: tbl.maxrow
        property alias dataset: gr.dataset
        property alias table_rows: gr.table_rows
        property alias table_columns: gr.table_columns
        property alias student: gr.student
    }


    FileDialog {
        id: fileDialog
        title: "Укажите имя файла данных таблицы"
        //folder: shortcuts.home
        selectExisting: false
        selectMultiple: false
        nameFilters: [ "Файлы данных(*.csv *.txt)", "Все файлы(*)" ]
        onAccepted: {
            m.filename=fileDialog.fileUrl;
            if(selectExisting) { //  загружаем данные из файла
                tbl.cleartable();
                gr.dataset=m.readfile();
                print("gr.dataset"+gr.dataset);
                filltable(gr.dataset);
                state="Таблица"
            }
            else  m.writefile();
            fileDialog.visible=false;
        }
        onRejected: {
            console.log("Canceled")
            fileDialog.visible=false;
        }

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
            id: firstrow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: tt.bottom
            anchors.margins: 10
            spacing: 30
            MyMenuItem {
                width: 150
                height: 40
                text: "Записать таблицу"
                command: "SAVE"
                onButtonClicked: {
                    table_columns=tbl.colnumber
                    table_rows=tbl.rownumber
                    dataset=tbl.getdata()
                    fileDialog.selectExisting = false
                    fileDialog.visible=true;
                    //gr.state="Загрузить"
                }
                muted: !settings.sound
            }
            MyMenuItem {
                width: 160
                height: 40
                text: "Загрузить таблицу"
                command: "READ"
                onButtonClicked: {
                    fileDialog.selectExisting = true
                    fileDialog.visible=true;
                    //gr.state="Загрузить"
                }
                muted: !settings.sound
            }
            MyMenuItem {
                width: 160
                height: 40
                text: "Таблица/График"
                command: "ПЕРЕКЛ"
                onButtonClicked: {
                   gr.state=gr.state==="Таблица"?"График":"Таблица" 
                }
                muted: !settings.sound
            }


            MyMenuItem {
                width: 160
                height: 40
                text: "Закрыть"
                command: "ЗАКРЫТЬ"
                onButtonClicked: {
                   mainrect.state="MAIN"
                }
                muted: !settings.sound
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: firstrow.bottom
            anchors.margins: 10
            spacing: 30
            MyMenuItem {
                width: 160
                height: 40
                text: "Погр./Дел."
                command: "ПЕРЕКЛ"
                onButtonClicked: {
                   gr.state="Погрешность"
                }
                muted: !settings.sound
            }
            MyMenuItem {
                width: 160
                height: 40
                text: "Отчет"
                command: "ОТЧЕТ"
                onButtonClicked: {
                   chart.pr("filename.png")
                   tbl_error.dataset=tbl.getdata()

                   gr.dataset_error=tbl_error.getdata();
                   print ("TABLE_ERROR_DATA:"+gr.dataset_error);
                   m.tabledataerror=gr.dataset_error;
                   m.values="Среднеарифметическая величина абсолютной погрешности, ед.:  "+tbl_error.sr_abs.toFixed(2)
                   m.values=m.values+ "\nСреднеарифметическая величина относительной погрешности, %:  "+tbl_error.sr_otn.toFixed(2)
                   m.values=m.values+ "\nСреднеарифметическая величина приведенной погрешности, %:  "+tbl_error.sr_priv.toFixed(2)
                   m.parameters=gr.table_rows+";"+gr.student+";"+tbl_error.k_b.toFixed(3)+";"+ tbl_error.k_bb.toFixed(3)
                   m.makeDoc()
                }
                muted: !settings.sound
            }MyMenuItem {
                width: 160
                height: 40
                text: "к-т Стьюдента"
                command: "СТЬЮДЕНТ"
                onButtonClicked: {
                   gr.state="Стьюдент"
                }
                muted: !settings.sound
            }
        }
        MyTable{
            id: tbl
            height:500
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            Component.onCompleted: {
//                for(var i=0;i<table_rows; i++) {
//                    addrow();
//                }
                for( var i=0;i<table_columns; i++) {
                    addcolumn();
                }
                //Расставляем данные
                table_rows=0;
                filltable(dataset)
            }
            rad: m.pulley
            imp_d: m.impeller_d
            imp_h: m.impeller_h
            imp: m.impeller
        }
        MyChartGrad {
            id: chart
            height:500
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
        }
        MyTable_error{
            id: tbl_error
            height:500
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            k_stud: gr.student
        }
    }


    MyStudentDialog {
        id: student
        visible: false
        anchors.centerIn: parent
        onBtnOK:  {gr.state="Таблица"; gr.student=input_value}
        onBtnCancel: gr.state="Таблица"
        input_value: gr.student
        num_rows: tbl.rownumber
    }


    states: [
        State {
            name: "Таблица"
            PropertyChanges { target: tbl; visible: true; }
            PropertyChanges { target: chart; visible: false; }
            PropertyChanges { target: tbl_error; visible: false; }
            PropertyChanges { target: student; visible: false}
        },
        State {
            name: "График"
            PropertyChanges { target: tbl; visible: false; }
            PropertyChanges { target: chart; visible: true; }
            PropertyChanges { target: tbl_error; visible: false; }
            PropertyChanges { target: student; visible: false}
        },
        State {
            name: "Погрешность"
            PropertyChanges { target: tbl; visible: false; }
            PropertyChanges { target: chart; visible: false; }
            PropertyChanges { target: tbl_error; visible: true; }
            PropertyChanges { target: tbl_error; dataset: tbl.getdata()}
            PropertyChanges { target: student; visible: false}
        },
        State {
            name: "Деления"
            PropertyChanges { target: tbl; visible: false; }
            PropertyChanges { target: chart; visible: false; }
            PropertyChanges { target: tbl_error; visible: false; }
            PropertyChanges { target: tbl_error; dataset: tbl.getdata()}
            PropertyChanges { target: student; visible: false}
        },
        State {
            name: "Стьюдент"
            PropertyChanges { target: tbl; visible: false; }
            PropertyChanges { target: chart; visible: false; }
            PropertyChanges { target: tbl_error; visible: false; }
            PropertyChanges { target: student; visible: true}
        }
    ]

}
