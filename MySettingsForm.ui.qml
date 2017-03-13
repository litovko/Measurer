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
    property alias textField_h: textField_h
    property alias textField_d: textField_d
    property alias sound: checkBox1.checked

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
            x: 33
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
                width: 140
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
                text: qsTr("Радиус шкива, мм")
                anchors.leftMargin: 0
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
            }

            Label {
                id: label3
                x: 2
                y: 118
                width: 154
                height: 27
                color: "#e0e0e0"
                text: qsTr("Диаметр крыльчатки, мм")
                font.pointSize: 10
                anchors.left: parent.left
                anchors.leftMargin: 0
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            TextField {
                id: textField_d
                x: 174

                y: 112
                width: 140
                height: 41
                text: m.impeller_d
                bottomPadding: 0
                rightPadding: 0
                leftPadding: 0
                topPadding: 0
                anchors.right: parent.right
                font.pointSize: 12
                renderType: Text.QtRendering
                horizontalAlignment: Text.AlignHCenter
                anchors.rightMargin: 0
            }

            Label {
                id: label4
                x: 11
                y: 177
                width: 154
                height: 27
                color: "#e0e0e0"
                text: qsTr("Высота  крыльчатки, мм")
                font.pointSize: 10
                anchors.left: parent.left
                anchors.leftMargin: 0
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            TextField {
                id: textField_h
                x: 170
                y: 170
                width: 140
                height: 41
                text: m.impeller_h
                topPadding: 0
                rightPadding: 0
                anchors.right: parent.right
                font.pointSize: 12
                renderType: Text.QtRendering
                bottomPadding: 0
                leftPadding: 0
                anchors.rightMargin: 0
                horizontalAlignment: Text.AlignHCenter
            }

            CheckBox {
                id: checkBox1
                x: 170
                y: 223
                checked: false
            }

            Label {
                id: label5
                x: 1
                y: 230
                width: 154
                height: 27
                color: "#e0e0e0"
                text: qsTr("Звуки")
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: 0
                anchors.left: parent.left
                font.pointSize: 10
            }
        }
    }

    Connections {
        target: buttonOK
        onClicked: visible = false
    }
}
