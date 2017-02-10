import QtQuick 2.7
import QtQuick.Controls 2.0
import Gyco 1.0
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

// График измерения усилия по результатам калибровки
// График тау по результатам калибровки

// Окончательный график по итогам измерения


ApplicationWindow {
    id: win
    visible: true
    width: 1024
    height: 768
    title: qsTr("Измеритель")
//    background: Rectangle{
//        color: "#000000"
//        border.color: "#fbf837"
//        anchors.fill: parent;



//    }

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
          case "START":
              //m.start();
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
        Keys.onPressed: {
            console.log("KEY:"+event.key)
            if (event.key === Qt.Key_F1 || event.key === Qt.Key_1) win.fcommand("HELP")
            if (event.key === Qt.Key_F2 || event.key === Qt.Key_2) win.fcommand("START")
            if (event.key === Qt.Key_F5||event.key ===  Qt.Key_5)     win.fcommand("CALIBRATE")
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
                text: "КАЛИБРОВКА [F5]"
                command: "CALIBRATE"
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
        }

        Measurer {
            id: m
            Component.onCompleted:{
                m.listPorts();
                console.debug(m.ports);
                m.openSerialPort(0);


            }
            onPulleyChanged: console.log("pulley radius chaged:"+m.pulley)
            series:  mc.ser
            onStopTare: win.fcommand("CALIBRATE STOP")

        }

        MyStatus {
            id: status

            status_text:  m.name+':'+ porterror(m.error)+''
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            height: 40
        }

        MChart {
            id: mc
            height: 300
            width: 300
            anchors.right:  parent.right
            anchors.bottom: status.top
            //Component.onCompleted: {m.fill()
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
            anchors.centerIn: parent
        }
    }
}
