import QtQuick 2.7
import QtQuick.Controls 2.0
import Gyco 1.0
//import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Измеритель")

    Measurer {
        id: m
        Component.onCompleted:{
            m.listPorts();
            console.debug(m.ports);
            m.openSerialPort(5);
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
        text: qsTr(m.data)
        font.pixelSize: 12
    }
}
