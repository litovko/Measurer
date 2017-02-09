import QtQuick 2.0

Item {
    property real value: 0
    Rectangle {
        //color: "transparent"
        anchors.fill: parent
        color: "#1f201f"
        border.color: "#666666"
        border.width: 4
        radius: 6
        Text {
           id:t
           color: "yellow"
           anchors.margins: 5
           anchors.fill: parent
           text: (value/1000).toFixed(1)
           font.family: "SimSun-ExtB"
           font.bold: true
           font.pointSize: t.height-t.anchors.margins*2
           horizontalAlignment: Text.AlignHCenter
        }
    }

}
