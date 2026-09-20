pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: theme

    // --- Typography ---------------------------------------------------------
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    // --- Base surfaces (the stacked glass layers) ---------------------------
    // Layer 0: the bar window itself. Faintest wash of white.
    readonly property color barBg: "#56ffffff"
    // Layer 1: module pills sitting on the bar. Slightly more present.
    readonly property color pillBg: "#8fffffff"
    // Layer 2: the active/highlight pill. Most opaque, reads as solid glass.
    readonly property color pillActiveBg: "#d9ffffff"

    // --- Glass detail -------------------------------------------------------
    // Thin bright edge on top of a glass layer (inset highlight).
    readonly property color glassEdge: "#99ffffff"
    // 1px ring around an active pill.
    readonly property color glassRing: "#8cffffff"

    // --- Content (text/icons on glass) --------------------------------------
    // Darkest: active/selected content.
    readonly property color fg: "#ff000000"
    // Default content on glass.
    readonly property color fgMuted: "#8f000000"
    // Faintest: inactive/nonexistent workspaces.
    readonly property color fgFaint: "#4f000000"
    // Content on dark/urgent surfaces.
    readonly property color fgOnDark: "#ffffffff"
    // Urgent/dark accent surface.
    readonly property color accent: "#ff0d1f14"

    // --- Workspaces ---------------------------------------------------------
    // Icons per workspace id (nerd font glyphs). Empty string = number only.
    // NOTE: which monitor a workspace is on is read live from Hyprland
    // (HyprlandWorkspace.monitor), so workspaces that get moved/switched
    // between monitors automatically appear on the right bar.
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

    // --- Misc ---------------------------------------------------------------
    readonly property color trans: "transparent"

    // --- Motion -------------------------------------------------------------
    // Matched to the waybar feel: quick color shifts, slower sweep.
    readonly property int animFast: 200
    readonly property int animSlow: 300
    readonly property var easingGlass: [0.4, 0, 0.2, 1, 1, 1]  // Material standard
}
