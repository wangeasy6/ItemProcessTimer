import QtQuick 2.14
import QtQuick.Controls 1.4

Rectangle {
    id:task_row
    QtObject {
        id: counter
        property int n : 0
        property int seconds: 0
        property int minutes: 0
        property int hours: 0
        property string forward_timing: ""

        property int estimated_seconds: 0
        property int estimated_minutes: 0
        property int estimated_hours: 0
        property int down_n : 0
        property int down_seconds: 0
        property int down_minutes: 0
        property int down_hours: 0
        property string reverse_timing: ""

        onNChanged: {
            seconds = n % 60
            minutes = (n / 60) % 60
            hours = n / 3600
            forward_timing = hours + ":" + minutes + ":" + seconds

            var rest_n = down_n - n
            reverse_timing = ""
            if(rest_n < 0)
            {
                reverse_timing = "-"
                rest_n = -rest_n
            }
            down_seconds = rest_n % 60
            down_minutes = (rest_n / 60) % 60
            down_hours = rest_n / 3600
            reverse_timing += down_hours + ":" + down_minutes + ":" + down_seconds
        }

        onEstimated_hoursChanged: {
            down_n = estimated_hours * 3600 + estimated_minutes * 60 + estimated_seconds
        }
        onEstimated_minutesChanged: {
            down_n = estimated_hours * 3600 + estimated_minutes * 60 + estimated_seconds
        }
        onEstimated_secondsChanged: {
            down_n = estimated_hours * 3600 + estimated_minutes * 60 + estimated_seconds
        }
        onDown_nChanged: {
            estimated_seconds = down_n % 60
            estimated_minutes = (down_n / 60) % 60
            estimated_hours = down_n / 3600
        }
    }

    Timer {
        id: task_timer
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            counter.n++
            count.text = counter.forward_timing
            count_down.text = counter.reverse_timing
        }
    }

    Row {
        topPadding: 10

        Text {
            text: "父任务:"
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: 75
            height: 17
            color: "white"
            border.color: "lightgrey"
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            TextInput {
                id: parent_task_name
                anchors.fill: parent
                anchors.margins: 2
                verticalAlignment: TextInput.AlignVCenter
                font.pointSize: 8
                focus: true
            }
        }

        Text {
            text: "任务名称:"
            leftPadding: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: 85
            height: 17
            color: "white"
            border.color: "lightgrey"
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            TextInput {
                id: task_name
                anchors.fill: parent
                anchors.margins: 2
                verticalAlignment: TextInput.AlignVCenter
                font.pointSize: 8
                focus: true
            }
        }

        Text {
            text: "预计时间:"
            leftPadding: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: 20
            height: 17
            color: "white"
            border.color: "lightgrey"
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            TextInput {
                id: task_estimated_hours
                anchors.fill: parent
                anchors.margins: 2
                font.pointSize: 10
                focus: true
                maximumLength: 2
//                            autoScroll: false

                onTextChanged: {
                    if (text == "")
                    {
                        counter.estimated_hours = 0
                        return
                    }

                    var num = Number(text)
                    if (num === NaN)
                    {
                        tips.text = "请输入数字！"
                        tips.open()
                        clear()
                        counter.estimated_hours = 0
                        return
                    }

                    if (counter.estimated_hours !== num)
                        counter.estimated_hours = num
               }

            }
        }

        Text {
            text: "h"
            leftPadding: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: 20
            height: 17
            color: "white"
            border.color: "lightgrey"
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            TextInput {
                id: task_estimated_minutes
                anchors.fill: parent
                anchors.margins: 2
                font.pointSize: 10
                focus: true
                maximumLength: 2

                onTextChanged: {
                    if (text == "")
                    {
                        counter.estimated_minutes = 0
                        return
                    }

                    var num = Number(text)
                    if (num === NaN)
                    {
                        tips.text = "请输入数字！"
                        tips.open()
                        clear()
                        counter.estimated_minutes = 0
                        return
                    }

                    if (counter.estimated_minutes !== num)
                        counter.estimated_minutes = num
               }

            }
        }

        Text {
            text: "m"
            leftPadding: 3
            anchors.verticalCenter: parent.verticalCenter
        }

        Button {
            id: bt_1
            text: "开始"
            width: 60
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                if(task_name.text == "")
                {
                    console.log("task_name is null")
                    tips.text = "请输入任务名称！"
                    tips.open()
                    return
                }

                if(task_timer.running)
                {
                    task_timer.stop()
                    counter.n = 0
                    task_timer.start()
                }
                else
                {
                    task_timer.start()
                    bt_1.text = "重新开始"
                    bt_2.text = "暂停"
                }
            }
        }

        Button {
            id: bt_2
            text: "暂停"
            width: 40
            height: 20
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                if(task_name.text == "" || bt_1.text == "开始")
                {
                    return
                }

                if(task_timer.running)
                {
                    task_timer.stop()
                    text = "继续"
                }
                else
                {
                    task_timer.start()
                    text = "暂停"
                }
            }
        }

        Text {
            text: "正计时:"
            leftPadding: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: count
            text: ""
            width: 60
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: "倒计时:"
            leftPadding: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: count_down
            text: ""
            width: 60
            anchors.verticalCenter: parent.verticalCenter
        }

        Button {
            id: bt_3
            text: "取消"
            width: 40
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                // 日志
                task_timer.stop()
                counter.n = 0
                counter.down_n = 0
                task_name.clear()
                parent_task_name.clear()
                task_estimated_hours.clear()
                task_estimated_minutes.clear()
                count.text = ""
                count_down.text = ""
                bt_1.text = "开始"
                bt_2.text = "暂停"
                task_row.destroy()
                task_timing.rows--
            }
        }

        Button {
            id: bt_4
            text: "完成"
            width: 40
            height: 20
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                // 日志
                task_timer.stop()
                counter.n = 0
                counter.down_n = 0
                task_name.clear()
                parent_task_name.clear()
                task_estimated_hours.clear()
                task_estimated_minutes.clear()
                count.text = ""
                count_down.text = ""
                bt_1.text = "开始"
                bt_2.text = "暂停"
                task_row.destroy()
                task_timing.rows--
            }
        }
    }
}
