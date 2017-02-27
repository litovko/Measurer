import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: c
    property string celldate: ""
    property int celltype : 0 //1-int 2-real -1 - c датчика 3 - 0 - вычисляемый
    signal changed
    onCelldateChanged: {
        if (celltype===0) console.log("C="+celldate+" "+t.text)
    }
    function bw() {if (celltype===0)return 1; return 3}
    Rectangle {
        id: r
        anchors.fill: parent
        color: "transparent"
        border.width: ma.containsMouse?bw():1
        border.color: "lightblue"
        Text {
            id: t
            anchors.fill: parent
            color: "#e7ee90"

            font.pointSize: 9
            text: c.celldate
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        TextField {
            id: f
            anchors.fill: parent
            anchors.margins: 5
            font.pixelSize: 14
            font.bold: true
            text: t.text
            onAccepted: { c.celldate=f.text; c.state="SHOW" }
            onFocusChanged: if(!focus) c.state="SHOW"
            validator: RegExpValidator{
                        regExp: /(?:\d*\.)?\d+/
                       }
            Component.onCompleted:  {
                if (celltype==1)
                    validator=Qt.createQmlObject(
                      'import QtQuick 2.0;IntValidator{bottom: 1; top: 5;}',f, "validator");
                if (celltype===-1)  validator=null;



            }

            horizontalAlignment: TextInput.AlignHCenter
            style: TextFieldStyle {
                      textColor: "white"

                      background: Rectangle {
                          radius: 1
                          implicitWidth: 100
                          implicitHeight: 24
                          border.color: "white"
                          border.width: 0
                          color: "black"
                      }
                  }
            opacity: 1

            visible: false
        }
        Keys.onPressed: {
                console.log("pressed:"+event.key+"  "+Qt.Key_Enter)
                if (event.key === Qt.Key_Escape) {
                    f.text=t.text;
                    c.state="SHOW"
                    event.accepted = true;
                }
            }
        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: if(c.celltype>0)c.state=c.state==="EDIT"?"SHOW":"EDIT"
                       else if(c.celltype<0) {t.text=c.celldate=m.weight; c.changed();}
        }

    }
    states: [
        State {
            name: "SHOW"
            PropertyChanges { target: r; color: "transparent"; }
            PropertyChanges { target: t; visible: true; }
            PropertyChanges { target: f; visible: false; }

        },
        State {
            name: "EDIT"
            PropertyChanges { target: r; color: "transparent"; }
            PropertyChanges { target: t; visible: false; }
            PropertyChanges { target: f; visible: true; focus:true }
        }
    ]
}
