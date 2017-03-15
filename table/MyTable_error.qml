import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../"

Item {
    id: mte
    property int colnumber: 0
    property int rownumber: 0

    property string dataset: ""
    property int maxrow: 7
    function addcolumn(){ //добавляем одну колонку во все строки в хэдер
        //if (!rownumber) return;
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
            'MyCellLine_error {
                width: header.width
                height: 40
            }',datarows, "dynamicRow");

        for (var i=0;i<colnumber; i++) newObject.addcolumn()
        //print(makedatastring())
    }
    function delrow(num){
        datarows.children[num].destroy()
    }
    function getrow(num) {
        return datarows.children[num]
    }
    function getdata() {
        var s=""
//        s="'Радиус крыльчатки':'"+rad+"';'Высота крыльчатки':'"+imp_h+"';'Диаметр крыльчатки':'"+imp_d+"';'Количество строк':'"+rownumber +"';'Количество колонок':'"+colnumber
//        s=s+"'\r"
        for (var i=0; i<datarows.children.length; i++)
        s=s+datarows.children[i].getdata()+"\n\r"
        return s
    }
    function setcell(i,j,val){
        datarows.children[i].datalinerow.children[j].setdata(val)
    }
    function cleartable() {
        for(var i=rownumber;i>0; i--) datarows.children[i-1].destroy();
    }
    function  recalc(d, sr) {
        var sl=d.split("/");
        var s=""
        for (var i=0; i<sl.length;i++ ){

            print (sl[i]);
            s=s+(sl[i]-sr)+"/"
        }
        return s
    }

    function calculate(str) {
        var s=str.indexOf("\r",0)
        var i=0; var j=0
        while (s>0) {
            print("rownumber:"+rownumber)
            if (i > rownumber-1) {addrow()}
            var sbstr=str.substring(0,s)
            str=str.substring(s+1,str.length)
            print("Fillstr:"+sbstr)
            s=str.indexOf("\r",0);
            var sl=sbstr.split(";");  //print("sl="+sl)
                setcell(i,0,sl[0].trim());
                setcell(i,1,sl[3].trim());
                setcell(i,2,sl[6].trim());
                setcell(i,3,recalc(sl[5].trim(),sl[6]));
//                tbl.setcell(i,3,sl[2].trim());
//                tbl.setcell(i,6,sl[5].trim());
            i++
        }
    }
    onDatasetChanged:  calculate(dataset)

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
//            Rectangle {
//                width: 90
//                height: 80
//                color: "transparent"
//                border.color: "transparent"
//                MyMenuItem{
//                  anchors.fill: parent
//                  anchors.margins: 6
//                  text: "Добавить"
//                  onButtonClicked: if(rownumber<maxrow) addrow()
//                }
//            }

            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Порядковый</p><p>№</p><p>измерений</p><p></p>"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Сопр.вращ.</p><p>срезу</p><p>гс/см/см</p><p></p>"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Средн. зна-</p><p>ченине</p><p>ед</p><p></p>"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Сумма откло-</p><p>нений</p><p>ед</p><p></p>"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Абсолютная</p><p>погр-ть</p><p>ед</p><p></p>"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Относи-</p><p>тельная</p><p>погр-ть</p><p>%</p>"
            }

        } //конец заголовка
        Column {
            id: datarows
            anchors.leftMargin:  5
            anchors.left: parent.left
            anchors.top: header.bottom
            anchors.right: parent.right
            onChildrenChanged: mte.rownumber=children.length
        }
    }

}
