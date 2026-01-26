import QtQuick
import Quickshell.Io

import "../"
import "root:/"

Item {
  property string battery
  property bool hasBattery: false
  property string text: text_content.text
  property string batterySymbol
  
  property int icon_size
  property real icon_top

  width: parent.width
  height: Theme.get.preferredHeight
  
  Rectangle {
    anchors.fill: parent
    color: "transparent"
    
    Row {
      anchors.centerIn: parent
      spacing: 5

      Text {
        id: text_content
        text: `${battery}`
        font.weight: Theme.get.fontWeight
        font.pixelSize: Theme.get.fontSize
        color: Theme.get.text
      }

      Icon {
        y: +icon_top
        color: Theme.get.symbol
        symbol: batterySymbol
        pointSize: icon_size
      }
    }
  }
  

  Process {
    id: batteryCheck
    command: ["sh", "-c", "test -d /sys/class/power_supply/BAT*"]
    running: true
    onExited: function(exitCode) { hasBattery = exitCode === 0 }
  }

  Process {
    id: batteryProc
    // Modify command to get both capacity and status in one call
    command: ["sh", "-c", "echo $(cat /sys/class/power_supply/BAT*/capacity),$(cat /sys/class/power_supply/BAT*/status)"]
    running: hasBattery

    stdout: SplitParser {
      onRead: function(data) {
        const [capacityStr, status] = data.trim().split(',')
        const capacity = parseInt(capacityStr)
        let batteryIcon = ""
        if (capacity <= 20) batteryIcon = ""
        else if (capacity <= 40) batteryIcon = ""
        else if (capacity <= 60) batteryIcon = ""
        else if (capacity <= 80) batteryIcon = ""
        else batteryIcon = ""
	
	icon_size = status === "Charging" ? 11 : 14 
	icon_top = status === "Charging" ? 1 : 0.2 
        const symbol = status === "Charging" ? "" : batteryIcon
	
	battery = `${capacity}%`
        batterySymbol = symbol
      }
    }
  }

  Timer {
    interval: 1000
    running: hasBattery
    repeat: true
    onTriggered: batteryProc.running = true
  }
}
