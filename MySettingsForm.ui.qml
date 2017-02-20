import QtQuick 2.4
import QtQuick.Controls 2.0

Item {
    width: 400
    height: 400
    property alias textField: textField
    property alias frame: frame
    property alias buttonCANCEL: buttonCANCEL
    property alias comboBox: comboBox
    property alias buttonOK: buttonOK

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

        Frame {
            id: frame
            x: 34
            y: 49
            width: 334
            height: 287
            anchors.right: parent.right
            anchors.rightMargin: 33

            Label {
                id: label1
                y: 4
                width: 151
                height: 27
                color: "#e0e0e0"
                text: qsTr("Коммуникационный порт")
                anchors.left: parent.left
                anchors.leftMargin: 0
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 10
            }

            ComboBox {
                id: comboBox
                x: 160
                y: -2
                width: 137
                height: 40
                anchors.right: parent.right
                anchors.rightMargin: 0
            }

            TextField {
                id: textField
                x: 160
                y: 57
                width: 150
                height: 40
                text: m.pulley
                renderType: Text.QtRendering
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 12
                anchors.right: parent.right
                anchors.rightMargin: 0
            }

            Label {
                id: label2
                x: -4
                y: 63
                width: 154
                height: 27
                color: "#e0e0e0"
                text: qsTr("Радиус шкива х0.1мм")
                anchors.leftMargin: 0
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
            }
        }
    }

    Connections {
        target: buttonOK
        onClicked: visible = false
    }
}
