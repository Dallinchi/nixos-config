import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

import "blocks" as Blocks
import "root:/"
import "../utils" as Utils

Scope {
  IpcHandler {
    target: "bar"

    function toggleVis(): void {
      // Toggle visibility of all bar instances
      barInstances.forEach(bar => {
        bar.visible = !bar.visible;
      });
    }
  }

  property var barInstances: []

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      property var modelData
      screen: modelData
      color: "transparent"
      implicitHeight: Theme.get.preferredHeight
      visible: true

      Component.onCompleted: {
        barInstances.push(bar);
      }

      Rectangle {
        id: highlight
        anchors.fill: parent
        color: Theme.get.background
        
        Behavior on color {
            ColorAnimation {
                duration: Theme.get.animationDuration 
                easing: Easing.InOutQuad 
            }
          }

      }

      anchors {
        top: Theme.get.onTop
        bottom: !Theme.get.onTop
        left: true
        right: true
      }

      RowLayout {
        id: allBlocks
        spacing: 0
        anchors.fill: parent
        anchors.topMargin: -3

        // Left side
        RowLayout {
          id: leftBlocks
          spacing: 12
          Layout.alignment: Qt.AlignLeft
          Rectangle {
            color: "#00ff9999" // Light red color for left side
            // width: 100
            Layout.fillWidth: true // Позволяет расширяться до доступной ширины
            Layout.maximumWidth: Math.floor(Quickshell.screens[0].width / 3) // Максимальная ширина 1/3 от ширины экрана
            height: Theme.get.preferredHeight // Match the height of the bar

            RowLayout {
              anchors.fill: parent // Заполняет родительский элемент
              spacing: 10 // Пространство между элементами
              
              Blocks.Space {
                width: 2.5
                Layout.alignment: Qt.AlignCenter // Центрирование
              }
              
              Rectangle {
                Layout.alignment: Qt.AlignCenter
                height: Theme.get.preferredHeight
                width: 125
                color: Theme.get.block
        
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

                Row {   
                  anchors.centerIn: parent
                  Blocks.Time {
                    width: 60
                    // Layout.alignment: Qt.AlignLeft // Центрирование
                  }
                  Blocks.Date {
                    width: 60
                    // Layout.fillWidth: true // Позволяет занимать доступное пространство
                    // Layout.alignment: Qt.AlignLeft // Центрирование
                  }
                }
              }

              Blocks.TimerDelay {
                id: timerDelay 
                Layout.minimumWidth: timerDelay.width_content 
                Layout.fillWidth: false 
                Layout.alignment: Qt.AlignLeft
              }

              Blocks.Workspaces {
                Layout.fillWidth: true // Позволяет занимать доступное пространство
                Layout.alignment: Qt.AlignLeft // Центрирование
              } 
            }
          }
        }

        // Center side
        RowLayout {
          id: centerBlocks
          spacing: 10 // Пространство между элементами
          Layout.alignment: Qt.AlignCenter

          Rectangle {
            color: "#0099ccff" // Light blue color for center side
            height: Theme.get.preferredHeight // Match the height of the bar
            Layout.fillWidth: true // Позволяет расширяться до доступной ширины
            Layout.maximumWidth: Math.floor(Quickshell.screens[0].width / 3) // Максимальная ширина 1/3 от ширины экрана

            RowLayout {
              anchors.fill: parent // Заполняет родительский элемент
              spacing: 10 // Пространство между элементами

              Blocks.Space {
                width: 2.5
                Layout.alignment: Qt.AlignCenter // Центрирование
              }

              Blocks.ActiveWorkspace {
                Layout.fillWidth: true // Позволяет занимать доступное пространство
                Layout.alignment: Qt.AlignCenter // Центрирование
                chopLength: {
                    var space = Math.floor(bar.width - (rightBlocks.implicitWidth + leftBlocks.implicitWidth));
                    return space * 0.04; // Множитель длины текста
                }
              }

              Blocks.Space {
                width: 2.5
                Layout.alignment: Qt.AlignCenter // Центрирование
              }

            }
          }
        }



        // Right side
        RowLayout {
          id: rightBlocks
          spacing: 10
          Layout.alignment: Qt.AlignRight
          Rectangle {
            color: "#0099ff99" // Light green color for right side
            // width: 100
            Layout.fillWidth: true // Позволяет расширяться до доступной ширины
            Layout.maximumWidth: Math.floor(Quickshell.screens[0].width / 3) // Максимальная ширина 1/3 от ширины экрана
            height: Theme.get.preferredHeight // Match the height of the bar
            
            RowLayout {
              anchors.fill: parent // Заполняет родительский элемент
              spacing: 10 // Пространство между элементами
              
              Blocks.Player {
                id: playerBlock
                Layout.fillWidth: true // Позволяет занимать доступное пространство
                Layout.alignment: Qt.AlignCenter // Центрирование
                chopLength: {
                    var space = Math.floor(playerBlock.width);
                    return space * 0.135; // Множитель длины текста
                }
              }
              
              Blocks.SystemTray {
                Layout.minimumWidth: 23.7 * SystemTray.items.values.length // Установите минимальную ширину для SystemTray
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: false // Не заполнять всю ширину, чтобы занимать только необходимое пространство
              }

              Rectangle {
                Layout.alignment: Qt.AlignCenter
                height: Theme.get.preferredHeight
                width: {
                  return 155 
                }
                color: Theme.get.block
        
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
                
                Row {
                  anchors.centerIn: parent
                  Blocks.Sound {
                    id: sound
                    width: 55
                  }

                  Blocks.Language {
                    width: 35
                  }
    
                  Blocks.Battery {
                    id: battery
                    width: 50
                  }   
                }
              }
                             
              Blocks.Space {
                width: 2.5
                Layout.alignment: Qt.AlignCenter // Центрирование
              }
            }
          }
        }
      }
    }
  }
}

