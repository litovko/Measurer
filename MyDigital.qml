import QtQuick 2.0

Item {
    property real value: 0
    property string name: ":"
    Rectangle {
        //color: "transparent"
        anchors.fill: parent
        color: "#1f201f"
        border.color: "#666666"
        border.width: 4
        radius: 6
        Row {
            id: r
            anchors.margins: 5
            anchors.fill: parent
            Text {
               id:t2
               color: "yellow"
//               anchors.margins: 5
//               anchors.fill: parent
               text: name
               font.family: "SimSun-ExtB"
               font.bold: true
               font.pointSize: r.height-r.anchors.margins*2
               horizontalAlignment: Text.AlignHCenter
            }
            Text {
               id:t
               color: "yellow"

               text: (value).toFixed(2)
               font.family: "Arial"
               font.bold: true
               font.pointSize: r.height-r.anchors.margins*2
               horizontalAlignment: Text.AlignHCenter
            }

        }
    }

}
