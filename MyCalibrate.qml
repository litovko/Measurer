import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    id: cl
    property string command: "CALIBRATE START"
    signal buttonClicked
    Rectangle {
        id: r
        color: "black"
        border.color: "yellow"
        border.width: 3
        radius: 20
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#000000";
            }
            GradientStop {
                position: 1.00;
                color: "#666666";
            }
        }
        anchors.fill: parent
        opacity: 0.8

        Column {
            anchors.centerIn: parent
            anchors.margins: 30
            spacing: 5


           Text {
               anchors.horizontalCenter: parent.horizontalCenter
               color: "yellow"
               font.bold: true
               horizontalAlignment: Text.AlignHCenter
               font.pointSize: 10
               text: "КАЛИБРОВКА НУЛЯ"
           }
           Text {
               anchors.horizontalCenter: parent.horizontalCenter
               color: "yellow"
               font.bold: true
               horizontalAlignment: Text.AlignHCenter
               font.pointSize: 10
               text:  qsTr("Для калибровки необходимо снять нагрузку\n с датчика силы. "+
                           "\nПрибор должен находится на твердой поверхности.\n Необходимо исключить или уменьшить вибрацию.\n"
                           +"Для завершения калибровки\n нажмите кнопку 'КАЛИБРОВКА'")
           }
           Button {
               id: button
               anchors.horizontalCenter: parent.horizontalCenter
               width: 90
               height: 30
               text: qsTr("КАЛИБРОВКА")
               onClicked: {cl.buttonClicked()}
           }
        }


//           TextArea {
//               id: textArea
//               width: r.width-5
//               height: 30
//               text:


    }

}
