import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

import "../"
import "../utils"
import "root:/" 

Item {
    id: root
    width: parent.width
    height: Theme.get.preferredHeight
    
    property string text: text_content.text
    property var icons: {
        "headset-output": "",
        "analog-output-headphones": "",
        "analog-output-speaker": "",
    }
    property var icons_mute: {
        "headset-output": "󰟎",
        "analog-output-headphones": "󰟎",
        "analog-output-speaker": "",
    }

    Rectangle {
        anchors.fill: parent 
        color: "transparent" 
      }

    Row {
      anchors.centerIn: parent
      spacing: 5
 
      Icon {
        y: +1
        color: Theme.get.symbol
        symbol: `${Audio.muted ? icons_mute[Audio.activePort] : icons[Audio.activePort]}`
        pointSize: 12
      }
      
      Text {
        id: text_content
        text: `${Math.round(Audio.volume * 100)}%`
        font.weight: Theme.get.fontWeight
        font.pixelSize: Theme.get.fontSize
        color: Theme.get.text 
      }
    }

    MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        onClicked: (mouse)=> {
          if (mouse.button == Qt.RightButton) {
            // Если через полсекунды фокус не дал, закроетася, а если дал фокус, закроется через 250 милесукунд, если убрать фокус
            closeTimer.interval = 1500 
            closeTimer.start()
            toggleMenu() 
          } else if (mouse.button == Qt.LeftButton)
              Audio.sink.audio && (Audio.sink.audio.muted = !Audio.sink.audio.muted) 
        }


	    onWheel: function(event) {
            if (Audio.sink.audio) {
                Audio.setVolume(Math.max(0, Math.min(1, Audio.volume + (event.angleDelta.y / 120) * 0.05)))
            }
        }
    }

    Process {
        id: pavucontrol
        command: ["pavucontrol"]
        running: false
    }

    PopupWindow {
        id: menuWindow
        implicitWidth: 150
        implicitHeight: 150
        visible: false
        color: "transparent" 
        anchor {
   
            window: root.QsWindow.window
            // item: root
            edges: Edges.Bottom
            gravity: Edges.Bottom
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onExited: {
              if (!containsMouse) {
                    closeTimer.interval = 250
                    closeTimer.start()
                }
            }
            onEntered: closeTimer.stop()

            Timer {
                id: closeTimer
                interval: 250
                onTriggered: {
                  main_wrapper.height = 0
                }
            }

            Rectangle {
                id: main_wrapper
                width: 149 // -1 для фикса визуального бага
                height: menuWindow.visible ? 150 : 0
                color: Theme.get.block
                border.color: Theme.get.border
                border.width: 1

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
                
                Behavior on height {
                  NumberAnimation {
                    duration: Theme.get.animationDurationHeight
                    easing: Easing.InOutQuad
                  }
                }
                  
                radius: 10
                
                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    // Volume Slider
                    Rectangle {
                        width: parent.width
                        height: 35
                        color: "transparent"

                        Slider {
                            id: volumeSlider
                            anchors.fill: parent
                            from: 0
                            to: 1
                            value: Audio.volume || 0
                            onValueChanged: {
                                if (Audio.sink.audio) {
                                    Audio.setVolume(value)
                                }
                            }

                            background: Rectangle {
                                x: volumeSlider.leftPadding
                                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                width: volumeSlider.availableWidth
                                height: 4
                                radius: 2
                                color: "#3c3c3c"

                                Rectangle {
                                    width: volumeSlider.visualPosition * parent.width
                                    height: parent.height
                                    color: Theme.get.accent
                                    radius: 2
                                }
                            }

                            handle: Rectangle {
                                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                width: 16
                                height: 16
                                radius: 8
                                color: volumeSlider.pressed ? Theme.get.accent : "#ffffff"
                                border.color: "#3c3c3c"
                            }
                        }
                    }

                    Repeater {
                        model: [
                            { text: Audio.muted ? "Unmute" : "Mute", action: () => Audio.sink.audio && (Audio.sink.audio.muted = !Audio.sink.audio.muted) },
                            { text: "Pavucontrol", action: () => { pavucontrol.running = true; menuWindow.visible = false } }
                        ]

                        Rectangle {
                            width: parent.width
                            height: 35
                            border.color: mouseArea.containsMouse ? Theme.get.border : "transparent"
                            color: mouseArea.containsMouse ? Theme.get.block : "transparent"
                            radius: 4

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                text: modelData.text
                                color: "white"
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    modelData.action()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function toggleMenu() {
        if (root.QsWindow?.window?.contentItem) {
            menuWindow.anchor.rect = root.QsWindow.window.contentItem.mapFromItem(root, 0, -menuWindow.height + 154, root.width, root.height)
            menuWindow.visible = true
            main_wrapper.height = menuWindow.visible ? 150 : 0;
        }
    }
}
