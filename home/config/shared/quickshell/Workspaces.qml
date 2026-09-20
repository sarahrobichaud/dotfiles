pragma Singleton
import Quickshell
import Quickshell.Hyprland
import QtQuick
import "."

// Normalized Hyprland state for the bar.
//
// With static per-monitor workspace lists, the only dynamic facts views
// need are: which workspace is active on a given monitor, and which
// monitor is focused. Both are read from quickshell's Hyprland objects,
// which update reliably via the event socket.
Singleton {
    id: root

    // fixed workspace list per monitor
    property var monitorWorkspaces: ({
        "DP-1": [6, 7, 8, 9, 10],
        "DP-2": [1, 2, 3, 4, 5]
    })

    // --- queries ------------------------------------------------------------

    // the fixed workspace id list for a monitor
    function idsForMonitor(monitorName) {
        return monitorWorkspaces[monitorName] ?? []
    }

    // is this workspace the one active on its monitor?
    // HyprlandWorkspace.active is exactly this - per-monitor active state
    function isActive(id) {
        const w = Hyprland.workspaces.values.find(w => w.id === id)
        return w?.active ?? false
    }

    // is this monitor the currently focused one?
    function isMonitorFocused(monitorName) {
        return Hyprland.focusedMonitor?.name === monitorName
    }

    // --- actions ------------------------------------------------------------

    function activate(id) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${id}})`)
    }
}
