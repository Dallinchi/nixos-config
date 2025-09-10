import QtQuick
import Quickshell.Io
import "../"
import "../utils"
import "root:/"

Item {
  width: parent.width
  height: Theme.get.preferredHeight
  property int chopLength
  property string title: PlayerTitle.title

  Rectangle {
    color: text_content.text.length >= 1 ? Theme.get.block : "transparent" 
    anchors.right: parent.right
    width: text_content.implicitWidth + 30
    height: Theme.get.preferredHeight
    
    border.color: text_content.text.length >= 1 ? Theme.get.border : "transparent" 
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
        duration: Theme.get.animationDurationWidth * 3
        easing: Easing.InOutQuad
      }
    }   
    Row {
      anchors.centerIn: parent
      spacing: 5
 
      Icon {
        y: +1.7
        color: Theme.get.symbol
        symbol: text_content.text.length >= 1 ? `` : "" 
        pointSize: 10
      }
      Text {
        id: text_content
        text: {
          var str = title
          return str.length > chopLength ? str.slice(0, chopLength) + '...' : str;
        }
        font.weight: Theme.get.fontWeight
        color: Theme.get.text 
      }
    }
    // Text {
    //   id: text_content
    //   anchors.centerIn: parent 
    //   font.weight: Theme.get.fontWeight
    //
    //
    //   color: Theme.get.text 
    // }

    MouseArea {
      anchors.fill: parent
      onClicked: playPause.running = true
      onWheel: function(event) {
        if (Math.max(0, Math.min((event.angleDelta.y / 120) * 1))) {
          next.running = true
        } else {
          prev.running = true
        }
      }
    }
    
    Process {
        id: playPause
        command: ["playerctl", "play-pause"]
        running: false
      }
      
    Process {
      id: next
      command: ["playerctl", "next"]
      running: false
    }
    
    Process {
      id: prev
      command: ["playerctl", "previous"]
      running: false
    }
  }
}

