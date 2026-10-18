import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Niri

ShellRoot {
    component BarText: Text {
        property int textSize: 18

        font.family: "Noto Sans"
        font.pixelSize: textSize

        color: "#F2EEFF"
    }

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
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 20

            Row {
                spacing: 8
                Layout.alignment: Qt.AlignVCenter

                Repeater {
                    model: niri.workspaces

                    Rectangle {
                        width: 26
                        height: 20
                        radius: 10

                        color: model.isFocused ? "#B26BFF" : (model.isActive ? "#372E4D" : "#231B38")

                        BarText {
                            anchors.centerIn: parent
                            text: model.index
                            textSize: 16
                            color: model.isFocused ? "#05040A" : (model.isActive ? "#F2EEFF" : "#8A81A6")
                            visible: !model.isFocused
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: niri.focusWorkspaceById(model.id)
                        }
                    }
                }
            }

            BarText {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: niri.focusedWindow?.title ?? "Niri"
                color: "#D7C1FF"
                elide: Text.ElideRight
            }

            Row {
                spacing: 20
                Layout.alignment: Qt.AlignVCenter

                BarText {
                    height: bar.implicitHeight
                    verticalAlignment: Text.AlignVCenter
                    text: "󰁹 " + Math.round(UPower.displayDevice.percentage * 100) + "%"
                    color: "#B26BFF"
                    visible: UPower.displayDevice.ready && UPower.displayDevice.isLaptopBattery
                }

                BarText {
                    id: clock
                    height: bar.implicitHeight
                    verticalAlignment: Text.AlignVCenter
                    property date now: new Date()
                    text: Qt.formatTime(now, "HH:mm:ss")
                    font.bold: true

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clock.now = new Date()
                    }
                }

                Row {
                    spacing: 8
                    visible: trayRepeater.count > 0

                    Repeater {
                        id: trayRepeater
                        model: SystemTray.items

                        delegate: Item {
                            width: 18
                            height: bar.implicitHeight

                            Image {
                                id: trayIcon
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                fillMode: Image.PreserveAspectFit
                                source: modelData.icon ? modelData.icon : ""
                                sourceSize: Qt.size(16, 16)
                            }

                            BarText {
                                anchors.centerIn: parent
                                visible: trayIcon.status !== Image.Ready
                                text: modelData.title ? modelData.title.charAt(0).toUpperCase() : "T"
                                textSize: 16
                                color: "#D7C1FF"
                            }

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.RightButton

                                onClicked: {
                                    var item = modelData;

                                    if (mouse.button === Qt.RightButton) {
                                        if (typeof item.openMenu === "function")
                                            item.openMenu(mouse.x, mouse.y);
                                        else if (typeof item.contextMenu === "function")
                                            item.contextMenu(mouse.x, mouse.y);
                                    } else {
                                        if (typeof item.activate === "function")
                                            item.activate(mouse.x, mouse.y);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
