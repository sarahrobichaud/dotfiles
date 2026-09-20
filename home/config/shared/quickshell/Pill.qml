import QtQuick
import QtQuick.Layouts
import "."

Rectangle {
    id: pill

    radius: height / 2
    color: Theme.pillBg
    implicitHeight: 30
    implicitWidth: contentRow.implicitWidth + 20   // horizontal padding

    default property alias content: contentRow.data
    // shared sliding highlight lives here, painted under the content
    property alias highlight: highlightLayer
    // exposed so the highlight can compute row-relative positions
    property alias contentItem: contentRow

    // declared before contentRow so it paints beneath it
    Item {
        id: highlightLayer
        anchors {
            fill: parent
            margins: 2   // inset so the highlight sits inside the pill
        }
    }

    RowLayout {
        id: contentRow
        anchors.centerIn: parent
        spacing: 6
    }
}
