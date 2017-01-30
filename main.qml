import QtQuick 2.7
import QtQuick.Controls 2.0
import Gyco 1.0
//import QtQuick.Layouts 1.0

ApplicationWindow {
    id: win
    visible: true
    width: 640
    height: 480
    title: qsTr("Измеритель")

    function fcommand (cmd) {
        console.log ("COMMAND="+cmd)
        switch(cmd) {
          case "QUIT":
              Qt.quit();
              break;
          case "CALIBRATE":
              m.calibrate(33.9);
              break;
          case "TARE10":
              m.tare(25);
              break;
          case "RESET":
              m.reset();
              break;
          case "HELP":

              break;

          case "MENU":

              break;
          case "FULLSCREEN":
              win.visibility = win.visibility===ApplicationWindow.FullScreen?ApplicationWindow.Maximized:ApplicationWindow.FullScreen;
              break;
        }

    }
    Rectangle{
        color: "#f9f8ba"
        border.color: "#030564"
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            console.log("KEY:"+event.key)
            if (event.key === Qt.Key_F1 || event.key === Qt.Key_1) win.fcommand("HELP")
            if (event.key === Qt.Key_F8||event.key ===  Qt.Key_8)     win.fcommand("CALIBRATE")
            if (event.key === Qt.Key_F9||event.key ===  Qt.Key_9)     win.fcommand("TARE10")
            if (event.key === Qt.Key_F10||event.key === Qt.Key_0)     win.fcommand("QUIT")
            if (event.key === Qt.Key_F11)     win.fcommand("RESET")

            if (event.key === Qt.Key_F12||event.key === Qt.Key_Equal) win.fcommand("FULLSCREEN")
        }

        Measurer {
            id: m
            Component.onCompleted:{
                m.listPorts();
                console.debug(m.ports);
                m.openSerialPort(1);
                m.tare(100);
            }
        }
        Text {
            id: txt
            x: 90
            y: 154
            text: qsTr(m.name+" \r\n"+"\n\r  e="+m.error)
        }

        ComboBox {
            id: portslist
            x: 90
            y: 79
        }

        Text {
            id: text1
            x: 205
            y: 154
            width: 77
            height: 22
            text: m.weight.toString()
            font.pixelSize: 12
        }
        Text {
            id: text2
            x: 205
            y: 184
            width: 77
            height: 22
            text: m.average.toString()
            font.pixelSize: 12
        }
    }
}
