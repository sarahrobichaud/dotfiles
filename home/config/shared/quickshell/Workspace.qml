import QtQuick
import "."

Rectangle {
    id: ws

    required property int index
    property string icon: ""
    property bool isActive: false
    property bool isUrgent: false
    property bool exists: true

    signal clicked()

    radius: height / 2
    color: isUrgent ? Theme.accent : "transparent"
    implicitWidth: label.implicitWidth + iconLabel.implicitWidth + (icon ? 4 : 0) + 24
    implicitHeight: 26

    Behavior on color {
        ColorAnimation { duration: Theme.animFast }
    }

    Row {
        id: label
        anchors.centerIn: parent
        spacing: 4

        Text {
            id: iconLabel
            text: ws.icon
            visible: ws.icon !== ""
            color: {
                if (ws.isUrgent) return Theme.fgOnDark
                if (ws.isActive) return Theme.fg
                return ws.exists ? Theme.fgMuted : Theme.fgFaint
            }
            font {
                pixelSize: Theme.fontSize
                bold: ws.isActive || ws.isUrgent
            }
        }

        Text {
            text: ws.index
            color: {
                if (ws.isUrgent) return Theme.fgOnDark
                if (ws.isActive) return Theme.fg
                return ws.exists ? Theme.fgMuted : Theme.fgFaint
            }
            font {
                pixelSize: Theme.fontSize
                bold: ws.isActive || ws.isUrgent
            }

            Behavior on color {
                ColorAnimation { duration: Theme.animFast }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: ws.clicked()
    }
}
