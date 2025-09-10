import QtQuick
import "../"
import "../utils"
import "root:/"

Item {
  width: parent.width
  height: Theme.get.preferredHeight // Match the height of the bar

  Rectangle {
    anchors.fill: parent // Заполняет весь доступный пространство
    color: "transparent" // Установите желаемый цвет фона
    
    Row {
      anchors.centerIn: parent
      spacing: 4
      Text {
        // anchors.centerIn: parent // Центрирование текста внутри Rectangle
        text: ``
        color: Theme.get.text // Цвет текста
      }
    }
  }
}

