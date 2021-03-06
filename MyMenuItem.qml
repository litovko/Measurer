import QtQuick 2.5
import QtMultimedia 5.5
Item {
    id: menuitem
    property string text: "Item1"
    property string command: "Command"
    property bool pressed: false
    property real fontsize: 10
    property alias muted: effect.muted
    signal buttonClicked
    SoundEffect {
        id:effect
        source: "/sound/menuitemhover.wav"
    }

    Rectangle {
        id: body
        visible: true
        z:1
        anchors.fill: parent
        color: "#030c53"

        radius: 6
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#050505";
            }
            GradientStop {
                position: 0.50;
                color: "#aaaaaa";
            }
            GradientStop {
                position: 1.00;
                color: "#050505";
            }
        }
        opacity: ma.pressedButtons& Qt.LeftButton ? 0.4:0.7
        border.color: ma.containsMouse?"yellow":"#666666"
        border.width: ma.containsMouse?1:4
        Text {
            id: ttt
            color: ma.containsMouse?"yellow":"white"
            text: menuitem.text
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: ma.containsMouse?fontsize*1.2:fontsize
            anchors.centerIn: parent
        }

        MouseArea {
            id: ma
            z:3
            anchors.fill: body
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton


            onPressed: {
                menuitem.pressed=true; menuitem.buttonClicked();
//                console.log("onPressed->onButtonClicked")
            }
            onReleased: menuitem.pressed=false
            onContainsMouseChanged: if(containsMouse)effect.play()
        }
    }

}
