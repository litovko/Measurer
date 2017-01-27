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
        Component.onCompleted: m.openSerialPort();
    }
    Text {
        id: txt
        text: qsTr(m.name+" \r\n"+m.data+"\n\r  e="+m.error)
    }
}
