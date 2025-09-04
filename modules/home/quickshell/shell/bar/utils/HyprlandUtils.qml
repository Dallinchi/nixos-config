pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

import "root:/"

Singleton {
    id: hyprland

    property list<HyprlandWorkspace> focusedmonitor_workspaces: filterWorkspacesByMonitor(Hyprland.focusedMonitor.id)
    property int maxWorkspace: findMaxId()
    
    function switchWorkspace(w: int): void {
        Hyprland.dispatch(`workspace ${w}`);
    }

    function filterWorkspacesByMonitor(monitorId) {
        let minId = (monitorId === 0) ? 0 : 8;
        let maxId = (monitorId === 0) ? 9 : 17;
        return Hyprland.workspaces.values.filter(ws => ws.id < maxId && ws.id > minId);
    }

    Process {
      id: procWorkspaceStatus
      command: ["sh", "-c", "~/.config/quickshell/nerd-space/scripts/workspace_state_scribe " + Hyprland.focusedWorkspace.id]
      running: false

      stdout: SplitParser {
          onRead: data => {
            switch (data) {
                case "default":
                {
                  Theme.get.background = Theme.get.backgroundDefault
                  Theme.get.text = Theme.get.textDefault
                  Theme.get.block = Theme.get.blockDefault              
                  Theme.get.symbol = Theme.get.symbolDefault              
                  Theme.get.border = Theme.get.borderDefault
                  break
                }
                case "empty":
                {
                  Theme.get.background = Theme.get.backgroundEmpty 
                  Theme.get.text = Theme.get.textEmpty
                  Theme.get.block = Theme.get.blockEmpty              
                  Theme.get.symbol = Theme.get.symbolEmpty
                  Theme.get.border = Theme.get.borderEmpty
                  break
                }
                case "solo":
                {
                  Theme.get.background = Theme.get.backgroundActive 
                  Theme.get.text = Theme.get.textDefault
                  Theme.get.block = Theme.get.blockDefault
                  Theme.get.symbol = Theme.get.symbolActive
                  Theme.get.border = Theme.get.borderActive
                  break
                }
            }
          }
      }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            let eventName = event.name;
            procWorkspaceStatus.running = true
        }
    }
}
