import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland

import "../"
import "root:/"

Item {
    width: parent.width
    height: Theme.get.preferredHeight

    property int chopLength
    property string activeWindowTitle
    property string workspace_state

    Rectangle {
      anchors.centerIn: parent
      width: text_content.implicitWidth + 15
      height: Theme.get.preferredHeight
      color: text_content.text.length >= 1 ? Theme.get.block : "transparent"        
        
      border.color: Theme.get.border
      border.pixelAligned: Theme.get.borderPixelAligned
      border.width: Theme.get.borderWidth

      bottomRightRadius: Theme.get.bottomRightRadius
      bottomLeftRadius: Theme.get.bottomLeftRadius
      topRightRadius: Theme.get.topRightRadius
      topLeftRadius: Theme.get.topLeftRadius     

      clip: true

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
      
      Text {
        id: text_content
        anchors.centerIn: parent
        font.weight: Theme.get.fontWeight
        text: {
          var str = activeWindowTitle
          if (activeWindowTitle.length < 1) {
            return "Welcome"
          }
          return str.length > chopLength ? str.slice(0, chopLength) + '...' : str;
        }
        color: Theme.get.text
      }
    }

    Process {
        id: titleProc
        command: ["sh", "-c", "hyprctl activewindow | grep title: | sed 's/^[^:]*: //'"]
        running: true

        stdout: SplitParser {
            onRead: data => activeWindowTitle = data
        }
    }

    Component.onCompleted: {
        Hyprland.rawEvent.connect(hyprEvent)
    }

    function hyprEvent(e) {
        titleProc.running = true
    }
}

