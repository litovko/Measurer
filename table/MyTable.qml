import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../"

Item {
    id: mt
    property int colnumber: 0
    property int rownumber: 0
    property alias children: datarows.children
    property real rad: 0
    property real imp_h: 0
    property real imp_d: 0
    property real imp: 1
    function addcolumn(){ //добавляем одну колонку во все строки в хэдер
        if (!rownumber) return;
        for(var i=0; i<datarows.children.length;i++) {
            datarows.children[i].addcolumn();
        }
        lh.addcolumn();
        colnumber+=1
    }
    function delcolumn(num){
        for(var i=0; i<datarows.children.length;i++) {
            datarows.children[i].delcolumn(num);
        }
        lh.delcolumn(num);
        colnumber-=1
    }
    function addrow(){
        var newObject = Qt.createQmlObject(
            'MyCellLine {
                width: header.width
                height: 40
                radius_R: mt.rad
                imp: mt.imp
                imp_h: mt.imp_h
                imp_d: mt.imp_d
            }',datarows, "dynamicRow");
        newObject.number=rownumber
//        rownumber+=1
        for (var i=0;i<colnumber; i++) newObject.addcolumn()
    }
    function delrow(num){
        datarows.children[num].destroy()
    }
    function getrow(num) {
        return datarows.children[num]
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        anchors.margins: 5
        border.color: "gray"
        border.width: 1
        color: "transparent"

        Row { // заголовок таблицы
            id: header
            anchors.margins: 5
            anchors.left: parent.left
            anchors.top: parent.top

            Rectangle {
                width: 90
                height: 80
                color: "transparent"
                border.color: "transparent"
                MyMenuItem{
                  anchors.fill: parent
                  anchors.margins: 6

                  text: "Добавить"
                  onButtonClicked: addrow()
                }
            }

            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Порядковый</p><p>№</p><p>измерений</p><p></p>"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>№</p><p>гирь</p><p></p><p></p>"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Вес гирь</p><p>на площадке</p><p>P, гс</p><p></p>"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Вр.момент</p><p>М=R*P,</p><p>гс*см</p><p></p>"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Сопр.вращ.</p><p>срезу</p><p>гс/см/см</p><p></p>"
            }
            MyLongHeader {
                id: lh
                width: 300
                height: 80
                text1: "Отсчеты по индикатору ("+count+" шт.)"
                onCountChanged: {
                    print("count changed="+count)
                }
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Среднее</p><p>арифм.</p><p>значение</p><p>ед.</p>"
            }
        } //конец заголовка
        Column {
            id: datarows
            anchors.leftMargin:  5
            anchors.left: parent.left
            anchors.top: header.bottom
            anchors.right: parent.right
            onChildrenChanged: mt.rownumber=children.length
        }
    }

}
