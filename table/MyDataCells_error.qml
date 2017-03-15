import QtQuick 2.0

Item {
    id: d
    property int count:0
    property real average: 0
    property string celldata: ""
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
            //print("i="+i+" v="+dataset.children[i].celldata+" s="+s)
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
            print(" Setdata:"+d)
        var s0=0

        var ds=d.split("/"); //print("ds:"+ds); //print("min:"+Math.min(dataset.children.length, ds.length))

        for(var i=0; i<Math.min(dataset.children.length, ds.length); i++) {
            print (dataset.children[i]);
            dataset.children[i].setdata(ds[i]);
        }
        changed()
    }

//    onCountChanged: {
//        print("Data cell count changed="+count)
//        for(var i=0;i<dataset.children.length;i++) print("i:"+i+"="+dataset.children[i].celldata);
//    }
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
