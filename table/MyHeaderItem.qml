import QtQuick 2.0

Item {
    property alias text: t.text
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: "lightblue"
        Text {
            id: t
            anchors.fill: parent
            color: "lightgreen"
            font.bold: true
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 9

        }
    }
}
