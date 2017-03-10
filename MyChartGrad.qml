import QtQuick 2.7
import QtCharts 2.0

Item {
    id: chart
    property string seriesName: "Усилие, ед."
    property string chartName: "График зависимости показаний датчика от массы грузов"
    property alias series: ls
    property alias lineseries: line
    property alias absseries: absseries
    property real maxY: 20
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

            ScatterSeries {
                id: ls
                name: seriesName
                //style: Qt.DotLine
                //capStyle: Qt.RoundCap
                color: "yellow"
                //width: 2
                pointLabelsVisible: true
                pointsVisible: true
                pointLabelsColor: "yellow"
                markerSize: 3
                ValueAxis {
                        id: axisX
                        min: 0
                        max: 500
                        tickCount: 21
                        gridVisible: true
                        color: "white"
                        labelsVisible: true
                        minorGridVisible: false
                        titleText: "Сопротивление вращательному срезу, кПа"
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
                      titleText: "Давление по прибору, ед."
                  }
                axisX: axisX
                axisY: axisY
            }
            LineSeries {
                id: line
                name: seriesName
                style: Qt.SolidLine
                capStyle: Qt.RoundCap
                color: "green"
                //width: 2
                pointLabelsVisible: false
                pointsVisible: false
                pointLabelsColor: "yellow"
                ValueAxis {
                        id: axisXl
                        min: 0
                        max: 500
                        tickCount: 21
                        gridVisible: true
                        color: "white"
                        labelsVisible: true
                        minorGridVisible: false
                    }
                ValueAxis {
                      id: axisYl
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
            ScatterSeries {
                id: absseries
                name: "Относительное отклонение"
                //style: Qt.DotLine
                //capStyle: Qt.RoundCap
                color: "lightblue"
                //width: 2
                pointLabelsVisible: true
                pointsVisible: true
                pointLabelsColor: "lightblue"
                markerSize: 3
                ValueAxis {
                        id: axisXabs
                        min: 0
                        max: 500
                        tickCount: 21
                        gridVisible: true
                        color: "lightblue"
                        labelsVisible: true
                        minorGridVisible: false

                    }
                ValueAxis {
                      id: axisYabs
                      min: 0
                      max: chart.maxY
                      tickCount: 11
                      gridVisible: true
                      labelsColor: "lightblue"
                      color: "lightblue"
                      labelsVisible: true
                      titleText: "отклонение в %"
                  }
                axisXTop:  axisXabs
                axisYRight: axisYabs
            }
        }
    }
}
