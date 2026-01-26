import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "root:/bar"
import "root:/"

Item {
    height: Theme.get.preferredHeight 
    visible: SystemTray.items.values.length >= 1 ? true : false
    Rectangle {
        color: Theme.get.block 
        width: 23.5 * SystemTray.items.values.length 
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

        RowLayout {
            id: system_tray_item
            spacing: 1
            anchors.right: parent.right 
            anchors.verticalCenter: parent.verticalCenter 
            height: Theme.get.preferredHeight 
            // anchors.margins: 10

            Repeater {
                model: SystemTray.items.values

                MouseArea {
                    id: delegate
                    required property SystemTrayItem modelData
                    property alias item: delegate.modelData

                    Layout.fillHeight: true
                    width: icon.implicitWidth + 8.5

                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    hoverEnabled: true

                    onClicked: event => {
                        if (event.button == Qt.LeftButton) {
                            item.activate();
                        } else if (event.button == Qt.MiddleButton) {
                            item.secondaryActivate();
                        } else if (event.button == Qt.RightButton) {
                            menuAnchor.open();
                        }
                    }

                    Rectangle {
                        width: delegate.width
                        height: Theme.get.preferredHeight 
                        color: "transparent"
                    }

                    onWheel: event => {
                        event.accepted = true;
                        const points = event.angleDelta.y / 120;
                        item.scroll(points, false);
                    }

                    IconImage {
                        id: icon
                        anchors.centerIn: parent
                        source: item.icon
                        implicitSize: 12
                      }

                    QsMenuAnchor {
                        id: menuAnchor
                        menu: item.menu

                        anchor.window: delegate.QsWindow.window
                        anchor.adjustment: PopupAdjustment.Flip

                        anchor.onAnchoring: {
                            const window = delegate.QsWindow.window;
                            const widgetRect = window.contentItem.mapFromItem(delegate, 0, delegate.height, delegate.width, delegate.height);
                            menuAnchor.anchor.rect = widgetRect;
                        }
                    }

                    Tooltip {
                        relativeItem: delegate.containsMouse ? delegate : null

                        Label {
                            text: delegate.item.tooltipTitle || delegate.item.id
                        }
                    }
                }
            }
        }
    }
}

