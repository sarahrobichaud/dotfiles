import QtQuick
import QtQuick.Layouts
import "."

Rectangle {
    id: pill

    radius: height / 2
    color: Theme.pillBg
    implicitHeight: 30
    implicitWidth: contentRow.implicitWidth + 20

    default property alias content: contentRow.data
    property alias highlight: highlightLayer
    property alias contentItem: contentRow

    Item {
        id: highlightLayer
        anchors {
            fill: parent
            margins: 2
        }
    }

    RowLayout {
        id: contentRow
        anchors.centerIn: parent
        spacing: 6
    }
}
