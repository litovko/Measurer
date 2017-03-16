import QtQuick 2.0

Item {
    id: d
    property int count:0
    property real average: 0
    property string celldata: ""
    property real summa:0

    signal changed
    function addcolumn(dat) {
        var newObject = Qt.createQmlObject(
            'MyCellInt {
                celldata: "'+dat+'"
                celltype: 4
                width: d.width/dataset.children.length
                height: dataline.height
                fontsize: 8
                onChanged: d.changed()
            }',dataset, "dynamicDataCell");
    }
    function delcolumn(num) {
      dataset.children[num].destroy();
    }
    onChanged: {average=calc_average(); celldata=getdata()}
    function calc_average() {
        var  s=0.0
        for(var i=0;i<dataset.children.length;i++) {
            s+=dataset.children[i].celldata*1.0;
        }
        return (s/dataset.children.length).toFixed(2)
    }
    function getdata() {
        var s=""
        for (var i=0; i<dataset.children.length; i++)
          s=s+dataset.children[i].celldata+"/"

        return s.substring(0,s.length-1)
    }
    function setdata(d) {
        var s0=0
        var ds=d.split("/"); //print("ds:"+ds); //print("min:"+Math.min(dataset.children.length, ds.length))
        summa=0;
        for(var i=0; i<ds.length; i++) {
            if (dataset.children[i]===undefined) addcolumn(ds[i])
            else dataset.children[i].setdata(ds[i]);
            summa=summa+ds[i]*1.0;
        }
        changed()
        while (lhe.count<i) lhe.addcolumn()
        while (lhe.count>i) lhe.delcolumn()
    }
    Rectangle {
        anchors.fill: parent
        border.color: "lightblue"
        visible: !count
        color:"transparent"
    }

    Row {
        id: dataset
        anchors.fill: parent
        onChildrenChanged: {count=children.length;}
        Component.onCompleted: {count=children.length;}
    }

}
