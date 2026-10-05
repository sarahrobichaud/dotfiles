pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "."

Scope {
    id: root
    property string time

    Variants {
        model: Quickshell.screens;

        PanelWindow { // qmllint disable uncreatable-type

            required property var modelData

            readonly property string monitorName: modelData.name
            readonly property var wsIds: Workspaces.idsForMonitor(monitorName)

            screen:  modelData
            anchors.top: true
            anchors.left: true
            anchors.right: true
            color: Theme.trans
            implicitHeight: 30

            margins { // qmllint disable unresolved-type unqualified
                top: 10
                left: 20
                right:20
                bottom:10
            }

            RowLayout {
                anchors.fill: parent
                Layout.alignment: Qt.AlignVCenter
                spacing: 10

                Pill {
                    id: monitorPill

                    Text {
                        text: monitorName
                        font { pixelSize: Theme.fontSize; bold: true }
                        color: Workspaces.isMonitorFocused(monitorName) ? Theme.fg : Theme.fgFaint

                        Behavior on color {
                            ColorAnimation { duration: Theme.animFast }
                        }
                    }

                    Rectangle {
                        parent: monitorPill.highlight
                        anchors.fill: parent
                        radius: height / 2
                        color: Theme.pillActiveBg
                        border.color: Theme.glassRing
                        border.width: 1
                        visible: Workspaces.isMonitorFocused(monitorName)

                        Behavior on opacity {
                            NumberAnimation { duration: Theme.animFast }
                        }
                    }
                }

                Pill {
                    id: wsPill

                    Repeater {
                        id: wsRepeater
                        model: wsIds
                        Workspace {
                            id: workspaces
                            required property var modelData

                            property int wsId: modelData

                            index: wsId
                            icon: Theme.workspaceIcons[wsId] ?? ""
                            isActive: Workspaces.isActive(wsId)
                            exists: true
                            isUrgent: false

                            onClicked: Workspaces.activate(wsId)
                        }
                    }

                    Rectangle {
                        id: slider
                        parent: wsPill.highlight
                        radius: height / 2
                        color: Theme.pillActiveBg
                        border.color: Theme.glassRing
                        border.width: 1

                        Rectangle {
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: parent.top
                                leftMargin: parent.radius / 2
                                rightMargin: parent.radius / 2
                                topMargin: 1
                            }
                            height: 1
                            color: Theme.glassEdge
                        }

                        readonly property int activeIndex: {
                            void wsIds.length
                            let idx = -1
                            for (let i = 0; i < wsIds.length; i++) {
                                if (Workspaces.isActive(wsIds[i])) { idx = i; break }
                            }
                            return idx
                        }

                        readonly property Item activeDelegate: activeIndex >= 0 ? wsRepeater.itemAt(activeIndex) : null

                        x: activeDelegate ? activeDelegate.mapToItem(slider.parent, 0, 0).x : width / -2
                        width: activeDelegate ? activeDelegate.width : 0
                        height: parent.height
                        opacity: activeDelegate ? 1 : 0

                        Behavior on x {
                            NumberAnimation {
                                duration: Theme.animSlow
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.easingGlass
                            }
                        }
                        Behavior on width {
                            NumberAnimation {
                                duration: Theme.animSlow
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.easingGlass
                            }
                        }
                        Behavior on opacity {
                            NumberAnimation { duration: Theme.animFast }
                        }
                    }
                }
                Item {Layout.fillWidth: true}
                Pill {
                    Text {
                        text: root.time
                        font { pixelSize: Theme.fontSize; bold: true }
                        color: Theme.fgMuted
                    }
                }
            }
        }
    }

    Process {
        id: dateProc
        command: ["date"]
        running: true

        stdout: StdioCollector {
          onStreamFinished: root.time = this.text.trim()
        }
      }

      Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
      }
}
