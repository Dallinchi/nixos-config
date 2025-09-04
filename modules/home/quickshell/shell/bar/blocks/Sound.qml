import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io

import "../"
import "root:/" 

Item {
    id: root
    width: parent.width
    height: Theme.get.preferredHeight
    
    property var sink: Pipewire.defaultAudioSink

    property string text: text_content

    PwObjectTracker { 
        objects: [Pipewire.defaultAudioSink]
        onObjectsChanged: {
            sink = Pipewire.defaultAudioSink
            if (sink?.audio) {
                sink.audio.volumeChanged.connect(updateVolume)
            } 
        }
    }

    function updateVolume() {
        if (sink?.audio) {
            const icon = sink.audio.muted ? "" : ""
            content.symbolText = `${icon} ${Math.round(sink.audio.volume * 100)}%`
        }
    }
    Rectangle {
        anchors.fill: parent 
        color: "transparent" 
      }

    Row {
      anchors.centerIn: parent
      spacing: 5
 
      Icon {
        y: +2.7
        color: Theme.get.symbol
        symbol: `${sink?.audio?.muted ? "" : ""}`
        pointSize: 12
      }
      
      Text {
        id: text_content
        text: `${Math.round(sink?.audio?.volume * 100)}%`
        font.weight: Theme.get.fontWeight
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
              sink?.audio && (sink.audio.muted = !sink.audio.muted) 
        }


        onWheel: function(event) {
            if (sink?.audio) {
                sink.audio.volume = Math.max(0, Math.min(1, sink.audio.volume + (event.angleDelta.y / 120) * 0.05))
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
        visible: falsanimationDurationHeighte
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
                            value: sink?.audio?.volume || 0
                            onValueChanged: {
                                if (sink?.audio) {
                                    sink.audio.volume = value
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
                            { text: sink?.audio?.muted ? "Unmute" : "Mute", action: () => sink?.audio && (sink.audio.muted = !sink.audio.muted) },
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
