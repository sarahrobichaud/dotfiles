pragma Singleton
import Quickshell
import Quickshell.Hyprland
import QtQuick
import "."

Singleton {
    id: root

    property var monitorWorkspaces: ({
        "DP-1": [6, 7, 8, 9, 10],
        "DP-2": [1, 2, 3, 4, 5]
    })

    function idsForMonitor(monitorName) {
        return monitorWorkspaces[monitorName] ?? []
    }

    function isActive(id) {
        const w = Hyprland.workspaces.values.find(w => w.id === id)
        return w?.active ?? false
    }

    function isMonitorFocused(monitorName) {
        return Hyprland.focusedMonitor?.name === monitorName
    }

    function activate(id) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${id}})`)
    }
}
