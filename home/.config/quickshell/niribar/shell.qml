import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.UPower
import Niri

ShellRoot {
    PanelWindow {
        id: bar
        anchors { top: true; left: true; right: true }
        implicitHeight: 28
        color: "#05040A"

        Niri {
            id: niri
            Component.onCompleted: connect()
        }

        Component.onCompleted: niri.workspaces.maxCount = 10

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            anchors.rightMargin: 15
            spacing: 20


            Row {
                spacing: 8
                Repeater {
                    model: niri.workspaces
                    Rectangle {
                        width: 20; height: 20; radius: 10


                        color: model.isFocused ? "#B26BFF" : (model.isActive ? "#372E4D" : "#231B38")

                        Text {
                            anchors.centerIn: parent
                            text: model.index

                            color: model.isFocused ? "#05040A" : (model.isActive ? "#F2EEFF" : "#8A81A6")
                            font.pixelSize: 12
                            visible: !model.isFocused
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: niri.focusWorkspaceById(model.id)
                        }
                    }
                }
            }


            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: niri.focusedWindow?.title ?? "Niri"
                color: "#D7C1FF"
                font.pixelSize: 14
                elide: Text.ElideRight
            }


            Row {
                spacing: 15

                Text {
                    text: "󰁹 " + Math.round(UPower.displayDevice.percentage * 100) + "%"
                    color: "#B26BFF"
                    font.pixelSize: 14
                    visible: UPower.displayDevice.ready && UPower.displayDevice.isLaptopBattery
                }

                Text {
                    id: clock
                    property date now: new Date()
                    text: Qt.formatTime(now, "HH:mm")
                    color: "#F2EEFF"
                    font.pixelSize: 14
                    font.bold: true

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clock.now = new Date()
                    }
                }
            }
        }
    }
}
