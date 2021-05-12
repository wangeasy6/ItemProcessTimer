import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3

Window {
    visible: true
    width: 700
    height: 480
    title: qsTr("Task Process Timer v0.0.5")

    MessageDialog {
        id: tips
        title: "提示:"
        standardButtons: StandardButton.Yes
        onYes: close()
    }

    TabView {
        width: parent.width
        height: parent.height

        Tab {
            title: "任务计时"
            id: task_timing
            property int rows: 0

            function addRow(){
                var component = Qt.createComponent("task_row.qml");
                if (component.status === Component.Ready) {
                    var row = component.createObject(task_timing ,{"y" : rows * 70 + 5});
                }
                rows++
            }

            onChildrenChanged: {
                rowRefresh()
            }

            function rowRefresh(){
                var list = task_timing.children
                var pre_y = 0
                var is_adjust = false
                for(var i in list)
                {
                    if(list[i].height !== 0)
                        continue

//                    console.log("list[ " +i + " ] y = " + list[i].y)
//                    console.log("list[ " +i + " ] height = " + list[i].height)

                    if(list[i].y - pre_y > 70){
                        is_adjust = true
                    }
                    else
                    {
                        pre_y = list[i].y
                    }

                    if(is_adjust)
                    {
                        list[i].y -= 70
                        continue
                    }

                }
            }

            onLoaded: {
                addRow()
            }

            Rectangle{
                Button {
                    text: "新增"
                    width: 40
                    height: 20

                    anchors.margins: 5
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    onClicked: {
                        addRow();
                    }
                }
            }
        }

        Tab {
            title: "任务树"
            TabView {
                tabPosition: Qt.BottomEdge
                Tab {
                    title: "项目1"
                }
                Tab {
                    title: "项目2"
                }
            }
        }

        Tab {
            title: "统计分析"
//            Rectangle { color: "green" }
        }

        Tab {
            title: "日志"
//            Rectangle { color: "green" }
        }
    }
}
