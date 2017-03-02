import QtQuick 2.7
import QtCharts 2.0

Item {
    id: chart
    property string seriesName: "Усилие, ед."
    property string chartName: "График зависимости показаний датчика от массы грузов"
    property alias series: ls
    property real maxY: 10
    function addpoint(p) {
        ls.append(p)
    }
    Rectangle {
        border.color: "gray"
        radius:  20
        color: "transparent"
        anchors.margins: 5
        anchors.fill: parent
        ChartView {
            title: chartName
            anchors.fill: parent
            antialiasing: true
            backgroundColor:  "black"
            plotAreaColor: "black"
            titleColor: "yellow"
            LineSeries {
                id: ls
                name: seriesName
                style: Qt.DotLine
                capStyle: Qt.RoundCap
                color: "green"
                width: 2
                pointLabelsVisible: true
                pointsVisible: true
                pointLabelsColor: "yellow"
                ValueAxis {
                        id: axisX
                        min: 0
                        max: 500
                        tickCount: 21
                        gridVisible: true
                        color: "white"
                        labelsVisible: true
                        minorGridVisible: false
                    }
                ValueAxis {
                      id: axisY
                      min: 0
                      max: chart.maxY
                      tickCount: 11
                      gridVisible: true
                      labelsColor: "white"
                      color: "white"
                      labelsVisible: true
                  }
                axisX: axisX
                axisY: axisY
            }
        }
    }
}
