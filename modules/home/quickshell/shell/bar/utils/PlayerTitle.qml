// with this line our type becomes a Singleton
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// your singletons should always have Singleton as the type
Singleton {
  id: root
  property string title

  Process {
    id: titleProc
    command: ["sh", "-c", "~/Code/Projects/waybar-player-title/waybar_script"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.title = this.text.trim()
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: titleProc.running = true
  }
}
