import QtQuick 2.4
import QtQuick.Controls 2.0
import "../js/statistics.js" as Statistics
Item {
    width: 400
    height: 400
    //property alias buttonCANCEL: buttonCANCEL
    //property alias buttonOk: buttonCANCEL
    property alias input_value: inp.text
    property int num_rows: 7

    signal btnOK
    signal btnCancel
    Rectangle {
        id: rectangle1
        radius: 9
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        gradient: Gradient {
            GradientStop {
                position: 0.997
                color: "#555555"
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
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:parent.top
            anchors.margins: 10
            color: "#ffff00"
            text: qsTr("Коэффициент Стьюдента")
            font.bold: true
            font.pixelSize: 20
        }
        Rectangle {
            id: ri
            width: 170
            height: 40
            color: "transparent"
            border.color: "yellow"
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 10
            anchors.top: text1.bottom
            TextInput {
                id: inp
                color: "yellow"
                width: parent.width
                height: parent.height
                font.pointSize: 14
                anchors.centerIn: parent
                validator: DoubleValidator{bottom: 1; top: 20; decimals: 3; locale: "us_US" }
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment:TextInput.AlignHCenter

            }
        }
        Text {
            id: text2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:ri.bottom
            anchors.margins: 10
            color: "#ffff00"
            text: qsTr("количество измерений: "+num_rows)
            font.bold: true
            font.pixelSize: 14
        }
        Button {
            id: buttonCalculate
            anchors.centerIn: parent
            width: 170
            height: 40
            text: qsTr("РАСЧИТАТЬ")
            autoRepeat: false
            autoExclusive: false
            highlighted: false
            onClicked: {  //alpha 0.95 K=i-2
                inp.text=Statistics.aStudentT(num_rows-2,0.1).toFixed(3)
            }
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
            onClicked:  {
                var s=inp.text;
                var i=s.indexOf(',');
                print (i+"="+s)

                if (i>=0) {print(".="+s[i]); s[i]=46}
                print (i+"="+s)
                inp.text=s
                btnOK()
            }
        }
        
        Button {
            id: buttonCANCEL
            x: 220
            y: 342
            width: 163
            height: 40
            text: qsTr("Отмена")
            onClicked: btnCancel()
        }
       }

}
