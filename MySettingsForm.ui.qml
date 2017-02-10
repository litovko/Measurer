import QtQuick 2.4
import QtQuick.Controls 2.0

Item {
    width: 400
    height: 400
    property alias buttonOK: buttonOK
    property alias comboBox1: comboBox1

    Rectangle {
        id: rectangle1
        radius: 9
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        gradient: Gradient {
            GradientStop {
                position: 1
                color: "#666666"
            }

            GradientStop {
                position: 0
                color: "#000000"
            }
        }
        border.color: "#ffff00"
        border.width: 2
        anchors.fill: parent

        Text {
            id: text1
            x: 145
            y: 14
            color: "#ffff00"
            text: qsTr("Настройки")
            font.bold: true
            font.pixelSize: 20
        }

        Button {
            id: buttonOK
            x: 16
            y: 342
            width: 170
            height: 40
            text: qsTr("ОК")
            autoRepeat: false
            autoExclusive: false
            highlighted: false
        }

        Button {
            id: buttonCANCEL
            x: 220
            y: 342
            width: 163
            height: 40
            text: qsTr("Отмена")
        }

        ComboBox {
            id: comboBox1
            x: 225
            y: 55
            textRole: "Порт"
        }

        Label {
            id: label1
            x: 42
            y: 60
            width: 182
            height: 27
            color: "#e0e0e0"
            text: qsTr("Коммуникационный порт")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pointSize: 10
        }
    }
}
