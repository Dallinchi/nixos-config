import QtQuick
import "../"
import "../utils"
import "root:/"

Item {
  width: parent.width
  height: Theme.get.preferredHeight

  Rectangle {
    anchors.fill: parent
    color: "transparent"

    Row {
      anchors.centerIn: parent
      spacing: 5
 
      Icon {
        y: +1.2
        color: Theme.get.symbol
        symbol: ""
        pointSize: 12
      }
      Text {
        text: `${Datetime.date}`
        color: Theme.get.text
        font.weight: Theme.get.fontWeight
      }
    }
  }
}

