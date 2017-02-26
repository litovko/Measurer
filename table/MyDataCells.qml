import QtQuick 2.0

Item {
    id: d
    property int count:0
    signal changed
    function addcolumn(dat) {
        var newObject = Qt.createQmlObject(
            'MyCellInt {
                celldate: "'+dat+'"
                celltype: -1
                width: d.width/dataset.children.length
                height: dataline.height
                onChanged: d.changed()
            }',dataset, "dynamicDataCell");
    }
    function delcolumn(num) {
      dataset.children[num].destroy();
    }
    function average() {
        var  s=0.0
        for(var i=0;i<dataset.children.length;i++) {
            s+=dataset.children[i].celldate*1.0;
            print("i="+i+" v="+dataset.children[i].celldate+" s="+s)
        }
        return s/dataset.children.length
    }

    onCountChanged: {
        print("Data cell count changed="+count)
        for(var i=0;i<dataset.children.length;i++) print("i:"+i+"="+dataset.children[i].celldate);
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
