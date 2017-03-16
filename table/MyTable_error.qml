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
    property real prived_error: 1
    property real sr_abs: 0
    property real sr_otn: 0
    property real sr_priv: 0
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
                prived_error: mte.prived_error
            }',datarows, "dynamicRow");

        for (var i=0;i<colnumber; i++) newObject.addcolumn()
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
    function getcell(i,j){
        return datarows.children[i].datalinerow.children[j].getdata()
    }
    function cleartable() {
        for(var i=rownumber;i>0; i--) datarows.children[i-1].destroy();
    }
    function round10(a,b){
        return Math.round(Math.abs(a)*b)/b
    }

    function  recalc(d, sr) {
        var sl=d.split("/");
        var s=""
        for (var i=0; i<sl.length;i++ ){
            s=s+round10((sl[i]-sr),100)+"/"
        }

        return s.substring(0,s.length-1)
    }

    function calculate(str) {
        var s=str.indexOf("\r",0)
        var i=0; var j=0;
        sr_abs=0; sr_otn=0; sr_priv=0
        while (s>0) {
            if (i > (rownumber-1)) { addrow()}
            var sbstr=str.substring(0,s)
            str=str.substring(s+1,str.length)
            s=str.indexOf("\r",0);
            var sl=sbstr.split(";");
            setcell(i,0,sl[0].trim());
            setcell(i,1,sl[4].trim());
            setcell(i,2,sl[6].trim());
            setcell(i,3,recalc(sl[5].trim(),sl[6]));
            sr_abs+=getcell(i,5)*1.0;
            sr_otn+=getcell(i,6)*1.0;
            sr_priv+=getcell(i,7)*1.0;
            i++
        }
        sr_abs/=i
        sr_otn/=i
        sr_priv/=i
    }
    onDatasetChanged:  {
        prived_error=tbl.get_prived_error();
        cleartable()
        calculate(dataset)
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
            MyLongHeader {
                id: lhe
                width: 300
                height: 80
                text1: "Отклонение от среднего"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Сумма откло-</p><p>нений</p><p>ед</p><p></p>"
            }
            MyHeaderItem {
                id: a
                width: 90
                height: 80
                text: "<p>Абсолютная</p><p>погр-ть</p><p>ед</p><p></p>"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Относи-</p><p>тельная</p><p>погр-ть</p><p>%</p>"
            }
            MyHeaderItem {
                width: 90
                height: 80
                text: "<p>Приве-</p><p>денная</p><p>погр-ть</p><p>%</p>"
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
        Row {
            x: a.x+5
            anchors.margins: 5
            anchors.top: datarows.bottom
            height: 30
            MyCellInt {
                width: 90
                celltype: 0
                celldata: sr_abs
                height: parent.height
            }
            MyCellInt {
                width: 90
                celltype: 0
                celldata: sr_otn
                height: parent.height
            }
            MyCellInt {
                width: 90
                celltype: 0
                celldata: sr_priv
                height: parent.height
            }
        }

    }

}
