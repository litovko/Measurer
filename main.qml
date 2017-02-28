import QtQuick 2.7
import QtQuick.Controls 2.0
import Gyco 1.0
import "./table"
import Qt.labs.settings 1.0


//import QtQuick.Layouts 1.0

// Текущее значение веса
// Текущая позиция вращающегося стола в градусах
// Порт
// Статус соединения
// График текущих значений

// Окно параметров
// - смещение нуля
// - масштабирующий коэффициент
// - коэффициент погрешности
// - радиус ролика
// - вес груза
// - значение, соответствующее весу груза
// - диаметр крыльчатки
// - высота крыльчатки
// - постоянная крыльчатки - вычисляемое значение

// График измерения усилия по результатам калибровки
// График тау по результатам калибровки

// Окончательный график по итогам измерения


ApplicationWindow {
    id: win
    visible: true
    width: 1024
    height: 768
    title: qsTr("Измеритель")

    property int table_rows: 7
    property int table_columns: 7
    Settings {
            //category: "PPMainWindow"
            property alias x: win.x
            property alias y: win.y
            property alias width: win.width
            property alias height: win.height
    }
    Settings {
            //category: "PPTable"
            property alias table_rows: win.table_rows
            property alias table_columns: win.table_columns
    }
    function fcommand (cmd) {
        console.log ("COMMAND="+cmd)
        switch(cmd) {
          case "QUIT":
              Qt.quit();
              break;
          case "CALIBRATE":
              //m.calibrate(33.9);
              calibrate.visible = true;
              break;
          case "CALIBRATE START":
              //m.calibrate(33.9);
              busyIndicator.visible=true;
              calibrate.visible = false;
              m.tare(50);
              break;
          case "CALIBRATE STOP":
              //m.calibrate(33.9);
              busyIndicator.visible=false;
              break;
          case "TARE10":
              m.tare(25);
              break;
          case "RESET":
              m.reset();
              break;
          case "SETTINGS":
              settings.visible=true;
              break;
          case "START":
              //m.start();
              break;
          case "TABLE":
              tbl.visible=!tbl.visible
              break;
          case "MENU":

              break;
          case "FULLSCREEN":
              win.visibility = win.visibility===ApplicationWindow.FullScreen?ApplicationWindow.Maximized:ApplicationWindow.FullScreen;
              break;
        }

    }
    function porterror(err){
        switch (err){
            case 0: return "";
            case 99: return "ошибка записи в порт";
            case 11: return "неизвестная ошибка";
            case 12: return "ошибка по таймауту";
            case 10: return "запрещенная операция";
            case 9: return "неожиданное извлечение";
            case 8: return "ошибка чтения";
            case 7: return "ошибка записи";
            case 6: return "break condition detected";
            case 5: return "framing error";
            case 4: return "ошибка четности";
            case 3: return "ошибка открытия порта";
            case 2: return "ошибка доступа к порту";
            case 1: return "порт не найден";
        }
    }

    Rectangle{
        color: "#000000"
        border.color: "yellow"
        border.width: 3
        radius: 10
        anchors.fill: parent
        focus: true
        state: "MAIN"
        states: [
            State {
                name: "MAIN"
                //PropertyChanges { target: tbl; visible: false; }
                PropertyChanges { target: settings; visible: false; }
            },
            State {
                name: "GRAD"
                PropertyChanges { target: grad; visible: true;}
                PropertyChanges { target: settings; visible: false; }
            }
        ]
        Keys.onPressed: {
            console.log("KEY:"+event.key)
            if (event.key === Qt.Key_F1 || event.key === Qt.Key_1) win.fcommand("HELP")
            if (event.key === Qt.Key_F2 || event.key === Qt.Key_2) win.fcommand("START")
            if (event.key === Qt.Key_F5||event.key ===  Qt.Key_5)     win.fcommand("CALIBRATE")
            if (event.key === Qt.Key_F6||event.key ===  Qt.Key_6)     win.fcommand("TABLE")
            if (event.key === Qt.Key_F9||event.key ===  Qt.Key_9)     win.fcommand("TARE10")
            if (event.key === Qt.Key_F10||event.key === Qt.Key_0)     win.fcommand("QUIT")
            if (event.key === Qt.Key_F11)     win.fcommand("RESET")

            if (event.key === Qt.Key_F12||event.key === Qt.Key_Equal) win.fcommand("FULLSCREEN")
        }
        BusyIndicator {
            id: busyIndicator
            padding: 6
            anchors.centerIn: parent
            visible: false
        }
        Row {
            id: r
            anchors.margins: 10
            anchors.left: parent.left
            anchors.top: parent.top
            spacing: 20
            readonly  property int wo: 160
            MyMenuItem{
                width: r.wo
                height: 40
                text: "СТАРТ [F2]"
                command: "START"
                onButtonClicked: win.fcommand(command)
            }
            MyMenuItem{
                width: r.wo
                height: 40
                text: "КАЛИБРОВКА '0'[F5]"
                command: "CALIBRATE"
                onButtonClicked: win.fcommand(command)
            }
            MyMenuItem{
                width: r.wo
                height: 40
                text: "ГРАДУИР.[F6]"
                command: "TABLE"
                onButtonClicked: win.fcommand(command)
            }
            MyMenuItem{
                width: r.wo
                height: 40
                text: "НАСТРОЙКА [F8]"
                command: "SETTINGS"
                onButtonClicked: win.fcommand(command)
            }
        }
        Column {
            id: c
            anchors.margins: 10
            anchors.left: parent.left
            anchors.top: r.bottom
            MyDigital {
                name: "Сила :"
                value: m.weight
                width: 280
                height: 40
            }
            MyDigital {
                name: "Средн:"
                value: m.average
                width: 280
                height: 40
            }

            MyDigital {
                name: "Смещ.:"
                value: m.tare0
                width: 280
                height: 40
            }
            MyDigital {
                name: "Рад. :"
                value: m.pulley*1000
                width: 280
                height: 40
            }
            MyDigital {
                name: "Угол :"
                value: m.rotor*1000
                width: 280
                height: 40
            }
            MyDigital {
                name: "Пост. К :"
                value: m.impeller*1000
                width: 280
                height: 40
            }
        }

        Measurer {
            id: m
            Component.onCompleted:{
                //m.listPorts();
                console.debug(m.ports);
                //m.openSerialPort(0);
            }
            onPulleyChanged: console.log("pulley radius chaged:"+m.pulley)
            series:  mc.ser
            onStopTare: win.fcommand("CALIBRATE STOP")

        }

        MyStatus {
            id: status

            //status_text:  m.name +':'+m.isOpen?'ОТКРЫТ ':'ЗАКРЫТ '+ porterror(m.error)+''
            status_text: m.name+':'+ porterror(m.error)+''
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            height: 40
            lamp: m.isOpen
        }

        MChart {
            id: mc
            height: 300
            width: 300
            anchors.right:  parent.right
            anchors.top: parent.top

        }

        MyCalibrate {
            id: calibrate
            visible: false
            height: 200
            width: 500
            anchors.centerIn: parent
            onButtonClicked: win.fcommand(command)
        }

        MySettingsForm {
            id: settings
            visible: false
            onVisibleChanged: {

                 if (visible) {
                     comboBox.currentIndex= m.ports.indexOf(m.name)>=0?m.ports.indexOf(m.name):0
                     m.listPorts(); // обновляем список доступных ком-портов и устанавливаем индекс по текущему порту
                 }
            }
            anchors.centerIn: parent
            comboBox.model: m.ports //список доступных ком-портов
            buttonCANCEL.onClicked: {
                visible=false;
            }
            buttonOK.onClicked: {
                visible=false;
                print ("locacl="+Qt.locale())
                m.openSerialPort(comboBox.currentIndex);
                m.pulley=textField.text;
                m.impeller_h=textField_h.text
                m.impeller_d=textField_d.text
            }
            RegExpValidator{
                id: num_validator
                regExp: /(?:\d*\.)?\d+/
            }
            textField.validator: num_validator//DoubleValidator{bottom: 1; top: 10; decimals: 1}
            textField_h.validator:  textField.validator
            textField_d.validator:  textField.validator
            textField.color: "lightgray"
            textField_h.color: "lightgray"
            textField_d.color: "lightgray"
        }
        MyGraduator {
            id: grad
            height: 600
            width: 1000
            anchors.centerIn: parent
        }
    }
}
