pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: theme

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    readonly property color barBg: "#56ffffff"
    readonly property color pillBg: "#8fffffff"
    readonly property color pillActiveBg: "#d9ffffff"

    readonly property color glassEdge: "#99ffffff"
    readonly property color glassRing: "#8cffffff"

    readonly property color fg: "#ff000000"
    readonly property color fgMuted: "#8f000000"
    readonly property color fgFaint: "#4f000000"
    readonly property color fgOnDark: "#ffffffff"
    readonly property color accent: "#ff0d1f14"

    readonly property var workspaceIcons: ({
        1: "",
        2: "",
        3: "",
        4: "",
        5: "",
        6: "",
        7: "",
        8: "",
        9: "",
        10: ""
    })

    readonly property color trans: "transparent"

    readonly property int animFast: 200
    readonly property int animSlow: 300
    readonly property var easingGlass: [0.4, 0, 0.2, 1, 1, 1]
}
