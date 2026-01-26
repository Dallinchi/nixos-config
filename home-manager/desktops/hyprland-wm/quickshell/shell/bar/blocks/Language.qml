import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland

import "../"
import "root:/"

Item { 
    property string keyboardLayout: "En"
    
    width: parent.width
    height: Theme.get.preferredHeight

    Rectangle {
      anchors.fill: parent
      color: "transparent"
 
      Text {
        anchors.centerIn: parent
        text: `${keyboardLayout}`
        font.weight: Theme.get.fontWeight
        font.pixelSize: Theme.get.fontSize
        color: Theme.get.text
      }
    }
    Component.onCompleted: {
      Hyprland.rawEvent.connect(hyprEvent)
    }

    function hyprEvent(e) {
      var layout = e.data.split(",")[0]; 
        if (layout.includes("at-translated-set-2-keyboard")) {
        keyboardLayout = e.data.split(",").pop().slice(0, 2)
      }
    }
}
