import QtQuick 2.0

Item {
    id: hh
    property real h: 30
    property string text1: "Отсчеты по датчику, ед."
    property string text2: "Порядковый номер наблюдений"
    property int count: 0

    function addcolumn() { //создаем объект заголовка
        print("header data column add->"+(count+1))
        var newObject = Qt.createQmlObject(
                'MyHeaderItem{
                text: "'+(r.children.length+1)+'"
                width: hh.width/r.children.length
                height: 20}',r, "dynamicColumn");
    }
    function delcolumn(num) {
      print("del->"+num);
      r.children[num].destroy();
      for(var i=0;i<r.children.length;i++) r.children[i].text=i;
    }
    Column {
        anchors.fill: parent
        spacing: 0
        Rectangle {
            width: hh.width
            height: h
            color: "transparent"
            MyHeaderItem{
                text: text1
                anchors.fill: parent
            }
        }
        Rectangle {
            width: hh.width
            height: h
            color: "transparent"
            MyHeaderItem{
                text: text2
                anchors.fill: parent
            }
        }

        Rectangle {
            width: hh.width
            height: h
            color: "transparent"
            Row {
                id: r
                onChildrenChanged: {count=r.children.length;}
                Component.onCompleted: {count=r.children.length;}
            }
        }
    }

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
