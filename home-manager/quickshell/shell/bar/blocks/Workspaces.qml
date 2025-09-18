import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../utils" as Utils
import "root:/"
import "../"

Item {
    height: Theme.get.preferredHeight 

    property var workspaceTextMap: {
        "1": "",
        "2": "",
        "3": "󰨞",
        "4": "",
        "5": "󰭹",
        "6": "󰓓",
        "7": "",
        "8": "",
        
        "9": "",
        "10": "",
        "11": "󰨞",
        "12": "",
        "13": "󰭹",
        "14": "󰓓",
        "15": "",
        "16": "",
    }

    Rectangle {
        color: Theme.get.block 
        width: 27 * Utils.HyprlandUtils.focusedmonitor_workspaces.length 
        height: Theme.get.preferredHeight 

        border.color: Theme.get.border
        border.pixelAligned: Theme.get.borderPixelAligned
        border.width: Theme.get.borderWidth

        bottomRightRadius: Theme.get.bottomRightRadius
        bottomLeftRadius: Theme.get.bottomLeftRadius
        topRightRadius: Theme.get.topRightRadius
        topLeftRadius: Theme.get.topLeftRadius
        
        Behavior on color {
          ColorAnimation {
            duration: Theme.get.animationDuration
            easing: Easing.InOutQuad
          }
        }

        Behavior on border.color {
          ColorAnimation {
            duration: Theme.get.animationDuration
            easing: Easing.InOutQuad
          }
        }

        Behavior on width {
          NumberAnimation {
            duration: Theme.get.animationDurationWidth
            easing: Easing.InOutQuad
          }
        }
        RowLayout {
            id: rowWorkspaces
            spacing: 2 
            anchors.centerIn: parent 
            anchors.verticalCenter: parent.verticalCenter 

            Repeater {
                model: Utils.HyprlandUtils.focusedmonitor_workspaces
                Item {
                    required property int index
                    property bool isActive: Hyprland.focusedMonitor?.activeWorkspace?.id === Utils.HyprlandUtils.focusedmonitor_workspaces[index].id
                    
                    width: 25  
                    height: Theme.get.preferredHeight
                    Rectangle {
                        width: 25 
                        height: Theme.get.preferredHeight
                        color: "transparent" 
                        Icon {
                          anchors.centerIn: parent
                          color: isActive ? Theme.get.symbol : Theme.get.symbolEmpty // Цвет текста в зависимости от активности
                          symbol: workspaceTextMap[Utils.HyprlandUtils.focusedmonitor_workspaces[index].id.toString()]
                          pointSize: 11
                        }
                        
                       MouseArea {
                          anchors.fill: parent
                          hoverEnabled: true
                          onClicked: Utils.HyprlandUtils.switchWorkspace(Utils.HyprlandUtils.focusedmonitor_workspaces[index].id)
                        }
                    }
                }
            }
        }
    }
}
